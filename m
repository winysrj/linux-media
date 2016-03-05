Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:51467 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752494AbcCEIoe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 03:44:34 -0500
Subject: Re: [PATCHv12 05/17] HID: add HDMI CEC specific keycodes
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
 <1455108711-29850-6-git-send-email-hverkuil@xs4all.nl>
 <20160304195827.GE17145@dtor-ws>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56DA9C68.2080702@xs4all.nl>
Date: Sat, 5 Mar 2016 09:44:24 +0100
MIME-Version: 1.0
In-Reply-To: <20160304195827.GE17145@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

On 03/04/2016 08:58 PM, Dmitry Torokhov wrote:
> On Wed, Feb 10, 2016 at 01:51:39PM +0100, Hans Verkuil wrote:
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
> 
> Can you please add some comments to these and how they are different
> form normal KEY_UP/KEY_DOWN or KEY_DPAD* or BTN_A/B/X/Y.

These go in the diagonal direction (which is how they are different.)

I'll add a comment.

> 
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
> 
> KEY_FRAMEBACK maybe?

FRAMEBACK suggests to me that it goes back a single frame and then pauses
at that frame. Whereas SLOWREVERSE is continual slow reverse playback.

So I would prefer to keep it, unless you think otherwise.

BTW, the CEC spec actually has three variants for each of the slow/fast forward/reverse
commands: min/medium/max speed.

As you can see in the rc-cec.c patch (06/17) I'm mapping all three to a single key code:

        { 0x6005, KEY_FASTFORWARD },
        { 0x6006, KEY_FASTFORWARD },
        { 0x6007, KEY_FASTFORWARD },
        { 0x6015, KEY_SLOW },
        { 0x6016, KEY_SLOW },
        { 0x6017, KEY_SLOW },
        { 0x6009, KEY_FASTREVERSE },
        { 0x600a, KEY_FASTREVERSE },
        { 0x600b, KEY_FASTREVERSE },
        { 0x6019, KEY_SLOWREVERSE },
        { 0x601a, KEY_SLOWREVERSE },
        { 0x601b, KEY_SLOWREVERSE },

But in theory I might have to add e.g. KEY_FASTREVERSE_MIN/MAX in the future and
ditto for the other three speed keys. I don't want to do that now, though, as I
think that is overkill. But I might have to revisit this once I have a better idea
of what I can expect from CEC devices.

Thank you for the review, I'm planning to post a v13 soon.

Regards,

	Hans

> 
>> +/*
>> + * Control a data application associated with the currently viewed channel,
>> + * e.g. teletext or data broadcast application (MHEG, MHP, HbbTV, etc.)
>> + */
>> +#define KEY_DATA			0x275
>> +
>>  #define BTN_TRIGGER_HAPPY		0x2c0
>>  #define BTN_TRIGGER_HAPPY1		0x2c0
>>  #define BTN_TRIGGER_HAPPY2		0x2c1
>> -- 
>> 2.7.0
>>
> 
> Thanks.
> 
