# API-Helpers
API Helpers for Networking in iOS App. Written in Objective C

## REQUISITE : [AFNetworking 3.1.0](https://github.com/AFNetworking/AFNetworking/)

## HOW TO ADD: 

Drag drop API Helpers into your Project.

## HOW TO USE:

1. ```#import MyWebserviceManager.h```

2. Set your ```LOCAL AND HOSTING SERVER``` links.

3. Create ```MyWebserviceManager``` instance. Set ```delegate``` to your view controller.

4. Set your ```parameters``` as ```NSDictionary```.

5. Call instance method ```callMyWebServiceManager``` .

- 

6. Implement two required delegate methods. ```processCompleted``` & ```processFailed```.

7. [Optional] ```processOnGoing```

# Reachability

Reachability class tells about internet connectivity. You can use instance method ```connected``` to check for connectivity.

# SHA1 Auth Code Generation

SHA1 generation generates auth code with SALT and provided string. You can use class method ```getSHA1WithCharacters``` to get Auth Code.

# Support

Suggestions/Queries/Feedbacks are welcome.

Feel free to contribute in anyway.


CHEERS!
