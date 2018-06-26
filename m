Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:37281 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751175AbeFZU60 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 16:58:26 -0400
Received: by mail-ot0-f196.google.com with SMTP id u6-v6so12401028otk.4
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2018 13:58:25 -0700 (PDT)
Subject: Re: [PATCH v3 05/13] media: v4l2-fwnode: Add a convenience function
 for registering subdevs with notifiers
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1521592649-7264-1-git-send-email-steve_longerbeam@mentor.com>
 <1521592649-7264-6-git-send-email-steve_longerbeam@mentor.com>
 <20180423071444.2rsqvlvlfvpoxpbu@paasikivi.fi.intel.com>
 <8e59e530-9d13-c1ae-5f0b-6205a7b21182@gmail.com>
 <20180508102825.xamrlnnipknsoi62@kekkonen.localdomain>
 <40dae271-2d82-6119-e289-aec07147dce5@gmail.com>
 <20180626074522.zhgolz47k6xyf4qt@kekkonen.localdomain>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <88ab8115-9c9c-d23b-1af1-1014341e4900@gmail.com>
Date: Tue, 26 Jun 2018 13:58:22 -0700
MIME-Version: 1.0
In-Reply-To: <20180626074522.zhgolz47k6xyf4qt@kekkonen.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/26/2018 12:45 AM, Sakari Ailus wrote:
> On Tue, May 08, 2018 at 08:55:04PM -0700, Steve Longerbeam wrote:
>>
>> On 05/08/2018 03:28 AM, Sakari Ailus wrote:
>>> Hi Steve,
>>>
>>> Again, sorry about the delay. This thread got buried in my inbox. :-(
>>> Please see my reply below.
>>>
>>> On Mon, Apr 23, 2018 at 11:00:22AM -0700, Steve Longerbeam wrote:
>>>> On 04/23/2018 12:14 AM, Sakari Ailus wrote:
>>>>> Hi Steve,
>>>>>
>>>>> On Tue, Mar 20, 2018 at 05:37:21PM -0700, Steve Longerbeam wrote:
>>>>>> Adds v4l2_async_register_fwnode_subdev(), which is a convenience function
>>>>>> for parsing a sub-device's fwnode port endpoints for connected remote
>>>>>> sub-devices, registering a sub-device notifier, and then registering
>>>>>> the sub-device itself.
>>>>>>
>>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>>> ---
>>>>>> Changes since v2:
>>>>>> - fix error-out path in v4l2_async_register_fwnode_subdev() that forgot
>>>>>>      to put device.
>>>>>> Changes since v1:
>>>>>> - add #include <media/v4l2-subdev.h> to v4l2-fwnode.h for
>>>>>>      'struct v4l2_subdev' declaration.
>>>>>> ---
>>>>>>     drivers/media/v4l2-core/v4l2-fwnode.c | 101 ++++++++++++++++++++++++++++++++++
>>>>>>     include/media/v4l2-fwnode.h           |  43 +++++++++++++++
>>>>>>     2 files changed, 144 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>>> index 99198b9..d42024d 100644
>>>>>> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>>> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
>>>>>> @@ -880,6 +880,107 @@ int v4l2_async_register_subdev_sensor_common(struct v4l2_subdev *sd)
>>>>>>     }
>>>>>>     EXPORT_SYMBOL_GPL(v4l2_async_register_subdev_sensor_common);
>>>>>> +int v4l2_async_register_fwnode_subdev(
>>>>>> +	struct v4l2_subdev *sd, size_t asd_struct_size,
>>>>>> +	unsigned int *ports, unsigned int num_ports,
>>>>>> +	int (*parse_endpoint)(struct device *dev,
>>>>>> +			      struct v4l2_fwnode_endpoint *vep,
>>>>>> +			      struct v4l2_async_subdev *asd))
>>>>>> +{
>>>>>> +	struct v4l2_async_notifier *notifier;
>>>>>> +	struct device *dev = sd->dev;
>>>>>> +	struct fwnode_handle *fwnode;
>>>>>> +	unsigned int subdev_port;
>>>>>> +	bool is_port;
>>>>>> +	int ret;
>>>>>> +
>>>>>> +	if (WARN_ON(!dev))
>>>>>> +		return -ENODEV;
>>>>>> +
>>>>>> +	fwnode = dev_fwnode(dev);
>>>>>> +	if (!fwnode_device_is_available(fwnode))
>>>>>> +		return -ENODEV;
>>>>>> +
>>>>>> +	is_port = (is_of_node(fwnode) &&
>>>>>> +		   of_node_cmp(to_of_node(fwnode)->name, "port") == 0);
>>>>> What's the intent of this and the code below? You may not parse the graph
>>>>> data structure here, it should be done in the actual firmware
>>>>> implementation instead.
>>>> The i.MX6 CSI sub-device registers itself from a port fwnode, so
>>>> the intent of the is_port code below is to support the i.MX6 CSI.
>>>>
>>>> I can remove the is_port checks, but it means
>>>> v4l2_async_register_fwnode_subdev() won't be usable by the CSI
>>>> sub-device.
>>> This won't scale.
>> The vast majority of sub-devices register themselves as
>> port parent nodes. So for now at least, I think
>> v4l2_async_register_fwnode_subdev() could be useful to many
>> platforms.
>>
>>>    Instead, I think we'd need to separate registering
>>> sub-devices (through async sub-devices) and binding them with the driver
>>> that registered the notifier. Or at least change how that process works: a
>>> single sub-device can well be bound to multiple notifiers,
>> Ok, that is certainly not the case now, a sub-device can only
>> be bound to a single notifier.
>>
>>>    or multiple
>>> times to the same notifier while it may be registered only once.
>> Anyway, this is a future generalization if I understand you
>> correctly. Not something to deal with here.
>>
>>>>> Also, sub-devices generally do not match ports.
>>>> Yes that's generally true, sub-devices generally match to port parent
>>>> nodes. But I do know of one other sub-device that buck that trend.
>>>> The ADV748x CSI-2 output sub-devices match against endpoint nodes.
>>> Endpoints, yes, but not ports.
>> Well, the imx CSI registers from a port node.
> I looked at the imx driver and it appears to be parsing DT without much
> help from the frameworks; graph or V4L2 fwnode. Is there a reason to do so,
> other than it's a staging driver? :-)

That's the whole point of this patchset. It gets rid of the code in imx
that discovers subdevices by recursively walking the graph, replacing
with the subdev notifier framework.


>
> Do you happen to have any DT source (or bindings) for this?

Documentation/devicetree/bindings/media/imx.txt.

For example DT source, it's all in the imx6 reference boards,
see imx6qdl-sabresd.dtsi for example.

>   It'd help to understand what is the aim here.

The aim of what? Of this specific commit? I'll reprint it here:

Adds v4l2_async_register_fwnode_subdev(), which is a convenience function
for parsing a sub-device's fwnode port endpoints for connected remote
sub-devices, registering a sub-device notifier, and then registering
the sub-device itself.


Steve
