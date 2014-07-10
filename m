Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47653 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaGJI5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 04:57:39 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8H00IKMNK14370@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Jul 2014 17:57:37 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: arun.kk@samsung.com, k.debski@samsung.com, jtp.park@samsung.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v2 0/3] Add support for Exynos3250 SoC to s5p-mfc driver
Date: Thu, 10 Jul 2014 10:57:26 +0200
Message-id: <1404982646-23363-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is second version of the patch set that adds support for
MFC codec on Exynos3250 to the s5p-mfc driver
(Sachin and Arun - thanks for a review).

=================
Changes since v1:
=================
- made SCLK an optional parameter, as not all the devices
  with the same MFC version require initializing the clock explicitly.
- adjusted commit message of the patch extending DT documentation

Thanks,
Jacek Anaszewski

Jacek Anaszewski (3):
  s5p-mfc: Fix selective sclk_mfc init
  ARM: dts: exynos3250 add MFC codec device node
  DT: s5p-mfc: Document exynos3250 SoC related settings

 .../devicetree/bindings/media/s5p-mfc.txt          |   10 +++++---
 arch/arm/boot/dts/exynos3250.dtsi                  |   11 +++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        |   24 ++++++++++++++++++++
 3 files changed, 42 insertions(+), 3 deletions(-)

-- 
1.7.9.5

