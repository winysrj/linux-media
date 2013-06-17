Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62366 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3FQOpw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 10:45:52 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOJ00094KZJ7P20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jun 2013 15:45:50 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Arun Kumar K' <arun.kk@samsung.com>, linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
 <1370870586-24141-4-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370870586-24141-4-git-send-email-arun.kk@samsung.com>
Subject: RE: [PATCH 3/6] [media] s5p-mfc: Core support for MFC v7
Date: Mon, 17 Jun 2013 16:45:29 +0200
Message-id: <002a01ce6b69$512943c0$f37bcb40$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

I have read your patches. They seem alright, I back comments made by Hans
and Sylwester. I have one question, which follows inline.

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland

> -----Original Message-----
> From: Arun Kumar K [mailto:arun.kk@samsung.com]
> Sent: Monday, June 10, 2013 3:23 PM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; jtp.park@samsung.com; s.nawrocki@samsung.com;
> avnd.kiran@samsung.com; arunkk.samsung@gmail.com
> Subject: [PATCH 3/6] [media] s5p-mfc: Core support for MFC v7
> 
> Adds variant data and core support for the MFC v7 firmware
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |   32
> +++++++++++++++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index d12faa6..d6be52f 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1391,6 +1391,32 @@ static struct s5p_mfc_variant mfc_drvdata_v6 = {
>  	.fw_name        = "s5p-mfc-v6.fw",
>  };
> 
> +struct s5p_mfc_buf_size_v6 mfc_buf_size_v7 = {
> +	.dev_ctx	= MFC_CTX_BUF_SIZE_V7,
> +	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V7,
> +	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V7,
> +	.h264_enc_ctx	= MFC_H264_ENC_CTX_BUF_SIZE_V7,
> +	.other_enc_ctx	= MFC_OTHER_ENC_CTX_BUF_SIZE_V7,
> +};
> +
> +struct s5p_mfc_buf_size buf_size_v7 = {
> +	.fw	= MAX_FW_SIZE_V7,
> +	.cpb	= MAX_CPB_SIZE_V7,
> +	.priv	= &mfc_buf_size_v7,
> +};
> +
> +struct s5p_mfc_buf_align mfc_buf_align_v7 = {
> +	.base = 0,
> +};
> +
> +static struct s5p_mfc_variant mfc_drvdata_v7 = {
> +	.version	= MFC_VERSION_V7,
> +	.port_num	= MFC_NUM_PORTS_V7,
> +	.buf_size	= &buf_size_v7,
> +	.buf_align	= &mfc_buf_align_v7,
> +	.fw_name        = "s5p-mfc-v7.fw",
> +};
> +
>  static struct platform_device_id mfc_driver_ids[] = {
>  	{
>  		.name = "s5p-mfc",
> @@ -1401,6 +1427,9 @@ static struct platform_device_id mfc_driver_ids[]
> = {
>  	}, {
>  		.name = "s5p-mfc-v6",
>  		.driver_data = (unsigned long)&mfc_drvdata_v6,
> +	}, {
> +		.name = "s5p-mfc-v7",
> +		.driver_data = (unsigned long)&mfc_drvdata_v7,
>  	},
>  	{},
>  };
> @@ -1413,6 +1442,9 @@ static const struct of_device_id
> exynos_mfc_match[] = {
>  	}, {
>  		.compatible = "samsung,mfc-v6",
>  		.data = &mfc_drvdata_v6,
> +	}, {
> +		.compatible = "samsung,mfc-v7",
> +		.data = &mfc_drvdata_v7,
>  	},
>  	{},
>  };
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index ef4074c..7281de2 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -24,6 +24,7 @@
>  #include <media/videobuf2-core.h>
>  #include "regs-mfc.h"
>  #include "regs-mfc-v6.h"
> +#include "regs-mfc-v7.h"
> 
>  /* Definitions related to MFC memory */
> 
> @@ -684,5 +685,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
>  				(dev->variant->port_num ? 1 : 0) : 0) : 0)
>  #define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 :
0)
>  #define IS_MFCV6(dev)		(dev->variant->version >= 0x60 ? 1 :
0)
> +#define IS_MFCV7(dev)		(dev->variant->version >= 0x70 ? 1 :
0)

According to this, MFC v7 is also detected as MFC v6. Was this intended?
I think that it would be much better to use this in code:
	if (IS_MFCV6(dev) || IS_MFCV7(dev))
And change the define to detect only single MFC revision:
	#define IS_MFCV6(dev)		(dev->variant->version >= 0x60 &&
dev->variant->version < 0x70)

Other possibility I see is to change the name of the check. Although
IS_MFCV6_OR_NEWER(dev) seems too long :)

> 
>  #endif /* S5P_MFC_COMMON_H_ */
> --
> 1.7.9.5


