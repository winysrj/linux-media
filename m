Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50034 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbbAGHiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 02:38:10 -0500
Received: by mail-pd0-f178.google.com with SMTP id r10so3017266pdi.9
        for <linux-media@vger.kernel.org>; Tue, 06 Jan 2015 23:38:10 -0800 (PST)
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart+renesas@ideasonboard.com,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 2/2] [media] v4l: vsp1: Fix VI6_DISP_IRQ_STA_LNE macro
Date: Wed,  7 Jan 2015 16:37:54 +0900
Message-Id: <1420616274-15018-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
In-Reply-To: <1420616274-15018-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1420616274-15018-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LNE bit in VI6_DISP_IRQ_STA register are from the 0 bit to 4 bit.
This fixes bit position specified by VI6_DISP_IRQ_STA_LNE.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 79d4063..da3c573 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -48,7 +48,7 @@
 #define VI6_DISP_IRQ_STA		0x007c
 #define VI6_DISP_IRQ_STA_DSE		(1 << 8)
 #define VI6_DISP_IRQ_STA_MAE		(1 << 5)
-#define VI6_DISP_IRQ_STA_LNE(n)		(1 << ((n) + 4))
+#define VI6_DISP_IRQ_STA_LNE(n)		(1 << (n))
 
 #define VI6_WPF_LINE_COUNT(n)		(0x0084 + (n) * 4)
 #define VI6_WPF_LINE_COUNT_MASK		(0x1fffff << 0)
-- 
2.1.3

