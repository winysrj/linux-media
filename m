Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34231 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcDVS5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 14:57:30 -0400
Received: by mail-lf0-f41.google.com with SMTP id j11so84498491lfb.1
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2016 11:57:29 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Fri, 22 Apr 2016 20:57:27 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 6/6] rcar-vin: failed start_streaming didn't call
 s_stream(0)
Message-ID: <20160422185726.GC23014@bigcity.dyn.berto.se>
References: <1461330222-34096-1-git-send-email-hverkuil@xs4all.nl>
 <1461330222-34096-7-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1461330222-34096-7-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

On 2016-04-22 15:03:42 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This can leave adv7180 in an inconsistent state
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 644ec9b..087c30c 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1058,8 +1058,10 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	ret = rvin_capture_start(vin);
>  out:
>  	/* Return all buffers if something went wrong */
> -	if (ret)
> +	if (ret) {
>  		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> +		v4l2_subdev_call(sd, video, s_stream, 0);
> +	}
>  
>  	spin_unlock_irqrestore(&vin->qlock, flags);
>  
> -- 
> 2.8.0.rc3
> 

-- 
Regards,
Niklas Söderlund
