Return-path: <mchehab@pedra>
Received: from bombadil.infradead.org ([18.85.46.34]:51532 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab0IHULc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 16:11:32 -0400
Message-ID: <4C87EDF5.80803@infradead.org>
Date: Wed, 08 Sep 2010 17:11:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: raja_mani@ti.com
CC: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	matti.j.aaltonen@nokia.com, Pramodh AG <pramodh_ag@ti.com>
Subject: Re: [RFC/PATCH 1/8] drivers:media:video: Adding new CIDs for FM RX
 ctls
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com> <1283443080-30644-2-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-2-git-send-email-raja_mani@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Em 02-09-2010 12:57, raja_mani@ti.com escreveu:
> From: Raja Mani <raja_mani@ti.com>
> 
> Add support for the following new Control IDs (CID)
>    V4L2_CID_FM_RX_CLASS    - FM RX Tuner controls
>    V4L2_CID_FM_BAND        - FM band

Hmm... both you and Matti are adding _the_same_ ioctls on different patchsets?
Please, coordinate between yourself to avoid duplicated/conflicted patches.

>    V4L2_CID_RSSI_THRESHOLD - RSSI Threshold
>    V4L2_CID_TUNE_AF        - Alternative Frequency
> 
> Signed-off-by: Raja Mani <raja_mani@ti.com>
> Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
> ---
>  drivers/media/video/v4l2-common.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
> index 4e53b0b..33c3037 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -354,6 +354,12 @@ const char **v4l2_ctrl_get_menu(u32 id)
>  		"75 useconds",
>  		NULL,
>  	};
> +	static const char *fm_band[] = {
> +		"87.5 - 108. MHz",
> +		"76. - 90. MHz, Japan",
> +		"65. - 74. MHz, OIRT",
> +		NULL,
> +	};

Already NACKED at Matti's patchset. I'll review/comment the other ioctls together with the DocBook spec file.
>  
>  	switch (id) {
>  		case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
> @@ -394,6 +400,8 @@ const char **v4l2_ctrl_get_menu(u32 id)
>  			return colorfx;
>  		case V4L2_CID_TUNE_PREEMPHASIS:
>  			return tune_preemphasis;
> +		case V4L2_CID_FM_BAND:
> +			return fm_band;
>  		default:
>  			return NULL;
>  	}
> @@ -520,6 +528,10 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_TUNE_PREEMPHASIS:	return "Pre-emphasis settings";
>  	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
>  	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna Capacitor";
> +	case V4L2_CID_FM_RX_CLASS:	return "FM Radio Tuner Controls";
> +	case V4L2_CID_FM_BAND:		return "FM Band";
> +	case V4L2_CID_RSSI_THRESHOLD:	return "RSSI Threshold";
> +	case V4L2_CID_TUNE_AF:		return "Alternative Frequency";
>  
>  	default:
>  		return NULL;
> @@ -585,6 +597,9 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
>  	case V4L2_CID_EXPOSURE_AUTO:
>  	case V4L2_CID_COLORFX:
>  	case V4L2_CID_TUNE_PREEMPHASIS:
> +	case V4L2_CID_FM_BAND:
> +	case V4L2_CID_RSSI_THRESHOLD:
> +	case V4L2_CID_TUNE_AF:
>  		qctrl->type = V4L2_CTRL_TYPE_MENU;
>  		step = 1;
>  		break;
> @@ -596,6 +611,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 min, s32 max, s32 ste
>  	case V4L2_CID_CAMERA_CLASS:
>  	case V4L2_CID_MPEG_CLASS:
>  	case V4L2_CID_FM_TX_CLASS:
> +	case V4L2_CID_FM_RX_CLASS:
>  		qctrl->type = V4L2_CTRL_TYPE_CTRL_CLASS;
>  		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
>  		min = max = step = def = 0;

