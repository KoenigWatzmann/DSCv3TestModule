#### get:
Defines how DSC must call the DSC Resource to get the current state of an instance.

#### set:
Defines how DSC must call the DSC Resource to set the desired state of an instance and how to process the output from the DSC Resource.

#### whatif:
Defines how DSC must call the DSC Resource to indicate whether and how the set command will modify an instance and how to process the output from the DSC Resource.

#### test:
Defines how DSC must call the DSC Resource to test if an instance is in the desired state and how to process the output from the DSC Resource.

#### delete:
Defines how DSC must call the DSC Resource to delete an instance. 
Define this method for resources as an alternative to handling the `_exist` property in a `set` operation, which can lead to highly complex code. 
If the `set` operation for the resource is able to handle deleting an instance when `_exist` is `false`, 
set the `handlesExist` property of the set method definition to `true` instead.

#### export
Defines how DSC must call the DSC Resource to get the current state of every instance.

#### validate
Defines how DSC must call the DSC Resource to validate the state of an instance. 
This method is mandatory for DSC Group Resources. It's ignored for all other DSC Resources.

#### resolve
Defines how DSC must call the DSC Resource to resolve a nested configuration document from an external source. 
Define this method for importer resources where the resource kind is set to `Import`.
