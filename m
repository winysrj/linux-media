Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37053 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753066Ab2CaN3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 09:29:54 -0400
Subject: Re: [PATCH for v3.4] Fix ivtv AUDIO_(BILINGUAL_)CHANNEL_SELECT
 regression
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Martin Dauskardt <martin.dauskardt@gmx.de>
Date: Sat, 31 Mar 2012 09:29:51 -0400
In-Reply-To: <201203311118.19446.hverkuil@xs4all.nl>
References: <201203311118.19446.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1333200592.2514.25.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-03-31 at 11:18 +0200, Hans Verkuil wrote:
> Hi Mauro,
> 
> When I converted ivtv to the new decoder API I introduced a regression in the
> support of the old channel select API. The patch below fixes this.
> 
> Thanks to Martin Dauskardt for reporting this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good.  Thanks Martin and Hans.

Reviewd-by: Andy Walls <awalls@md.metrocast.net>

> Regards,
> 
> 	Hans
> 
> diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
> index 5452bee..989e556 100644
> --- a/drivers/media/video/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/video/ivtv/ivtv-ioctl.c
> @@ -1763,13 +1763,13 @@ static int ivtv_decoder_ioctls(struct file *filp, unsigned int cmd, void *arg)
>  		IVTV_DEBUG_IOCTL("AUDIO_CHANNEL_SELECT\n");
>  		if (iarg > AUDIO_STEREO_SWAPPED)
>  			return -EINVAL;
> -		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg);
> +		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_playback, iarg + 1);
>  
>  	case AUDIO_BILINGUAL_CHANNEL_SELECT:
>  		IVTV_DEBUG_IOCTL("AUDIO_BILINGUAL_CHANNEL_SELECT\n");
>  		if (iarg > AUDIO_STEREO_SWAPPED)
>  			return -EINVAL;
> -		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg);
> +		return v4l2_ctrl_s_ctrl(itv->ctrl_audio_multilingual_playback, iarg + 1);
>  
>  	default:
>  		return -EINVAL;


