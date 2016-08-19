Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34375 "EHLO
        mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755633AbcHSV6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 17:58:43 -0400
Received: by mail-lf0-f41.google.com with SMTP id l89so41775689lfi.1
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2016 14:58:03 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] vsp1: add R8A7792 VSP1V support
Date: Sat, 20 Aug 2016 00:57:59 +0300
Message-ID: <10305550.upKOiT5SIy@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add  support for the R8A7792 VSP1V cores which are different from the other
gen2 VSP1 cores...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo's 'master' branch.

 drivers/media/platform/vsp1/vsp1_drv.c  |   20 ++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_regs.h |    2 ++
 2 files changed, 22 insertions(+)

Index: media_tree/drivers/media/platform/vsp1/vsp1_drv.c
===================================================================
--- media_tree.orig/drivers/media/platform/vsp1/vsp1_drv.c
+++ media_tree/drivers/media/platform/vsp1/vsp1_drv.c
@@ -596,6 +596,26 @@ static const struct vsp1_device_info vsp
 		.num_bru_inputs = 4,
 		.uapi = true,
 	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPS_V2H,
+		.gen = 2,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT |
+			    VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
+		.rpf_count = 4,
+		.uds_count = 1,
+		.wpf_count = 4,
+		.num_bru_inputs = 4,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPD_V2H,
+		.gen = 2,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT |
+			    VSP1_HAS_LIF,
+		.rpf_count = 4,
+		.uds_count = 1,
+		.wpf_count = 1,
+		.num_bru_inputs = 4,
+		.uapi = true,
+	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
 		.gen = 3,
 		.features = VSP1_HAS_CLU | VSP1_HAS_LUT | VSP1_HAS_SRU
Index: media_tree/drivers/media/platform/vsp1/vsp1_regs.h
===================================================================
--- media_tree.orig/drivers/media/platform/vsp1/vsp1_regs.h
+++ media_tree/drivers/media/platform/vsp1/vsp1_regs.h
@@ -660,6 +660,8 @@
 #define VI6_IP_VERSION_MODEL_VSPR_H2	(0x0a << 8)
 #define VI6_IP_VERSION_MODEL_VSPD_GEN2	(0x0b << 8)
 #define VI6_IP_VERSION_MODEL_VSPS_M2	(0x0c << 8)
+#define VI6_IP_VERSION_MODEL_VSPS_V2H	(0x12 << 8)
+#define VI6_IP_VERSION_MODEL_VSPD_V2H	(0x13 << 8)
 #define VI6_IP_VERSION_MODEL_VSPI_GEN3	(0x14 << 8)
 #define VI6_IP_VERSION_MODEL_VSPBD_GEN3	(0x15 << 8)
 #define VI6_IP_VERSION_MODEL_VSPBC_GEN3	(0x16 << 8)

