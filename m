Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:64259 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1CYPNq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:13:46 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, david.cohen@nokia.com,
	hiroshi.doyu@nokia.com
Subject: [PATCH 1/4] omap iommu: Check existence of arch_iommu
Date: Fri, 25 Mar 2011 17:13:22 +0200
Message-Id: <1301066005-7882-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4D8CB106.7030608@maxwell.research.nokia.com>
References: <4D8CB106.7030608@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Check that the arch_iommu has been installed before trying to use it. This
will lead to kernel oops if the arch_iommu isn't there.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 arch/arm/plat-omap/iommu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index b1107c0..f0fea0b 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -104,6 +104,9 @@ static int iommu_enable(struct iommu *obj)
 	if (!obj)
 		return -EINVAL;
 
+	if (!arch_iommu)
+		return -ENOENT;
+
 	clk_enable(obj->clk);
 
 	err = arch_iommu->enable(obj);
-- 
1.7.2.3

