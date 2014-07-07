Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57736 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaGGQcc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 12:32:32 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 0/9] Add support for Exynos3250 SoC to the s5p-jpeg driver
Date: Mon, 07 Jul 2014 18:32:01 +0200
Message-id: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for jpeg codec on Exynos3250 SoC to
the s5p-jpeg driver. Supported raw formats are: YUYV, YVYU, UYVY,
VYUY, RGB565, RGB565X, RGB32, NV12, NV21. The support includes
also scaling and cropping features.

Thanks,
Jacek Anaszewski

Jacek Anaszewski (9):
  s5p-jpeg: Add support for Exynos3250 SoC
  s5p-jpeg: return error immediately after get_byte fails
  s5p-jpeg: Adjust jpeg_bound_align_image to Exynos3250 needs
  s5p-jpeg: fix g_selection op
  s5p-jpeg: Assure proper crop rectangle initialization
  s5p-jpeg: Prevent erroneous downscaling for Exynos3250 SoC
  s5p-jpeg: add chroma subsampling adjustment for Exynos3250
  Documentation: devicetree: Document sclk-jpeg clock for exynos3250
    SoC
  ARM: dts: exynos3250: add JPEG codec device node

 .../bindings/media/exynos-jpeg-codec.txt           |    9 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |   12 +
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  666 ++++++++++++++++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   33 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |  486 ++++++++++++++
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.h   |   60 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  247 +++++++-
 8 files changed, 1459 insertions(+), 56 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h

-- 
1.7.9.5

