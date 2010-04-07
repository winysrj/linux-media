Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59408 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757259Ab0DGJZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 05:25:59 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Dan Carpenter <error27@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 7 Apr 2010 14:55:34 +0530
Subject: RE: [patch] davinci: don't return under lock on error path
Message-ID: <19F8576C6E063C45BE387C64729E7394044DF7F9AA@dbde02.ent.ti.com>
References: <20100407092105.GC5157@bicker>
In-Reply-To: <20100407092105.GC5157@bicker>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Wednesday, April 07, 2010 2:51 PM
> To: Mauro Carvalho Chehab
> Cc: Hans Verkuil; Hiremath, Vaibhav; Laurent Pinchart; Karicheri,
> Muralidharan; linux-media@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch] davinci: don't return under lock on error path
> 
> If the kmalloc() failed for "ccdc_cfg = kmalloc(...);" then we would exit
> with the lock held.  I moved the mutex_lock() below the allocation
> because it isn't protecting anything in that block and allocations are
> allocations are sometimes slow.
[Hiremath, Vaibhav] Good catch and thanks for the patch.


Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>

Thanks,
Vaibhav
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/davinci/vpfe_capture.c
> b/drivers/media/video/davinci/vpfe_capture.c
> index 7cf042f..5c83f90 100644
> --- a/drivers/media/video/davinci/vpfe_capture.c
> +++ b/drivers/media/video/davinci/vpfe_capture.c
> @@ -1824,7 +1824,6 @@ static __init int vpfe_probe(struct platform_device
> *pdev)
>  		goto probe_free_dev_mem;
>  	}
> 
> -	mutex_lock(&ccdc_lock);
>  	/* Allocate memory for ccdc configuration */
>  	ccdc_cfg = kmalloc(sizeof(struct ccdc_config), GFP_KERNEL);
>  	if (NULL == ccdc_cfg) {
> @@ -1833,6 +1832,8 @@ static __init int vpfe_probe(struct platform_device
> *pdev)
>  		goto probe_free_dev_mem;
>  	}
> 
> +	mutex_lock(&ccdc_lock);
> +
>  	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
>  	/* Get VINT0 irq resource */
>  	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
