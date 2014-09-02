Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52245 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaIBUfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Sep 2014 16:35:04 -0400
Date: Tue, 2 Sep 2014 22:34:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
cc: linuxtv-commits@linuxtv.org
Subject: Re: [git:media_tree/master] [media] atmel-isi: Fix a truncate warning
In-Reply-To: <E1XOtGI-0007MC-Uf@www.linuxtv.org>
Message-ID: <Pine.LNX.4.64.1409022227160.31953@axis700.grange>
References: <E1XOtGI-0007MC-Uf@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Aug 2014, Mauro Carvalho Chehab wrote:

> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] atmel-isi: Fix a truncate warning
> Author:  Mauro Carvalho Chehab <m.chehab@samsung.com>
> Date:    Fri Aug 22 05:53:27 2014 -0500
> 
>    drivers/media/platform/soc_camera/atmel-isi.c: In function 'start_streaming':
>    drivers/media/platform/soc_camera/atmel-isi.c:397:26: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>      isi_writel(isi, ISI_INTDIS, ~0UL);
>                              ^
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
>  drivers/media/platform/soc_camera/atmel-isi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=9842a417d46bf40f2d460120016b6392d3ac32c9
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index f87012b..96a4b11 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -394,7 +394,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
>  		return ret;
>  	}
>  	/* Disable all interrupts */
> -	isi_writel(isi, ISI_INTDIS, ~0UL);
> +	isi_writel(isi, ISI_INTDIS, (u32)~0UL);

Uhm... Wouldn't it have been much better to just remove the 'L' above to 
make it "~0U" ?.. Too late, I guess.

Thanks
Guennadi

>  
>  	spin_lock_irq(&isi->lock);
>  	/* Clear any pending interrupt */
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 
