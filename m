Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:32871 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946535AbbHHBzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 21:55:48 -0400
Received: by oio137 with SMTP id 137so61680132oio.0
        for <linux-media@vger.kernel.org>; Fri, 07 Aug 2015 18:55:48 -0700 (PDT)
MIME-Version: 1.0
From: Helen Fornazier <helen.fornazier@gmail.com>
Date: Fri, 7 Aug 2015 22:55:28 -0300
Message-ID: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com>
Subject: VIMC: API proposal, configuring the topology through user space
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, mchehab@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've made a first sketch about the API of the vimc driver (virtual
media controller) to configure the topology through user space.
As first suggested by Laurent Pinchart, it is based on configfs.

I would like to know you opinion about it, if you have any suggestion
to improve it, otherwise I'll start its implementation as soon as
possible.
This API may change with the MC changes and I may see other possible
configurations as I implementing it but here is the first idea of how
the API will look like.

vimc project link: https://github.com/helen-fornazier/opw-staging/
For more information: http://kernelnewbies.org/LaurentPinchart

/***********************
The API:
************************/

In short, a topology like this one: http://goo.gl/Y7eUfu
Would look like this filesystem tree: https://goo.gl/tCZPTg
Txt version of the filesystem tree: https://goo.gl/42KX8Y

* The /configfs/vimc subsystem
The vimc driver registers a subsystem in the configfs with the
following contents:
        > ls /configfs/vimc
        build_topology status
The build_topology attribute file will be used to tell the driver the
configuration is done and it can build the topology internally
        > echo -n "anything here" > /configfs/vimc/build_topology
Reading from the status attribute can have 3 different classes of outputs
1) deployed: the current configured tree is built
2) undeployed: no errors, the user has modified the configfs tree thus
the topology was undeployed
3) error error_message: the topology configuration is wrong

* Creating an entity:
Use mkdir in the /configfs/vimc to create an entity representation, e.g.:
        > mkdir /configfs/vimc/sensor_a
The attribute files will be created by the driver through configfs:
        > ls /configfs/vimc/sensor_a
        name role
Configure the name that will appear to the /dev/media0 and what this
node do (debayer, scaler, capture, input, generic)
        > echo -n "Sensor A" > /configfs/vimc/sensor_a/name
        > echo -n "sensor" > /configfs/vimc/sensor_a/role

* Creating a pad:
Use mkdir inside an entity's folder, the attribute called "direction"
will be automatically created in the process, for example:
        > mkdir /configfs/vimc/sensor_a/pad_0
        > ls /configfs/vimc/sensor_a/pad_0
        direction
        > echo -n "source" > /configfs/vimc/sensor_a/pad_0/direction
The direction attribute can be "source" or "sink"

* Creating a link between pads in two steps:
Step 1)
Create a folder inside the source pad folder, the attribute called
"flag" will be automatically created in the process, for example:
        > mkdir /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
        > ls /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
        flags
        > echo -n "enabled,immutable" >
/configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/flags
In the flags attribute we can have all the links attributes (enabled,
immutable and dynamic) separated by comma

Step 2)
Add a symlink between the previous folder we just created in the
source pad and the sink pad folder we want to connect. Lets say we
want to connect with the pad on the raw_capture_0 entity pad 0
        > ln -s /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
/configfs/vimc/raw_capture_0/pad_0/

* Build the topology.
After configuring it, tell the driver we finished:
        > echo -n "anything here" > /configfs/vimc/build_topology
        > cat /configfs/vimc/status

NOTE 1: The entity's numbering, as read from /dev/media0, will be the
order of the creation, same about the pads. Pad 0 will be the first
pad created in an entity's folder.

NOTE 2: Most of the errors will be captured while configuring the
topology, e.g., the user won't be able to setup a link if the pad
which contains the /configfs/ent/pad/link/ folder does not have the
direction attribute set to source and the use can't change the
direction of a pad to sink if it already has a symlink going out of
the current pad.

NOTE 3: The user won't be able to modify the configfs tree if any
streaming is on.


That's it, I hope it is clear.

Regards
-- 
Helen M. Koike Fornazier
