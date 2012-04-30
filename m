Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:24227 "EHLO
	rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2D3QAf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:00:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v3 04/14] V4L: Add camera wide dynamic range control
Date: Mon, 30 Apr 2012 17:50:57 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <1335536611-4298-5-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1335536611-4298-5-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301750.57488.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 April 2012 16:23:21 Sylwester Nawrocki wrote:
> Add V4L2_CID_WIDE_DYNAMIC_RANGE camera class control for camera wide
> dynamic range (WDR, HDR) feature. This control has now only menu entries
> for enabling and disabling WDR. It can be extended when the wide dynamic
> range technique selection is needed.
> 
> Signed-off-by: HeungJun Kim <riverful.kim@samsung.com>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   28 ++++++++++++++++++++++++++
>  drivers/media/video/v4l2-ctrls.c             |    9 +++++++++
>  include/linux/videodev2.h                    |    6 ++++++
>  3 files changed, 43 insertions(+)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index b671a70..487b7b5 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3018,6 +3018,34 @@ sky. It corresponds approximately to 9000...10000 K color temperature.
>  	  </row>
>  	  <row><entry></entry></row>
>  
> +	  <row id="v4l2-wide-dynamic-range-type">
> +	    <entry spanname="id"><constant>V4L2_CID_WIDE_DYNAMIC_RANGE</constant></entry>
> +	    <entry>enum&nbsp;v4l2_wide_dynamic_range_type</entry>
> +	  </row>
> +	  <row>
> +	    <entry spanname="descr">Enables or disables the camera's wide dynamic
> +range feature. This feature allows to obtain clear images in situations where
> +intensity of the illumination varies significantly throughout the scene, i.e.
> +there are simultaneously very dark and very bright areas. It is most commonly
> +realized in cameras by combining two subsequent frames with different exposure
> +times.</entry>
> +	  </row>
> +	  <row>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +		<row>
> +		  <entry><constant>V4L2_WIDE_DYNAMIC_RANGE_DISABLED</constant></entry>
> +		  <entry>Wide dynamic range is disabled.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_WIDE_DYNAMIC_RANGE_ENABLED</constant></entry>
> +		  <entry>Wide dynamic range is enabled.</entry>
> +		</row>
> +	      </tbody>
> +	    </entrytbl>
> +	  </row>
> +	  <row><entry></entry></row>
> +
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 02fa9b0..ad2f035 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -256,6 +256,11 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		"Shade",
>  		NULL,
>  	};
> +	static const char * const camera_wide_dynamic_range[] = {
> +		"Disabled",
> +		"Enabled",
> +		NULL
> +	};

Huh? Why isn't this a boolean control? This looks very weird.

Regards,

	Hans

>  	static const char * const tune_preemphasis[] = {
>  		"No Preemphasis",
>  		"50 Microseconds",
> @@ -427,6 +432,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>  		return colorfx;
>  	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
>  		return auto_n_preset_white_balance;
> +	case V4L2_CID_WIDE_DYNAMIC_RANGE:
> +		return camera_wide_dynamic_range;
>  	case V4L2_CID_TUNE_PREEMPHASIS:
>  		return tune_preemphasis;
>  	case V4L2_CID_FLASH_LED_MODE:
> @@ -614,6 +621,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
>  	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
>  	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto & Preset";
> +	case V4L2_CID_WIDE_DYNAMIC_RANGE:	return "Wide Dynamic Range";
>  
>  	/* FM Radio Modulator control */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -751,6 +759,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
> +	case V4L2_CID_WIDE_DYNAMIC_RANGE:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_RDS_TX_PS_NAME:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 08891e6..3ca9b10 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1709,6 +1709,12 @@ enum v4l2_auto_n_preset_white_balance_type {
>  	V4L2_WHITE_BALANCE_SHADE		= 9,
>  };
>  
> +#define V4L2_CID_WIDE_DYNAMIC_RANGE		(V4L2_CID_CAMERA_CLASS_BASE+21)
> +enum v4l2_wide_dynamic_range_type {
> +	V4L2_WIDE_DYNAMIC_RANGE_DISABLED	= 0,
> +	V4L2_WIDE_DYNAMIC_RANGE_ENABLED		= 1,
> +};
> +
>  /* FM Modulator class control IDs */
>  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> 
