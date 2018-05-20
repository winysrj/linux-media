Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60158 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbeETHEV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 May 2018 03:04:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 9/9] v4l: vsp1: Reduce display list body size
Date: Sun, 20 May 2018 10:04:43 +0300
Message-ID: <2794710.jCN7UpUv5u@avalon>
In-Reply-To: <e0ad4e839ffffb002ced5e960b43f5a54cd0260e.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com> <e0ad4e839ffffb002ced5e960b43f5a54cd0260e.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 28 February 2018 22:52:43 EEST Kieran Bingham wrote:
> The display list originally allocated a body of 256 entries to store all
> of the register lists required for each frame.
> 
> This has now been separated into fragments for constant stream setup, and
> runtime updates.
> 
> Empirical testing shows that the body0 now uses a maximum of 41
> registers for each frame, for both DRM and Video API pipelines thus a
> rounded 64 entries provides a suitable allocation.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Just wondering, why have you dropped this from new versions of the patch 
series ?

> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index a762e840d147..6b5743a431a2
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -21,7 +21,7 @@
>  #include "vsp1.h"
>  #include "vsp1_dl.h"
> 
> -#define VSP1_DL_NUM_ENTRIES		256
> +#define VSP1_DL_NUM_ENTRIES		64
> 
>  #define VSP1_DLH_INT_ENABLE		(1 << 1)
>  #define VSP1_DLH_AUTO_START		(1 << 0)


-- 
Regards,

Laurent Pinchart
