Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50494 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756929AbdLQARW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 19:17:22 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH/RFC 3/4] v4l: vsp1: Add support for colorkey alpha blending
Date: Sun, 17 Dec 2017 02:17:23 +0200
Message-Id: <20171217001724.1348-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20171217001724.1348-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>

The VSP2 found in R-Car Gen3 SoCs supports changing the alpha value of
source pixels that match a color key. Add support for this feature for
display pipelines through the API exposed to the DU driver.

The colorkey key value is expressed as a XYZ 888 value, where the X, Y
and Z components are either RGB or YCbCr depending on the plane format.
When the plane is configured with an RGB formats all three components
are matched by the hardware, while with an YCbCr format only the
luminance component is matched the chroma components will be ignored.

Signed-off-by: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>
[Group all color key parameters in a structure]
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c  |  3 +++
 drivers/media/platform/vsp1/vsp1_rpf.c  | 10 ++++++++--
 drivers/media/platform/vsp1/vsp1_rwpf.h |  5 +++++
 include/media/vsp1.h                    |  5 +++++
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 7ce69f23f50a..68af99e5cfa3 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -378,6 +378,9 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
 	rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
 	rpf->alpha = cfg->alpha;
+	rpf->colorkey.enabled = cfg->colorkey.enabled;
+	rpf->colorkey.key = cfg->colorkey.key;
+	rpf->colorkey.alpha = cfg->colorkey.alpha;
 
 	rpf->mem.addr[0] = cfg->mem[0];
 	rpf->mem.addr[1] = cfg->mem[1];
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index fe0633da5a5f..8c532f22013b 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -243,8 +243,14 @@ static void rpf_configure(struct vsp1_entity *entity,
 	}
 
 	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
-
+	if (rpf->colorkey.enabled) {
+		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_SET0,
+			       (rpf->colorkey.alpha << 24) | rpf->colorkey.key);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL,
+			       VI6_RPF_CKEY_CTRL_SAPE0);
+	} else {
+		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
+	}
 }
 
 static void rpf_partition(struct vsp1_entity *entity,
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 58215a7ab631..78119bb681f9 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -50,6 +50,11 @@ struct vsp1_rwpf {
 	unsigned int bru_input;
 
 	unsigned int alpha;
+	struct {
+		bool enabled;
+		u32 key;
+		u32 alpha;
+	} colorkey;
 
 	u32 mult_alpha;
 	u32 outfmt;
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 68a8abe4fac5..cc6a411e2312 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -49,6 +49,11 @@ struct vsp1_du_atomic_config {
 	struct v4l2_rect dst;
 	unsigned int alpha;
 	unsigned int zpos;
+	struct {
+		bool enabled;
+		u32 key;
+		u32 alpha;
+	} colorkey;
 };
 
 void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
-- 
Regards,

Laurent Pinchart
