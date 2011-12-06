Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43632 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab1LFMbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 07:31:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a menu control
Date: Tue, 6 Dec 2011 13:31:14 +0100
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <1323011776-15967-2-git-send-email-snjw23@gmail.com>
In-Reply-To: <1323011776-15967-2-git-send-email-snjw23@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112061331.14987.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sunday 04 December 2011 16:16:12 Sylwester Nawrocki wrote:
> Change the V4L2_CID_FOCUS_AUTO control type from boolean to a menu
> type. In case of boolean control we had values 0 and 1 corresponding
> to manual and automatic focus respectively.
> 
> The V4L2_CID_FOCUS_AUTO menu control has currently following items:
>   0 - V4L2_FOCUS_MANUAL,
>   1 - V4L2_FOCUS_AUTO,
>   2 - V4L2_FOCUS_AUTO_MACRO,
>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.

I think the mapping is wrong, please see my answer to 2/5.

> To trigger single auto focus action in V4L2_FOCUS_AUTO mode the
> V4L2_DO_AUTO_FOCUS control can be used, which is also added in this
> patch.
> 
> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   52
> +++++++++++++++++++++++-- drivers/media/video/v4l2-ctrls.c             |  
> 13 ++++++-
>  include/linux/videodev2.h                    |    8 ++++
>  3 files changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml index 3bc5ee8..5ccb0b0
> 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2782,12 +2782,54 @@ negative values towards infinity. This is a
> write-only control.</entry> </row>
>  	  <row><entry></entry></row>
> 
> -	  <row>
> +	  <row id="v4l2-focus-auto-type">
>  	    <entry
> spanname="id"><constant>V4L2_CID_FOCUS_AUTO</constant>&nbsp;</entry> -	   
> <entry>boolean</entry>
> -	  </row><row><entry spanname="descr">Enables automatic focus
> -adjustments. The effect of manual focus adjustments while this feature
> -is enabled is undefined, drivers should ignore such requests.</entry>
> +	    <entry>enum&nbsp;v4l2_focus_auto_type</entry>
> +	  </row><row><entry spanname="descr">Determines the camera
> +focus mode. The effect of manual focus adjustments while <constant>
> +V4L2_CID_FOCUS_AUTO </constant> is not set to <constant>
> +V4L2_FOCUS_MANUAL</constant> is undefined, drivers should ignore such
> +requests.</entry>
> +	  </row>
> +	  <row>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +		<row>
> +		  <entry><constant>V4L2_FOCUS_MANUAL</constant>&nbsp;</entry>
> +		  <entry>Manual focus.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_FOCUS_AUTO</constant>&nbsp;</entry>
> +		  <entry>Single shot auto focus. When switched to
> +this mode the camera focuses on a subject just once. <constant>
> +V4L2_CID_DO_AUTO_FOCUS</constant> control can be used to manually
> +invoke auto focusing.</entry>
> +		</row>

Do we need this single-shot auto-focus menu entry ? We could just use 
V4L2_CID_DO_AUTO_FOCUS in V4L2_FOCUS_MANUAL mode to do this. This is what 
happens with one-shot white balance.

> +		<row>
> +		  <entry><constant>V4L2_FOCUS_AUTO_MACRO</constant>&nbsp;</entry>
> +		  <entry>Macro (close-up) auto focus. Usually camera
> +auto focus algorithms do not attempt to focus on a subject that is
> +closer than a given distance. This mode can be used to tell the camera
> +to use minimum distance for focus that it is capable of.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_FOCUS_AUTO_CONTINUOUS</constant>&nbsp;</entry>
> +		  <entry>Continuous auto focus. When switched to this
> +mode the camera continually adjusts focus.</entry>
> +		</row>
> +	      </tbody>
> +	    </entrytbl>
> +	  </row>
> +	  <row><entry></entry></row>
> +
> +	  <row>
> +	    <entry
> spanname="id"><constant>V4L2_CID_DO_AUTO_FOCUS</constant>&nbsp;</entry> +	
>    <entry>button</entry>
> +	  </row><row><entry spanname="descr">When this control is set

Wouldn't "written" be better than "set" here ? I understand "When this control 
is set" as "while the control has a non-zero value" (but it might just be me).

> +the camera will perform one shot auto focus. The effect of using this
> +control when <constant>V4L2_CID_FOCUS_AUTO</constant> is in mode
> +different than <constant>V4L2_FOCUS_AUTO</constant> is undefined,
> +drivers should ignore such requests. </entry>
>  	  </row>
>  	  <row><entry></entry></row>
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index 0f415da..7d8862f 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -221,6 +221,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Aperture Priority Mode",
>  		NULL
>  	};
> +	static const char * const camera_focus_auto[] = {
> +		"Manual Focus",
> +		"One-shot Auto Focus",
> +		"Macro Auto Focus",
> +		"Continuous Auto Focus",
> +		NULL
> +	};
>  	static const char * const colorfx[] = {
>  		"None",
>  		"Black & White",
> @@ -388,6 +395,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return camera_power_line_frequency;
>  	case V4L2_CID_EXPOSURE_AUTO:
>  		return camera_exposure_auto;
> +	case V4L2_CID_FOCUS_AUTO:
> +		return camera_focus_auto;
>  	case V4L2_CID_COLORFX:
>  		return colorfx;
>  	case V4L2_CID_TUNE_PREEMPHASIS:
> @@ -567,6 +576,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_PRIVACY:			return "Privacy";
>  	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
> +	case V4L2_CID_DO_AUTO_FOCUS:		return "Do Auto Focus";
> 
>  	/* FM Radio Modulator control */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -633,7 +643,6 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
>  	case V4L2_CID_MPEG_VIDEO_PULLDOWN:
>  	case V4L2_CID_EXPOSURE_AUTO_PRIORITY:
> -	case V4L2_CID_FOCUS_AUTO:
>  	case V4L2_CID_PRIVACY:
>  	case V4L2_CID_AUDIO_LIMITER_ENABLED:
>  	case V4L2_CID_AUDIO_COMPRESSION_ENABLED:
> @@ -658,6 +667,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_TILT_RESET:
>  	case V4L2_CID_FLASH_STROBE:
>  	case V4L2_CID_FLASH_STROBE_STOP:
> +	case V4L2_CID_DO_AUTO_FOCUS:
>  		*type = V4L2_CTRL_TYPE_BUTTON;
>  		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
>  		*min = *max = *step = *def = 0;
> @@ -679,6 +689,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_MPEG_STREAM_TYPE:
>  	case V4L2_CID_MPEG_STREAM_VBI_FMT:
>  	case V4L2_CID_EXPOSURE_AUTO:
> +	case V4L2_CID_FOCUS_AUTO:
>  	case V4L2_CID_COLORFX:
>  	case V4L2_CID_TUNE_PREEMPHASIS:
>  	case V4L2_CID_FLASH_LED_MODE:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 4b752d5..9acb514 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1608,6 +1608,12 @@ enum  v4l2_exposure_auto_type {
>  #define V4L2_CID_FOCUS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+10)
>  #define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
>  #define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)
> +enum v4l2_focus_auto_type {
> +	V4L2_FOCUS_MANUAL = 0,
> +	V4L2_FOCUS_AUTO = 1,
> +	V4L2_FOCUS_AUTO_MACRO = 2,
> +	V4L2_FOCUS_AUTO_CONTINUOUS = 3,
> +};
> 
>  #define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
>  #define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
> @@ -1618,6 +1624,8 @@ enum  v4l2_exposure_auto_type {
>  #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
>  #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
> 
> +#define V4L2_CID_DO_AUTO_FOCUS			(V4L2_CID_CAMERA_CLASS_BASE+19)
> +
>  /* FM Modulator class control IDs */
>  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)

-- 
Regards,

Laurent Pinchart
