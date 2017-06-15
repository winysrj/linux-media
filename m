Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35688 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdFOIXy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 04:23:54 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 3/6] v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances
Date: Thu, 15 Jun 2017 11:24:06 +0300
Message-Id: <20170615082409.9523-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170615082409.9523-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New Gen3 SoCs come with two new VSP2 variants names VSP2-BS and VSP2-DL,
as well as a new VSP2-D variant on V3M and V3H SoCs. Add new entries for
them in the VSP device info table.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c  | 24 ++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_regs.h | 15 +++++++++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 2f2a7455e9fd..649b2fc63dd3 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -723,6 +723,14 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.num_bru_inputs = 5,
 		.uapi = true,
 	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPBS_GEN3,
+		.model = "VSP2-BS",
+		.gen = 3,
+		.features = VSP1_HAS_BRS,
+		.rpf_count = 2,
+		.wpf_count = 1,
+		.uapi = true,
+	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
 		.model = "VSP2-D",
 		.gen = 3,
@@ -730,6 +738,22 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.rpf_count = 5,
 		.wpf_count = 2,
 		.num_bru_inputs = 5,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPD_V3,
+		.model = "VSP2-D",
+		.gen = 3,
+		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
+		.rpf_count = 5,
+		.wpf_count = 1,
+		.num_bru_inputs = 5,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPDL_GEN3,
+		.model = "VSP2-DL",
+		.gen = 3,
+		.features = VSP1_HAS_BRS | VSP1_HAS_BRU | VSP1_HAS_LIF,
+		.rpf_count = 5,
+		.wpf_count = 2,
+		.num_bru_inputs = 5,
 	},
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 744217e020b9..ab439a60a100 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -699,9 +699,20 @@
 #define VI6_IP_VERSION_MODEL_VSPBD_GEN3	(0x15 << 8)
 #define VI6_IP_VERSION_MODEL_VSPBC_GEN3	(0x16 << 8)
 #define VI6_IP_VERSION_MODEL_VSPD_GEN3	(0x17 << 8)
+#define VI6_IP_VERSION_MODEL_VSPD_V3	(0x18 << 8)
+#define VI6_IP_VERSION_MODEL_VSPDL_GEN3	(0x19 << 8)
+#define VI6_IP_VERSION_MODEL_VSPBS_GEN3	(0x1a << 8)
 #define VI6_IP_VERSION_SOC_MASK		(0xff << 0)
-#define VI6_IP_VERSION_SOC_H		(0x01 << 0)
-#define VI6_IP_VERSION_SOC_M		(0x02 << 0)
+#define VI6_IP_VERSION_SOC_H2		(0x01 << 0)
+#define VI6_IP_VERSION_SOC_V2H		(0x01 << 0)
+#define VI6_IP_VERSION_SOC_V3M		(0x01 << 0)
+#define VI6_IP_VERSION_SOC_M2		(0x02 << 0)
+#define VI6_IP_VERSION_SOC_M3W		(0x02 << 0)
+#define VI6_IP_VERSION_SOC_V3H		(0x02 << 0)
+#define VI6_IP_VERSION_SOC_H3		(0x03 << 0)
+#define VI6_IP_VERSION_SOC_D3		(0x04 << 0)
+#define VI6_IP_VERSION_SOC_M3N		(0x04 << 0)
+#define VI6_IP_VERSION_SOC_E3		(0x04 << 0)
 
 /* -----------------------------------------------------------------------------
  * RPF CLUT Registers
-- 
Regards,

Laurent Pinchart
