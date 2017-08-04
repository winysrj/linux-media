Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753010AbdHDQc6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 12:32:58 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 6/7] v4l: vsp1: Provide UDS register updates
Date: Fri,  4 Aug 2017 17:32:43 +0100
Message-Id: <05ce4c38d01f03ccc7895e447ff2368e4b6ddbde.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide register definitions required for UDS phase and partition
algorithm support. The registers and bits defined here are available on
Gen3 hardware only.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_regs.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index cd3e32af6e3b..362f4f8b1148 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -388,6 +388,7 @@
 #define VI6_UDS_CTRL_NE_RCR		(1 << 18)
 #define VI6_UDS_CTRL_NE_GY		(1 << 17)
 #define VI6_UDS_CTRL_NE_BCB		(1 << 16)
+#define VI6_UDS_CTRL_AMDSLH		(1 << 2)
 #define VI6_UDS_CTRL_TDIPC		(1 << 1)
 
 #define VI6_UDS_SCALE			0x2304
@@ -420,11 +421,24 @@
 #define VI6_UDS_PASS_BWIDTH_V_MASK	(0x7f << 0)
 #define VI6_UDS_PASS_BWIDTH_V_SHIFT	0
 
+#define VI6_UDS_HPHASE			0x2314
+#define VI6_UDS_HPHASE_HSTP_MASK	(0xfff << 16)
+#define VI6_UDS_HPHASE_HSTP_SHIFT	16
+#define VI6_UDS_HPHASE_HEDP_MASK	(0xfff << 0)
+#define VI6_UDS_HPHASE_HEDP_SHIFT	0
+
 #define VI6_UDS_IPC			0x2318
 #define VI6_UDS_IPC_FIELD		(1 << 27)
 #define VI6_UDS_IPC_VEDP_MASK		(0xfff << 0)
 #define VI6_UDS_IPC_VEDP_SHIFT		0
 
+#define VI6_UDS_HSZCLIP			0x231c
+#define VI6_UDS_HSZCLIP_HCEN		(1 << 28)
+#define VI6_UDS_HSZCLIP_HCL_OFST_MASK	(0xff << 16)
+#define VI6_UDS_HSZCLIP_HCL_OFST_SHIFT	16
+#define VI6_UDS_HSZCLIP_HCL_SIZE_MASK	(0x1fff << 0)
+#define VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT	0
+
 #define VI6_UDS_CLIP_SIZE		0x2324
 #define VI6_UDS_CLIP_SIZE_HSIZE_MASK	(0x1fff << 16)
 #define VI6_UDS_CLIP_SIZE_HSIZE_SHIFT	16
-- 
git-series 0.9.1
