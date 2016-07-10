Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:62531 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbcGJWe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 18:34:28 -0400
Subject: Re: [PATCH 06/11] media: adv7180: add bt.656-4 OF property
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Ian Arkver <ian.arkver.dev@gmail.com>,
	Lars-Peter Clausen <lars@metafoo.de>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-7-git-send-email-steve_longerbeam@mentor.com>
 <577E6C98.3020608@metafoo.de> <5781497A.2080804@gmail.com>
 <5781685C.7040907@mentor.com> <57816E47.90102@mentor.com>
 <57823B25.5070709@metafoo.de>
 <93d03258-d145-0a46-44a9-3c1d6f67873e@xs4all.nl>
 <8be92278-e1e1-fdf8-b11f-54054ae9a8ca@gmail.com>
 <557f0160-11a0-36c8-c303-c4626f81df45@xs4all.nl>
CC: <linux-media@vger.kernel.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <5782CD6F.4020202@mentor.com>
Date: Sun, 10 Jul 2016 15:34:23 -0700
MIME-Version: 1.0
In-Reply-To: <557f0160-11a0-36c8-c303-c4626f81df45@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/10/2016 07:30 AM, Hans Verkuil wrote:
> On 07/10/2016 04:17 PM, Ian Arkver wrote:
>> On 10/07/16 13:55, Hans Verkuil wrote:
>>> On 07/10/2016 02:10 PM, Lars-Peter Clausen wrote:
>>>> On 07/09/2016 11:36 PM, Steve Longerbeam wrote:
>>>>> On 07/09/2016 02:10 PM, Steve Longerbeam wrote:
>>>>>> On 07/09/2016 11:59 AM, Steve Longerbeam wrote:
>>>>>>> On 07/07/2016 07:52 AM, Lars-Peter Clausen wrote:
>>>>>>>> On 07/07/2016 12:59 AM, Steve Longerbeam wrote:
>>>>>>>>> Add a device tree boolean property "bt656-4" to allow setting
>>>>>>>>> the ITU-R BT.656-4 compatible bit.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>>>>> +    /* select ITU-R BT.656-4 compatible? */
>>> Please don't use the '-4': BT.656 is sufficient. The -4 is just the version
>>> number of the standard (and 5 is the latest anyway).
>>   From the ADV7180 DS [1]:
>>
>> BT.656-4, ITU-R BT.656-4 Enable, Address 0x04[7]
>>
>> Between Revision 3 and Revision 4 of the ITU-R BT.656 standards, the ITU
>> has changed the toggling position for the V bit within the SAV EAV codes
>> for NTSC. The ITU-R BT.656-4 standard bit allows the user to select an
>> output mode that is compliant with either the previous or new standard.
>> For further information, visit the International Telecommunication Union
>> website.
>>
>> Note that the standard change only affects NTSC and has no bearing on PAL.
>>
>> When ITU-R BT.656-4 is 0 (default), the ITU-R BT.656-3 specification is
>> used. The V bit goes low at EAV of Line 10 and Line 273.
>>
>> When ITU-R BT.656-4 is 1, the ITU-R BT.656-4 specification is used. The
>> V bit goes low at EAV of Line 20 and Line 283.
>>
>> [1]www.analog.com/media/en/technical-documentation/data-sheets/*ADV7180*.pdf
> Rev 4 came in in 1998. I would say that that is the default. We have had any
> problems with this and I would need some proof that this is really needed.

Hi Hans, yeah I agree with you that new capture drivers should not
expect BT.656-3 compatible buss' any longer. The problem with i.MX6
however, is that the IPU CSI CCIR_CODE registers, which inform the IPU
about the AV code positions, are very poorly documented. In order for
i.MX6 to support BT.656-4 it would require very time-consuming reverse
engineering to find the right values to plug into those registers to conform
to the BT.656-4 AV code positions.

Steve

