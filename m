Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:24334 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaGHMxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 08:53:07 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8E00FA394HO9A0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Jul 2014 21:53:05 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com,
	b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 0/3] Add support for Exynos3250 SoC to s5p-mfc driver
Date: Tue, 08 Jul 2014 14:51:46 +0200
Message-id: <1404823909-5509-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for MFC codec on Exynos3250
to the s5p-mfc driver.

Thanks,
Jacek Anaszewski

Jacek Anaszewski (3):
  s5p-mfc: Fix selective sclk_mfc init
  ARM: dts: exynos3250 add MFC codec device node
  Documentation: devicetree: Document exynos3250 SoC related settings

 .../devicetree/bindings/media/s5p-mfc.txt          |   10 +++++---
 arch/arm/boot/dts/exynos3250.dtsi                  |   11 +++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   26 ++++++++++++++++++++
 3 files changed, 44 insertions(+), 3 deletions(-)

-- 
1.7.9.5

