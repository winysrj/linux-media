Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:33551 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753801AbcINS2u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 14:28:50 -0400
Received: by mail-lf0-f45.google.com with SMTP id h127so16575587lfh.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 11:28:49 -0700 (PDT)
Date: Wed, 14 Sep 2016 20:28:46 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 03/13] v4l: vsp1: Ensure pipeline locking in resume path
Message-ID: <20160914182846.GH739@bigcity.dyn.berto.se>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473808626-19488-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1473808626-19488-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-09-14 02:16:56 +0300, Laurent Pinchart wrote:
> From: Kieran Bingham <kieran+renesas@bingham.xyz>
> 
> The vsp1_pipeline_ready() and vsp1_pipeline_run() functions must be
> called with the pipeline lock held, fix the resume code path.
> 
> Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/vsp1/vsp1_pipe.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
> index 3e75fb3fcace..474de82165d8 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -365,6 +365,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
>  
>  void vsp1_pipelines_resume(struct vsp1_device *vsp1)
>  {
> +	unsigned long flags;
>  	unsigned int i;
>  
>  	/* Resume all running pipelines. */
> @@ -379,7 +380,9 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
>  		if (pipe == NULL)
>  			continue;
>  
> +		spin_lock_irqsave(&pipe->irqlock, flags);
>  		if (vsp1_pipeline_ready(pipe))
>  			vsp1_pipeline_run(pipe);
> +		spin_unlock_irqrestore(&pipe->irqlock, flags);
>  	}
>  }
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
