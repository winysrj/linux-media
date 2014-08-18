Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40133 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaHRJOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 05:14:02 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAH00BVHWARHO50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Aug 2014 10:13:39 +0100 (BST)
Message-id: <53F1C3D5.6030606@samsung.com>
Date: Mon, 18 Aug 2014 11:13:57 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Pawel Osciak <pawel@osciak.com>
Subject: Re: [RFC PATCH] vb2: use pr_info instead of pr_debug
References: <53E4C996.4060001@xs4all.nl>
In-reply-to: <53E4C996.4060001@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-08-08 14:59, Hans Verkuil wrote:
> Modern kernels enable dynamic printk support, which is fine, except when it is
> combined with a debug module option. Enabling debug in videobuf2-core now produces
> no debugging unless it is also enabled through the dynamic printk support in debugfs.
>
> Either use a debug module option + pr_info, or use pr_debug without a debug module
> option. In this case the fact that you can set various debug levels is very useful,
> so I believe that for videobuf2-core.c we should use pr_info.
>
> The mix of the two is very confusing: I've spent too much time already trying to
> figure out why I am not seeing any debug output in the kernel log when I do:
>
> 	echo 1 >/sys/modules/videobuf2_core/parameters/debug
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 0e3d927..0b59735 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -36,7 +36,7 @@ module_param(debug, int, 0644);
>   #define dprintk(level, fmt, arg...)					      \
>   	do {								      \
>   		if (debug >= level)					      \
> -			pr_debug("vb2: %s: " fmt, __func__, ## arg); \
> +			pr_info("vb2: %s: " fmt, __func__, ## arg); \
>   	} while (0)
>   
>   #ifdef CONFIG_VIDEO_ADV_DEBUG
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

