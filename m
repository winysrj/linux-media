Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35704 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628AbcGLKZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 06:25:06 -0400
Received: by mail-lf0-f51.google.com with SMTP id f93so8827974lfi.2
        for <linux-media@vger.kernel.org>; Tue, 12 Jul 2016 03:25:05 -0700 (PDT)
Subject: Re: [PATCH 06/11] media: adv7180: add bt.656-4 OF property
To: Steve Longerbeam <steve_longerbeam@mentor.com>
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
 <578417CB.9060201@mentor.com>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b52ad9b6-7510-bfa8-bc52-2bf02cdd0eff@gmail.com>
Date: Tue, 12 Jul 2016 11:25:01 +0100
MIME-Version: 1.0
In-Reply-To: <578417CB.9060201@mentor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This conversation has drifted off topic, sorry.
It now relates to code in drivers/gpu/ipu-v3/ipu-csi.c, so adding 
Philipp Zabel.

On 11/07/16 23:03, Steve Longerbeam wrote:
> On 07/11/2016 12:06 AM, Ian Arkver wrote:
>> On 10/07/16 23:34, Steve Longerbeam wrote:
>>>
>>> On 07/10/2016 07:30 AM, Hans Verkuil wrote:
>>>> On 07/10/2016 04:17 PM, Ian Arkver wrote:
>>>>> On 10/07/16 13:55, Hans Verkuil wrote:
>>>>>> On 07/10/2016 02:10 PM, Lars-Peter Clausen wrote:
>>>>>>> On 07/09/2016 11:36 PM, Steve Longerbeam wrote:
>>>>>>>> On 07/09/2016 02:10 PM, Steve Longerbeam wrote:
>>>>>>>>> On 07/09/2016 11:59 AM, Steve Longerbeam wrote:
>>>>>>>>>> On 07/07/2016 07:52 AM, Lars-Peter Clausen wrote:
>>>>>>>>>>> On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
>>>>>>>>>>>> Add a device tree boolean property "bt656-4" to allow setting
>>>>>>>>>>>> the ITU-R BT.656-4 compatible bit.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>>>>>>>> +    /* select ITU-R BT.656-4 compatible? */
>>>>>> Please don't use the '-4': BT.656 is sufficient. The -4 is just the version
>>>>>> number of the standard (and 5 is the latest anyway).
>>>>>    From the ADV7180 DS [1]:
>>>>>
>>>>> BT.656-4, ITU-R BT.656-4 Enable, Address 0x04[7]
>>>>>
>>>>> Between Revision 3 and Revision 4 of the ITU-R BT.656 standards, the ITU
>>>>> has changed the toggling position for the V bit within the SAV EAV codes
>>>>> for NTSC. The ITU-R BT.656-4 standard bit allows the user to select an
>>>>> output mode that is compliant with either the previous or new standard.
>>>>> For further information, visit the International Telecommunication Union
>>>>> website.
>>>>>
>>>>> Note that the standard change only affects NTSC and has no bearing on PAL.
>>>>>
>>>>> When ITU-R BT.656-4 is 0 (default), the ITU-R BT.656-3 specification is
>>>>> used. The V bit goes low at EAV of Line 10 and Line 273.
>>>>>
>>>>> When ITU-R BT.656-4 is 1, the ITU-R BT.656-4 specification is used. The
>>>>> V bit goes low at EAV of Line 20 and Line 283.
>>>>>
>>>>> [1]www.analog.com/media/en/technical-documentation/data-sheets/*ADV7180*.pdf
>>>> Rev 4 came in in 1998. I would say that that is the default. We have had any
>>>> problems with this and I would need some proof that this is really needed.
>>> Hi Hans, yeah I agree with you that new capture drivers should not
>>> expect BT.656-3 compatible buss' any longer. The problem with i.MX6
>>> however, is that the IPU CSI CCIR_CODE registers, which inform the IPU
>>> about the AV code positions, are very poorly documented. In order for
>>> i.MX6 to support BT.656-4 it would require very time-consuming reverse
>>> engineering to find the right values to plug into those registers to conform
>>> to the BT.656-4 AV code positions.
>>>
>>> Steve
>>>
>> Hi Steve,
>>
>> Once you dsicover that the 3-bit fields in each CCIR_CODE register correspond to the H, V and F flags in the SAV/EAV code (in that order, MSbit->LSbit),  those registers make more sense. Pity that's
>> not mentioned in the Ref Manual.
> Hi Ian, that's a plausible theory, but it doesn't work. I looked at the value
> programmed to CCIR_CODE_1 register (according to imx6 ref manual is
> values for first field), for NTSC : 0xD07DF.  Comparing with the definition of
> the H/V/F bits in the AV codes in the bt.656 spec:
>
> F = 1 during field 2, 0 during field 1
> V = 1 during field blanking, 0 elsewhere
> H = 1 in EAV, 0 in SAV
>
> There's no correspondence, for example F bit should be zero everywhere in
> CCIR_CODE_1. And wutz this "first/second blanking line command" stuff about?
> None of it makes any sense to me.
Hi,

d07df = 001 101 xxxx 011 111 011 111

                           H V F
CSI0_STRT_FLD0_ACTV       0 0 1
CSI0_END_FLD0_ACTV        1 0 1
CSI0_STRT_FLD0_BLNK_2ND   0 1 1
CSI0_END_FLD0_BLNK_2ND    1 1 1
CSI0_STRT_FLD0_BLNK_1ST   0 1 1
CSI0_END_FLD0_BLNK_1ST    1 1 1

40596 = 000 100 xxxx 010 110 010 110
405A6 = 000 100 xxxx 010 110 100 110

                           H V F
CSI0_STRT_FLD1_ACTV       0 0 0
CSI0_END_FLD1_ACTV        1 0 0
CSI0_STRT_FLD1_BLNK_2ND   0 1 0
CSI0_END_FLD1_BLNK_2ND    1 1 0
CSI0_STRT_FLD1_BLNK_1ST   0 1 0    or 1 0 0 ?
CSI0_END_FLD1_BLNK_1ST    1 1 0

For PAL:  IPU_CSI0_CCIR_CODE_1 = 0x40596, IPU_CSI0_CCIR_CODE_1 = 0xd07df
For NTSC: IPU_CSI0_CCIR_CODE_1 = 0xd07df, IPU_CSI0_CCIR_CODE_1 = 0x405A6

So, for the PAL case the field values make sense to me. The F bit is 
constant throughout each field.
I'm not sure why the NTSC case has 405A6 instead of 40596 again. This 
looks like a bug to me.
If you look back at the original Freescale capture driver[1], they use 
40596 for both PAL and NTSC.

The values are swapped between NTSC and PAL to account for the differing 
field order. I think using
the capture width and height to do this is poor as any "bt.656-like" 
source with non standard
dimensions will end up in the dev_err("Unsupported") case. Also, looking 
at BT.1120-8, for interlaced
video the same SAV and EAV codes as PAL are used, so 
IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR and
IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR modes are currently broken.

I think the 1st and 2nd blanking values might be needed for some odd non 
656 streams maybe? Also for
progressive (originally) the value 40030 is used which is

40030 = 000 100 xxxx 000 000 110 000

This leaves the 2nd blank values empty. In the HW I'd guess both fire on 
SAV but there's a fixed
event priority in the state machine, or it ignores events where both 
STRT and END fire on the same
clock tick.

btw: The patch I sent you a while back[2] dumps the CCIR values in octal 
which makes them
a bit more readable. It also fixes up theCSI0_STRT_FLD0_BLNK_1ST value 
for progressive bt.656 to
be {0 1 0}, which matches what's seen in the stream. In theory the 
blanking end value should
be {1 1 0}, but it seems to work OK with the same code as unblanked SAV 
{0 0 0}. If it's useful
I can rebase and post that patch to the ML.

Maybe I should create an RFC patch for ipu-csi.c and stop hijacking this 
thread?

1: 
https://github.com/Freescale/linux-fslc/blob/3.14-1.1.x-imx/drivers/mxc/ipu3/ipu_capture.c#L168
2: 0003-ipu_csi-more-debug.-Fix-Blanking-SAV-for-progressive.patch


>
>> However, I don't think that's relevant here, since the spec revision didn't change the codes, but just moved the lines the V bit is sent on. I believe the spec change switched the NTSC timing from
>> VSYNC to VBLANK, but the net effect was 10 fewer "active" video lines per field. Looking at a sample of one other video decoder (tvp5150), the default seems to be to change V on lines 20 and 283, as
>> per the newer revision of the spec., though again bets may have been hedged with a programmable override.
>>
>> In any case, I'm wondering if your extra ten lines per field are more related to this snippet from calc_default_crop in imx-camif.c, which seems like it would break other decoder front ends and
>> adv7180 in bt656-4 mode...
>>
>>      /*
>>       * FIXME: For NTSC standards, top must be set to an
>>       * offset of 13 lines to match fixed CCIR programming
>>       * in the IPU.
>>       */
>>      if (std != V4L2_STD_UNKNOWN && (std & V4L2_STD_525_60))
>>          rect->top = 13;
> could be. I'll try removing that FIXME block and try with bt.656-4 mode.
>
> Steve
>
>> I believe tvp5150 at least sends 243 active lines per field for an NTSC source and the top 3 lines are generally dropped.
>>
>> Regards,
>> Ian

All the best,
Ian
