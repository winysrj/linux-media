Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32383 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab3GRP7P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 11:59:15 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQ500FZP328FG20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 18 Jul 2013 16:59:13 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, patches@linaro.org,
	'Hans Verkuil' <hans.verkuil@cisco.com>
References: <1373870183-28063-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1373870183-28063-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/1] [media] s5p-g2d: Fix registration failure
Date: Thu, 18 Jul 2013 17:59:06 +0200
Message-id: <061601ce83cf$bc4e9aa0$34ebcfe0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Monday, July 15, 2013 8:36 AM
> 
> Commit 1c1d86a1ea ("[media] v4l2: always require v4l2_dev, rename
> parent to dev_parent") expects v4l2_dev to be always set.
> It converted most of the drivers using the parent field of video_device
> to v4l2_dev field. G2D driver did not set the parent field. Hence it
> got left out. Without this patch we get the following boot warning and
> G2D driver fails to register the video device.
> 
> WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/v4l2-dev.c:775
> __video_register_device+0xfc0/0x1028()
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc1-00001-g1c3e372-
> dirty #9 [<c0014b7c>] (unwind_backtrace+0x0/0xf4) from [<c0011524>]
> (show_stack+0x10/0x14) [<c0011524>] (show_stack+0x10/0x14) from
> [<c041d7a8>] (dump_stack+0x7c/0xb0) [<c041d7a8>] (dump_stack+0x7c/0xb0)
> from [<c001dc94>] (warn_slowpath_common+0x6c/0x88) [<c001dc94>]
> (warn_slowpath_common+0x6c/0x88) from [<c001dd4c>]
> (warn_slowpath_null+0x1c/0x24) [<c001dd4c>]
> (warn_slowpath_null+0x1c/0x24) from [<c02cf8d4>]
> (__video_register_device+0xfc0/0x1028)
> [<c02cf8d4>] (__video_register_device+0xfc0/0x1028) from [<c0311a94>]
> (g2d_probe+0x1f8/0x398) [<c0311a94>] (g2d_probe+0x1f8/0x398) from
> [<c0247d54>] (platform_drv_probe+0x14/0x18) [<c0247d54>]
> (platform_drv_probe+0x14/0x18) from [<c0246b10>]
> (driver_probe_device+0x108/0x220) [<c0246b10>]
> (driver_probe_device+0x108/0x220) from [<c0246cf8>]
> (__driver_attach+0x8c/0x90) [<c0246cf8>] (__driver_attach+0x8c/0x90)
> from [<c0245050>] (bus_for_each_dev+0x60/0x94) [<c0245050>]
> (bus_for_each_dev+0x60/0x94) from [<c02462c8>]
> (bus_add_driver+0x1c0/0x24c) [<c02462c8>] (bus_add_driver+0x1c0/0x24c)
> from [<c02472d0>] (driver_register+0x78/0x140) [<c02472d0>]
> (driver_register+0x78/0x140) from [<c00087c8>]
> (do_one_initcall+0xf8/0x144) [<c00087c8>] (do_one_initcall+0xf8/0x144)
> from [<c05b29e8>] (kernel_init_freeable+0x13c/0x1d8)
> [<c05b29e8>] (kernel_init_freeable+0x13c/0x1d8) from [<c041a108>]
> (kernel_init+0xc/0x160) [<c041a108>] (kernel_init+0xc/0x160) from
> [<c000e2f8>] (ret_from_fork+0x14/0x3c) ---[ end trace
> 4e0ec028b0028e02 ]--- s5p-g2d 12800000.g2d: Failed to register video
> device
> s5p-g2d: probe of 12800000.g2d failed with error -22
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-g2d/g2d.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/s5p-g2d/g2d.c
> b/drivers/media/platform/s5p-g2d/g2d.c
> index 553d87e..fd6289d 100644
> --- a/drivers/media/platform/s5p-g2d/g2d.c
> +++ b/drivers/media/platform/s5p-g2d/g2d.c
> @@ -784,6 +784,7 @@ static int g2d_probe(struct platform_device *pdev)
>  	}
>  	*vfd = g2d_videodev;
>  	vfd->lock = &dev->mutex;
> +	vfd->v4l2_dev = &dev->v4l2_dev;
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  	if (ret) {
>  		v4l2_err(&dev->v4l2_dev, "Failed to register video
> device\n");
> --
> 1.7.9.5


