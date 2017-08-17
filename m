Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56486 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750857AbdHQQLG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 12:11:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 8/8] v4l: vsp1: Reduce display list body size
Date: Thu, 17 Aug 2017 19:11:30 +0300
Message-ID: <3704707.T2fvHgbeUE@avalon>
In-Reply-To: <fa078611769415d7adbad208f1299d05bee3bda8.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com> <fa078611769415d7adbad208f1299d05bee3bda8.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday 14 Aug 2017 16:13:31 Kieran Bingham wrote:
> The display list originally allocated a body of 256 entries to store all
> of the register lists required for each frame.
> 
> This has now been separated into fragments for constant stream setup, and
> runtime updates.
> 
> Empirical testing shows that the body0 now uses a maximum of 41
> registers for each frame, for both DRM and Video API pipelines thus a
> rounded 64 entries provides a suitable allocation.

Didn't you mention in patch 7/8 that one of the fragments uses exactly 64 
entries ? Which one is it, and is there a risk it could use more ? 

> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 176a258146ac..b3f5eb2f9a4f
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
