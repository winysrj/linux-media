Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55174 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbbA2BXe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 20:23:34 -0500
Received: by mail-pa0-f49.google.com with SMTP id fa1so32120039pad.8
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2015 17:23:34 -0800 (PST)
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
To: laurent.pinchart+renesas@ideasonboard.com
Cc: linux-media@vger.kernel.org,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 2/3] [media] v4l: vsp1: Fix VI6_DPR_ROUTE_FP_MASK macro
Date: Thu, 29 Jan 2015 09:53:54 +0900
Message-Id: <1422492835-4398-2-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
In-Reply-To: <1422492835-4398-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1422492835-4398-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FP bit of VI6_DPR_mod_ROUTE register is 6bit. But VI6_DPR_ROUTE_FP_MASK is set
to 0xFF, this will mask until the reserve bit.
This fixes size for VI6_DPR_ROUTE_FP_MASK.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index f61e109..4177f98 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -306,7 +306,7 @@
 #define VI6_DPR_BRU_ROUTE		0x204c
 #define VI6_DPR_ROUTE_FXA_MASK		(0xff << 8)
 #define VI6_DPR_ROUTE_FXA_SHIFT		16
-#define VI6_DPR_ROUTE_FP_MASK		(0xff << 8)
+#define VI6_DPR_ROUTE_FP_MASK		(0x3f << 8)
 #define VI6_DPR_ROUTE_FP_SHIFT		8
 #define VI6_DPR_ROUTE_RT_MASK		(0x3f << 0)
 #define VI6_DPR_ROUTE_RT_SHIFT		0
-- 
2.1.3

