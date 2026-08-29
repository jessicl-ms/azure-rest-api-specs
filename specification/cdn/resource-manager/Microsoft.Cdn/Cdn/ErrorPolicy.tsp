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
 * A reusable error policy that describes negative caching and custom error page behavior. Routes decide which error codes are handled by which error policy.
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

/**
 * Defines an ErrorPolicy response body for long-running operations.
 */
@added(Versions.v2026_08_01_preview)
model ErrorPolicyAcceptedBody {
  /**
   * Defines an ErrorPolicy response body.
   */
  @bodyRoot
  _: ErrorPolicy;
}

@added(Versions.v2026_08_01_preview)
@armResourceOperations
interface ErrorPolicies {
  /**
   * Gets an existing error policy within a profile.
   */
  get is ArmResourceRead<ErrorPolicy>;

  /**
   * Creates a new error policy within the specified profile.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "Consistent with the other Azure Front Door child resources in this specification."
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "Consistent with the other Azure Front Door child resources in this specification."
  @Azure.Core.useFinalStateVia("azure-async-operation")
  create is ArmResourceCreateOrReplaceAsync<
    ErrorPolicy,
    Response =
      | ArmResourceUpdatedResponse<ErrorPolicy>
      | ArmResourceCreatedResponse<ErrorPolicy>
      | (ArmAcceptedLroResponse<LroHeaders = ArmAsyncOperationHeader<FinalResult = ErrorPolicy>> &
          ArmLroLocationHeader<FinalResult = ErrorPolicy> &
          ErrorPolicyAcceptedBody)
  >;

  /**
   * Updates an existing error policy within the specified profile.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "Consistent with the other Azure Front Door child resources in this specification."
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchAsync<
    ErrorPolicy,
    PatchModel = ErrorPolicyUpdateParameters,
    Response =
      | ArmResponse<ErrorPolicy>
      | (ArmAcceptedLroResponse<LroHeaders = ArmAsyncOperationHeader<FinalResult = ErrorPolicy> &
          ArmLroLocationHeader<FinalResult = ErrorPolicy> &
          Azure.Core.Foundations.RetryAfterHeader> &
          ErrorPolicyAcceptedBody)
  >;

  /**
   * Deletes an existing error policy within the specified profile. An error policy cannot be deleted while it is referenced by a route.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "Consistent with the other Azure Front Door child resources in this specification."
  @Azure.Core.useFinalStateVia("azure-async-operation")
  delete is ArmResourceDeleteWithoutOkAsync<
    ErrorPolicy,
    Response =
      | ArmDeletedResponse
      | ArmDeleteAcceptedLroResponse<ArmAsyncOperationHeader &
          ArmLroLocationHeader &
          Azure.Core.Foundations.RetryAfterHeader>
      | ArmDeletedNoContentResponse
  >;

  /**
   * Lists all of the existing error policies within a profile.
   */
  @list
  listByProfile is ArmResourceListByParent<ErrorPolicy>;
}

@@maxLength(ErrorPolicy.name, 260);
@@minLength(ErrorPolicy.name, 1);
@@doc(ErrorPolicy.name, "Name of the error policy under the profile.");
@@doc(
  ErrorPolicy.properties,
  "The JSON object that contains the properties of the error policy to create."
);
@@doc(ErrorPolicies.create::parameters.resource, "Error policy properties.");
@@doc(
  ErrorPolicies.update::parameters.properties,
  "Error policy update properties."
);
