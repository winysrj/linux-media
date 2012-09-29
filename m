Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58912 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2I2Pfv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 11:35:51 -0400
Received: by bkcjk13 with SMTP id jk13so4145629bkc.19
        for <linux-media@vger.kernel.org>; Sat, 29 Sep 2012 08:35:50 -0700 (PDT)
Message-ID: <50671552.5010508@gmail.com>
Date: Sat, 29 Sep 2012 17:35:46 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, k.debski@samsung.com,
	jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com,
	m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: Re: [PATCH v7 5/6] [media] s5p-mfc: MFCv6 register definitions
References: <1348851868-7698-1-git-send-email-arun.kk@samsung.com> <1348851868-7698-6-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1348851868-7698-6-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

I have a few minor comments.

On 09/28/2012 07:04 PM, Arun Kumar K wrote:
> From: Jeongtae Park<jtp.park@samsung.com>
> 
> Adds register definitions for MFC v6.x firmware
> 
> Signed-off-by: Jeongtae Park<jtp.park@samsung.com>
> Signed-off-by: Janghyuck Kim<janghyuck.kim@samsung.com>
> Signed-off-by: Jaeryul Oh<jaeryul.oh@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   drivers/media/platform/s5p-mfc/regs-mfc-v6.h |  408 ++++++++++++++++++++++++++
>   1 files changed, 408 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v6.h
> 
> diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
> new file mode 100644
> index 0000000..cce1841
> --- /dev/null
> +++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
> @@ -0,0 +1,408 @@
> +/*
> + * Register definition file for Samsung MFC V6.x Interface (FIMV) driver
> + *
> + * Copyright (c) 2012 Samsung Electronics

I believe the proper notation is

	Copyright (c) 2012 Samsung Electronics Co., Ltd.

Please make sure it's correct in all files added in this series.

> + *		http://www.samsung.com/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef _REGS_FIMV_V6_H
> +#define _REGS_FIMV_V6_H

Please add

#include <linux/kernel.h> 
#include <linux/sizes.h> 

> +#define S5P_FIMV_REG_SIZE_V6	(S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR)
> +#define S5P_FIMV_REG_COUNT_V6	((S5P_FIMV_END_ADDR - S5P_FIMV_START_ADDR) / 4)
> +
> +/* Number of bits that the buffer address should be shifted for particular
> + * MFC buffers.  */
> +#define S5P_FIMV_MEM_OFFSET_V6		0
> +
> +#define S5P_FIMV_START_ADDR_V6		0x0000
> +#define S5P_FIMV_END_ADDR_V6		0xfd80
> +
> +#define S5P_FIMV_REG_CLEAR_BEGIN_V6	0xf000
> +#define S5P_FIMV_REG_CLEAR_COUNT_V6	1024
> +
> +/* Codec Common Registers */
> +#define S5P_FIMV_RISC_ON_V6			0x0000
> +#define S5P_FIMV_RISC2HOST_INT_V6		0x003C

Could you make sure all hex numbers are in lower case in this file ?

...
> +#define S5P_FIMV_NUM_TMV_BUFFERS_V6		2
> +
> +#define S5P_FIMV_MAX_FRAME_SIZE_V6			(2048 * 1024)

(2 * SZ_1M)

> +#define S5P_FIMV_NUM_PIXELS_IN_MB_ROW_V6		16
> +#define S5P_FIMV_NUM_PIXELS_IN_MB_COL_V6		16
> +
> +/* Buffer size requirements defined by hardware */
> +#define S5P_FIMV_TMV_BUFFER_SIZE_V6(w, h)	((w + 1) * (h + 1) * 8)

The arguments should be in parentheses in the expressions, i.e.

#define S5P_FIMV_TMV_BUFFER_SIZE_V6(w, h)	(((w) + 1) * ((h) + 1) * 8)

> +#define S5P_FIMV_ME_BUFFER_SIZE_V6(imw, imh, mbw, mbh) \
> +						(((((imw+63)/64) * 16) * \
> +						(((imh+63)/64) * 16)) + \
> +						((((mbw*mbh)+31)/32) * 16))

Could be rewritten as:

#define S5P_FIMV_ME_BUFFER_SIZE_V6(imw, imh, mbw, mbh) \
	((ALIGN(imw, 64) *  ALIGN(imh, 64) * 256) + (ALIGN((mbw) * (mbh), 32) * 16))


> +#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(w, h)	((w * 192) + 64)
> +#define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(w, h) \
> +						(w * (h * 64 + 144) + \
> +						((2048 + 15)/16 * h * 64) + \
> +						((2048 + 15)/16 * 256 + 8320))

	(w * (h * 64 + 144) + (2048/16 * h * 64) + (2048/16 * 256 + 8320))

> +#define S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(w, h)	(2096 * (w + h + 1))
> +#define S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(w, h)	(w * 400)
> +#define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V6(w, h) \
> +						(w * 32 + h * 128 + \
> +						((w + 1) / 2) * 64 + 2112)

Unnecessarily broken into two lines.

> +#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(w, h) \
> +						((w * 64) + ((w + 1) * 16) + \
> +						(4096 * 16))

Ditto.

> +#define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(w, h) \
> +						((w * 16) + ((w + 1) * 16))
> +
> +/* MFC Context buffer sizes */
> +#define MFC_CTX_BUF_SIZE_V6		0x7000		/*  28KB */

Perhaps we could use the SZ_* macro definitions, e.g. (28 * SZ_1K) ?

> +#define MFC_H264_DEC_CTX_BUF_SIZE_V6	0x200000	/* 1.6MB */

(1600 * SZ_1K) ...

> +#define MFC_OTHER_DEC_CTX_BUF_SIZE_V6	0x5000		/*  20KB */
> +#define MFC_H264_ENC_CTX_BUF_SIZE_V6	0x19000		/* 100KB */
> +#define MFC_OTHER_ENC_CTX_BUF_SIZE_V6	0x3000		/*  12KB */
> +
> +/* MFCv6 variant defines */
> +#define MAX_FW_SIZE_V6			0x100000	/* 1MB */
> +#define MAX_CPB_SIZE_V6			0x300000	/* 3MB */

... (3 * SZ_1M)

> +#define MFC_VERSION_V6			0x61
> +#define MFC_NUM_PORTS_V6		1
> +
> +#endif /* _REGS_FIMV_V6_H */

Thanks,
Sylwester
