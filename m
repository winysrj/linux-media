Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45562 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932228AbcCRRaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 13:30:16 -0400
Subject: Re: [PATCHv13 05/17] HID: add HDMI CEC specific keycodes
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1458310036-19252-1-git-send-email-hans.verkuil@cisco.com>
 <1458310036-19252-6-git-send-email-hans.verkuil@cisco.com>
Cc: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56EC3B21.7060405@xs4all.nl>
Date: Fri, 18 Mar 2016 18:30:09 +0100
MIME-Version: 1.0
In-Reply-To: <1458310036-19252-6-git-send-email-hans.verkuil@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

Can you Ack this? I don't expect this to change anymore. Your comments have been
incorporated (added the "Diagonal movement keys" comment).

Thanks!

	Hans

On 03/18/2016 03:07 PM, Hans Verkuil wrote:
> From: Kamil Debski <kamil@wypas.org>
> 
> Add HDMI CEC specific keycodes to the keycodes definition.
> 
> Signed-off-by: Kamil Debski <kamil@wypas.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/input-event-codes.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
> index 87cf351..02b7b3a 100644
> --- a/include/uapi/linux/input-event-codes.h
> +++ b/include/uapi/linux/input-event-codes.h
> @@ -611,6 +611,36 @@
>  #define KEY_KBDINPUTASSIST_ACCEPT		0x264
>  #define KEY_KBDINPUTASSIST_CANCEL		0x265
>  
> +/* Diagonal movement keys */
> +#define KEY_RIGHT_UP			0x266
> +#define KEY_RIGHT_DOWN			0x267
> +#define KEY_LEFT_UP			0x268
> +#define KEY_LEFT_DOWN			0x269
> +
> +#define KEY_ROOT_MENU			0x26a /* Show Device's Root Menu */
> +#define KEY_MEDIA_TOP_MENU		0x26b /* Show Top Menu of the Media (e.g. DVD) */
> +#define KEY_NUMERIC_11			0x26c
> +#define KEY_NUMERIC_12			0x26d
> +/*
> + * Toggle Audio Description: refers to an audio service that helps blind and
> + * visually impaired consumers understand the action in a program. Note: in
> + * some countries this is referred to as "Video Description".
> + */
> +#define KEY_AUDIO_DESC			0x26e
> +#define KEY_3D_MODE			0x26f
> +#define KEY_NEXT_FAVORITE		0x270
> +#define KEY_STOP_RECORD			0x271
> +#define KEY_PAUSE_RECORD		0x272
> +#define KEY_VOD				0x273 /* Video on Demand */
> +#define KEY_UNMUTE			0x274
> +#define KEY_FASTREVERSE			0x275
> +#define KEY_SLOWREVERSE			0x276
> +/*
> + * Control a data application associated with the currently viewed channel,
> + * e.g. teletext or data broadcast application (MHEG, MHP, HbbTV, etc.)
> + */
> +#define KEY_DATA			0x275
> +
>  #define BTN_TRIGGER_HAPPY		0x2c0
>  #define BTN_TRIGGER_HAPPY1		0x2c0
>  #define BTN_TRIGGER_HAPPY2		0x2c1
> 

