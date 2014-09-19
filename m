Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33868 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaISNF4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 09:05:56 -0400
Message-ID: <1411131948.3965.3.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH] [media] coda: coda-bit: Include "<linux/slab.h>"
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: m.chehab@samsung.com, k.debski@samsung.com,
	linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Date: Fri, 19 Sep 2014 15:05:48 +0200
In-Reply-To: <1411126350-5936-1-git-send-email-festevam@gmail.com>
References: <1411126350-5936-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 19.09.2014, 08:32 -0300 schrieb Fabio Estevam:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> coda-bit uses kmalloc/kfree functions, so the slab header needs to be included
> in order to fix the following build errors:
> 
> drivers/media/platform/coda/coda-bit.c: In function 'coda_fill_bitstream':
> drivers/media/platform/coda/coda-bit.c:231:4: error: implicit declaration of function 'kmalloc' [-Werror=implicit-function-declaration]
> drivers/media/platform/coda/coda-bit.c: In function 'coda_alloc_framebuffers':
> drivers/media/platform/coda/coda-bit.c:312:3: error: implicit declaration of function 'kfree' [-Werror=implicit-function-declaration]
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/media/platform/coda/coda-bit.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index 07fc91a..9b8ea8b 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -17,6 +17,7 @@
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/reset.h>
> +#include <linux/slab.h>
>  #include <linux/videodev2.h>
>  
>  #include <media/v4l2-common.h>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

thanks
Philipp

