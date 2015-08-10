Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:34948 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753663AbbHJNMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 09:12:01 -0400
Message-ID: <55C8A305.9010509@xs4all.nl>
Date: Mon, 10 Aug 2015 15:11:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	mchehab@osg.samsung.com
Subject: Re: VIMC: API proposal, configuring the topology through user space
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com>
In-Reply-To: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen!

On 08/08/2015 03:55 AM, Helen Fornazier wrote:
> Hi!
> 
> I've made a first sketch about the API of the vimc driver (virtual
> media controller) to configure the topology through user space.
> As first suggested by Laurent Pinchart, it is based on configfs.
> 
> I would like to know you opinion about it, if you have any suggestion
> to improve it, otherwise I'll start its implementation as soon as
> possible.
> This API may change with the MC changes and I may see other possible
> configurations as I implementing it but here is the first idea of how
> the API will look like.
> 
> vimc project link: https://github.com/helen-fornazier/opw-staging/
> For more information: http://kernelnewbies.org/LaurentPinchart
> 
> /***********************
> The API:
> ************************/
> 
> In short, a topology like this one: http://goo.gl/Y7eUfu
> Would look like this filesystem tree: https://goo.gl/tCZPTg
> Txt version of the filesystem tree: https://goo.gl/42KX8Y
> 
> * The /configfs/vimc subsystem

I haven't checked the latest vimc driver, but doesn't it support
multiple instances, just like vivid? I would certainly recommend that.

And if there are multiple instances, then each instance gets its own
entry in configfs: /configs/vimc0, /configs/vimc1, etc.

> The vimc driver registers a subsystem in the configfs with the
> following contents:
>         > ls /configfs/vimc
>         build_topology status
> The build_topology attribute file will be used to tell the driver the
> configuration is done and it can build the topology internally
>         > echo -n "anything here" > /configfs/vimc/build_topology
> Reading from the status attribute can have 3 different classes of outputs
> 1) deployed: the current configured tree is built
> 2) undeployed: no errors, the user has modified the configfs tree thus
> the topology was undeployed
> 3) error error_message: the topology configuration is wrong

I don't see the status file in the filesystem tree links above.

I actually wonder if we can't use build_topology for that: reading it
will just return the status.

What happens if it is deployed and you want to 'undeploy' it? Instead of
writing anything to build_topology it might be useful to write a real
command to it. E.g. 'deploy', 'destroy'.

What happens when you make changes while a topology is deployed? Should
such changes be rejected until the usecount of the driver goes to 0, or
will it only be rejected when you try to deploy the new configuration?

> * Creating an entity:
> Use mkdir in the /configfs/vimc to create an entity representation, e.g.:
>         > mkdir /configfs/vimc/sensor_a
> The attribute files will be created by the driver through configfs:
>         > ls /configfs/vimc/sensor_a
>         name role
> Configure the name that will appear to the /dev/media0 and what this
> node do (debayer, scaler, capture, input, generic)
>         > echo -n "Sensor A" > /configfs/vimc/sensor_a/name
>         > echo -n "sensor" > /configfs/vimc/sensor_a/role
> 
> * Creating a pad:
> Use mkdir inside an entity's folder, the attribute called "direction"
> will be automatically created in the process, for example:
>         > mkdir /configfs/vimc/sensor_a/pad_0
>         > ls /configfs/vimc/sensor_a/pad_0
>         direction
>         > echo -n "source" > /configfs/vimc/sensor_a/pad_0/direction
> The direction attribute can be "source" or "sink"

Hmm. Aren't the pads+direction dictated by the entity role? E.g. a sensor
will only have one pad which is always a source. I think setting the role
is what creates the pad directories + direction files.

> 
> * Creating a link between pads in two steps:
> Step 1)
> Create a folder inside the source pad folder, the attribute called
> "flag" will be automatically created in the process, for example:
>         > mkdir /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
>         > ls /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
>         flags
>         > echo -n "enabled,immutable" >
> /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/flags
> In the flags attribute we can have all the links attributes (enabled,
> immutable and dynamic) separated by comma
> 
> Step 2)
> Add a symlink between the previous folder we just created in the
> source pad and the sink pad folder we want to connect. Lets say we
> want to connect with the pad on the raw_capture_0 entity pad 0
>         > ln -s /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
> /configfs/vimc/raw_capture_0/pad_0/

Can't this be created automatically? Or possibly not at all, since it is
implicit in step 1.

BTW, the direction is the wrong way around for pads 0 and 1 of the debayer
and scaler entities: pad_0 is a sink since it gets its data from a sensor
or debayer source pad.

> 
> * Build the topology.
> After configuring it, tell the driver we finished:
>         > echo -n "anything here" > /configfs/vimc/build_topology
>         > cat /configfs/vimc/status
> 
> NOTE 1: The entity's numbering, as read from /dev/media0, will be the
> order of the creation, same about the pads. Pad 0 will be the first
> pad created in an entity's folder.
> 
> NOTE 2: Most of the errors will be captured while configuring the
> topology, e.g., the user won't be able to setup a link if the pad
> which contains the /configfs/ent/pad/link/ folder does not have the
> direction attribute set to source and the use can't change the
> direction of a pad to sink if it already has a symlink going out of
> the current pad.
> 
> NOTE 3: The user won't be able to modify the configfs tree if any
> streaming is on.

Ah. But I would make this more strict: the user won't be able to modify
the configfs tree if any filehandles associated with the device are in
use.

Regards,

	Hans

> 
> 
> That's it, I hope it is clear.
> 
> Regards
> 

