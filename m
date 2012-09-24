Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33721 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2IXGzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 02:55:50 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAU00BOFDWGJ1R0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 15:55:49 +0900 (KST)
Received: from AMDC159 ([106.116.147.30])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAU00JBYDW38750@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 15:55:49 +0900 (KST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, pawel@osciak.com, patches@linaro.org
References: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
 <1348467468-19854-4-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1348467468-19854-4-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 4/4] [media] mem2mem_testdev: Use devm_kzalloc() in probe
Date: Mon, 24 Sep 2012 08:55:33 +0200
Message-id: <049001cd9a21$9b4103e0$d1c30ba0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, September 24, 2012 8:18 AM Sachin Kamat wrote:
 
> devm_kzalloc() makes error handling and cleanup simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/platform/mem2mem_testdev.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/mem2mem_testdev.c
> b/drivers/media/platform/mem2mem_testdev.c
> index f7d15ec..cd1c844 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -1019,7 +1019,7 @@ static int m2mtest_probe(struct platform_device *pdev)
>  	struct video_device *vfd;
>  	int ret;
> 
> -	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
>  	if (!dev)
>  		return -ENOMEM;
> 
> @@ -1027,7 +1027,7 @@ static int m2mtest_probe(struct platform_device *pdev)
> 
>  	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
>  	if (ret)
> -		goto free_dev;
> +		return ret;
> 
>  	atomic_set(&dev->num_inst, 0);
>  	mutex_init(&dev->dev_mutex);
> @@ -1073,8 +1073,6 @@ rel_vdev:
>  	video_device_release(vfd);
>  unreg_dev:
>  	v4l2_device_unregister(&dev->v4l2_dev);
> -free_dev:
> -	kfree(dev);
> 
>  	return ret;
>  }
> @@ -1089,7 +1087,6 @@ static int m2mtest_remove(struct platform_device *pdev)
>  	del_timer_sync(&dev->timer);
>  	video_unregister_device(dev->vfd);
>  	v4l2_device_unregister(&dev->v4l2_dev);
> -	kfree(dev);
> 
>  	return 0;
>  }
> --
> 1.7.4.1

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


