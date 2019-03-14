Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B1DEC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 10:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0160A21019
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 10:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfCNKaU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 06:30:20 -0400
Received: from foss.arm.com ([217.140.101.70]:41852 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbfCNKaT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 06:30:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B06D80D;
        Thu, 14 Mar 2019 03:30:19 -0700 (PDT)
Received: from [10.1.196.69] (e112269-lin.cambridge.arm.com [10.1.196.69])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A337D3F71D;
        Thu, 14 Mar 2019 03:30:17 -0700 (PDT)
Subject: Re: [PATCH v3] media: rga: fix NULL pointer dereferences,
 use-after-free, memory leak
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <ff11d704-489f-836e-6c9d-1b2fb5e963b6@arm.com>
 <20190314050344.29790-1-kjlu@umn.edu>
From:   Steven Price <steven.price@arm.com>
Message-ID: <3471f9df-ad8e-59c8-07d4-454dcc45e480@arm.com>
Date:   Thu, 14 Mar 2019 10:30:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190314050344.29790-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 14/03/2019 05:03, Kangjie Lu wrote:
> 1. dma_alloc_attrs, __get_free_pages can fail and return NULL.
> Further uses of their return values lead to NULL pointer
> dereferences
> 
> 2. In the error-handling path, video_unregister_device uses
> "rga->vfd" which has been freed by video_device_release
> 
> 3. The error handling for v4l2_m2m_init and video_register_device
> has memory-leak issues
> 
> The patch fixes the above issues.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>

Reviewed-by: Steven Price <steven.price@arm.com>

Yes, that looks like it solves the issues with the clean up - thanks for
reworking it!

> ---
>  drivers/media/platform/rockchip/rga/rga.c | 26 ++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
> index 5c653287185f..468365ceb99d 100644
> --- a/drivers/media/platform/rockchip/rga/rga.c
> +++ b/drivers/media/platform/rockchip/rga/rga.c
> @@ -889,11 +889,24 @@ static int rga_probe(struct platform_device *pdev)
>  	rga->cmdbuf_virt = dma_alloc_attrs(rga->dev, RGA_CMDBUF_SIZE,
>  					   &rga->cmdbuf_phy, GFP_KERNEL,
>  					   DMA_ATTR_WRITE_COMBINE);
> +	if (!rga->cmdbuf_virt) {
> +		ret = -ENOMEM;
> +		goto unreg_video_dev;
> +	}
>  
>  	rga->src_mmu_pages =
>  		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
> +	if (!rga->src_mmu_pages) {
> +		ret = -ENOMEM;
> +		goto free_dma_attrs;
> +	}
> +
>  	rga->dst_mmu_pages =
>  		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
> +	if (!rga->dst_mmu_pages) {
> +		ret = -ENOMEM;
> +		goto free_dst_pages;
> +	}
>  
>  	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
>  	def_frame.size = def_frame.stride * def_frame.height;
> @@ -901,7 +914,7 @@ static int rga_probe(struct platform_device *pdev)
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
>  	if (ret) {
>  		v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
> -		goto rel_vdev;
> +		goto free_pages;
>  	}
>  
>  	v4l2_info(&rga->v4l2_dev, "Registered %s as /dev/%s\n",
> @@ -909,10 +922,17 @@ static int rga_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> -rel_vdev:
> -	video_device_release(vfd);
> +free_pages:
> +	free_pages((unsigned long)rga->src_mmu_pages, 3);
> +free_dst_pages:
> +	free_pages((unsigned long)rga->dst_mmu_pages, 3);

Minor comment: free_pages accepts a NULL pointer (or more precisely 0,
since it takes an unsigned long), it just returns having done nothing.
So there isn't actually any harm in calling free_pages unconditionally
in the error path (since rga is initialised to all zeros). You can save
a couple of labels in the error path using that trick.

Thanks,

Steve

> +free_dma_attrs:
> +	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, rga->cmdbuf_virt,
> +		       rga->cmdbuf_phy,
> +		       DMA_ATTR_WRITE_COMBINE);
>  unreg_video_dev:
>  	video_unregister_device(rga->vfd);
> +	video_device_release(vfd);
>  unreg_v4l2_dev:
>  	v4l2_device_unregister(&rga->v4l2_dev);
>  err_put_clk:
> 

