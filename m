Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47005 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1CHMqT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 07:46:19 -0500
From: David Cohen <dacohen@gmail.com>
To: Hiroshi.DOYU@nokia.com
Cc: linux-omap@vger.kernel.org, fernando.lugo@ti.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>
Subject: [PATCH 2/3] omap3: change ISP's IOMMU da_start address
Date: Tue,  8 Mar 2011 14:46:04 +0200
Message-Id: <1299588365-2749-3-git-send-email-dacohen@gmail.com>
In-Reply-To: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

ISP doesn't consider 0x0 as a valid address, so it should explicitly
exclude first page from allowed 'da' range.

Signed-off-by: David Cohen <dacohen@gmail.com>
---
 arch/arm/mach-omap2/omap-iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-iommu.c b/arch/arm/mach-omap2/omap-iommu.c
index 3fc5dc7..3bea489 100644
--- a/arch/arm/mach-omap2/omap-iommu.c
+++ b/arch/arm/mach-omap2/omap-iommu.c
@@ -33,7 +33,7 @@ static struct iommu_device omap3_devices[] = {
 			.name = "isp",
 			.nr_tlb_entries = 8,
 			.clk_name = "cam_ick",
-			.da_start = 0x0,
+			.da_start = 0x1000,
 			.da_end = 0xFFFFF000,
 		},
 	},
-- 
1.7.0.4

