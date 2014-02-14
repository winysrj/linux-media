Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3636 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaBNOV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 09:21:27 -0500
Message-ID: <52FE263E.9010408@xs4all.nl>
Date: Fri, 14 Feb 2014 15:20:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 3/6] v4l: reorganize RF tuner control ID numbers
References: <1392049026-13398-1-git-send-email-crope@iki.fi> <1392049026-13398-4-git-send-email-crope@iki.fi>
In-Reply-To: <1392049026-13398-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On 02/10/2014 05:17 PM, Antti Palosaari wrote:
> It appears that controls are ordered by ID number. Change order of
> controls by reorganizing assigned IDs now as we can. It is not
> reasonable possible after the API is released. Leave some spare
> space between IDs too for future extensions.

Am I missing something? I see no reason for this patch or for adding the
spare space.

Regards,

	Hans

> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  include/uapi/linux/v4l2-controls.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
> index 3cf68a6..cc488c3 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -899,13 +899,13 @@ enum v4l2_deemphasis {
>  #define V4L2_CID_RF_TUNER_CLASS_BASE		(V4L2_CTRL_CLASS_RF_TUNER | 0x900)
>  #define V4L2_CID_RF_TUNER_CLASS			(V4L2_CTRL_CLASS_RF_TUNER | 1)
>  
> -#define V4L2_CID_LNA_GAIN_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 1)
> -#define V4L2_CID_LNA_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 2)
> -#define V4L2_CID_MIXER_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 3)
> -#define V4L2_CID_MIXER_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 4)
> -#define V4L2_CID_IF_GAIN_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 5)
> -#define V4L2_CID_IF_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 6)
> -#define V4L2_CID_BANDWIDTH_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 7)
> -#define V4L2_CID_BANDWIDTH			(V4L2_CID_RF_TUNER_CLASS_BASE + 8)
> +#define V4L2_CID_BANDWIDTH_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 11)
> +#define V4L2_CID_BANDWIDTH			(V4L2_CID_RF_TUNER_CLASS_BASE + 12)
> +#define V4L2_CID_LNA_GAIN_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 41)
> +#define V4L2_CID_LNA_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 42)
> +#define V4L2_CID_MIXER_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 51)
> +#define V4L2_CID_MIXER_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 52)
> +#define V4L2_CID_IF_GAIN_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 61)
> +#define V4L2_CID_IF_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 62)
>  
>  #endif
> 

