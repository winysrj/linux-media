Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43649 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab1LFMcc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 07:32:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC/PATCH 3/5] v4l: Add V4L2_CID_METERING_MODE camera control
Date: Tue, 6 Dec 2011 13:32:39 +0100
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <1323011776-15967-4-git-send-email-snjw23@gmail.com>
In-Reply-To: <1323011776-15967-4-git-send-email-snjw23@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112061332.40168.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sunday 04 December 2011 16:16:14 Sylwester Nawrocki wrote:
> The V4L2_CID_METERING_MODE control allows to determine what method
> is used by the camera to measure the amount of light available for
> automatic exposure control.
> 
> Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/controls.xml |   31
> ++++++++++++++++++++++++++ drivers/media/video/v4l2-ctrls.c             | 
>   2 +
>  include/linux/videodev2.h                    |    7 ++++++
>  3 files changed, 40 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml index 5ccb0b0..53d7c08
> 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2893,6 +2893,7 @@ mechanical obturation of the sensor and firmware
> image processing, but the device is not restricted to these methods.
> Devices that implement the privacy control must support read access and
> may support write access.</entry> </row>
> +	  <row><entry></entry></row>
> 
>  	  <row>
>  	    <entry
> spanname="id"><constant>V4L2_CID_BAND_STOP_FILTER</constant>&nbsp;</entry>
> @@ -2902,6 +2903,36 @@ camera sensor on or off, or specify its strength.
> Such band-stop filters can be used, for example, to filter out the
> fluorescent light component.</entry> </row>
>  	  <row><entry></entry></row>
> +
> +	  <row id="v4l2-metering-mode">
> +	    <entry
> spanname="id"><constant>V4L2_CID_METERING_MODE</constant>&nbsp;</entry> +	
>    <entry>enum&nbsp;v4l2_metering_mode</entry>
> +	  </row><row><entry spanname="descr">Determines how the camera measures
> +the amount of light available to expose a frame. Possible values
> are:</entry> +	  </row>
> +	  <row>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +		<row>
> +		  <entry><constant>V4L2_METERING_MODE_AVERAGE</constant>&nbsp;</entry>
> +		  <entry>Use the light information coming from the entire scene
> +and average giving no weighting to any particular portion of the metered
> area. +		  </entry>
> +		</row>
> +		<row>
> +		 
> <entry><constant>V4L2_METERING_MODE_CENTER_WEIGHTED</constant>&nbsp;</entr
> y> +		  <entry>Average the light information coming from the entire scene
> +giving priority to the center of the metered area.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_METERING_MODE_SPOT</constant>&nbsp;</entry>
> +		  <entry>Measure only very small area at the cent-re of the
> scene.</entry> +		</row>
> +	      </tbody>

For the last two cases, would it also make sense to specify the center of the 
weighted area and the spot location ?

> +	    </entrytbl>
> +	  </row>
> +	  <row><entry></entry></row>
> +
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/drivers/media/video/v4l2-ctrls.c
> b/drivers/media/video/v4l2-ctrls.c index 7d8862f..8d0cd0e 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -577,6 +577,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
>  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
>  	case V4L2_CID_DO_AUTO_FOCUS:		return "Do Auto Focus";
> +	case V4L2_CID_METERING_MODE:		return "Metering Mode";
> 
>  	/* FM Radio Modulator control */
>  	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -703,6 +704,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type, case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
>  	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
> +	case V4L2_CID_METERING_MODE:
>  		*type = V4L2_CTRL_TYPE_MENU;
>  		break;
>  	case V4L2_CID_RDS_TX_PS_NAME:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 9acb514..8956ed6 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1626,6 +1626,13 @@ enum v4l2_focus_auto_type {
> 
>  #define V4L2_CID_DO_AUTO_FOCUS			(V4L2_CID_CAMERA_CLASS_BASE+19)
> 
> +#define V4L2_CID_METERING_MODE			(V4L2_CID_CAMERA_CLASS_BASE+20)
> +enum v4l2_metering_mode {
> +	V4L2_METERING_MODE_AVERAGE,
> +	V4L2_METERING_MODE_CENTER_WEIGHTED,
> +	V4L2_METERING_MODE_SPOT,
> +};
> +
>  /* FM Modulator class control IDs */
>  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)

-- 
Regards,

Laurent Pinchart
