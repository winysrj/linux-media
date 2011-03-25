Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:41986 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab1CYPNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:13:44 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, david.cohen@nokia.com,
	hiroshi.doyu@nokia.com
Subject: [PATCH 3/4] omap2 iommu: Set module information in omap2_iommu_ops
Date: Fri, 25 Mar 2011 17:13:24 +0200
Message-Id: <1301066005-7882-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4D8CB106.7030608@maxwell.research.nokia.com>
References: <4D8CB106.7030608@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Set omap2_iommu_ops.module to point to THIS_MODULE.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 arch/arm/mach-omap2/iommu2.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/iommu2.c b/arch/arm/mach-omap2/iommu2.c
index 14ee686..cf0c32a 100644
--- a/arch/arm/mach-omap2/iommu2.c
+++ b/arch/arm/mach-omap2/iommu2.c
@@ -342,6 +342,8 @@ static const struct iommu_functions omap2_iommu_ops = {
 	.save_ctx	= omap2_iommu_save_ctx,
 	.restore_ctx	= omap2_iommu_restore_ctx,
 	.dump_ctx	= omap2_iommu_dump_ctx,
+
+	.module		= THIS_MODULE,
 };
 
 static int __init omap2_iommu_init(void)
-- 
1.7.2.3

