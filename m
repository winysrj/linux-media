Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45836 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976AbcBXIbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 03:31:20 -0500
Subject: Re: [PATCHv12 05/17] HID: add HDMI CEC specific keycodes
To: linux-media@vger.kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
 <1455108711-29850-6-git-send-email-hverkuil@xs4all.nl>
 <56BDA577.5060302@xs4all.nl>
Cc: linux-input@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56CD6A53.4090606@xs4all.nl>
Date: Wed, 24 Feb 2016 09:31:15 +0100
MIME-Version: 1.0
In-Reply-To: <56BDA577.5060302@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry,

Ping!

Regards,

	Hans

On 02/12/16 10:27, Hans Verkuil wrote:
> Dmitry,
> 
> Can you provide an Ack for this patch?
> 
> Thanks!
> 
> 	Hans
> 
> On 02/10/2016 01:51 PM, Hans Verkuil wrote:
>> From: Kamil Debski <kamil@wypas.org>
>>
>> Add HDMI CEC specific keycodes to the keycodes definition.
>>
>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  include/uapi/linux/input-event-codes.h | 28 ++++++++++++++++++++++++++++
>>  1 file changed, 28 insertions(+)
>>
>> diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
>> index 87cf351..2662500 100644
>> --- a/include/uapi/linux/input-event-codes.h
>> +++ b/include/uapi/linux/input-event-codes.h
>> @@ -611,6 +611,34 @@
>>  #define KEY_KBDINPUTASSIST_ACCEPT		0x264
>>  #define KEY_KBDINPUTASSIST_CANCEL		0x265
>>  
>> +#define KEY_RIGHT_UP			0x266
>> +#define KEY_RIGHT_DOWN			0x267
>> +#define KEY_LEFT_UP			0x268
>> +#define KEY_LEFT_DOWN			0x269
>> +#define KEY_ROOT_MENU			0x26a /* Show Device's Root Menu */
>> +#define KEY_MEDIA_TOP_MENU		0x26b /* Show Top Menu of the Media (e.g. DVD) */
>> +#define KEY_NUMERIC_11			0x26c
>> +#define KEY_NUMERIC_12			0x26d
>> +/*
>> + * Toggle Audio Description: refers to an audio service that helps blind and
>> + * visually impaired consumers understand the action in a program. Note: in
>> + * some countries this is referred to as "Video Description".
>> + */
>> +#define KEY_AUDIO_DESC			0x26e
>> +#define KEY_3D_MODE			0x26f
>> +#define KEY_NEXT_FAVORITE		0x270
>> +#define KEY_STOP_RECORD			0x271
>> +#define KEY_PAUSE_RECORD		0x272
>> +#define KEY_VOD				0x273 /* Video on Demand */
>> +#define KEY_UNMUTE			0x274
>> +#define KEY_FASTREVERSE			0x275
>> +#define KEY_SLOWREVERSE			0x276
>> +/*
>> + * Control a data application associated with the currently viewed channel,
>> + * e.g. teletext or data broadcast application (MHEG, MHP, HbbTV, etc.)
>> + */
>> +#define KEY_DATA			0x275
>> +
>>  #define BTN_TRIGGER_HAPPY		0x2c0
>>  #define BTN_TRIGGER_HAPPY1		0x2c0
>>  #define BTN_TRIGGER_HAPPY2		0x2c1
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
