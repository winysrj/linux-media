Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:35728 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750898AbeCIKzJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:55:09 -0500
Subject: Re: [PATCH 1/2] usbtv: Use same decoder sequence as Windows driver
To: "Hugo \"Bonstra\" Grostabussiat" <bonstra@bonstra.fr.eu.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
References: <20180224182419.15670-1-bonstra@bonstra.fr.eu.org>
 <20180224182419.15670-2-bonstra@bonstra.fr.eu.org>
 <de1f0031-be47-1c7b-265e-da32825f66b9@xs4all.nl>
 <7969d9ad-9ff7-3221-cca0-8b2f59274bbf@bonstra.fr.eu.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d7be9472-d71b-2ad4-a794-d0982ca9a51e@xs4all.nl>
Date: Fri, 9 Mar 2018 11:55:06 +0100
MIME-Version: 1.0
In-Reply-To: <7969d9ad-9ff7-3221-cca0-8b2f59274bbf@bonstra.fr.eu.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/02/18 23:35, Hugo "Bonstra" Grostabussiat wrote:
> Le 26/02/2018 à 15:12, Hans Verkuil a écrit :
>> Thanks for this patch, but I am a bit hesitant to apply it. Did you test
>> that PAL and NTSC still work after this change?
> 
> I did test with both a PAL and a NTSC source before submitting the
> patch. It seemed to work fine.

That's great!

> However, after reading your reply, I needed to be certain, so I
> double-checked using the Windows driver USB dumps I collected.
> 
> When it sets the TV standard, the Windows driver:
> 
>   1. plays the decoder configuration sequence, in the exact same order
>      as the one specified in the .INF file.
>      -> My patch 1 does that, the unpatched driver doesn't
> 
>   2. sets registers 0xc24e and 0xc24f to value 0x02.
>      -> The unpatched driver does this, my patch 1 doesn't, which is
>         a regression
> 
>   3. sets register 0xc16f to a different value for PAL, NTSC and
>      SECAM.
>      -> No write is ever done to that register by the patched
>         or the unpatched drivers
> 
> About step 3, I added it to the usbtv driver, and quickly understood
> what register 0xc16f is for. It actually sets the standard for color
> encoding!
> It would seem that by default, the decoder auto-detects the standard
> used to encode the color signal, and that writing a value to that
> register forces selection of a specific standard.
> 
> So, with the current unpatched driver, capturing a PAL source while
> setting the V4L2 norm to NTSC will still get the colors right (mostly),
> but the image will be clipped at the bottom because of the lower
> vertical resolution used for NTSC.
> 
> With the Windows driver or the usbtv driver patched to set the
> norm in register 0xc16f, capturing a PAL source with the adapter
> configured for NTSC would give the result you would expect from
> misconfigured hardware: incorrect resolution and messed-up colors.
> 
> Here are some screenshots to illustrate the matter:
> 
> * Unpatched driver, PAL source, adapter configured for PAL.
>   Picture is fully displayed, and colors are ok. Used as reference:
> 
> https://www.bonstra.fr.eu.org/pub/img/usbtv_unpatched-PAL_source-PAL_setting.png
> 
> * Unpatched driver, PAL source, adapter configured for NTSC.
>   A part of the picture is cut at the bottom, colors are ok:
> 
> https://www.bonstra.fr.eu.org/pub/img/usbtv_unpatched-PAL_source-NTSC_setting.png
> 
> * Patched driver, PAL source, adapter configured for NTSC:
>   Picture bottom is clipped, vertical stripes with the wrong colors
>   are present over the colored areas:
> 
> https://www.bonstra.fr.eu.org/pub/img/usbtv_patched-PAL_source-NTSC_setting.png
> 
> Now about part 1; the sequence of register writes before actually
> setting the color system register is there to set the image correction
> parameters, such as color correction or image sharpness, appropriate
> for the selected standard.
> 
>> Unless you've tested it then I'm inclined to just apply the second patch that
>> adds the SECAM sequence.
> 
> Applying only patch 2 would get some values of the image correction
> registers overwritten with PAL/NTSC values which were put in common
> since they were identical (registers 0xc100, 0xc115, 0xc220, 0xc225 and
> 0xc24e).
> 
> I think I should make a v2 of this patch series which:
>   1. fixes the mistakes I made in patch 1
>   2. add SECAM image correction settings sequence
>   3. writes the standard setting to register 0xc16f so that we get as
>      closes as possible to the Windows driver behavior
>   4. handles the PAL_60 case (NTSC resolution with PAL-like color
>      subcarrier) which was working "by accident" until now
> 
> What do you think of all this?

Sounds good. Since you can test with PAL and NTSC sources (besides SECAM) you
can verify that everything works. So I'm happy to apply a v2.

Regards,

	Hans

> 
> Regards
> --
> Hugo
> 
>> On 02/24/2018 07:24 PM, Hugo Grostabussiat wrote:
>>> Re-format the register {address, value} pairs so they follow the same
>>> order as the decoder configuration sequences in the Windows driver's .INF
>>> file.
>>>
>>> For instance, for PAL, the "AVPAL" sequence in the .INF file is:
>>> 0x04,0x68,0xD3,0x72,0xA2,0xB0,0x15,0x01,0x2C,0x10,0x20,0x2e,0x08,0x02,
>>> 0x02,0x59,0x16,0x35,0x17,0x16,0x36
>>>
>>> Signed-off-by: Hugo Grostabussiat <bonstra@bonstra.fr.eu.org>
>>> ---
>>>  drivers/media/usb/usbtv/usbtv-video.c | 26 +++++++++++++++++---------
>>>  1 file changed, 17 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
>>> index 3668a04359e8..52d06b30fabb 100644
>>> --- a/drivers/media/usb/usbtv/usbtv-video.c
>>> +++ b/drivers/media/usb/usbtv/usbtv-video.c
>>> @@ -124,15 +124,26 @@ static int usbtv_select_input(struct usbtv *usbtv, int input)
>>>  static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
>>>  {
>>>  	int ret;
>>> +	/* These are the series of register values used to configure the
>>> +	 * decoder for a specific standard.
>>> +	 * They are copied from the Settings\DecoderDefaults registry keys
>>> +	 * present in the Windows driver .INF file for each norm.
>>> +	 */
>>>  	static const u16 pal[][2] = {
>>> +		{ USBTV_BASE + 0x0003, 0x0004 },
>>>  		{ USBTV_BASE + 0x001a, 0x0068 },
>>> +		{ USBTV_BASE + 0x0100, 0x00d3 },
>>>  		{ USBTV_BASE + 0x010e, 0x0072 },
>>>  		{ USBTV_BASE + 0x010f, 0x00a2 },
>>>  		{ USBTV_BASE + 0x0112, 0x00b0 },
>>> +		{ USBTV_BASE + 0x0115, 0x0015 },
>>>  		{ USBTV_BASE + 0x0117, 0x0001 },
>>>  		{ USBTV_BASE + 0x0118, 0x002c },
>>>  		{ USBTV_BASE + 0x012d, 0x0010 },
>>>  		{ USBTV_BASE + 0x012f, 0x0020 },
>>> +		{ USBTV_BASE + 0x0220, 0x002e },
>>> +		{ USBTV_BASE + 0x0225, 0x0008 },
>>> +		{ USBTV_BASE + 0x024e, 0x0002 },
>>>  		{ USBTV_BASE + 0x024f, 0x0002 },
>>>  		{ USBTV_BASE + 0x0254, 0x0059 },
>>>  		{ USBTV_BASE + 0x025a, 0x0016 },
>>> @@ -143,14 +154,20 @@ static int usbtv_select_norm(struct usbtv *usbtv, v4l2_std_id norm)
>>>  	};
>>>  
>>>  	static const u16 ntsc[][2] = {
>>> +		{ USBTV_BASE + 0x0003, 0x0004 },
>>>  		{ USBTV_BASE + 0x001a, 0x0079 },
>>> +		{ USBTV_BASE + 0x0100, 0x00d3 },
>>>  		{ USBTV_BASE + 0x010e, 0x0068 },
>>>  		{ USBTV_BASE + 0x010f, 0x009c },
>>>  		{ USBTV_BASE + 0x0112, 0x00f0 },
>>> +		{ USBTV_BASE + 0x0115, 0x0015 },
>>>  		{ USBTV_BASE + 0x0117, 0x0000 },
>>>  		{ USBTV_BASE + 0x0118, 0x00fc },
>>>  		{ USBTV_BASE + 0x012d, 0x0004 },
>>>  		{ USBTV_BASE + 0x012f, 0x0008 },
>>> +		{ USBTV_BASE + 0x0220, 0x002e },
>>> +		{ USBTV_BASE + 0x0225, 0x0008 },
>>> +		{ USBTV_BASE + 0x024e, 0x0002 },
>>>  		{ USBTV_BASE + 0x024f, 0x0001 },
>>>  		{ USBTV_BASE + 0x0254, 0x005f },
>>>  		{ USBTV_BASE + 0x025a, 0x0012 },
>>> @@ -236,15 +253,6 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
>>>  		{ USBTV_BASE + 0x0158, 0x001f },
>>>  		{ USBTV_BASE + 0x0159, 0x0006 },
>>>  		{ USBTV_BASE + 0x015d, 0x0000 },
>>> -
>>> -		{ USBTV_BASE + 0x0003, 0x0004 },
>>> -		{ USBTV_BASE + 0x0100, 0x00d3 },
>>> -		{ USBTV_BASE + 0x0115, 0x0015 },
>>> -		{ USBTV_BASE + 0x0220, 0x002e },
>>> -		{ USBTV_BASE + 0x0225, 0x0008 },
>>> -		{ USBTV_BASE + 0x024e, 0x0002 },
>>> -		{ USBTV_BASE + 0x024e, 0x0002 },
>>> -		{ USBTV_BASE + 0x024f, 0x0002 },
>>>  	};
>>>  
>>>  	ret = usbtv_set_regs(usbtv, setup, ARRAY_SIZE(setup));
>>>
>>
> 
