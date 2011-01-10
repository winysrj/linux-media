Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4279 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab1AJWeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 17:34:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Roberto Rodriguez Alcala <rralcala@gmail.com>
Subject: Re: [PATCH 1/2] [media] v4l2-ctrls: Add V4L2_CID_NIGHT_MODE control to support night mode
Date: Mon, 10 Jan 2011 23:34:36 +0100
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1294697907-1714-1-git-send-email-rralcala@gmail.com> <1294697907-1714-2-git-send-email-rralcala@gmail.com>
In-Reply-To: <1294697907-1714-2-git-send-email-rralcala@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101102334.36968.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, January 10, 2011 23:18:26 Roberto Rodriguez Alcala wrote:
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

"Night Mode" (capital 'M', like in all the other strings).

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
>  /* FM Modulator class control IDs */
>  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> 

This control also needs to be documented in Documentation/DocBook/v4l/controls.xml.

However, reading up a bit on this I wonder whether this shouldn't be a 'Camera Mode'
menu control since there can be a lot of different modes:

http://www.digital-photography-school.com/digital-camera-modes

Also, how does this relate to controls like EXPOSURE_AUTO? Will selecting
manual exposure automatically turn off Night Mode? Or the inverse, will
selecting Night Mode automatically turn on autoexposure?

How is this done in the ov7670?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
