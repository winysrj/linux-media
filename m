Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab2LTRTI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Dec 2012 12:19:08 -0500
Date: Thu, 20 Dec 2012 15:18:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Linux Media ML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
Message-ID: <20121220151845.4e92f056@redhat.com>
In-Reply-To: <20121121152809.51c780a6@redhat.com>
References: <20121121152809.51c780a6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 21 Nov 2012 15:28:09 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Hi Andy,
> 
> I'm understanding that you'll be reviewing this patch. So, I'm marking it as
> under_review at patchwork.

-ENOANSWER. Let me apply it, in order to fix the warning.

> 
> Thanks,
> Mauro
> 
> Forwarded message:
> 
> Date: Wed, 24 Oct 2012 10:14:16 -0200
> From: Fabio Estevam <festevam@gmail.com>
> To: awalls@md.metrocast.net
> Cc: mchehab@infradead.org, linux-media@vger.kernel.org, tj@kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
> Subject: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
> 
> 
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Since commit 43829731d (workqueue: deprecate flush[_delayed]_work_sync()),
> flush_work() should be used instead of flush_work_sync().
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/media/pci/ivtv/ivtv-driver.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
> index 74e9a50..5d0a5df 100644
> --- a/drivers/media/pci/ivtv/ivtv-driver.c
> +++ b/drivers/media/pci/ivtv/ivtv-driver.c
> @@ -304,7 +304,7 @@ static void request_modules(struct ivtv *dev)
>  
>  static void flush_request_modules(struct ivtv *dev)
>  {
> -	flush_work_sync(&dev->request_module_wk);
> +	flush_work(&dev->request_module_wk);
>  }
>  #else
>  #define request_modules(dev)


-- 

Cheers,
Mauro
