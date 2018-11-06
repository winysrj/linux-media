Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44644 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388029AbeKFXJs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 18:09:48 -0500
Subject: Re: [PATCH] media: v4l: fix uapi mpeg slice params definition
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181102110945.191868-1-arnd@arndb.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d1ba33ad-ca69-1cbc-bd14-4935426c0abf@xs4all.nl>
Date: Tue, 6 Nov 2018 14:44:23 +0100
MIME-Version: 1.0
In-Reply-To: <20181102110945.191868-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd, Maxime, Paul,

Sorry for the late reply, I was on vacation and only saw this patch now.

On 11/02/18 12:09, Arnd Bergmann wrote:
> We get a headers_check warning about the newly defined ioctl command
> structures:
> 
> ./usr/include/linux/v4l2-controls.h:1105: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> This is resolved by including linux/types.h, as suggested by the
> warning, but there is another problem: Three of the four structures
> have an odd number of __u8 headers, but are aligned to 32 bit in the
> v4l2_ctrl_mpeg2_slice_params, so we get an implicit padding byte
> for each one. To solve that, let's add explicit padding that can
> be set to zero and verified in the kernel.
> 
> Fixes: c27bb30e7b6d ("media: v4l: Add definitions for MPEG-2 slice format and metadata")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 5 +++++
>  include/uapi/linux/v4l2-controls.h   | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 6e37950292cd..5f2b033a7a42 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1664,6 +1664,11 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
>  		    p_mpeg2_slice_params->forward_ref_index >= VIDEO_MAX_FRAME)
>  			return -EINVAL;
>  
> +		if (p_mpeg2_slice_params->pad ||
> +		    p_mpeg2_slice_params->picture.pad ||
> +		    p_mpeg2_slice_params->sequence.pad)
> +			return -EINVAL;
> +

Yuck.

>  		return 0;
>  
>  	case V4L2_CTRL_TYPE_MPEG2_QUANTIZATION:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 51b095898f4b..998983a6e6b7 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -50,6 +50,8 @@
>  #ifndef __LINUX_V4L2_CONTROLS_H
>  #define __LINUX_V4L2_CONTROLS_H
>  
> +#include <linux/types.h>
> +
>  /* Control classes */
>  #define V4L2_CTRL_CLASS_USER		0x00980000	/* Old-style 'user' controls */
>  #define V4L2_CTRL_CLASS_MPEG		0x00990000	/* MPEG-compression controls */
> @@ -1110,6 +1112,7 @@ struct v4l2_mpeg2_sequence {
>  	__u8	profile_and_level_indication;
>  	__u8	progressive_sequence;
>  	__u8	chroma_format;
> +	__u8	pad;

Rather than adding spurious 'pad' fields, can't we just change one of the u8 to u16?

Much cleaner that way.

Maxime, Paul, what do you think?

Regards,

	Hans

>  };
>  
>  struct v4l2_mpeg2_picture {
> @@ -1128,6 +1131,7 @@ struct v4l2_mpeg2_picture {
>  	__u8	alternate_scan;
>  	__u8	repeat_first_field;
>  	__u8	progressive_frame;
> +	__u8	pad;
>  };
>  
>  struct v4l2_ctrl_mpeg2_slice_params {
> @@ -1142,6 +1146,7 @@ struct v4l2_ctrl_mpeg2_slice_params {
>  
>  	__u8	backward_ref_index;
>  	__u8	forward_ref_index;
> +	__u8	pad;
>  };
>  
>  struct v4l2_ctrl_mpeg2_quantization {
> 
