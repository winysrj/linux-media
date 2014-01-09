Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54350 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaAID2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 22:28:49 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: s.nawrocki@samsung.com, posciak@google.com, hverkuil@xs4all.nl,
	shaik.ameer@samsung.com, m.chehab@samsung.com
Subject: [PATCH v5 0/4] Exynos5 Series SCALER Driver
Date: Thu,  9 Jan 2014 08:58:10 +0530
Message-Id: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for SCALER device which is a
new device for scaling, blending, color fill  and color space
conversion on EXYNOS5410/5420 SoCs.

This device supports the following as key features.
    input image format
        - YCbCr420 2P(UV/VU), 3P
        - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
        - YCbCr444 2P(UV,VU), 3P
        - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
        - Pre-multiplexed ARGB8888, L8A8 and L8
    output image format
        - YCbCr420 2P(UV/VU), 3P
        - YCbCr422 1P(YUYV/UYVY/YVYU), 2P(UV,VU), 3P
        - YCbCr444 2P(UV,VU), 3P
        - RGB565, ARGB1555, ARGB4444, ARGB8888, RGBA8888
        - Pre-multiplexed ARGB8888
    input rotation
        - 0/90/180/270 degree, X/Y/XY Flip
    scale ratio
        - 1/4 scale down to 16 scale up
    color space conversion
        - RGB to YUV / YUV to RGB
    Size - Exynos5420
        - Input : 16x16 to 8192x8192
        - Output:   4x4 to 8192x8192
    Size - Exynos5410
        - Input/Output: 4x4 to 4096x4096
    alpha blending, color fill

Rebased on:
-----------
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git:master

Changes from v4:
---------------
Addressed review comments from, Sylwester Nawrocki and Mauro Carvalho Chehab
Links to the review comments:
	1] https://linuxtv.org/patch/20307/
	2] https://linuxtv.org/patch/20308/
	3] https://linuxtv.org/patch/20451/

Changes from v3:
---------------
Addressed review comments from, Sylwester Nawrocki and Hans Verkuil.
Links to the review comments:
        1] https://linuxtv.org/patch/20072/
        2] https://linuxtv.org/patch/20073/

Changes from v2:
---------------
Addressed review comments from, Inki Dae, Hans Verkuil and Sylwester Nawrocki.
Links to the review comments:
        1] https://linuxtv.org/patch/19783/
        2] https://linuxtv.org/patch/19784/
        3] https://linuxtv.org/patch/19785/
        4] https://linuxtv.org/patch/19786/
        5] https://linuxtv.org/patch/19787/

Changes from v1:
---------------
1] Split the previous single patch into multiple patches.
2] Added DT binding documentation.
3] Removed the unnecessary header file inclusions.
4] Fix the condition check in mscl_prepare_address for swapping cb/cr addresses.

Shaik Ameer Basha (4):
  [media] exynos-scaler: Add new driver for Exynos5 SCALER
  [media] exynos-scaler: Add core functionality for the SCALER driver
  [media] exynos-scaler: Add m2m functionality for the SCALER driver
  [media] exynos-scaler: Add DT bindings for SCALER driver

 .../devicetree/bindings/media/exynos5-scaler.txt   |   22 +
 drivers/media/platform/Kconfig                     |    8 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/exynos-scaler/Makefile      |    3 +
 drivers/media/platform/exynos-scaler/scaler-m2m.c  |  788 +++++++++++++
 drivers/media/platform/exynos-scaler/scaler-regs.c |  337 ++++++
 drivers/media/platform/exynos-scaler/scaler-regs.h |  331 ++++++
 drivers/media/platform/exynos-scaler/scaler.c      | 1231 ++++++++++++++++++++
 drivers/media/platform/exynos-scaler/scaler.h      |  376 ++++++
 9 files changed, 3097 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt
 create mode 100644 drivers/media/platform/exynos-scaler/Makefile
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-m2m.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler-regs.h
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.c
 create mode 100644 drivers/media/platform/exynos-scaler/scaler.h

-- 
1.7.9.5

