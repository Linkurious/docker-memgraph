
# version_settings() enforces a minimum Tilt version
# https://docs.tilt.dev/api.html#api.version_settings
version_settings(constraint='>=0.30.8')

load('ext://kubectl_build', 'kubectl_build')
load('ext://helm_resource', 'helm_resource', 'helm_repo')

ctx = k8s_context()
if ctx.endswith('k8s-dev'):
  allow_k8s_contexts(ctx)

if not k8s_namespace().endswith("dev"):
  fail("You are not targeting a dev namespace")
builder = "builder-" + k8s_namespace()

# kubectl_build(
#   'memgraph',
#   #context='packages/memgraph/.',
#   context='.',
#   dockerfile='Dockerfile',
#   build_args={'NPM_TOKEN': os.getenv('NPM_TOKEN'),'BUILD_ENV': 'test', 'target_build': 'builder'},
#   builder=builder,
#   #ignore=['./client/'],
#   # live_update=[
#   #     sync('./api/', '/app/api/'),
#   #     run(
#   #         'pip install -r /app/requirements.txt',
#   #         trigger=['./api/requirements.txt']
#   #     )
#   # ]
# )

extra_values = ['--set=networkPolicies.allowAllNamespaceIngress=true']
helm_resource(
  name=ctx.removesuffix('@k8s-dev') + '-tilt-memgraph',
  chart='charts/memgraph',
  deps=['charts/memgraph'],
  flags=extra_values,
  #image_deps=['memgraph'],
  #image_keys=[('linkurious-enterprise.image.repository','linkurious-enterprise.image.tag')]
  )
