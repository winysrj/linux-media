Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35253 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760199AbcINTaD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 15:30:03 -0400
Received: by mail-lf0-f42.google.com with SMTP id l131so17568447lfl.2
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 12:30:03 -0700 (PDT)
Date: Wed, 14 Sep 2016 21:30:01 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 14/13] v4l: vsp1: Fix spinlock in mixed IRQ context
 function
Message-ID: <20160914193000.GM739@bigcity.dyn.berto.se>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473809348-5222-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1473809348-5222-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-09-14 02:29:08 +0300, Laurent Pinchart wrote:
> The wpf_configure() function can be called both from IRQ and non-IRQ
> contexts, use spin_lock_irqsave().
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/vsp1/vsp1_wpf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index b4ecffbaa3e3..c483fead3e98 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -251,11 +251,12 @@ static void wpf_configure(struct vsp1_entity *entity,
>  	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
>  		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
>  					| BIT(WPF_CTRL_HFLIP);
> +		unsigned long flags;
>  
> -		spin_lock(&wpf->flip.lock);
> +		spin_lock_irqsave(&wpf->flip.lock, flags);
>  		wpf->flip.active = (wpf->flip.active & ~mask)
>  				 | (wpf->flip.pending & mask);
> -		spin_unlock(&wpf->flip.lock);
> +		spin_unlock_irqrestore(&wpf->flip.lock, flags);
>  
>  		outfmt = (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT) | wpf->outfmt;
>  
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
