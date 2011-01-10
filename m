Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:56189 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1AJXPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 18:15:09 -0500
Date: Tue, 11 Jan 2011 00:15:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Roberto Rodriguez Alcala <rralcala@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] v4l2-ctrls: Add V4L2_CID_NIGHT_MODE control
 to support night mode
In-Reply-To: <1294697907-1714-2-git-send-email-rralcala@gmail.com>
Message-ID: <Pine.LNX.4.64.1101110013120.24479@axis700.grange>
References: <1294697907-1714-1-git-send-email-rralcala@gmail.com>
 <1294697907-1714-2-git-send-email-rralcala@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 10 Jan 2011, Roberto Rodriguez Alcala wrote:

> From: Roberto Rodriguez Alcala <rralcala@gmail.com> 
> 
> 
> Signed-off-by: Roberto Rodriguez Alcala <rralcala@gmail.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |    2 ++
>  include/linux/videodev2.h        |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 8f81efc..7a8934e 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -365,6 +365,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_PRIVACY:			return "Privacy";
>  	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
> +	case V4L2_CID_NIGHT_MODE:               return "Night mode";

After you have clarified questions, asked by Hans, if this patch is going 
to be accepted in more or less unchanged form, please, in the above line 
and...

>  
>  	/* FM Radio Modulator control */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -418,6 +419,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
>  	case V4L2_CID_FOCUS_AUTO:
>  	case V4L2_CID_PRIVACY:
> +	case V4L2_CID_NIGHT_MODE:
>  	case V4L2_CID_AUDIO_LIMITER_ENABLED:
>  	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
>  	case V4L2_CID_PILOT_TONE_ENABLED:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5f6f470..0df8a9f 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1300,6 +1300,8 @@ enum  v4l2_exposure_auto_type {
>  #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
>  #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
>  
> +#define V4L2_CID_NIGHT_MODE                     (V4L2_CID_CAMERA_CLASS_BASE+19)
> +

in this one use TABs and not spaces for indentation, just like other lines 
do.

>  /* FM Modulator class control IDs */
>  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> -- 
> 1.7.3.2

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
