Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1169 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZGYNDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jul 2009 09:03:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv10 3/8] v4l2: video device: Add FM_TX controls default configurations
Date: Sat, 25 Jul 2009 15:03:33 +0200
Cc: "ext Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1248453448-1668-1-git-send-email-eduardo.valentin@nokia.com> <1248453448-1668-3-git-send-email-eduardo.valentin@nokia.com> <1248453448-1668-4-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1248453448-1668-4-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251503.33713.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 24 July 2009 18:37:23 Eduardo Valentin wrote:
> Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  linux/drivers/media/video/v4l2-common.c |   63 ++++++++++++++++++++++++++++++-
>  1 files changed, 62 insertions(+), 1 deletions(-)
> 
> diff --git a/linux/drivers/media/video/v4l2-common.c b/linux/drivers/media/video/v4l2-common.c
> index bd13702..6fc0559 100644
> --- a/linux/drivers/media/video/v4l2-common.c
> +++ b/linux/drivers/media/video/v4l2-common.c
> @@ -343,6 +343,12 @@ const char **v4l2_ctrl_get_menu(u32 id)
>  		"Sepia",
>  		NULL
>  	};
> +	static const char *fm_tx_preemphasis[] = {
> +		"No preemphasis",
> +		"50 useconds",
> +		"75 useconds",
> +		NULL,
> +	};
>  
>  	switch (id) {
>  		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> @@ -381,6 +387,8 @@ const char **v4l2_ctrl_get_menu(u32 id)
>  			return camera_exposure_auto;
>  		case V4L2_CID_COLORFX:
>  			return colorfx;
> +		case V4L2_CID_FM_TX_PREEMPHASIS:
> +			return fm_tx_preemphasis;
>  		default:
>  			return NULL;
>  	}
> @@ -479,6 +487,28 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_ZOOM_CONTINUOUS:		return "Zoom, Continuous";
>  	case V4L2_CID_PRIVACY:			return "Privacy";
>  
> +	/* FM Radio Modulator control */
> +	case V4L2_CID_FM_TX_CLASS:		return "FM Radio Modulator Controls";
> +	case V4L2_CID_RDS_TX_PI:		return "RDS Program ID";
> +	case V4L2_CID_RDS_TX_PTY:		return "RDS Program Type";
> +	case V4L2_CID_RDS_TX_DEVIATION:		return "RDS Signal Deviation";
> +	case V4L2_CID_RDS_TX_PS_NAME:		return "RDS PS Name";
> +	case V4L2_CID_RDS_TX_RADIO_TEXT:	return "RDS Radio Text";
> +	case V4L2_CID_AUDIO_LIMITER_ENABLED:	return "Audio Limiter Feature Enabled";
> +	case V4L2_CID_AUDIO_LIMITER_RELEASE_TIME: return "Audio Limiter Release Time";
> +	case V4L2_CID_AUDIO_LIMITER_DEVIATION:	return "Audio Limiter Deviation";
> +	case V4L2_CID_AUDIO_COMPRESSION_ENABLED: return "Audio Compression Feature Enabled";
> +	case V4L2_CID_AUDIO_COMPRESSION_GAIN:	return "Audio Compression Gain";
> +	case V4L2_CID_AUDIO_COMPRESSION_THRESHOLD: return "Audio Compression Threshold";
> +	case V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME: return "Audio Compression Attack Time";
> +	case V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME: return "Audio Compression Release Time";
> +	case V4L2_CID_PILOT_TONE_ENABLED:	return "Pilot Tone Feature Enabled";
> +	case V4L2_CID_PILOT_TONE_DEVIATION:	return "Pilot Tone Deviation";
> +	case V4L2_CID_PILOT_TONE_FREQUENCY:	return "Pilot Tone Frequency";
> +	case V4L2_CID_FM_TX_PREEMPHASIS:	return "Pre-emphasis settings";
> +	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
> +	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
> +
>  	default:
>  		return NULL;
>  	}
> @@ -500,7 +530,18 @@ EXPORT_SYMBOL(v4l2_ctrl_is_value64);
>   * This information is used inside v4l2_compat_ioctl32. */
>  int v4l2_ctrl_is_pointer(u32 id)
>  {
> -	return 0;
> +	int is_pointer;
> +
> +	switch (id) {
> +	case V4L2_CID_RDS_TX_PS_NAME:
> +	case V4L2_CID_RDS_TX_RADIO_TEXT:
> +		is_pointer = 1;
> +		break;
> +	default:
> +		is_pointer = 0;
> +	}
> +
> +	return is_pointer;
>  }

There is no need for a temp variable. Just do this:

int v4l2_ctrl_is_pointer(u32 id)
{
	switch (id) {
	case V4L2_CID_RDS_TX_PS_NAME:
	case V4L2_CID_RDS_TX_RADIO_TEXT:
		return 1;
	default:
		return 0;
	}
}

Regards,

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
