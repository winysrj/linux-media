Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FF4C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 13:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E7C20657
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 13:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfCKNQC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:16:02 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:54070 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfCKNQB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 09:16:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 772CFA78;
        Mon, 11 Mar 2019 06:16:01 -0700 (PDT)
Received: from [10.1.196.69] (e112269-lin.cambridge.arm.com [10.1.196.69])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF0293F703;
        Mon, 11 Mar 2019 06:15:59 -0700 (PDT)
From:   Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] media: rga: fix NULL pointer dereferences
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        pakki001@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <20190309063556.32487-1-kjlu@umn.edu>
Message-ID: <6fc9f670-a199-b83d-ff0a-d4cdb8cb80d1@arm.com>
Date:   Mon, 11 Mar 2019 13:15:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190309063556.32487-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 09/03/2019 06:35, Kangjie Lu wrote:
> In case __get_free_pages fails, return -ENOMEM to avoid NULL
> pointer dereferences.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>  drivers/media/platform/rockchip/rga/rga.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
> index 5c653287185f..d42b214977a9 100644
> --- a/drivers/media/platform/rockchip/rga/rga.c
> +++ b/drivers/media/platform/rockchip/rga/rga.c
> @@ -892,8 +892,13 @@ static int rga_probe(struct platform_device *pdev)
>  
>  	rga->src_mmu_pages =
>  		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
> +	if (!rga->src_mmu_pages)
> +		return -ENOMEM;
> +
>  	rga->dst_mmu_pages =
>  		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);
> +	if (!rga->dst_mmu_pages)
> +		return -ENOMEM;

I believe you need to perform clean up when probe fails, not just return
early, e.g. with a 'goto' to the existing clean up code at the end of
the function.

Also from what I can tell there is already a potential memory leak if
video_register_device() fails. You probably want something more like the
(completely untested) change below.

Steve

----8<----
diff --git a/drivers/media/platform/rockchip/rga/rga.c
b/drivers/media/platform/rockchip/rga/rga.c
index 5c653287185f..8df1945594ab 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -895,6 +895,11 @@ static int rga_probe(struct platform_device *pdev)
 	rga->dst_mmu_pages =
 		(unsigned int *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 3);

+	if (!rga->src_mmu_pages || !rga->dst_mmu_pages) {
+		ret = -ENOMEM;
+		goto free_mem;
+	}
+
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
 	def_frame.size = def_frame.stride * def_frame.height;

@@ -911,6 +916,9 @@ static int rga_probe(struct platform_device *pdev)

 rel_vdev:
 	video_device_release(vfd);
+free_mem:
+	free_pages((unsigned long)rga->src_mmu_pages, 3);
+	free_pages((unsigned long)rga->dst_mmu_pages, 3);
 unreg_video_dev:
 	video_unregister_device(rga->vfd);
 unreg_v4l2_dev:
