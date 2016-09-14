Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36179 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758268AbcINSj4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 14:39:56 -0400
Received: by mail-lf0-f52.google.com with SMTP id g62so16682023lfe.3
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 11:39:56 -0700 (PDT)
Date: Wed, 14 Sep 2016 20:39:53 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 05/13] v4l: vsp1: Use DFE instead of FRE for frame end
Message-ID: <20160914183953.GI739@bigcity.dyn.berto.se>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473808626-19488-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1473808626-19488-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-09-14 02:16:58 +0300, Laurent Pinchart wrote:
> From: Kieran Bingham <kieran+renesas@bingham.xyz>
> 
> The DFE and FRE interrupts are both fired at frame completion, as each
> display list processes a single frame. This won't be true anymore when
> using image partitioning, switch to DFE in preparation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/vsp1/vsp1_drv.c | 2 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 92418fc09511..57c713a4e1df 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -60,7 +60,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
>  		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA(i));
>  		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status & mask);
>  
> -		if (status & VI6_WFP_IRQ_STA_FRE) {
> +		if (status & VI6_WFP_IRQ_STA_DFE) {
>  			vsp1_pipeline_frame_end(wpf->pipe);
>  			ret = IRQ_HANDLED;
>  		}
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 31983169c24a..748f5af90b7e 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -318,7 +318,7 @@ static void wpf_configure(struct vsp1_entity *entity,
>  	/* Enable interrupts */
>  	vsp1_dl_list_write(dl, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
>  	vsp1_dl_list_write(dl, VI6_WPF_IRQ_ENB(wpf->entity.index),
> -			   VI6_WFP_IRQ_ENB_FREE);
> +			   VI6_WFP_IRQ_ENB_DFEE);
>  }
>  
>  static const struct vsp1_entity_operations wpf_entity_ops = {
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
