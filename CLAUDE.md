# Agent instructions

## Validation and testing

Use **regent** (not `pdk`) to validate and test this Puppet module.

- Validate: `regent validate` (instead of `pdk validate`)
- Unit tests: `regent test unit` (instead of `pdk test unit`)
- Do not run `pdk` commands for validation or testing in this repo, even if module scaffolding (e.g. `metadata.json`, `Rakefile`, `spec/`) suggests a PDK workflow.

The module source lives under `baseapp/`. Run `regent` commands from that directory unless told otherwise.
