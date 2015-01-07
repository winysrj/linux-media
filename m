Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:65459 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbAGHiG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 02:38:06 -0500
Received: by mail-pa0-f52.google.com with SMTP id eu11so3127686pac.11
        for <linux-media@vger.kernel.org>; Tue, 06 Jan 2015 23:38:05 -0800 (PST)
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart+renesas@ideasonboard.com,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 1/2] [media] v4l: vsp1: Fix VI6_DISP_IRQ_ENB_LNEE macro
Date: Wed,  7 Jan 2015 16:37:53 +0900
Message-Id: <1420616274-15018-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LNEE bit in VI6_DISP_IRQ_ENB register are from the 0 bit to 4 bit.
This fixes bit position specified by VI6_DISP_IRQ_ENB_LNEE.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 55f163d..79d4063 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -43,7 +43,7 @@
 #define VI6_DISP_IRQ_ENB		0x0078
 #define VI6_DISP_IRQ_ENB_DSTE		(1 << 8)
 #define VI6_DISP_IRQ_ENB_MAEE		(1 << 5)
-#define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << ((n) + 4))
+#define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << (n))
 
 #define VI6_DISP_IRQ_STA		0x007c
 #define VI6_DISP_IRQ_STA_DSE		(1 << 8)
-- 
2.1.3

