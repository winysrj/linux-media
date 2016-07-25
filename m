Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33841 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbcGYTga (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 15:36:30 -0400
Subject: Re: [PATCH v3 3/9] media: adv7180: add support for NEWAVMODE
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Steve Longerbeam <slongerbeam@gmail.com>, lars@metafoo.de
References: <1469293249-6774-1-git-send-email-steve_longerbeam@mentor.com>
 <1469293249-6774-4-git-send-email-steve_longerbeam@mentor.com>
 <b2f5e6ab-86f0-7caf-40bd-8b3259dce5cd@gmail.com>
 <0fa0100f-3c7a-9dc0-2b29-7de9da7e86b5@mentor.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <67a21914-cf3d-7d80-7b80-6abfd26c1a21@gmail.com>
Date: Mon, 25 Jul 2016 20:36:26 +0100
MIME-Version: 1.0
In-Reply-To: <0fa0100f-3c7a-9dc0-2b29-7de9da7e86b5@mentor.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/07/16 18:55, Steve Longerbeam wrote:
> On 07/25/2016 05:04 AM, Ian Arkver wrote:
>> On 23/07/16 18:00, Steve Longerbeam wrote:
>>> Parse the optional v4l2 endpoint DT node. If the bus type is
>>> V4L2_MBUS_BT656 and the endpoint node specifies "newavmode",
>>> configure the BT.656 bus in NEWAVMODE.
>>>
>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>
>>> ---
>>>
>>> v3:
>>> - the newavmode endpoint property is now private to adv7180.
>>> ---
>>>   .../devicetree/bindings/media/i2c/adv7180.txt      |  4 ++
>>>   drivers/media/i2c/adv7180.c                        | 46 ++++++++++++++++++++--
>>>   2 files changed, 47 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>>> index 0d50115..6c175d2 100644
>>> --- a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>>> @@ -15,6 +15,10 @@ Required Properties :
>>>   		"adi,adv7282"
>>>   		"adi,adv7282-m"
>>>   
>>> +Optional Endpoint Properties :
>>> +- newavmode: a boolean property to indicate the BT.656 bus is operating
>>> +  in Analog Device's NEWAVMODE. Valid for BT.656 busses only.
>>> +
>>>   Example:
>>>   
>>>   	i2c0@1c22000 {
>>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
>>> index cb83ebb..3067d5f 100644
>>> --- a/drivers/media/i2c/adv7180.c
>>> +++ b/drivers/media/i2c/adv7180.c
>>> @@ -31,6 +31,7 @@
>>>   #include <media/v4l2-event.h>
>>>   #include <media/v4l2-device.h>
>>>   #include <media/v4l2-ctrls.h>
>>> +#include <media/v4l2-of.h>
>>>   #include <linux/mutex.h>
>>>   #include <linux/delay.h>
>>>   
>>> @@ -106,6 +107,7 @@
>>>   #define ADV7180_REG_SHAP_FILTER_CTL_1	0x0017
>>>   #define ADV7180_REG_CTRL_2		0x001d
>>>   #define ADV7180_REG_VSYNC_FIELD_CTL_1	0x0031
>>> +#define ADV7180_VSYNC_FIELD_CTL_1_NEWAVMODE 0x02
>> See below re this value.
>>
> Hi Ian, I double-checked the ADV7180 datasheet, this value is
> correct. Bit 4, when cleared, _enables_ NEWAVMODE.

Hah, ok. I'm not familiar enough with the history of this chip and didn't
know what "OLDAVMODE" was. So, to enable NEWAVMODE you clear
the NEWAVMODE bit. That makes perfect sense.

Anyway, I still don't see what NEWAVMODE gets you. As
far as I can see it just locks down the timings and removes the flexibility
the chip otherwise offers to move the BT656 SAV and EAV codes around
relative to the incoming video.

In what circumstances would you need to set the newavmode property
and change this default behaviour? We're not coupling the adv7180
back-to-back with an ADV video encoder here, which is what
NEWAVMODE is for and is presumably why AD recommend it for their
eval boards. We're trying to get a BT656 compliant stream, which is
what the default mode purports to generate.

Regards,
IanJ
>
>>>   #define ADV7180_REG_MANUAL_WIN_CTL_1	0x003d
>>>   #define ADV7180_REG_MANUAL_WIN_CTL_2	0x003e
>>>   #define ADV7180_REG_MANUAL_WIN_CTL_3	0x003f
>>> @@ -214,6 +216,7 @@ struct adv7180_state {
>>>   	struct mutex		mutex; /* mutual excl. when accessing chip */
>>>   	int			irq;
>>>   	v4l2_std_id		curr_norm;
>>> +	bool			newavmode;
>>>   	bool			powered;
>>>   	bool			streaming;
>>>   	u8			input;
>>> @@ -864,9 +867,15 @@ static int adv7180_init(struct adv7180_state *state)
>>>   	if (ret < 0)
>>>   		return ret;
>>>   
>>> -	/* Manually set V bit end position in NTSC mode */
>>> -	return adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
>>> -					ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
>>> +	if (!state->newavmode) {
>>> +		/* Manually set V bit end position in NTSC mode */
>>> +		ret = adv7180_write(state, ADV7180_REG_NTSC_V_BIT_END,
>>> +				    ADV7180_NTSC_V_BIT_END_MANUAL_NVEND);
>>> +		if (ret < 0)
>>> +			return ret;
>>> +	}
>>> +
>>> +	return 0;
>> According to the ADV7180 datasheet, rev. J, page 48 [1], when NEWAVMODE is 0,
>> no adjustments are possible to the output timings, which would imply this write
>> is ignored after your edit.
> That's correct, when NEWAVMODE is enabled (by clearing reg 0x31 bit 4), no
> adjustments are possible to the output timings:
>
>  From the rev J datasheet, page 91, when reg 0x31 bit 4 is set (NEAVMODE disabled):
>
> "Manual VS/FIELD position controlled by Register 0x32, Register 0x33, and
> Register 0xE5 to Register 0xEA"
>
>> 1: www.analog.com/media/en/technical-documentation/data-sheets/*ADV7180*.pdf
>>
>>>   }
>>>   
>>>   static int adv7180_set_std(struct adv7180_state *state, unsigned int std)
>>> @@ -1217,6 +1226,13 @@ static int init_device(struct adv7180_state *state)
>>>   	if (ret)
>>>   		goto out_unlock;
>>>   
>>> +	if (state->newavmode) {
>>> +		ret = adv7180_write(state, ADV7180_REG_VSYNC_FIELD_CTL_1,
>>> +				    ADV7180_VSYNC_FIELD_CTL_1_NEWAVMODE);
>>> +		if (ret < 0)
>>> +			goto out_unlock;
>>> +	}
>>> +
>> Again according to the DS, NEWAVMODE is set by default and enables a
>> stream which is by default CCIR656 compliant. Your edit writes 0x02 to
>> this register which actually clears NEWAVMODE (bit 4).
> correct, it clears bit 4 which _enables_ NEWAVMODE.
>
> NEWAVMODE by default is _disabled_ (bit 4 is set).
>
>
> Steve
>

