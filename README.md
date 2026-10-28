# tentacle_scale

**One capability bit from GBT V8, packaged standalone.** No. 307 of 341,
`tentacle` domain (Tentacle).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 亿万触手寻址（逻辑 · 只读）：10^8 地址空间按算不占盘（t00000001…）+ 1024 分片 + 每根钥匙由主密钥 HMAC 派生（同一根永远同一把、彼此不同、可复算）· 钥匙只回指纹。**实体化/落盘不做**（新增位无 policy 分支 = 零作用域，属登记在册的坑，要开请主人在 security/policy.py 挂作用域）；主密钥不在就如实报「未配」，不代建。op=space/addr/parse/shard/key/master

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-tentacle-scale.git
cd gbt-tentacle-scale
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_tentacle_scale info                  # capability card
python -m gbt_tentacle_scale spec --json           # machine-readable contract
python -m gbt_tentacle_scale check --payload '{}'
python -m gbt_tentacle_scale run   --payload '{}'
```

Real `info` output from this machine:

```text
tentacle_scale  (tentacle)  v1.0.0
----------------------------------------
亿万触手寻址（逻辑 · 只读）：10^8 地址空间按算不占盘（t00000001…）+ 1024 分片 + 每根钥匙由主密钥 HMAC 派生（同一根永远同一把、彼此不同、可复算）· 钥匙只回指纹。**实体化/落盘不做**（新增位无 policy 分支 = 零作用域，属登记在册的坑，要开请主人在 security/policy.py 挂作用域）；主密钥不在就如实报「未配」，不代建。op=space/addr/parse/shard/key/master

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : space, addr, parse, shard, key, master
```

Wire a real implementation:

```python
from gbt_tentacle_scale import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`space`、`addr`、`parse`、`shard`、`key`、`master`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `tentacle_scale` |
| domain | `tentacle` |
| handler | `tentacle_scale` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [tentacle/tentacle_scale](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/tentacle/tentacle_scale.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
