Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab2DQNVG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 09:21:06 -0400
Message-ID: <4F8D6EB5.5050304@redhat.com>
Date: Tue, 17 Apr 2012 15:23:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 04/15] V4L: Add camera white balance preset control
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com> <1334657396-5737-5-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1334657396-5737-5-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/17/2012 12:09 PM, Sylwester Nawrocki wrote:
> Add V4L2_CID_WHITE_BALANCE_PRESET control for camera white balance
> presets. The following items are defined:
>
>   - V4L2_WHITE_BALANCE_NONE,
>   - V4L2_WHITE_BALANCE_INCANDESCENT,
>   - V4L2_WHITE_BALANCE_FLUORESCENT,
>   - V4L2_WHITE_BALANCE_HORIZON,
>   - V4L2_WHITE_BALANCE_DAYLIGHT,
>   - V4L2_WHITE_BALANCE_FLASH,
>   - V4L2_WHITE_BALANCE_CLOUDY,
>   - V4L2_WHITE_BALANCE_SHADE,
>
> This is a manual white balance control, in addition to V4L2_CID_RED_BALANCE,
> V4L2_CID_BLUE_BALANCE and V4L2_CID_WHITE_BALANCE_TEMPERATURE. It's useful
> for camera devices running more complex firmware and exposing white balance
> preset selection in their user register interface.

Hmm, how is this supposed to work together with the v4l2-ctrls framework?
The framework has a concept of a master control, which has a manual value,
and the slave controls will only get unlocked (V4L2_CTRL_FLAG_INACTIVE
will be cleared) when that master control is set at its manual value, now lets
say that we've V4L2_CID_AUTO_WHITE_BALANCE as master with
V4L2_CID_WHITE_BALANCE_PRESET and V4L2_CID_RED_BALANCE and V4L2_CID_BLUE_BALANCE
slaves. Then when the master control changes from auto to manual all 3 will
have their inactive flag cleared, but if the preset value != V4L2_WHITE_BALANCE_NONE
then the red- and blue-balance should have kept their inactive flag. And since this
clearing of the inactive flag is done after v4l2-ctrls.c has called into the driver
there is no way for the driver to fix this.

One could work-around this by not specifying the whitebalance control cluster as
being an auto cluster, and doing all the auto cluster stuff from the driver, but
that significantly complicates the driver, and we are trying to get away of every
driver doing this kinda stuff for itself...

I still believe that the solution I came up with for pwc is better, the auto
whitebalance control really is a tri state when you add presets whitebalance
is controlled through one of this 3 options:
1) auto
2) preset
3) manual

I know you are worried about having a V4L2_CID_AUTO_WHITE_BALANCE control
which is not a boolean breaking apps, well the pwc driver is a quite popular
driver and I've had 0 bug reports about my turning it into a menu...

Alternatively we could add a new V4L2_CID_WHITE_BALANCE_MENU control and use
that for drivers which have presets rather then the old V4L2_CID_AUTO_WHITE_BALANCE
to ensure that userspace won't trip over it being a menu all of a sudden, but
I believe that it is really important to properly reflect the tri-state nature
of the awb once presets come into play, rather then trying to bolt something
on top of / to the side of our current bi-state control. And I hope that my above
example of what sort of troubles using the bolt-on solution will give, clearly
demonstrates that the bolt-on solution is a bad idea.

Regards,

Hans



>
> Signed-off-by: HeungJun Kim<riverful.kim@samsung.com>
> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   Documentation/DocBook/media/v4l/controls.xml |   68 ++++++++++++++++++++++++++
>   drivers/media/video/v4l2-ctrls.c             |   16 ++++++
>   include/linux/videodev2.h                    |   12 +++++
>   3 files changed, 96 insertions(+)
>
> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
> index 69363dc..0ee3e9c 100644
> --- a/Documentation/DocBook/media/v4l/controls.xml
> +++ b/Documentation/DocBook/media/v4l/controls.xml
> @@ -3013,6 +3013,74 @@ camera sensor on or off, or specify its strength. Such band-stop filters can
>   be used, for example, to filter out the fluorescent light component.</entry>
>   	</row>
>   	<row><entry></entry></row>
> +
> +	<row id="v4l2-white-balance-preset">
> +	<entry spanname="id"><constant>V4L2_CID_WHITE_BALANCE_PRESET</constant>&nbsp;</entry>
> +	<entry>enum&nbsp;v4l2_white_balance_preset</entry>
> +	</row><row><entry spanname="descr">Sets a predefined white balance
> +configuration. The presets determine color temperature of the light on a basis
> +of which the camera performs white balance adjustments, in order to obtain most
> +accurate color representation. This control has no effect when automatic white
> +balance adjustments are enabled, i.e.<constant>V4L2_CID_AUTO_WHITE_BALANCE
> +</constant>  control is set to<constant>TRUE</constant>  (1). The following white
> +balance presets are listed in order of increasing color temperature.</entry>
> +	</row>
> +	<row>
> +	<entrytbl spanname="descr" cols="2">
> +	<tbody valign="top">
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_NONE</constant>&nbsp;</entry>
> +		<entry>None of the presets is active, i.e. the white balance
> +preset feature is disabled. It is useful when driver exposes other manual white
> +balance controls, like<constant>V4L2_CID_RED_BALANCE</constant>  and<constant>
> +V4L2_CID_BLUE_BALANCE</constant>, that may render a configured preset invalid.
> +</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_INCANDESCENT</constant>&nbsp;</entry>
> +		<entry>White balance settings for incandescent (tungsten) lighting.
> +It generally cools down the colors and corresponds approximately to 2500...3500 K
> +color temperature range.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_FLUORESCENT</constant>&nbsp;</entry>
> +		<entry>With this setting the camera will compensate for fluorescent
> +lighting. It corresponds approximately to 4000...5000 K color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_HORIZON</constant>&nbsp;</entry>
> +		<entry>White balance settings for horizon daylight.
> +This corresponds approximately to 5000 K color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_DAYLIGHT</constant>&nbsp;</entry>
> +		<entry>White balance settings for daylight (with clear sky).
> +This corresponds approximately to 5000...6500 K color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_FLASH</constant>&nbsp;</entry>
> +		<entry>With this setting the camera will compensate for the flash
> +light. It slightly warms up the colors and corresponds roughly to 5000...5500 K
> +color temperature.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_CLOUDY</constant>&nbsp;</entry>
> +		<entry>White balance settings for moderately overcast sky.
> +This option corresponds approximately to 6500...8000 K color temperature range
> +and will make colors appear warmer than with the
> +<constant>V4L2_WHITE_BALANCE_PRESET_DAYLIGHT</constant>  preset.</entry>
> +		</row>
> +		<row>
> +		<entry><constant>V4L2_WHITE_BALANCE_PRESET_SHADE</constant>&nbsp;</entry>
> +		<entry>White balance settings for shade or heavily overcast
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
> index 1f67bf2..b6cd147 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -249,6 +249,17 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>   		"Arbitrary",
>   		NULL
>   	};
> +	static const char * const white_balance_preset[] = {
> +		"None",
> +		"Incandescent",
> +		"Fluorescent",
> +		"Horizon",
> +		"Daylight",
> +		"Flash",
> +		"Cloudy",
> +		"Shade",
> +		NULL,
> +	};
>   	static const char * const tune_preemphasis[] = {
>   		"No Preemphasis",
>   		"50 useconds",
> @@ -418,6 +429,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
>   		return camera_exposure_auto;
>   	case V4L2_CID_COLORFX:
>   		return colorfx;
> +	case V4L2_CID_WHITE_BALANCE_PRESET:
> +		return white_balance_preset;
>   	case V4L2_CID_TUNE_PREEMPHASIS:
>   		return tune_preemphasis;
>   	case V4L2_CID_FLASH_LED_MODE:
> @@ -605,6 +618,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>   	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
>   	case V4L2_CID_AUTO_EXPOSURE_BIAS:	return "Auto Exposure, Bias";
>
> +	case V4L2_CID_WHITE_BALANCE_PRESET:	return "White Balance, Preset";
> +
>   	/* FM Radio Modulator control */
>   	/* Keep the order of the 'case's the same as in videodev2.h! */
>   	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
> @@ -727,6 +742,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>   	case V4L2_CID_MPEG_STREAM_VBI_FMT:
>   	case V4L2_CID_EXPOSURE_AUTO:
>   	case V4L2_CID_COLORFX:
> +	case V4L2_CID_WHITE_BALANCE_PRESET:
>   	case V4L2_CID_TUNE_PREEMPHASIS:
>   	case V4L2_CID_FLASH_LED_MODE:
>   	case V4L2_CID_FLASH_STROBE_SOURCE:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index fd2f400..537663a 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1729,6 +1729,18 @@ enum  v4l2_exposure_auto_type {
>
>   #define V4L2_CID_AUTO_EXPOSURE_BIAS		(V4L2_CID_CAMERA_CLASS_BASE+19)
>
> +#define V4L2_CID_WHITE_BALANCE_PRESET		(V4L2_CID_CAMERA_CLASS_BASE+20)
> +enum v4l2_white_balance_preset {
> +	V4L2_WHITE_BALANCE_PRESET_NONE		= 0,
> +	V4L2_WHITE_BALANCE_PRESET_INCANDESCENT	= 1,
> +	V4L2_WHITE_BALANCE_PRESET_FLUORESCENT	= 2,
> +	V4L2_WHITE_BALANCE_PRESET_HORIZON	= 3,
> +	V4L2_WHITE_BALANCE_PRESET_DAYLIGHT	= 4,
> +	V4L2_WHITE_BALANCE_PRESET_FLASH		= 5,
> +	V4L2_WHITE_BALANCE_PRESET_CLOUDY	= 6,
> +	V4L2_WHITE_BALANCE_PRESET_SHADE		= 7,
> +};
> +
>   /* FM Modulator class control IDs */
>   #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
>   #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
