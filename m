Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46502 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab1BYJV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 04:21:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: [RFC PATCH v2 1/3] v4l2-ctrls: change the boolean type of V4L2_CID_FOCUS_AUTO to menu type
Date: Fri, 25 Feb 2011 10:21:59 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D674A67.3000504@samsung.com>
In-Reply-To: <4D674A67.3000504@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251021.59847.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 25 February 2011 07:21:27 Kim, HeungJun wrote:
> Support more modes of autofocus, it changes the type of V4L2_CID_FOCUS_AUTO
> from boolean to menu. And it includes 4 kinds of enumeration types:
> 
> V4L2_FOCUS_AUTO, V4L2_FOCUS_MANUAL, V4L2_FOCUS_MACRO, V4L2_FOCUS_CONTINUOUS
> 
> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   11 ++++++++++-
>  include/linux/videodev2.h        |    6 ++++++
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index 2412f08..0b1cce0 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -197,6 +197,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Aperture Priority Mode",
>  		NULL
>  	};
> +	static const char * const camera_focus_auto[] = {
> +		"Manual Mode",
> +		"Auto Mode",
> +		"Macro Mode",
> +		"Continuous Mode",

This might be nit-picking, but maybe the menu entries should be named "Manual 
Focus", "Auto Focus", "Macro Focus" and "Continuous Auto Focus". Hans ?

> +		NULL
> +	};
>  	static const char * const colorfx[] = {
>  		"None",
>  		"Black & White",
> @@ -252,6 +259,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return camera_power_line_frequency;
>  	case V4L2_CID_EXPOSURE_AUTO:
>  		return camera_exposure_auto;
> +	case V4L2_CID_FOCUS_AUTO:
> +		return camera_focus_auto;
>  	case V4L2_CID_COLORFX:
>  		return colorfx;
>  	case V4L2_CID_TUNE_PREEMPHASIS:
> @@ -416,7 +425,6 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
>  	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
>  	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
> -	case V4L2_CID_FOCUS_AUTO:
>  	case V4L2_CID_PRIVACY:
>  	case V4L2_CID_AUDIO_LIMITER_ENABLED:
>  	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> @@ -450,6 +458,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_MPEG_STREAM_TYPE:
>  	case V4L2_CID_MPEG_STREAM_VBI_FMT:
>  	case V4L2_CID_EXPOSURE_AUTO:
> +	case V4L2_CID_FOCUS_AUTO:
>  	case V4L2_CID_COLORFX:
>  	case V4L2_CID_TUNE_PREEMPHASIS:
>  		*type = V4L2_CTRL_TYPE_MENU;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index a94c4d5..959d59e 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1374,6 +1374,12 @@ enum  v4l2_exposure_auto_type {
>  #define V4L2_CID_FOCUS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+10)
>  #define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
>  #define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)
> +enum  v4l2_focus_auto_type {
> +	V4L2_FOCUS_MANUAL = 0,
> +	V4L2_FOCUS_AUTO = 1,
> +	V4L2_FOCUS_MACRO = 2,
> +	V4L2_FOCUS_CONTINUOUS = 3
> +};
> 
>  #define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
>  #define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)

-- 
Regards,

Laurent Pinchart
