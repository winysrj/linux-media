Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:33718 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab2IXGzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Sep 2012 02:55:48 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAU00KF7DWYQER0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 15:55:46 +0900 (KST)
Received: from AMDC159 ([106.116.147.30])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MAU00JBYDW38750@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 24 Sep 2012 15:55:46 +0900 (KST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: mchehab@infradead.org, pawel@osciak.com, patches@linaro.org
References: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1348467468-19854-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/4] [media] mem2mem_testdev: Fix incorrect location of
 v4l2_m2m_release()
Date: Mon, 24 Sep 2012 08:55:15 +0200
Message-id: <048f01cd9a21$97daa760$c78ff620$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, September 24, 2012 8:18 AM Sachin Kamat wrote:

> v4l2_m2m_release() was placed after the return statement and outside
> any of the goto labels and hence was not getting executed under the
> error exit path. This patch moves it under the exit path label.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/platform/mem2mem_testdev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/mem2mem_testdev.c
> b/drivers/media/platform/mem2mem_testdev.c
> index 771a84f..fc95559 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -1067,8 +1067,8 @@ static int m2mtest_probe(struct platform_device *pdev)
> 
>  	return 0;
> 
> -	v4l2_m2m_release(dev->m2m_dev);
>  err_m2m:
> +	v4l2_m2m_release(dev->m2m_dev);
>  	video_unregister_device(dev->vfd);
>  rel_vdev:
>  	video_device_release(vfd);
> --
> 1.7.4.1

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


