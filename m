Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2KAU6l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Nov 2012 16:58:41 -0400
Message-ID: <5092E2EA.5010101@redhat.com>
Date: Thu, 01 Nov 2012 22:00:26 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2, RESEND] libv4lconvert: clarify the behavior and resulting
 restrictions of v4lconvert_convert()
References: <1350838722-15074-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838722-15074-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks, Looks good, added to git-master (with some trailing whitespace cleanups)

Regards,

Hans


On 10/21/2012 06:58 PM, Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>   lib/include/libv4lconvert.h |   20 ++++++++++++++++++--
>   1 Datei geändert, 18 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)
>
> diff --git a/lib/include/libv4lconvert.h b/lib/include/libv4lconvert.h
> index 167b57d..509655e 100644
> --- a/lib/include/libv4lconvert.h
> +++ b/lib/include/libv4lconvert.h
> @@ -89,8 +89,24 @@ LIBV4L_PUBLIC int v4lconvert_needs_conversion(struct v4lconvert_data *data,
>   		const struct v4l2_format *src_fmt,   /* in */
>   		const struct v4l2_format *dest_fmt); /* in */
>
> -/* return value of -1 on error, otherwise the amount of bytes written to
> -   dest */
> +/* This function does the following conversions:
> +    - format conversion
> +    - cropping
> +   if enabled:
> +    - processing (auto whitebalance, auto gain, gamma correction)
> +    - horizontal/vertical flipping
> +    - 90 degree (clockwise) rotation
> +
> +   NOTE: the last 3 steps are enabled/disabled depending on
> +    - the internal device list
> +    - the state of the (software emulated) image controls
> +
> +   Therefore this function should
> +    - not be used when getting the frames from libv4l
> +    - be called only once per frame
> +   Otherwise this may result in unintended double conversions !
> +
> +   Returns the amount of bytes written to dest and -1 on error */
>   LIBV4L_PUBLIC int v4lconvert_convert(struct v4lconvert_data *data,
>   		const struct v4l2_format *src_fmt,  /* in */
>   		const struct v4l2_format *dest_fmt, /* in */
>
