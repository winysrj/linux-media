Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:46811 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792Ab2K1TJq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:46 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700HZQP81F3B0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:45 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:44 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 03/12] fimc-lite: Register dump function cleanup
Date: Wed, 28 Nov 2012 20:09:20 +0100
Message-id: <1354129766-2821-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_info() to make it possible to identify which FIMC-LITE
device instance the logs refer to.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
index a22d7eb..ad63ebf 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite-reg.c
@@ -292,9 +292,11 @@ void flite_hw_dump_regs(struct fimc_lite *dev, const char *label)
 	};
 	u32 i;
 
-	pr_info("--- %s ---\n", label);
+	v4l2_info(&dev->subdev, "--- %s ---\n", label);
+
 	for (i = 0; i < ARRAY_SIZE(registers); i++) {
 		u32 cfg = readl(dev->regs + registers[i].offset);
-		pr_info("%s: %s:\t0x%08x\n", __func__, registers[i].name, cfg);
+		v4l2_info(&dev->subdev, "%9s: 0x%08x\n",
+			  registers[i].name, cfg);
 	}
 }
-- 
1.7.9.5

