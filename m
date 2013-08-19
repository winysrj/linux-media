Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:37356 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab3HSM06 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 08:26:58 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Shaik Ameer Basha' <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	cpgs@samsung.com
Cc: s.nawrocki@samsung.com, posciak@google.com, arun.kk@samsung.com
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
Subject: RE: [PATCH v2 0/5] Exynos5 M-Scaler Driver
Date: Mon, 19 Aug 2013 21:26:53 +0900
Message-id: <032601ce9cd7$63666640$2a3332c0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Shaik Ameer Basha
> Sent: Monday, August 19, 2013 7:59 PM
> To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
> Cc: s.nawrocki@samsung.com; posciak@google.com; arun.kk@samsung.com;
> shaik.ameer@samsung.com
> Subject: [PATCH v2 0/5] Exynos5 M-Scaler Driver
> 
> This patch adds support for M-Scaler (M2M Scaler) device which is a
> new device for scaling, blending, color fill  and color space
> conversion on EXYNOS5 SoCs.

All Exynos5 SoCs really have this IP? It seems that only Exynos5420 and
maybe Exynos5410 have this IP, NOT Exynos5250. Please check it again and
describe it surely over the all patch series.

Thanks,
Inki Dae

> 
> This device supports the following as key features.
>     input image format
>         - YCbCr420 2P(UV/VU), 3P
>         - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
>         - YCbCr444 2P(UV,VU), 3P
>         - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
>         - Pre-multiplexed ARGB8888, L8A8 and L8
>     output image format
>         - YCbCr420 2P(UV/VU), 3P
>         - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
>         - YCbCr444 2P(UV,VU), 3P
>         - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
>         - Pre-multiplexed ARGB8888
>     input rotation
>         - 0/90/180/270 degree, X/Y/XY Flip
>     scale ratio
>         - 1/4 scale down to 16 scale up
>     color space conversion
>         - RGB to YUV / YUV to RGB
>     Size
>         - Input : 16x16 to 8192x8192
>         - Output:   4x4 to 8192x8192
>     alpha blending, color fill
> 
> Rebased on:
> -----------
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git:master
> 
> Changes from v1:
> ---------------
> 1] Split the previous single patch into multiple patches.
> 2] Added DT binding documentation.
> 3] Removed the unnecessary header file inclusions.
> 4] Fix the condition check in mscl_prepare_address for swapping cb/cr
> addresses.
> 
> Shaik Ameer Basha (5):
>   [media] exynos-mscl: Add new driver for M-Scaler
>   [media] exynos-mscl: Add core functionality for the M-Scaler driver
>   [media] exynos-mscl: Add m2m functionality for the M-Scaler driver
>   [media] exynos-mscl: Add DT bindings for M-Scaler driver
>   [media] exynos-mscl: Add Makefile for M-Scaler driver
> 
>  .../devicetree/bindings/media/exynos5-mscl.txt     |   34 +
>  drivers/media/platform/Kconfig                     |    8 +
>  drivers/media/platform/Makefile                    |    1 +
>  drivers/media/platform/exynos-mscl/Makefile        |    3 +
>  drivers/media/platform/exynos-mscl/mscl-core.c     | 1312
> ++++++++++++++++++++
>  drivers/media/platform/exynos-mscl/mscl-core.h     |  549 ++++++++
>  drivers/media/platform/exynos-mscl/mscl-m2m.c      |  763 ++++++++++++
>  drivers/media/platform/exynos-mscl/mscl-regs.c     |  318 +++++
>  drivers/media/platform/exynos-mscl/mscl-regs.h     |  282 +++++
>  9 files changed, 3270 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-
> mscl.txt
>  create mode 100644 drivers/media/platform/exynos-mscl/Makefile
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.c
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-core.h
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-m2m.c
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.c
>  create mode 100644 drivers/media/platform/exynos-mscl/mscl-regs.h
> 
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

