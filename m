Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab2D0O22 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:28:28 -0400
Message-ID: <4F9AAD7C.3030409@redhat.com>
Date: Fri, 27 Apr 2012 16:30:20 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v3 03/14] V4L: Add an extended camera white balance
 control
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <1335536611-4298-4-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1335536611-4298-4-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Looks good!

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


On 04/27/2012 04:23 PM, Sylwester Nawrocki wrote:
> This patch adds V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE control which is
> an extended version of the V4L2_CID_AUTO_WHITE_BALANCE control,
> including white balance presets. The following presets are defined:
>
>   - V4L2_WHITE_BALANCE_INCANDESCENT,
>   - V4L2_WHITE_BALANCE_FLUORESCENT,
>   - V4L2_WHITE_BALANCE_FLUORESCENT_H,
>   - V4L2_WHITE_BALANCE_HORIZON,
>   - V4L2_WHITE_BALANCE_DAYLIGHT,
>   - V4L2_WHITE_BALANCE_FLASH,
>   - V4L2_WHITE_BALANCE_CLOUDY,
>   - V4L2_WHITE_BALANCE_SHADE.
>
> Signed-off-by: HeungJun Kim<riverful.kim@samsung.com>
> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   Documentation/DocBook/media/v4l/controls.xml |   70 ++++++++++++++++++++++++++
>   drivers/media/video/v4l2-ctrls.c             |   17 +++++++
>   include/linux/videodev2.h                    |   14 ++++++
>   3 files changed, 101 insertions(+)
>
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 56a53a8..b671a70 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -2948,6 +2948,76 @@ camera sensor on or off, or specify its strength. Such band-stop filters can
>   be used, for example, to filter out the fluorescent light component.</entry>
>   	</row>
>   	<row><entry></entry></row>
> +
> +	<row id="v4l2-auto-n-preset-white-balance-type">
> +	<entry spanname="id"><constant>V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE</constant>&nbsp;</entry>
> +	<entry>enum&nbsp;v4l2_auto_n_preset_white_balance_type</entry>
> +	</row><row><entry spanname="descr">Sets white balance to automatic,
> +manual or a preset. The presets determine color temperature of the light as
> +a hint to the camera for white balance adjustments resulting in most accurate
> +color representation. The following white balance presets are listed in order
> +of increasing color temperature.</entry>
> +	</row>
> +	<row>
> +	<entrytbl spanname="descr" cols="2">
> +	<tbody valign="top">
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_MANUAL</constant>&nbsp;</entry>
> +		<entry>Manual white balance.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_AUTO</constant>&nbsp;</entry>
> +		<entry>Automatic white balance adjustments.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_INCANDESCENT</constant>&nbsp;</entry>
> +		<entry>White balance setting for incandescent (tungsten) lighting.
> +It generally cools down the colors and corresponds approximately to 2500...3500 K
> +color temperature range.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>&nbsp;</entry>
> +		<entry>White balance preset for fluorescent lighting.
> +It corresponds approximately to 4000...5000 K color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT_H</constant>&nbsp;</entry>
> +		<entry>With this setting the camera will compensate for
> +fluorescent H lighting.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_HORIZON</constant>&nbsp;</entry>
> +		<entry>White balance setting for horizon daylight.
> +It corresponds approximately to 5000 K color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_DAYLIGHT</constant>&nbsp;</entry>
> +		<entry>White balance preset for daylight (with clear sky).
> +It corresponds approximately to 5000...6500 K color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_FLASH</constant>&nbsp;</entry>
> +		<entry>With this setting the camera will compensate for the flash
> +light. It slightly warms up the colors and corresponds roughly to 5000...5500 K
> +color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_CLOUDY</constant>&nbsp;</entry>
> +		<entry>White balance preset for moderately overcast sky.
> +This option corresponds approximately to 6500...8000 K color temperature
> +range.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_SHADE</constant>&nbsp;</entry>
> +		<entry>White balance preset for shade or heavily overcast
> +sky. It corresponds approximately to 9000...10000 K color temperature.
> +</entry>
> +		</row>
> +	</tbody>
> +	</entrytbl>
> +	</row>
> +	<row><entry></entry></row>
> +
>   	</tbody>
>         </tgroup>
>       </table>
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 1d7091f..02fa9b0 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -243,6 +243,19 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>   		"Vivid",
>   		NULL
>   	};
> +	static const char * const auto_n_preset_white_balance[] = {
> +		"Manual",
> +		"Auto",
> +		"Incandescent",
> +		"Fluorescent",
> +		"Fluorescent H",
> +		"Horizon",
> +		"Daylight",
> +		"Flash",
> +		"Cloudy",
> +		"Shade",
> +		NULL,
> +	};
>   	static const char * const tune_preemphasis[] = {
>   		"No Preemphasis",
>   		"50 Microseconds",
> @@ -412,6 +425,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>   		return camera_exposure_auto;
>   	case V4L2_CID_COLORFX:
>   		return colorfx;
> +	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
> +		return auto_n_preset_white_balance;
>   	case V4L2_CID_TUNE_PREEMPHASIS:
>   		return tune_preemphasis;
>   	case V4L2_CID_FLASH_LED_MODE:
> @@ -598,6 +613,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>   	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
>   	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
>   	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
> +	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE: return "White Balance, Auto&  Preset";
>
>   	/* FM Radio Modulator control */
>   	/* Keep the order of the 'case's the same as in videodev2.h! */
> @@ -721,6 +737,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>   	case V4L2_CID_MPEG_STREAM_VBI_FMT:
>   	case V4L2_CID_EXPOSURE_AUTO:
>   	case V4L2_CID_COLORFX:
> +	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
>   	case V4L2_CID_TUNE_PREEMPHASIS:
>   	case V4L2_CID_FLASH_LED_MODE:
>   	case V4L2_CID_FLASH_STROBE_SOURCE:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index da60cbb..08891e6 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1695,6 +1695,20 @@ enum  v4l2_exposure_auto_type {
>
>   #define V4L2_CID_AUTO_EXPOSURE_BIAS		(V4L2_CID_CAMERA_CLASS_BASE+19)
>
> +#define V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE	(V4L2_CID_CAMERA_CLASS_BASE+20)
> +enum v4l2_auto_n_preset_white_balance_type {
> +	V4L2_WHITE_BALANCE_MANUAL		= 0,
> +	V4L2_WHITE_BALANCE_AUTO			= 1,
> +	V4L2_WHITE_BALANCE_INCANDESCENT		= 2,
> +	V4L2_WHITE_BALANCE_FLUORESCENT		= 3,
> +	V4L2_WHITE_BALANCE_FLUORESCENT_H	= 4,
> +	V4L2_WHITE_BALANCE_HORIZON		= 5,
> +	V4L2_WHITE_BALANCE_DAYLIGHT		= 6,
> +	V4L2_WHITE_BALANCE_FLASH		= 7,
> +	V4L2_WHITE_BALANCE_CLOUDY		= 8,
> +	V4L2_WHITE_BALANCE_SHADE		= 9,
> +};
> +
>   /* FM Modulator class control IDs */
>   #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>   #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
