Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44549 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbeCZRVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 13:21:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        stable@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: vsp1: Fix BRx conditional path in WPF
Date: Mon, 26 Mar 2018 20:21:51 +0300
Message-ID: <3524048.Iptq6jntDe@avalon>
In-Reply-To: <1522070958-24295-1-git-send-email-kieran.bingham@ideasonboard.com>
References: <1522070958-24295-1-git-send-email-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday, 26 March 2018 16:29:17 EEST Kieran Bingham wrote:
> When a BRx is provided by a pipeline, the WPF must determine the master
> layer. Currently the condition to check this identifies pipe->bru ||
> pipe->num_inputs > 1.
> 
> The code then moves on to dereference pipe->bru, thus the check fails
> static analysers on the possibility that pipe->num_inputs could be
> greater than 1 without pipe->bru being set.
> 
> The reality is that the pipeline must have a BRx to support more than
> one input, thus this could never cause a fault - however it also
> identifies that the num_inputs > 1 check is redundant.
> 
> Remove the redundant check - and always configure the master layer
> appropriately when we have a BRx configured in our pipeline.
> 
> Fixes: 6134148f6098 ("v4l: vsp1: Add support for the BRS entity")
> Cc: stable@vger.kernel.org
> 
> Suggested-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

Looking at commit 5d0beeec59e303c76160ddd67fa73dcfc5d76de0 I think your patch 
is correct.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and taken in my tree.

> ---
>  drivers/media/platform/vsp1/vsp1_wpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
> b/drivers/media/platform/vsp1/vsp1_wpf.c index f7f3b4b2c2de..8bd6b2f1af15
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -452,7 +452,7 @@ static void wpf_configure(struct vsp1_entity *entity,
>  			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
>  	}
> 
> -	if (pipe->bru || pipe->num_inputs > 1)
> +	if (pipe->bru)
>  		srcrpf |= pipe->bru->type == VSP1_ENTITY_BRU
>  			? VI6_WPF_SRCRPF_VIRACT_MST
>  			: VI6_WPF_SRCRPF_VIRACT2_MST;

-- 
Regards,

Laurent Pinchart
