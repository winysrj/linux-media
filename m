Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39693 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbbEHLAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 07:00:55 -0400
Message-ID: <554C9755.7030102@xs4all.nl>
Date: Fri, 08 May 2015 13:00:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: Re: [PATCH v6 04/11] HID: add HDMI CEC specific keycodes
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com> <1430760785-1169-5-git-send-email-k.debski@samsung.com>
In-Reply-To: <1430760785-1169-5-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2015 07:32 PM, Kamil Debski wrote:
> Add HDMI CEC specific keycodes to the keycodes definition.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  include/uapi/linux/input.h |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index 731417c..7430a3f 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -752,6 +752,18 @@ struct input_keymap_entry {
>  #define KEY_KBDINPUTASSIST_ACCEPT		0x264
>  #define KEY_KBDINPUTASSIST_CANCEL		0x265
>  
> +#define KEY_RIGHT_UP			0x266
> +#define KEY_RIGHT_DOWN			0x267
> +#define KEY_LEFT_UP			0x268
> +#define KEY_LEFT_DOWN			0x269
> +
> +#define KEY_NEXT_FAVORITE		0x270
> +#define KEY_STOP_RECORD			0x271
> +#define KEY_PAUSE_RECORD		0x272
> +#define KEY_VOD				0x273
> +#define KEY_UNMUTE			0x274
> +#define KEY_DVB				0x275
> +
>  #define BTN_TRIGGER_HAPPY		0x2c0
>  #define BTN_TRIGGER_HAPPY1		0x2c0
>  #define BTN_TRIGGER_HAPPY2		0x2c1
> 

