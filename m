Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35290 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932942AbeBVQbT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 11:31:19 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v4] v4l: vsp1: Fix video output on R8A77970
Date: Thu, 22 Feb 2018 18:32:00 +0200
Message-Id: <20180222163200.3900-1-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <11341738.DVmQoThvsb@avalon>
References: <11341738.DVmQoThvsb@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

Commit d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL,
and VSP2-D instances") added support for the VSP2-D found in the R-Car
V3M (R8A77970) but the video output that VSP2-D sends to DU has a greenish
garbage-like line repeated every 8 screen rows. It turns out that R-Car
V3M has the LIF0 buffer attribute register that you need to set to a non-
default value in order to get rid of the output artifacts.

Based on the original (and large) patch by Daisuke Matsushita
<daisuke.matsushita.ns@hitachi.com>.

Fixes: d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
[Removed braces, added VI6_IP_VERSION_MASK to improve readabiliy]
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lif.c  | 12 ++++++++++++
 drivers/media/platform/vsp1/vsp1_regs.h |  6 ++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index e6fa16d7fda8..704920753998 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -155,6 +155,18 @@ static void lif_configure(struct vsp1_entity *entity,
 			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
 			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
 			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
+
+	/*
+	 * On R-Car V3M the LIF0 buffer attribute register has to be set to a
+	 * non-default value to guarantee proper operation (otherwise artifacts
+	 * may appear on the output). The value required by the manual is not
+	 * explained but is likely a buffer size or threshold.
+	 */
+	if ((entity->vsp1->version & VI6_IP_VERSION_MASK) ==
+	    (VI6_IP_VERSION_MODEL_VSPD_V3 | VI6_IP_VERSION_SOC_V3M))
+		vsp1_lif_write(lif, dl, VI6_LIF_LBA,
+			       VI6_LIF_LBA_LBA0 |
+			       (1536 << VI6_LIF_LBA_LBA1_SHIFT));
 }
 
 static const struct vsp1_entity_operations lif_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index b1912c83a1da..dae0c1901297 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -693,6 +693,11 @@
 #define VI6_LIF_CSBTH_LBTH_MASK		(0x7ff << 0)
 #define VI6_LIF_CSBTH_LBTH_SHIFT	0
 
+#define VI6_LIF_LBA			0x3b0c
+#define VI6_LIF_LBA_LBA0		(1 << 31)
+#define VI6_LIF_LBA_LBA1_MASK		(0xfff << 16)
+#define VI6_LIF_LBA_LBA1_SHIFT		16
+
 /* -----------------------------------------------------------------------------
  * Security Control Registers
  */
@@ -705,6 +710,7 @@
  */
 
 #define VI6_IP_VERSION			0x3f00
+#define VI6_IP_VERSION_MASK		(0xffff << 0)
 #define VI6_IP_VERSION_MODEL_MASK	(0xff << 8)
 #define VI6_IP_VERSION_MODEL_VSPS_H2	(0x09 << 8)
 #define VI6_IP_VERSION_MODEL_VSPR_H2	(0x0a << 8)
-- 
Regards,

Laurent Pinchart
