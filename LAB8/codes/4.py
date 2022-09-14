from collections.abc import MutableMapping
import redis

def setflat_skeys(
    r: redis.Redis,
    obj: dict,
    prefix: str,
    delim: str = ":",
    *,
    _autopfix=""
) -> None:
    """Flatten `obj` and set resulting field-value pairs into `r`.

    Calls `.set()` to write to Redis instance inplace and returns None.

    `prefix` is an optional str that prefixes all keys.
    `delim` is the delimiter that separates the joined, flattened keys.
    `_autopfix` is used in recursive calls to created de-nested keys.

    The deepest-nested keys must be str, bytes, float, or int.
    Otherwise a TypeError is raised.
    """
    allowed_vtypes = (str, bytes, float, int)
    for key, value in obj.items():
        key = _autopfix + key
        if isinstance(value, allowed_vtypes):
            r.set(f"{prefix}{delim}{key}", value)
        elif isinstance(value, MutableMapping):
            setflat_skeys(
                r, value, prefix, delim, _autopfix=f"{key}{delim}"
            )
        else:
            raise TypeError(f"Unsupported value type: {type(value)}")

restaurant_484272 = {
    "name": "Ravagh",
    "type": "Persian",
    "address": {
        "street": {
            "line1": "11 E 30th St",
            "line2": "APT 1",
        },
        "city": "New York",
        "state": "NY",
        "zip": 10016,
    }
}
r = redis.Redis()
r.flushdb()
setflat_skeys(r, restaurant_484272, 484272)
for key in sorted(r.keys("484272*")):
    print(f"{repr(key):35}{repr(r.get(key)):15}")
print(r.get("484272:address:street:line1"))



