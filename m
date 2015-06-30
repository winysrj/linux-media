Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47694 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbbF3HiF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 03:38:05 -0400
Message-ID: <55924711.9070001@xs4all.nl>
Date: Tue, 30 Jun 2015 09:36:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org
Subject: Re: [PATCHv7 04/15] HID: add HDMI CEC specific keycodes
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com> <1435572900-56998-5-git-send-email-hans.verkuil@cisco.com> <20150629192509.GD22166@dtor-ws>
In-Reply-To: <20150629192509.GD22166@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/15 21:25, Dmitry Torokhov wrote:
> On Mon, Jun 29, 2015 at 12:14:49PM +0200, Hans Verkuil wrote:
>> From: Kamil Debski <kamil@wypas.org>
>>
>> Add HDMI CEC specific keycodes to the keycodes definition.
>>
>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Could you please describe the intended use for these keycodes for people
> who do not live and breathe CEC specs?

Do you want this as comments in the patch or as the commit description?

I realized that this patch needs to be updated anyway since there are a few
keys missing that were added for CEC 2.0.

Regards,

	Hans

> 
> Thanks!
> 
>> ---
>>  include/uapi/linux/input.h | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
>> index 731417c..7430a3f 100644
>> --- a/include/uapi/linux/input.h
>> +++ b/include/uapi/linux/input.h
>> @@ -752,6 +752,18 @@ struct input_keymap_entry {
>>  #define KEY_KBDINPUTASSIST_ACCEPT		0x264
>>  #define KEY_KBDINPUTASSIST_CANCEL		0x265
>>  
>> +#define KEY_RIGHT_UP			0x266
>> +#define KEY_RIGHT_DOWN			0x267
>> +#define KEY_LEFT_UP			0x268
>> +#define KEY_LEFT_DOWN			0x269
>> +
>> +#define KEY_NEXT_FAVORITE		0x270
>> +#define KEY_STOP_RECORD			0x271
>> +#define KEY_PAUSE_RECORD		0x272
>> +#define KEY_VOD				0x273
>> +#define KEY_UNMUTE			0x274
>> +#define KEY_DVB				0x275
>> +
>>  #define BTN_TRIGGER_HAPPY		0x2c0
>>  #define BTN_TRIGGER_HAPPY1		0x2c0
>>  #define BTN_TRIGGER_HAPPY2		0x2c1
>> -- 
>> 2.1.4
>>
> 
