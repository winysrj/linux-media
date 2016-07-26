Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36366 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbcGZB54 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 21:57:56 -0400
Subject: Re: [PATCH v3 3/9] media: adv7180: add support for NEWAVMODE
To: Ian Arkver <ian.arkver.dev@gmail.com>,
	Steve Longerbeam <steve_longerbeam@mentor.com>, lars@metafoo.de
References: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
 <1469293249-6774-4-git-send-email-steve_longerbeam@mentor.com>
 <b2f5e6ab-86f0-7caf-40bd-8b3259dce5cd@gmail.com>
 <0fa0100f-3c7a-9dc0-2b29-7de9da7e86b5@mentor.com>
 <67a21914-cf3d-7d80-7b80-6abfd26c1a21@gmail.com>
 <cd28566d-acaa-8d04-bb6c-042c27e4d51d@mentor.com>
 <153fdfbc-a929-6584-3f06-26413498c1fa@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <18f9e081-018d-26c2-e35e-262627826ed3@gmail.com>
Date: Mon, 25 Jul 2016 18:57:53 -0700
MIME-Version: 1.0
In-Reply-To: <153fdfbc-a929-6584-3f06-26413498c1fa@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/25/2016 03:24 PM, Ian Arkver wrote:
> On 25/07/16 23:04, Steve Longerbeam wrote:
>>
>>
>> On 07/25/2016 12:36 PM, Ian Arkver wrote:
>>> On 25/07/16 18:55, Steve Longerbeam wrote:
>>>> On 07/25/2016 05:04 AM, Ian Arkver wrote:
>>>>> On 23/07/16 18:00, Steve Longerbeam wrote:
>>>>>> <snip>
>>>>>> +#define ADV7180_VSYNC_FIELD_CTL_1_NEWAVMODE 0x02
>>>>> See below re this value.
>>>>>
>>>> Hi Ian, I double-checked the ADV7180 datasheet, this value is
>>>> correct. Bit 4, when cleared, _enables_ NEWAVMODE.
>>>
>>> Hah, ok. I'm not familiar enough with the history of this chip and didn't
>>> know what "OLDAVMODE" was. So, to enable NEWAVMODE you clear
>>> the NEWAVMODE bit. That makes perfect sense.
>>>
>>> Anyway, I still don't see what NEWAVMODE gets you.
>>
>> Hi Ian,
>>
>> With video standard auto-detect disabled in the chip (VID_SEL > 2), captured NTSC
>> images by the i.mx6q SabreAuto are corrupted, best I can describe it as "extremely
>> fuzzy". Only when newavmode is enabled do the images look good again, in manual
>> mode. With auto-detect enabled, images look good with or without newavmode.
>>
>> The strange this is, the auto-detected standard is identical to the standard set
>> explicitly in manual mode (NTSC-M). I did a complete i2c dump of the registers
>> for both auto-detect and manual mode, and found no other differences besides
>> the auto-detect/manual setting.
>>
>> Trying to track this down further would probably require a logic analyzer on the
>> bt.656 bus, which I don't have access to.
>>
>> I will not be debugging this further so NEWAVMODE it will have to remain.
>>
>> Steve
>
> OK, interesting. And weird indeed.
>
> I may be interfacing an ADV7280 to the i.MX6 in the August timeframe, depending on
> project needs etc. I'll see if I hit this with that chip. My test app does use autodetect.
>
> Incidentally, looking at the BT656-5 spec and comparing to the tvp5150, I see that
> the spec calls for 244 and 243 lines per field for NTSC, and the tvp5150 provides
> that number of lines. However this write...
>
> adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
>             ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
>
> where NVEND is 0x4f, configures the adv7180 to send only 242 lines in each field.
> Not sure if this is significant.

Right. I thought for sure that was the reason for the image problems, but
I tried commenting out that write (default value for ADV7180_REG_NTSC_V_BIT_END)
with NEWAVMODE disabled, and still the images were corrupted in manual mode.

Steve

