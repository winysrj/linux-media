Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:39147 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbcGKWD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 18:03:58 -0400
Subject: Re: [PATCH 06/11] media: adv7180: add bt.656-4 OF property
To: Ian Arkver <ian.arkver.dev@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Lars-Peter Clausen <lars@metafoo.de>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-7-git-send-email-steve_longerbeam@mentor.com>
 <577E6C98.3020608@metafoo.de> <5781497A.2080804@gmail.com>
 <5781685C.7040907@mentor.com> <57816E47.90102@mentor.com>
 <57823B25.5070709@metafoo.de>
 <93d03258-d145-0a46-44a9-3c1d6f67873e@xs4all.nl>
 <8be92278-e1e1-fdf8-b11f-54054ae9a8ca@gmail.com>
 <557f0160-11a0-36c8-c303-c4626f81df45@xs4all.nl>
 <5782CD6F.4020202@mentor.com>
 <b49d5433-67b6-9dd4-140d-ad310326f647@gmail.com>
CC: <linux-media@vger.kernel.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <578417CB.9060201@mentor.com>
Date: Mon, 11 Jul 2016 15:03:55 -0700
MIME-Version: 1.0
In-Reply-To: <b49d5433-67b6-9dd4-140d-ad310326f647@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2016 12:06 AM, Ian Arkver wrote:
> On 10/07/16 23:34, Steve Longerbeam wrote:
>>
>>
>> On 07/10/2016 07:30 AM, Hans Verkuil wrote:
>>> On 07/10/2016 04:17 PM, Ian Arkver wrote:
>>>> On 10/07/16 13:55, Hans Verkuil wrote:
>>>>> On 07/10/2016 02:10 PM, Lars-Peter Clausen wrote:
>>>>>> On 07/09/2016 11:36 PM, Steve Longerbeam wrote:
>>>>>>> On 07/09/2016 02:10 PM, Steve Longerbeam wrote:
>>>>>>>> On 07/09/2016 11:59 AM, Steve Longerbeam wrote:
>>>>>>>>> On 07/07/2016 07:52 AM, Lars-Peter Clausen wrote:
>>>>>>>>>> On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
>>>>>>>>>>> Add a device tree boolean property "bt656-4" to allow setting
>>>>>>>>>>> the ITU-R BT.656-4 compatible bit.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>>>>>>> +    /* select ITU-R BT.656-4 compatible? */
>>>>> Please don't use the '-4': BT.656 is sufficient. The -4 is just the version
>>>>> number of the standard (and 5 is the latest anyway).
>>>>   From the ADV7180 DS [1]:
>>>>
>>>> BT.656-4, ITU-R BT.656-4 Enable, Address 0x04[7]
>>>>
>>>> Between Revision 3 and Revision 4 of the ITU-R BT.656 standards, the ITU
>>>> has changed the toggling position for the V bit within the SAV EAV codes
>>>> for NTSC. The ITU-R BT.656-4 standard bit allows the user to select an
>>>> output mode that is compliant with either the previous or new standard.
>>>> For further information, visit the International Telecommunication Union
>>>> website.
>>>>
>>>> Note that the standard change only affects NTSC and has no bearing on PAL.
>>>>
>>>> When ITU-R BT.656-4 is 0 (default), the ITU-R BT.656-3 specification is
>>>> used. The V bit goes low at EAV of Line 10 and Line 273.
>>>>
>>>> When ITU-R BT.656-4 is 1, the ITU-R BT.656-4 specification is used. The
>>>> V bit goes low at EAV of Line 20 and Line 283.
>>>>
>>>> [1]www.analog.com/media/en/technical-documentation/data-sheets/*ADV7180*.pdf
>>> Rev 4 came in in 1998. I would say that that is the default. We have had any
>>> problems with this and I would need some proof that this is really needed.
>>
>> Hi Hans, yeah I agree with you that new capture drivers should not
>> expect BT.656-3 compatible buss' any longer. The problem with i.MX6
>> however, is that the IPU CSI CCIR_CODE registers, which inform the IPU
>> about the AV code positions, are very poorly documented. In order for
>> i.MX6 to support BT.656-4 it would require very time-consuming reverse
>> engineering to find the right values to plug into those registers to conform
>> to the BT.656-4 AV code positions.
>>
>> Steve
>>
> Hi Steve,
>
> Once you dsicover that the 3-bit fields in each CCIR_CODE register correspond to the H, V and F flags in the SAV/EAV code (in that order, MSbit->LSbit),  those registers make more sense. Pity that's
> not mentioned in the Ref Manual.

Hi Ian, that's a plausible theory, but it doesn't work. I looked at the value
programmed to CCIR_CODE_1 register (according to imx6 ref manual is
values for first field), for NTSC : 0xD07DF.  Comparing with the definition of
the H/V/F bits in the AV codes in the bt.656 spec:

F = 1 during field 2, 0 during field 1
V = 1 during field blanking, 0 elsewhere
H = 1 in EAV, 0 in SAV

There's no correspondence, for example F bit should be zero everywhere in
CCIR_CODE_1. And wutz this "first/second blanking line command" stuff about?
None of it makes any sense to me.

> However, I don't think that's relevant here, since the spec revision didn't change the codes, but just moved the lines the V bit is sent on. I believe the spec change switched the NTSC timing from
> VSYNC to VBLANK, but the net effect was 10 fewer "active" video lines per field. Looking at a sample of one other video decoder (tvp5150), the default seems to be to change V on lines 20 and 283, as
> per the newer revision of the spec., though again bets may have been hedged with a programmable override.
>
> In any case, I'm wondering if your extra ten lines per field are more related to this snippet from calc_default_crop in imx-camif.c, which seems like it would break other decoder front ends and
> adv7180 in bt656-4 mode...
>
>     /*
>      * FIXME: For NTSC standards, top must be set to an
>      * offset of 13 lines to match fixed CCIR programming
>      * in the IPU.
>      */
>     if (std != V4L2_STD_UNKNOWN && (std & V4L2_STD_525_60))
>         rect->top = 13;

could be. I'll try removing that FIXME block and try with bt.656-4 mode.

Steve

>
> I believe tvp5150 at least sends 243 active lines per field for an NTSC source and the top 3 lines are generally dropped.
>
> Regards,
> Ian 
