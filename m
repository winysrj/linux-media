Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34597 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752932AbdDENuM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Apr 2017 09:50:12 -0400
Message-ID: <1491400210.2381.97.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: bump maximum number of internal
 framebuffers to 17
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Date: Wed, 05 Apr 2017 15:50:10 +0200
In-Reply-To: <20170405131115.31769-1-l.stach@pengutronix.de>
References: <20170405131115.31769-1-l.stach@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-04-05 at 15:11 +0200, Lucas Stach wrote:
> The h.264 standard allows up to 16 reference frame for the high profile
> and we need one additional internal framebuffer when the VDOA is in use.
> 
> Lift the current maximum of 8 internal framebuffers to allow playback
> of those video streams.
> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> ---
>  drivers/media/platform/coda/coda.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
> index 799ffca72203..2a5bbe0050bb 100644
> --- a/drivers/media/platform/coda/coda.h
> +++ b/drivers/media/platform/coda/coda.h
> @@ -28,7 +28,7 @@
>  
>  #include "coda_regs.h"
>  
> -#define CODA_MAX_FRAMEBUFFERS	8
> +#define CODA_MAX_FRAMEBUFFERS	17
>  #define FMO_SLICE_SAVE_BUF_SIZE	(32)
>  
>  enum {
