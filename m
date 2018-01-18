Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:46946 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932497AbeAROGF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 09:06:05 -0500
Received: by mail-lf0-f66.google.com with SMTP id q194so15337258lfe.13
        for <linux-media@vger.kernel.org>; Thu, 18 Jan 2018 06:06:04 -0800 (PST)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-Id: <20180118140600.363149670@cogentembedded.com>
Date: Thu, 18 Jan 2018 17:05:51 +0300
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v3] vsp1: fix video output on R8A77970
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=vsp1-fix-video-output-on-R8A77970-v3.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL,
and VSP2-D instances") added support for the VSP2-D found in the R-Car
V3M (R8A77970) but the video output that VSP2-D sends to DU has a greenish
garbage-like line repeated every 8 screen rows. It turns out that R-Car
V3M has the LIF0 buffer attribute register that you need to set to a non-
default value in order to get rid of the output artifacts...

Based on the original (and large) patch by Daisuke Matsushita
<daisuke.matsushita.ns@hitachi.com>.

Fixes: d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo's 'fixes' branch.

Changes in version 3:
- reworded the comment in lif_configure();
- reworded the patch description.

Changes in version 2:
- added a  comment before the V3M SoC check;
- fixed indetation in that check;
- reformatted  the patch description.

 drivers/media/platform/vsp1/vsp1_lif.c  |   15 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_regs.h |    5 +++++
 2 files changed, 20 insertions(+)

Index: media_tree/drivers/media/platform/vsp1/vsp1_lif.c
===================================================================
--- media_tree.orig/drivers/media/platform/vsp1/vsp1_lif.c
+++ media_tree/drivers/media/platform/vsp1/vsp1_lif.c
@@ -155,6 +155,21 @@ static void lif_configure(struct vsp1_en
 			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
 			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
 			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
+
+	/*
+	 * On R-Car V3M the LIF0 buffer attribute register has to be set
+	 * to a non-default value to guarantee proper operation (otherwise
+	 * artifacts may appear on the output). The value required by
+	 * the manual is not explained but is likely a buffer size or
+	 * threshold...
+	 */
+	if ((entity->vsp1->version &
+	     (VI6_IP_VERSION_MODEL_MASK | VI6_IP_VERSION_SOC_MASK)) ==
+	    (VI6_IP_VERSION_MODEL_VSPD_V3 | VI6_IP_VERSION_SOC_V3M)) {
+		vsp1_lif_write(lif, dl, VI6_LIF_LBA,
+			       VI6_LIF_LBA_LBA0 |
+			       (1536 << VI6_LIF_LBA_LBA1_SHIFT));
+	}
 }
 
 static const struct vsp1_entity_operations lif_entity_ops = {
Index: media_tree/drivers/media/platform/vsp1/vsp1_regs.h
===================================================================
--- media_tree.orig/drivers/media/platform/vsp1/vsp1_regs.h
+++ media_tree/drivers/media/platform/vsp1/vsp1_regs.h
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
