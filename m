Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44963 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752382AbdB1P7l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 10:59:41 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: [PATCH v3 4/8] v4l: vsp1: Fix HGO and HGT routing register addresses
Date: Tue, 28 Feb 2017 17:56:44 +0200
Message-Id: <20170228155648.12051-5-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The addresses are incorrect, fix them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 47b1dee044fb..61369e267667 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -328,8 +328,8 @@
 #define VI6_DPR_ROUTE_RT_MASK		(0x3f << 0)
 #define VI6_DPR_ROUTE_RT_SHIFT		0
 
-#define VI6_DPR_HGO_SMPPT		0x2050
-#define VI6_DPR_HGT_SMPPT		0x2054
+#define VI6_DPR_HGO_SMPPT		0x2054
+#define VI6_DPR_HGT_SMPPT		0x2058
 #define VI6_DPR_SMPPT_TGW_MASK		(7 << 8)
 #define VI6_DPR_SMPPT_TGW_SHIFT		8
 #define VI6_DPR_SMPPT_PT_MASK		(0x3f << 0)
-- 
Regards,

Laurent Pinchart
