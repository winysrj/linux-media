Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55989 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbcBURvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 12:51:12 -0500
Date: Sun, 21 Feb 2016 17:04:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrzej Hajda <a.hajda@samsung.com>
cc: linux-kernel@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] atmel-isi: fix IS_ERR_VALUE usage
In-Reply-To: <1455546925-22119-5-git-send-email-a.hajda@samsung.com>
Message-ID: <Pine.LNX.4.64.1602211700000.5959@axis700.grange>
References: <1455546925-22119-1-git-send-email-a.hajda@samsung.com>
 <1455546925-22119-5-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On Mon, 15 Feb 2016, Andrzej Hajda wrote:

> IS_ERR_VALUE macro should be used only with unsigned long type.
> For signed types comparison 'ret < 0' should be used.
> 
> The patch follows conclusion from discussion on LKML [1][2].
> 
> [1]: http://permalink.gmane.org/gmane.linux.kernel/2120927
> [2]: http://permalink.gmane.org/gmane.linux.kernel/2150581
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Thanks for the patch, but this one

https://lkml.org/lkml/2016/2/9/392

came a couple of days earlier. Unless there is an important reason to use 
yours, I'll use that one.

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/atmel-isi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 1af779e..ab2d9b9 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -1026,7 +1026,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
>  
>  static int atmel_isi_probe(struct platform_device *pdev)
>  {
> -	unsigned int irq;
> +	int irq;
>  	struct atmel_isi *isi;
>  	struct resource *regs;
>  	int ret, i;
> @@ -1086,7 +1086,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
>  		isi->width_flags |= 1 << 9;
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (IS_ERR_VALUE(irq)) {
> +	if (irq < 0) {
>  		ret = irq;
>  		goto err_req_irq;
>  	}
> -- 
> 1.9.1
> 
