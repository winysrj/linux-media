Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35016 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbcGJORn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 10:17:43 -0400
Received: by mail-wm0-f48.google.com with SMTP id f65so37223355wmi.0
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2016 07:17:42 -0700 (PDT)
Subject: Re: [PATCH 06/11] media: adv7180: add bt.656-4 OF property
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-7-git-send-email-steve_longerbeam@mentor.com>
 <577E6C98.3020608@metafoo.de> <5781497A.2080804@gmail.com>
 <5781685C.7040907@mentor.com> <57816E47.90102@mentor.com>
 <57823B25.5070709@metafoo.de>
 <93d03258-d145-0a46-44a9-3c1d6f67873e@xs4all.nl>
Cc: linux-media@vger.kernel.org
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <8be92278-e1e1-fdf8-b11f-54054ae9a8ca@gmail.com>
Date: Sun, 10 Jul 2016 15:17:39 +0100
MIME-Version: 1.0
In-Reply-To: <93d03258-d145-0a46-44a9-3c1d6f67873e@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/07/16 13:55, Hans Verkuil wrote:
> On 07/10/2016 02:10 PM, Lars-Peter Clausen wrote:
>> On 07/09/2016 11:36 PM, Steve Longerbeam wrote:
>>>
>>> On 07/09/2016 02:10 PM, Steve Longerbeam wrote:
>>>>
>>>> On 07/09/2016 11:59 AM, Steve Longerbeam wrote:
>>>>>
>>>>> On 07/07/2016 07:52 AM, Lars-Peter Clausen wrote:
>>>>>> On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
>>>>>>> Add a device tree boolean property "bt656-4" to allow setting
>>>>>>> the ITU-R BT.656-4 compatible bit.
>>>>>>>
>>>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>>> +    /* select ITU-R BT.656-4 compatible? */
> Please don't use the '-4': BT.656 is sufficient. The -4 is just the version
> number of the standard (and 5 is the latest anyway).
 From the ADV7180 DS [1]:

BT.656-4, ITU-R BT.656-4 Enable, Address 0x04[7]

Between Revision 3 and Revision 4 of the ITU-R BT.656 standards, the ITU 
has changed the toggling position for the V bit within the SAV EAV codes 
for NTSC. The ITU-R BT.656-4 standard bit allows the user to select an 
output mode that is compliant with either the previous or new standard. 
For further information, visit the International Telecommunication Union 
website.

Note that the standard change only affects NTSC and has no bearing on PAL.

When ITU-R BT.656-4 is 0 (default), the ITU-R BT.656-3 specification is 
used. The V bit goes low at EAV of Line 10 and Line 273.

When ITU-R BT.656-4 is 1, the ITU-R BT.656-4 specification is used. The 
V bit goes low at EAV of Line 20 and Line 283.

[1]www.analog.com/media/en/technical-documentation/data-sheets/*ADV7180*.pdf 

>
>>>>>> +    if (of_property_read_bool(client->dev.of_node, "bt656-4"))
>>>>>> +        state->bt656_4 = true;
>>>>>> This property needs to be documented. In my opinion it should also be a
>>>>>> property of the endpoint sub-node rather than the toplevel device node
>>>>>> since
>>>>>> this is a configuration of the endpoint format.
>>>>> Agreed, it's really a config of the backend capture endpoint. I'll move it
>>>>> there and also document it in
>>>>> Documentation/devicetree/bindings/media/i2c/adv7180.txt.
>>>> er, scratch that. ITU-R BT.656 compatibility is really a property of the
>>>> bt.656 bus. It
>>>> should be added to v4l2 endpoints and parsed by v4l2_of_parse_endpoint().
>>>> I've created
>>>> a patch to add a "bt656-mode" property to v4l2 endpoints and will copy all
>>>> the maintainers.
>>> But I'm going back and forth on whether this property should be added to the
>>> adv7180's
>>> local endpoint, or to the remote endpoint. I'm leaning towards the remote
>>> endpoint, since
>>> this is more about how the backend wants the bus configured.
>> I think it should be set for both, as both endpoints need to agree on the
>> format.
> Is it needed at all? Setting the polarity flags to H/VSYNC_ACTIVE_HIGH/LOW
> will already signal BT.656 mode. See include/media/v4l2-mediabus.h and
> v4l2-of.c.
>
> I haven't looked in detail at adv7180, so I may have missed something, but this
> looks strange.
>
> Regards,
>
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

