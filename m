Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49187 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab0E0LR2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 07:17:28 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m-karicheri2@ti.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 3/3] OMAP_VOUT:FIX: Module params were not working through bootargs
Date: Thu, 27 May 2010 16:47:09 +0530
Message-Id: <1274959029-5866-4-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap/Makefile b/drivers/media/video/omap/Makefile
index b8bab00..b287880 100644
--- a/drivers/media/video/omap/Makefile
+++ b/drivers/media/video/omap/Makefile
@@ -3,5 +3,5 @@
 #
 
 # OMAP2/3 Display driver
-omap-vout-mod-objs := omap_vout.o omap_voutlib.o
-obj-$(CONFIG_VIDEO_OMAP2_VOUT) += omap-vout-mod.o
+omap-vout-y := omap_vout.o omap_voutlib.o
+obj-$(CONFIG_VIDEO_OMAP2_VOUT) += omap-vout.o
-- 
1.6.2.4

