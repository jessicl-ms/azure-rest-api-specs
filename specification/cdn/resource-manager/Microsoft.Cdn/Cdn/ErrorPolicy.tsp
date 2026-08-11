import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "@typespec/versioning";
import "./models.tsp";
import "./Profile.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using TypeSpec.Versioning;

namespace Microsoft.Cdn;

/**
 * A reusable error policy that defines how Azure Front Door handles error responses. Routes select
 * the error status codes that trigger a policy, so a single policy can be shared across routes.
 */
@added(Versions.v2026_08_01_preview)
@parentResource(Profile)
model ErrorPolicy
  is Azure.ResourceManager.ProxyResource<ErrorPolicyProperties> {
  ...ResourceNameParameter<
    Resource = ErrorPolicy,
    KeyName = "errorPolicyName",
    SegmentName = "errorPolicies",
    NamePattern = "^[a-zA-Z0-9]+(-*[a-zA-Z0-9])*$"
  >;
}

@added(Versions.v2026_08_01_preview)
@armResourceOperations
interface ErrorPolicies {
  /**
   * Gets an existing error policy within a profile.
   */
  get is ArmResourceRead<ErrorPolicy>;

  /**
   * Creates or updates an error policy within the specified profile.
   */
  @Azure.Core.useFinalStateVia("azure-async-operation")
  create is ArmResourceCreateOrReplaceAsync<
    ErrorPolicy,
    Response =
      | ArmResourceUpdatedResponse<ErrorPolicy>
      | ArmResourceCreatedResponse<
          ErrorPolicy,
          LroHeaders = ArmAsyncOperationHeader<FinalResult = ErrorPolicy> &
            Azure.Core.Foundations.RetryAfterHeader
        >
  >;

  /**
   * Updates an existing error policy within a profile.
   */
  @Azure.Core.useFinalStateVia("azure-async-operation")
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    ErrorPolicy,
    PatchModel = ErrorPolicyUpdateParameters,
    Response =
      | ArmResponse<ErrorPolicy>
      | ArmAcceptedLroResponse<LroHeaders = ArmCombinedLroHeaders<FinalResult = ErrorPolicy> &
          Azure.Core.Foundations.RetryAfterHeader>
  >;

  /**
   * Deletes an existing error policy within a profile.
   */
  @Azure.Core.useFinalStateVia("azure-async-operation")
  delete is ArmResourceDeleteWithoutOkAsync<
    ErrorPolicy,
    Response =
      | ArmDeleteAcceptedLroResponse<ArmCombinedLroHeaders &
          Azure.Core.Foundations.RetryAfterHeader>
      | ArmDeletedNoContentResponse
  >;

  /**
   * Lists error policies associated with the profile.
   */
  @list
  listByProfile is ArmResourceListByParent<ErrorPolicy>;
}

@@doc(ErrorPolicy.name, "Name of the error policy under the profile.");
@@minLength(ErrorPolicy.name, 1);
@@maxLength(ErrorPolicy.name, 260);
@@doc(ErrorPolicy.properties, "Properties required to create an error policy.");
@@doc(
  ErrorPolicies.create::parameters.resource,
  "The error policy properties."
);
@@doc(
  ErrorPolicies.update::parameters.properties,
  "Error policy update properties."
);
