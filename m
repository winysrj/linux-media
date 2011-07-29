Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44563 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1G2JXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 05:23:13 -0400
Date: Fri, 29 Jul 2011 11:23:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Jan Pohanka <xhpohanka@gmail.com>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: mx2_camera driver on mx27ipcam: dma_alloc_coherent size  failed
Message-ID: <20110729092311.GY16561@pengutronix.de>
References: <op.vzdduqnuyxxkfz@localhost.localdomain>
 <20110729075143.GX16561@pengutronix.de>
 <op.vzdhx5ucyxxkfz@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vzdhx5ucyxxkfz@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

On Fri, Jul 29, 2011 at 10:59:55AM +0200, Jan Pohanka wrote:
> thank you for answer. You are right I give no memory to camera
> device in mach-imx27ipcam.c. I have tried to do it in same way as it
> is in mach-pcm037.c but no success. Here is my init function
> 
> static int __init mx27ipcam_camera_init(void) {
> 	int dma, ret = -ENOMEM;
> 	struct platform_device *pdev;
> 
> 	printk("MX2 camera initialization.\n");
> 
> 	pdev = imx27_add_mx2_camera(&mx27ipcam_camera);
> 
> 	if (IS_ERR(pdev)) {
> 		printk("pdev error\n");
> 		return PTR_ERR(pdev);
> 	}
> 
> 	dma = dma_declare_coherent_memory(&pdev->dev,
> 					mx2_camera_base, mx2_camera_base,
> 					MX2_CAMERA_BUF_SIZE,
> 					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> 	if (!(dma & DMA_MEMORY_MAP))
> 		goto err;
> 
> 
> 	ret = platform_device_add(pdev);
> 	if (ret) {
> 		printk("platform_device_add error\n");
> 
> err:
> 		platform_device_put(pdev);
> 	}
> 
> 	return ret;
> }
and you also have a reserve callback? See commit
90026c8c823bff54172eab33a5e7fcecfd3df635 for all details.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
