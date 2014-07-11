Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64320 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaGKPTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:19:54 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8J00ETAZX4QZ60@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jul 2014 00:19:52 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, andrzej.p@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v2 0/9] Add support for Exynos3250 SoC to the s5p-jpeg driver
Date: Fri, 11 Jul 2014 17:19:41 +0200
Message-id: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of the patch series adding support for
jpeg codec on Exynos3250 SoC to the s5p-jpeg driver (Sylwester -
thanks for a review). Supported raw formats are: YUYV, YVYU, UYVY,
VYUY, RGB565, RGB565X, RGB32, NV12, NV21. The support includes also
scaling and cropping features.

=================
Changes since v1:
=================

- added default case to the switch statement in the function
  exynos3250_jpeg_dec_scaling_ratiofunction
- removed not supported DT properties
- improved DT documentation
- updated Kconfig entry
- corrected DTS maintainer email in the commit message

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
 arch/arm/boot/dts/exynos3250.dtsi                  |    9 +
 drivers/media/platform/Kconfig                     |    5 +-
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  666 ++++++++++++++++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   33 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |  489 ++++++++++++++
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.h   |   60 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  247 +++++++-
 9 files changed, 1462 insertions(+), 58 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h

-- 
1.7.9.5

