Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35377 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbbHJRWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 13:22:18 -0400
Received: by obbop1 with SMTP id op1so129273887obb.2
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2015 10:22:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55C8A305.9010509@xs4all.nl>
References: <CAPW4XYagLAmCXpnFyzmfRjUHeTL0Q1mfcKiOCssh5o-NMZqR2w@mail.gmail.com>
 <55C8A305.9010509@xs4all.nl>
From: Helen Fornazier <helen.fornazier@gmail.com>
Date: Mon, 10 Aug 2015 14:21:58 -0300
Message-ID: <CAPW4XYarvYDfQa7iCY9fNMHLb7zFGXE2dzu-cr3Z1oLVBHTjtg@mail.gmail.com>
Subject: Re: VIMC: API proposal, configuring the topology through user space
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	mchehab@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, thanks for your reviews

On Mon, Aug 10, 2015 at 10:11 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Helen!
>
> On 08/08/2015 03:55 AM, Helen Fornazier wrote:
>> Hi!
>>
>> I've made a first sketch about the API of the vimc driver (virtual
>> media controller) to configure the topology through user space.
>> As first suggested by Laurent Pinchart, it is based on configfs.
>>
>> I would like to know you opinion about it, if you have any suggestion
>> to improve it, otherwise I'll start its implementation as soon as
>> possible.
>> This API may change with the MC changes and I may see other possible
>> configurations as I implementing it but here is the first idea of how
>> the API will look like.
>>
>> vimc project link: https://github.com/helen-fornazier/opw-staging/
>> For more information: http://kernelnewbies.org/LaurentPinchart
>>
>> /***********************
>> The API:
>> ************************/
>>
>> In short, a topology like this one: http://goo.gl/Y7eUfu
>> Would look like this filesystem tree: https://goo.gl/tCZPTg
>> Txt version of the filesystem tree: https://goo.gl/42KX8Y
>>
>> * The /configfs/vimc subsystem
>
> I haven't checked the latest vimc driver, but doesn't it support
> multiple instances, just like vivid? I would certainly recommend that.

Yes, it does support

>
> And if there are multiple instances, then each instance gets its own
> entry in configfs: /configs/vimc0, /configs/vimc1, etc.

You are right, I'll add those

>
>> The vimc driver registers a subsystem in the configfs with the
>> following contents:
>>         > ls /configfs/vimc
>>         build_topology status
>> The build_topology attribute file will be used to tell the driver the
>> configuration is done and it can build the topology internally
>>         > echo -n "anything here" > /configfs/vimc/build_topology
>> Reading from the status attribute can have 3 different classes of outputs
>> 1) deployed: the current configured tree is built
>> 2) undeployed: no errors, the user has modified the configfs tree thus
>> the topology was undeployed
>> 3) error error_message: the topology configuration is wrong
>
> I don't see the status file in the filesystem tree links above.

Sorry, I forgot to add

>
> I actually wonder if we can't use build_topology for that: reading it
> will just return the status.

Yes we can, I was just wondering what should be the name of the file,
as getting the status from reading the build_topology file doesn't
seem much intuitive

>
> What happens if it is deployed and you want to 'undeploy' it? Instead of
> writing anything to build_topology it might be useful to write a real
> command to it. E.g. 'deploy', 'destroy'.
>
> What happens when you make changes while a topology is deployed? Should
> such changes be rejected until the usecount of the driver goes to 0, or
> will it only be rejected when you try to deploy the new configuration?

I was thinking that if the user try changing the topology, or it will
fail (because the device instance is in use) or it will undeploy the
old topology (if the device is not in use). Then a 'destroy' command
won't be useful, the user can just unload the driver when it won't be
used anymore,

>
>> * Creating an entity:
>> Use mkdir in the /configfs/vimc to create an entity representation, e.g.:
>>         > mkdir /configfs/vimc/sensor_a
>> The attribute files will be created by the driver through configfs:
>>         > ls /configfs/vimc/sensor_a
>>         name role
>> Configure the name that will appear to the /dev/media0 and what this
>> node do (debayer, scaler, capture, input, generic)
>>         > echo -n "Sensor A" > /configfs/vimc/sensor_a/name
>>         > echo -n "sensor" > /configfs/vimc/sensor_a/role
>>
>> * Creating a pad:
>> Use mkdir inside an entity's folder, the attribute called "direction"
>> will be automatically created in the process, for example:
>>         > mkdir /configfs/vimc/sensor_a/pad_0
>>         > ls /configfs/vimc/sensor_a/pad_0
>>         direction
>>         > echo -n "source" > /configfs/vimc/sensor_a/pad_0/direction
>> The direction attribute can be "source" or "sink"
>
> Hmm. Aren't the pads+direction dictated by the entity role? E.g. a sensor
> will only have one pad which is always a source. I think setting the role
> is what creates the pad directories + direction files.

I thought that we could add as many pads that we want, having a scaler
with two or more sink pads (for example) in the same format that
scales the frames coming from any sink pad and send it to its source
pads, no?
Maybe it is better if we don't let this choice.
I need to check if I can modify the configfs dynamically, I mean, if
the user writes "debayer" to the role file, I need to create at least
one folder (or file) to allow the user to configure the link flag
related to its source pad, but if in the future we have another entity
role (lets say "new_entity") that has more then one source pad, and
the user writes "debayer" in the role and then "new_entity", we will
need to erase the folder created by the debayer to create two new
folders, I am still not sure if I can do that.

>
>>
>> * Creating a link between pads in two steps:
>> Step 1)
>> Create a folder inside the source pad folder, the attribute called
>> "flag" will be automatically created in the process, for example:
>>         > mkdir /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
>>         > ls /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
>>         flags
>>         > echo -n "enabled,immutable" >
>> /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/flags
>> In the flags attribute we can have all the links attributes (enabled,
>> immutable and dynamic) separated by comma
>>
>> Step 2)
>> Add a symlink between the previous folder we just created in the
>> source pad and the sink pad folder we want to connect. Lets say we
>> want to connect with the pad on the raw_capture_0 entity pad 0
>>         > ln -s /configfs/vimc/sensor_a/pad_0/link_to_raw_capture_0/
>> /configfs/vimc/raw_capture_0/pad_0/
>
> Can't this be created automatically? Or possibly not at all, since it is
> implicit in step 1.

Do you mean, create the symlink automatically? I don't think so
because the driver doesn't know a priori the entities you want to
connect together.

>
> BTW, the direction is the wrong way around for pads 0 and 1 of the debayer
> and scaler entities: pad_0 is a sink since it gets its data from a sensor
> or debayer source pad.

Sorry, thank you for noticing, I'll re-send a corrected version of it.

>
>>
>> * Build the topology.
>> After configuring it, tell the driver we finished:
>>         > echo -n "anything here" > /configfs/vimc/build_topology
>>         > cat /configfs/vimc/status
>>
>> NOTE 1: The entity's numbering, as read from /dev/media0, will be the
>> order of the creation, same about the pads. Pad 0 will be the first
>> pad created in an entity's folder.
>>
>> NOTE 2: Most of the errors will be captured while configuring the
>> topology, e.g., the user won't be able to setup a link if the pad
>> which contains the /configfs/ent/pad/link/ folder does not have the
>> direction attribute set to source and the use can't change the
>> direction of a pad to sink if it already has a symlink going out of
>> the current pad.
>>
>> NOTE 3: The user won't be able to modify the configfs tree if any
>> streaming is on.
>
> Ah. But I would make this more strict: the user won't be able to modify
> the configfs tree if any filehandles associated with the device are in
> use.

I see, I think that is better.

>
> Regards,
>
>         Hans
>
>>
>>
>> That's it, I hope it is clear.
>>
>> Regards
>>
>


Here is the new version 2 with the following changes:
- Rename build_topology to deploy
- Remove status file (as it will be read from the deploy file)
- Add vimc0/ folder to represent an instance of the driver

Changes in the notes:
- The user won't be allowed to change the topology of a device in
configfs if any filehandles associated with the device are in use
- Reading from deploy file will return the status (deployed,
undeployed or error)

The topology (its the same one): http://goo.gl/Y7eUfu
Filesystem tree V2: https://goo.gl/VnjQGe
Txt version of the filesystem tree V2: https://goo.gl/k1ZuH9

Regards
-- 
Helen M. Koike Fornazier
