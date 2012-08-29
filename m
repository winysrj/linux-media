Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44558 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2H2PQO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Aug 2012 11:16:14 -0400
Received: from eusync3.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9I00MTUVS0A220@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Aug 2012 16:16:48 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M9I00LS0VQZ7G00@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Aug 2012 16:16:11 +0100 (BST)
Message-id: <503E323A.8060409@samsung.com>
Date: Wed, 29 Aug 2012 17:16:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Josh Wu <josh.wu@atmel.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	nicolas.ferre@atmel.com, mchehab@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] atmel_isi: allocate memory to store the isi
 platform data.
References: <1346235093-28613-1-git-send-email-josh.wu@atmel.com>
In-reply-to: <1346235093-28613-1-git-send-email-josh.wu@atmel.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/29/2012 12:11 PM, Josh Wu wrote:
> This patch fix the bug: ISI driver's platform data became invalid 
> when isi platform data's attribution is __initdata.
> 
> If the isi platform data is passed as __initdata. Then we need store
> it in driver allocated memory. otherwise when we use it out of the 
> probe() function, then the isi platform data is invalid.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  drivers/media/platform/soc_camera/atmel-isi.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index ec3f6a0..dc0fdec 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -926,6 +926,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
>  	clk_put(isi->mck);
>  	clk_unprepare(isi->pclk);
>  	clk_put(isi->pclk);
> +	kfree(isi->pdata);
>  	kfree(isi);
>  
>  	return 0;
> @@ -968,8 +969,15 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
>  		goto err_alloc_isi;
>  	}
>  
> +	isi->pdata = kzalloc(sizeof(struct isi_platform_data), GFP_KERNEL);
> +	if (!isi->pdata) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "Can't allocate isi platform data!\n");
> +		goto err_alloc_isi_pdata;
> +	}
> +	memcpy(isi->pdata, pdata, sizeof(struct isi_platform_data));
> +

Why not just embed struct isi_platform_data in struct atmel_isi and drop this
another kzalloc() ?
Then you could simply do isi->pdata = *pdata.

Also, is this going to work when this driver is build and as a module
and its loading is deferred past system booting ? At that time the driver's
platform data may be well discarded. You may wan't to duplicate it on the
running boards in board code with kmemdup() or something.

--

Regards,
Sylwester
