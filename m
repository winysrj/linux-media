Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbbIMU5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 17/32] v4l: vsp1: Fix typo in VI6_DISP_IRQ_STA_DST register name
Date: Sun, 13 Sep 2015 23:56:55 +0300
Message-Id: <1442177830-24536-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the VI6_DISP_IRQ_STA_DSE register to VI6_DISP_IRQ_STA_DST to fix
a typo and match the datasheet.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 25b48738b147..8173ceaab9f9 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -46,7 +46,7 @@
 #define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << (n))
 
 #define VI6_DISP_IRQ_STA		0x007c
-#define VI6_DISP_IRQ_STA_DSE		(1 << 8)
+#define VI6_DISP_IRQ_STA_DST		(1 << 8)
 #define VI6_DISP_IRQ_STA_MAE		(1 << 5)
 #define VI6_DISP_IRQ_STA_LNE(n)		(1 << (n))
 
-- 
2.4.6

