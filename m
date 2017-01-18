Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22061 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdARPKq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 10:10:46 -0500
Subject: Re: [PATCH 02/11] [media] s5p-mfc: Adding initial support for MFC
 v10.10
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <ec5c2602-627e-7a42-eda2-6a68b846fff8@samsung.com>
Date: Wed, 18 Jan 2017 16:10:39 +0100
MIME-version: 1.0
In-reply-to: <1484733729-25371-3-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
 <CGME20170118100723epcas5p132e0ebfad38261bed95cffc47334f9dc@epcas5p1.samsung.com>
 <1484733729-25371-3-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.01.2017 11:02, Smitha T Murthy wrote:
> Adding the support for MFC v10.10, with new register file and
> necessary hw control, decoder, encoder and structural changes.
>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: devicetree@vger.kernel.org 
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> ---
>  .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
>  drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |   36 ++++++++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc.c           |   30 +++++++++++++
>  drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    4 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    4 ++
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   44 +++++++++++---------
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   21 +++++----
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |    9 +++-
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |    2 +
>  9 files changed, 118 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h
>
> diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> index 2c90128..b70c613 100644
> --- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
> +++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
> @@ -13,6 +13,7 @@ Required properties:
>  	(c) "samsung,mfc-v7" for MFC v7 present in Exynos5420 SoC
>  	(d) "samsung,mfc-v8" for MFC v8 present in Exynos5800 SoC
>  	(e) "samsung,exynos5433-mfc" for MFC v8 present in Exynos5433 SoC
> +	(f) "samsung,mfc-v10" for MFC v10 present in a variant of Exynos7 SoC

Could you specify explicitly SoC version(s), Exynos7 is misleading.
Btw are there plans to upstream platforms using this MFC?

>  
>    - reg : Physical base address of the IP registers and length of memory
>  	  mapped region.
> diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> new file mode 100644
> index 0000000..bd671a5
> --- /dev/null
> +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
> @@ -0,0 +1,36 @@
> +/*
> + * Register definition file for Samsung MFC V10.x Interface (FIMV) driver
> + *
> + * Copyright (c) 2017 Samsung Electronics Co., Ltd.
> + *     http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef _REGS_MFC_V10_H
> +#define _REGS_MFC_V10_H
> +
> +#include <linux/sizes.h>
> +#include "regs-mfc-v8.h"
> +
> +/* MFCv10 register definitions*/
> +#define S5P_FIMV_MFC_CLOCK_OFF_V10			0x7120
> +#define S5P_FIMV_MFC_STATE_V10				0x7124
> +
> +/* MFCv10 Context buffer sizes */
> +#define MFC_CTX_BUF_SIZE_V10		(30 * SZ_1K)	/* 30KB */
> +#define MFC_H264_DEC_CTX_BUF_SIZE_V10	(2 * SZ_1M)	/* 2MB */
> +#define MFC_OTHER_DEC_CTX_BUF_SIZE_V10	(20 * SZ_1K)	/* 20KB */
> +#define MFC_H264_ENC_CTX_BUF_SIZE_V10	(100 * SZ_1K)	/* 100KB */
> +#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10	(15 * SZ_1K)	/* 15KB */
> +
> +/* MFCv10 variant defines */
> +#define MAX_FW_SIZE_V10		(SZ_1M)		/* 1MB */
> +#define MAX_CPB_SIZE_V10	(3 * SZ_1M)	/* 3MB */
> +#define MFC_VERSION_V10		0xA0
> +#define MFC_NUM_PORTS_V10	1
> +
> +#endif /*_REGS_MFC_V10_H*/
> +
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index bb0a588..a043cce 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1542,6 +1542,33 @@ static int s5p_mfc_resume(struct device *dev)
>  	.num_clocks	= 3,
>  };
>  
> +static struct s5p_mfc_buf_size_v6 mfc_buf_size_v10 = {
> +	.dev_ctx        = MFC_CTX_BUF_SIZE_V10,
> +	.h264_dec_ctx   = MFC_H264_DEC_CTX_BUF_SIZE_V10,
> +	.other_dec_ctx  = MFC_OTHER_DEC_CTX_BUF_SIZE_V10,
> +	.h264_enc_ctx   = MFC_H264_ENC_CTX_BUF_SIZE_V10,
> +	.other_enc_ctx  = MFC_OTHER_ENC_CTX_BUF_SIZE_V10,
> +};
> +
> +static struct s5p_mfc_buf_size buf_size_v10 = {
> +	.fw     = MAX_FW_SIZE_V10,
> +	.cpb    = MAX_CPB_SIZE_V10,
> +	.priv   = &mfc_buf_size_v10,
> +};
> +
> +static struct s5p_mfc_buf_align mfc_buf_align_v10 = {
> +	.base = 0,
> +};
> +
> +static struct s5p_mfc_variant mfc_drvdata_v10 = {
> +	.version        = MFC_VERSION_V10,
> +	.version_bit    = MFC_V10_BIT,
> +	.port_num       = MFC_NUM_PORTS_V10,
> +	.buf_size       = &buf_size_v10,
> +	.buf_align      = &mfc_buf_align_v10,
> +	.fw_name[0]     = "s5p-mfc-v10.fw",

Is firmware file publicly available? Sent to firmware repository?

> +};
> +
>  static const struct of_device_id exynos_mfc_match[] = {
>  	{
>  		.compatible = "samsung,mfc-v5",
> @@ -1558,6 +1585,9 @@ static int s5p_mfc_resume(struct device *dev)
>  	}, {
>  		.compatible = "samsung,exynos5433-mfc",
>  		.data = &mfc_drvdata_v8_5433,
> +	}, {
> +		.compatible = "samsung,mfc-v10",
> +		.data = &mfc_drvdata_v10,
>  	},
>  	{},
>  };
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index b45d18c..1941c63 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -23,7 +23,7 @@
>  #include <media/v4l2-ioctl.h>
>  #include <media/videobuf2-v4l2.h>
>  #include "regs-mfc.h"
> -#include "regs-mfc-v8.h"
> +#include "regs-mfc-v10.h"
>  
>  #define S5P_MFC_NAME		"s5p-mfc"
>  
> @@ -723,11 +723,13 @@ struct mfc_control {
>  #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
>  #define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
>  #define IS_MFCV8_PLUS(dev)	(dev->variant->version >= 0x80 ? 1 : 0)
> +#define IS_MFCV10(dev)		(dev->variant->version >= 0xA0 ? 1 : 0)
>  
>  #define MFC_V5_BIT	BIT(0)
>  #define MFC_V6_BIT	BIT(1)
>  #define MFC_V7_BIT	BIT(2)
>  #define MFC_V8_BIT	BIT(3)
> +#define MFC_V10_BIT	BIT(5)

I think you can use BIT(4) here.

Regards
Andrzej

