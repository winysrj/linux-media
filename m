Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3449C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 13:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B71B8214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 13:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfCMNf4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 09:35:56 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:57742 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfCMNf4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 09:35:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F29CA78;
        Wed, 13 Mar 2019 06:35:55 -0700 (PDT)
Received: from [10.1.196.69] (e112269-lin.cambridge.arm.com [10.1.196.69])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A7D663F59C;
        Wed, 13 Mar 2019 06:35:53 -0700 (PDT)
Subject: Re: [PATCH v2] media: rga: fix NULL pointer dereferences and a memory
 leak
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <6fc9f670-a199-b83d-ff0a-d4cdb8cb80d1@arm.com>
 <20190312065824.19646-1-kjlu@umn.edu>
From:   Steven Price <steven.price@arm.com>
Message-ID: <ff11d704-489f-836e-6c9d-1b2fb5e963b6@arm.com>
Date:   Wed, 13 Mar 2019 13:35:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190312065824.19646-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/03/2019 06:58, Kangjie Lu wrote:
> In case __get_free_pages fails, the fix releases resources and
> return -ENOMEM to avoid NULL pointer dereferences.
> 
> Also, the fix frees pages when video_register_device fails to
> avoid a memory leak.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/platform/rockchip/rga/rga.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
> index 5c653287185f..307b7ab0ab64 100644
> --- a/drivers/media/platform/rockchip/rga/rga.c
> +++ b/drivers/media/platform/rockchip/rga/rga.c
> @@ -892,8 +892,17 @@ static int rga_probe(struct platform_device *pdev)
>  
>  	rga->src_mmu_pages =
>  		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
> +	if (!rga->src_mmu_pages) {
> +		ret = -ENOMEM;
> +		goto rel_vdev;
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
> @@ -901,7 +910,7 @@ static int rga_probe(struct platform_device *pdev)
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
>  	if (ret) {
>  		v4l2_err(&rga->v4l2_dev, "Failed to register video device\n");
> -		goto rel_vdev;
> +		goto free_pages;
>  	}
>  
>  	v4l2_info(&rga->v4l2_dev, "Registered %s as /dev/%s\n",
> @@ -909,6 +918,10 @@ static int rga_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> +free_pages:
> +	free_pages((unsigned long)rga->src_mmu_pages, 3);
> +free_dst_pages:
> +	free_pages((unsigned long)rga->dst_mmu_pages, 3);
>  rel_vdev:
>  	video_device_release(vfd);
>  unreg_video_dev:

That looks good. However looking into the error path more closely it
appears that this was already rather broken. Here's the original:

> rel_vdev:
> 	video_device_release(vfd);
> unreg_video_dev:
> 	video_unregister_device(rga->vfd);
> unreg_v4l2_dev:
> 	v4l2_device_unregister(&rga->v4l2_dev);
> err_put_clk:
> 	pm_runtime_disable(rga->dev);

video_device_release() is simply a call to kfree(), but
video_unregister_device will then be called with the same pointer
(rga->vfd is set to vfd further up). Which will then cause a
use-after-free on the pointer.

It might be a good idea to test this error path, for example make the
video_register_device() call always fail and run with memory debuggers
enabled (e.g. CONFIG_KASAN or CONFIG_DEBUG_KMEM_LEAK).

Steve
