Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:55284 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdEHAYi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 20:24:38 -0400
From: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>
To: <Alexandru_Gheorghe@mentor.com>,
        <laurent.pinchart@ideasonboard.com>,
        <linux-renesas-soc@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
        <geert@linux-m68k.org>, <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH v2 1/2] v4l: vsp1: Add support for colorkey alpha blending
Date: Sun, 7 May 2017 13:13:26 +0300
Message-ID: <1494152007-30094-2-git-send-email-Alexandru_Gheorghe@mentor.com>
In-Reply-To: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com>
References: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp2 hw supports changing of the alpha of pixels that match a color
key, this patch adds support for this feature in order to be used by
the rcar-du driver.
The colorkey is interpreted different depending of the pixel format:
	* RGB   - all color components have to match.
	* YCbCr - only the Y component has to match.

Signed-off-by: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c  |  3 +++
 drivers/media/platform/vsp1/vsp1_rpf.c  | 10 ++++++++--
 drivers/media/platform/vsp1/vsp1_rwpf.h |  3 +++
 include/media/vsp1.h                    |  3 +++
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 3627f08..a4d0aee 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -393,6 +393,9 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	else
 		rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
 	rpf->alpha = cfg->alpha;
+	rpf->colorkey = cfg->colorkey;
+	rpf->colorkey_en = cfg->colorkey_en;
+	rpf->colorkey_alpha = cfg->colorkey_alpha;
 	rpf->interlaced = cfg->interlaced;
 
 	if (soc_device_match(r8a7795es1) && rpf->interlaced) {
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index a12d6f9..91f2a9f 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -356,8 +356,14 @@ static void rpf_configure(struct vsp1_entity *entity,
 	}
 
 	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
-
+	if (rpf->colorkey_en) {
+		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_SET0,
+			       (rpf->colorkey_alpha << 24) | rpf->colorkey);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL,
+			       VI6_RPF_CKEY_CTRL_SAPE0);
+	} else {
+		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
+	}
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index fbe6aa6..2d7f4b9 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -51,6 +51,9 @@ struct vsp1_rwpf {
 	unsigned int brs_input;
 
 	unsigned int alpha;
+	u32 colorkey;
+	bool colorkey_en;
+	u32 colorkey_alpha;
 
 	u32 mult_alpha;
 	u32 outfmt;
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 97265f7..65e3934 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -32,6 +32,9 @@ struct vsp1_du_atomic_config {
 	struct v4l2_rect dst;
 	unsigned int alpha;
 	unsigned int zpos;
+	u32 colorkey;
+	u32 colorkey_alpha;
+	bool colorkey_en;
 	bool interlaced;
 };
 
-- 
1.9.1
