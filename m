Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:42102 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdLZVOb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 16:14:31 -0500
Received: by mail-lf0-f67.google.com with SMTP id e27so5766154lfb.9
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 13:14:30 -0800 (PST)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-Id: <20171226211424.870595086@cogentembedded.com>
Date: Wed, 27 Dec 2017 00:14:12 +0300
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v2] vsp1: fix video output on R8A77970
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=vsp1-fix-video-output-on-R8A77970-v2.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent has added support for the VSP2-D found on R-Car V3M (R8A77970) but
the video  output that VSP2-D sends to DU has a greenish garbage-like line
repeated every 8 or so screen rows. It turns out that V3M has a teeny LIF
register (at least it's documented!) that you need to set to some kind of
a  magic value for the LIF to work correctly...

Based on the original (and large) patch by Daisuke Matsushita
<daisuke.matsushita.ns@hitachi.com>.

Fixes: d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and VSP2-D instances")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
This patch is against the 'media_tree.git' repo's 'master' branch.

Changes in version 2:
- added a  comment before the V3M SoC check;
- fixed indetation in that check;
- reformatted  the patch description.

 drivers/media/platform/vsp1/vsp1_lif.c  |   12 ++++++++++++
 drivers/media/platform/vsp1/vsp1_regs.h |    5 +++++
 2 files changed, 17 insertions(+)

Index: media_tree/drivers/media/platform/vsp1/vsp1_lif.c
===================================================================
--- media_tree.orig/drivers/media/platform/vsp1/vsp1_lif.c
+++ media_tree/drivers/media/platform/vsp1/vsp1_lif.c
@@ -155,6 +155,18 @@ static void lif_configure(struct vsp1_en
 			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
 			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
 			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
+
+	/*
+	 * R-Car V3M has the buffer attribute register you absolutely need
+	 * to write kinda magic value to  for the LIF to work correctly...
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
