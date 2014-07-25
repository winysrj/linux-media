Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61813 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaGYOVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 10:21:08 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 0/9] Support for Exynos3250 SoC in the s5p-jpeg driver
Date: Fri, 25 Jul 2014 16:20:44 +0200
Message-id: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for the JPEG codec IP found on the
Exynos3250 SoCs. Supported raw formats are: YUYV, YVYU, UYVY, VYUY,
RGB565, RGB565X, RGB32, NV12, NV21. Support for the hardware scaling
and cropping features is added.

Changes since v2 (only patches 1/9, 2/9, 9/9):
 - the IP function clock renamed from "sclk-jpeg" to "sclk" and made
   optional regardless of the device compatible string,
 - fixed compilation warning in jpeg-hw-exynos3250.c.

Changes since v1:
 - added default case to the switch statement in the function
   exynos3250_jpeg_dec_scaling_ratiofunction
 - removed not supported DT properties
 - improved DT documentation
 - updated Kconfig entry
 - corrected DTS maintainer email in the commit message

Jacek Anaszewski (9):
  [media] s5p-jpeg: Document sclk-jpeg clock for Exynos3250 SoC
  s5p-jpeg: Add support for Exynos3250 SoC
  s5p-jpeg: return error immediately after get_byte fails
  s5p-jpeg: Adjust jpeg_bound_align_image to Exynos3250 needs
  s5p-jpeg: fix g_selection op
  s5p-jpeg: Assure proper crop rectangle initialization
  s5p-jpeg: Prevent erroneous downscaling for Exynos3250 SoC
  s5p-jpeg: add chroma subsampling adjustment for Exynos3250
  ARM: dts: exynos3250: add JPEG codec device node

 .../bindings/media/exynos-jpeg-codec.txt           |   12 +-
 arch/arm/boot/dts/exynos3250.dtsi                  |    9 +
 drivers/media/platform/Kconfig                     |    5 +-
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  660 ++++++++++++++++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   32 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |  487 +++++++++++++++
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.h   |   60 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  247 +++++++-
 9 files changed, 1455 insertions(+), 59 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h

--
1.7.9.5

