Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46234 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaCEKOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 05:14:44 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N1Y0033OKGC4G40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 05 Mar 2014 10:14:36 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Seung-Woo Kim' <sw0312.kim@samsung.com>,
	linux-media@vger.kernel.org, m.chehab@samsung.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
References: <1394014092-29620-1-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1394014092-29620-1-git-send-email-sw0312.kim@samsung.com>
Subject: RE: [PATCH] [media] s5-mfc: remove meaningless assignment
Date: Wed, 05 Mar 2014 11:14:40 +0100
Message-id: <187b01cf385b$b933c1b0$2b9b4510$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Seung-Woo,

> From: Seung-Woo Kim [mailto:sw0312.kim@samsung.com]
> Sent: Wednesday, March 05, 2014 11:08 AM
> 
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>

Thank you for your patch. I know that content of the patch is obvious, but
please provide a description of the patch.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> index 2475a3c..ee05f2d 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
> @@ -44,8 +44,6 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
>  		return -ENOMEM;
>  	}
> 
> -	dev->bank1 = dev->bank1;
> -
>  	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
>  		bank2_virt = dma_alloc_coherent(dev->mem_dev_r, 1 <<
> MFC_BASE_ALIGN_ORDER,
>  					&bank2_dma_addr, GFP_KERNEL);
> --
> 1.7.4.1

