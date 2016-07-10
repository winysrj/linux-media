Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44422 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753680AbcGJMz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 08:55:28 -0400
Subject: Re: [PATCH 06/11] media: adv7180: add bt.656-4 OF property
To: Lars-Peter Clausen <lars@metafoo.de>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-7-git-send-email-steve_longerbeam@mentor.com>
 <577E6C98.3020608@metafoo.de> <5781497A.2080804@gmail.com>
 <5781685C.7040907@mentor.com> <57816E47.90102@mentor.com>
 <57823B25.5070709@metafoo.de>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <93d03258-d145-0a46-44a9-3c1d6f67873e@xs4all.nl>
Date: Sun, 10 Jul 2016 14:55:21 +0200
MIME-Version: 1.0
In-Reply-To: <57823B25.5070709@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/10/2016 02:10 PM, Lars-Peter Clausen wrote:
> On 07/09/2016 11:36 PM, Steve Longerbeam wrote:
>>
>>
>> On 07/09/2016 02:10 PM, Steve Longerbeam wrote:
>>>
>>>
>>> On 07/09/2016 11:59 AM, Steve Longerbeam wrote:
>>>>
>>>>
>>>> On 07/07/2016 07:52 AM, Lars-Peter Clausen wrote:
>>>>> On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
>>>>>> Add a device tree boolean property "bt656-4" to allow setting
>>>>>> the ITU-R BT.656-4 compatible bit.
>>>>>>
>>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>>
>>>>> +    /* select ITU-R BT.656-4 compatible? */

Please don't use the '-4': BT.656 is sufficient. The -4 is just the version
number of the standard (and 5 is the latest anyway).

>>>>> +    if (of_property_read_bool(client->dev.of_node, "bt656-4"))
>>>>> +        state->bt656_4 = true;
>>>>> This property needs to be documented. In my opinion it should also be a
>>>>> property of the endpoint sub-node rather than the toplevel device node
>>>>> since
>>>>> this is a configuration of the endpoint format.
>>>>
>>>> Agreed, it's really a config of the backend capture endpoint. I'll move it
>>>> there and also document it in
>>>> Documentation/devicetree/bindings/media/i2c/adv7180.txt.
>>>
>>> er, scratch that. ITU-R BT.656 compatibility is really a property of the
>>> bt.656 bus. It
>>> should be added to v4l2 endpoints and parsed by v4l2_of_parse_endpoint().
>>> I've created
>>> a patch to add a "bt656-mode" property to v4l2 endpoints and will copy all
>>> the maintainers.
>>
>> But I'm going back and forth on whether this property should be added to the
>> adv7180's
>> local endpoint, or to the remote endpoint. I'm leaning towards the remote
>> endpoint, since
>> this is more about how the backend wants the bus configured.
> 
> I think it should be set for both, as both endpoints need to agree on the
> format.

Is it needed at all? Setting the polarity flags to H/VSYNC_ACTIVE_HIGH/LOW
will already signal BT.656 mode. See include/media/v4l2-mediabus.h and
v4l2-of.c.

I haven't looked in detail at adv7180, so I may have missed something, but this
looks strange.

Regards,

	Hans
