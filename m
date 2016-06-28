Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42713 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbcF1J5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 05:57:34 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Shuah Khan' <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
	jtp.park@samsung.com, mchehab@osg.samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1465847114-7427-1-git-send-email-shuahkh@osg.samsung.com>
In-reply-to: <1465847114-7427-1-git-send-email-shuahkh@osg.samsung.com>
Subject: RE: [PATCH] media: s5p-mfc fix memory leak in s5p_mfc_remove()
Date: Tue, 28 Jun 2016 11:57:29 +0200
Message-id: <025e01d1d123$7c14e620$743eb260$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Shuah,

Which branch do you base your patches on?

I have trouble applying this path
(https://patchwork.linuxtv.org/patch/34577/) and 
"s5p-mfc fix null pointer deference in clk_core_enable()"
(https://patchwork.linuxtv.org/patch/34751/) 
onto current linuxtv/master.

The top commit of linuxtv/master is :
"commit 0db5c79989de2c68d5abb7ba891bfdb3cd3b7e05
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Thu Jun 16 08:04:40 2016 -0300

    [media] media-devnode.h: Fix documentation"

Could you please rebase the two patches mentioned above to the
linuxtv/master?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


> -----Original Message-----
> From: Shuah Khan [mailto:shuahkh@osg.samsung.com]
> Sent: Monday, June 13, 2016 9:45 PM
> To: kyungmin.park@samsung.com; k.debski@samsung.com;
> jtp.park@samsung.com; mchehab@osg.samsung.com
> Cc: Shuah Khan; linux-arm-kernel@lists.infradead.org; linux-
> media@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] media: s5p-mfc fix memory leak in s5p_mfc_remove()
> 
> s5p_mfc_remove() fails to release encoder and decoder video devices.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
> Changes since v1:
> - Addressed comments from Javier Martinez Canillas and added
>   his reviewed by:
> 
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index 274b4f1..f537b74 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1318,6 +1318,8 @@ static int s5p_mfc_remove(struct platform_device
> *pdev)
> 
>  	video_unregister_device(dev->vfd_enc);
>  	video_unregister_device(dev->vfd_dec);
> +	video_device_release(dev->vfd_enc);
> +	video_device_release(dev->vfd_dec);
>  	v4l2_device_unregister(&dev->v4l2_dev);
>  	s5p_mfc_release_firmware(dev);
>  	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx[0]);
> --
> 2.7.4


