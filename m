Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46014 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390803AbeKWADX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 19:03:23 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH] media: vsp1: Fix LIF buffer thresholds
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>
References: <20181122041700.25461-1-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <07ab7d33-3d12-9e25-6fca-7e2358e2fb6a@ideasonboard.com>
Date: Thu, 22 Nov 2018 13:23:57 +0000
MIME-Version: 1.0
In-Reply-To: <20181122041700.25461-1-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 22/11/2018 04:17, Laurent Pinchart wrote:
> Commit de2bc45c84f7 ("media: vsp1: Update LIF buffer thresholds")
> updated the LIF buffer thresholds based on the VSP version, but used the
> wrong model mask. This resulted in all VSP instances to be treated as a
> Gen3 VSPD, breaking operation on all Gen2 platforms as well as on
> H3 ES2.0, M3-N, V3M and V3H. Fix it.
Ouch. :-S

> Fixes: de2bc45c84f7 ("media: vsp1: Update LIF buffer thresholds")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

At least it's an easy fix.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> ---
>  drivers/media/platform/vsp1/vsp1_lif.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
> index 0b18f0bd7419..8b0a26335d70 100644
> --- a/drivers/media/platform/vsp1/vsp1_lif.c
> +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> @@ -95,7 +95,7 @@ static void lif_configure_stream(struct vsp1_entity *entity,
>  	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
>  					    LIF_PAD_SOURCE);
>  
> -	switch (entity->vsp1->version & VI6_IP_VERSION_SOC_MASK) {
> +	switch (entity->vsp1->version & VI6_IP_VERSION_MODEL_MASK) {
>  	case VI6_IP_VERSION_MODEL_VSPD_GEN2:
>  	case VI6_IP_VERSION_MODEL_VSPD_V2H:
>  		hbth = 1536;
> 

-- 
Regards
--
Kieran
