Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50391 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbbFHJDp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 05:03:45 -0400
Message-ID: <55755A6A.9080300@xs4all.nl>
Date: Mon, 08 Jun 2015 11:03:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/9] v4l2: add RF gain control
References: <1433592188-31748-1-git-send-email-crope@iki.fi> <1433592188-31748-2-git-send-email-crope@iki.fi>
In-Reply-To: <1433592188-31748-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/06/2015 02:03 PM, Antti Palosaari wrote:
> Add new RF tuner gain control named RF gain. That is aimed for
> external LNA (amplifier) chip just right after antenna connector.

I don't follow. Do you mean:

This feeds into the external LNA...

But if that's the case, then the LNA chip isn't right after the antenna connector,
since there is a RF amplified in between.

Remember, this is not my area of expertise, so if I don't understand it, then that's
probably true for other non-experts as well :-)

Regards,

	Hans

> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
>  include/uapi/linux/v4l2-controls.h   | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index e3a3468..0fc34b8 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -888,6 +888,8 @@ const char *v4l2_ctrl_get_name(u32 id)
>  	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
>  	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
>  	case V4L2_CID_RF_TUNER_CLASS:		return "RF Tuner Controls";
> +	case V4L2_CID_RF_TUNER_RF_GAIN_AUTO:	return "RF Gain, Auto";
> +	case V4L2_CID_RF_TUNER_RF_GAIN:		return "RF Gain";
>  	case V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:	return "LNA Gain, Auto";
>  	case V4L2_CID_RF_TUNER_LNA_GAIN:	return "LNA Gain";
>  	case V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:	return "Mixer Gain, Auto";
> @@ -960,6 +962,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_WIDE_DYNAMIC_RANGE:
>  	case V4L2_CID_IMAGE_STABILIZATION:
>  	case V4L2_CID_RDS_RECEPTION:
> +	case V4L2_CID_RF_TUNER_RF_GAIN_AUTO:
>  	case V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:
>  	case V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:
>  	case V4L2_CID_RF_TUNER_IF_GAIN_AUTO:
> @@ -1161,6 +1164,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
>  	case V4L2_CID_PILOT_TONE_FREQUENCY:
>  	case V4L2_CID_TUNE_POWER_LEVEL:
>  	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
> +	case V4L2_CID_RF_TUNER_RF_GAIN:
>  	case V4L2_CID_RF_TUNER_LNA_GAIN:
>  	case V4L2_CID_RF_TUNER_MIXER_GAIN:
>  	case V4L2_CID_RF_TUNER_IF_GAIN:
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 9f6e108..87539be 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -932,6 +932,8 @@ enum v4l2_deemphasis {
>  
>  #define V4L2_CID_RF_TUNER_BANDWIDTH_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 11)
>  #define V4L2_CID_RF_TUNER_BANDWIDTH		(V4L2_CID_RF_TUNER_CLASS_BASE + 12)
> +#define V4L2_CID_RF_TUNER_RF_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 31)
> +#define V4L2_CID_RF_TUNER_RF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 32)
>  #define V4L2_CID_RF_TUNER_LNA_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 41)
>  #define V4L2_CID_RF_TUNER_LNA_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 42)
>  #define V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 51)
> 

