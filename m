Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46025 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbbHJI5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 04:57:30 -0400
Message-ID: <55C8675B.3070000@xs4all.nl>
Date: Mon, 10 Aug 2015 10:56:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 02/13] v4l2: add RF gain control
References: <1438308650-2702-1-git-send-email-crope@iki.fi> <1438308650-2702-3-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-3-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/31/2015 04:10 AM, Antti Palosaari wrote:
> Add new RF tuner gain control named RF Gain. That is aimed for first
> amplifier chip right after antenna connector.
> There is existing LNA Gain control, which is quite same, but it is
> aimed for cases amplifier is integrated to tuner chip. Some designs
> have both, as almost all recent tuner silicons has integrated LNA/RF
> amplifier in any case.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 2 ++
>  include/uapi/linux/v4l2-controls.h   | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b6b7dcc..d18462c 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -888,6 +888,7 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
>  	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
>  	case V4L2_CID_RF_TUNER_CLASS:		return "RF Tuner Controls";
> +	case V4L2_CID_RF_TUNER_RF_GAIN:		return "RF Gain";
>  	case V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:	return "LNA Gain, Auto";
>  	case V4L2_CID_RF_TUNER_LNA_GAIN:	return "LNA Gain";
>  	case V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:	return "Mixer Gain, Auto";
> @@ -1161,6 +1162,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_PILOT_TONE_FREQUENCY:
>  	case V4L2_CID_TUNE_POWER_LEVEL:
>  	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> +	case V4L2_CID_RF_TUNER_RF_GAIN:
>  	case V4L2_CID_RF_TUNER_LNA_GAIN:
>  	case V4L2_CID_RF_TUNER_MIXER_GAIN:
>  	case V4L2_CID_RF_TUNER_IF_GAIN:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index d448c53..1bdce50 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -936,6 +936,7 @@ enum v4l2_deemphasis {
>  
>  #define V4L2_CID_RF_TUNER_BANDWIDTH_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 11)
>  #define V4L2_CID_RF_TUNER_BANDWIDTH		(V4L2_CID_RF_TUNER_CLASS_BASE + 12)
> +#define V4L2_CID_RF_TUNER_RF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 32)
>  #define V4L2_CID_RF_TUNER_LNA_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 41)
>  #define V4L2_CID_RF_TUNER_LNA_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 42)
>  #define V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 51)
> 

