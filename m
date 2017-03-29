Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:37344 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752071AbdC2OPt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 10:15:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 01/11] cec-edid: rename cec_get_edid_phys_addr
Date: Wed, 29 Mar 2017 16:15:33 +0200
Message-Id: <20170329141543.32935-2-hverkuil@xs4all.nl>
In-Reply-To: <20170329141543.32935-1-hverkuil@xs4all.nl>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Rename cec_get_edid_phys_addr to cec_get_raw_edid_phys_addr.

Add a new cec_get_edid_phys_addr function that takes a struct edid pointer.

This reflects the fact that some drivers have a struct edid pointer and
others a u8 pointer to the raw edid data.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec-edid.c                     | 15 +++++++++++++--
 drivers/media/i2c/adv7511.c                  |  5 ++---
 drivers/media/i2c/adv7604.c                  |  3 ++-
 drivers/media/i2c/adv7842.c                  |  2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c |  3 ++-
 include/media/cec-edid.h                     | 17 ++++++++++++++---
 6 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/media/cec-edid.c b/drivers/media/cec-edid.c
index 5719b991e340..d7b369f53831 100644
--- a/drivers/media/cec-edid.c
+++ b/drivers/media/cec-edid.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <media/cec-edid.h>
+#include <drm/drm_edid.h>
 
 /*
  * This EDID is expected to be a CEA-861 compliant, which means that there are
@@ -82,8 +83,8 @@ static unsigned int cec_get_edid_spa_location(const u8 *edid, unsigned int size)
 	return 0;
 }
 
-u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
-			   unsigned int *offset)
+u16 cec_get_raw_edid_phys_addr(const u8 *edid, unsigned int size,
+			       unsigned int *offset)
 {
 	unsigned int loc = cec_get_edid_spa_location(edid, size);
 
@@ -93,6 +94,16 @@ u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 		return CEC_PHYS_ADDR_INVALID;
 	return (edid[loc] << 8) | edid[loc + 1];
 }
+EXPORT_SYMBOL_GPL(cec_get_raw_edid_phys_addr);
+
+u16 cec_get_edid_phys_addr(const struct edid *edid)
+{
+	if (!edid || edid->extensions == 0)
+		return CEC_PHYS_ADDR_INVALID;
+
+	return cec_get_raw_edid_phys_addr((u8 *)edid,
+				EDID_LENGTH * (edid->extensions + 1), NULL);
+}
 EXPORT_SYMBOL_GPL(cec_get_edid_phys_addr);
 
 void cec_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr)
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 8c9e28949ab1..4723e826804a 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1712,9 +1712,8 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 
 		v4l2_dbg(1, debug, sd, "%s: edid complete with %d segment(s)\n", __func__, state->edid.segments);
 		state->edid.complete = true;
-		ed.phys_addr = cec_get_edid_phys_addr(state->edid.data,
-						      state->edid.segments * 256,
-						      NULL);
+		ed.phys_addr = cec_get_raw_edid_phys_addr(state->edid.data,
+				  state->edid.segments * 256, NULL);
 		/* report when we have all segments
 		   but report only for segment 0
 		 */
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d8bf435db86d..ac60c9116f9c 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2305,7 +2305,8 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		edid->blocks = 2;
 		return -E2BIG;
 	}
-	pa = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, &spa_loc);
+	pa = cec_get_raw_edid_phys_addr(edid->edid,
+					edid->blocks * 128, &spa_loc);
 	err = cec_phys_addr_validate(pa, &pa, NULL);
 	if (err)
 		return err;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 2d61f0cc2b5b..440870d1d988 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -802,7 +802,7 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	if (!state->hdmi_edid.present)
 		return 0;
 
-	pa = cec_get_edid_phys_addr(edid, 256, &spa_loc);
+	pa = cec_get_raw_edid_phys_addr(edid, 256, &spa_loc);
 	err = cec_phys_addr_validate(pa, &pa, NULL);
 	if (err)
 		return err;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 01419455e545..6a7310e212cf 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1736,7 +1736,8 @@ int vidioc_s_edid(struct file *file, void *_fh,
 		edid->blocks = dev->edid_max_blocks;
 		return -E2BIG;
 	}
-	phys_addr = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, NULL);
+	phys_addr = cec_get_raw_edid_phys_addr(edid->edid,
+					       edid->blocks * 128, NULL);
 	ret = cec_phys_addr_validate(phys_addr, &phys_addr, NULL);
 	if (ret)
 		return ret;
diff --git a/include/media/cec-edid.h b/include/media/cec-edid.h
index bdf731ecba1a..46a1d383608e 100644
--- a/include/media/cec-edid.h
+++ b/include/media/cec-edid.h
@@ -27,7 +27,7 @@
 	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
 
 /**
- * cec_get_edid_phys_addr() - find and return the physical address
+ * cec_get_raw_edid_phys_addr() - find and return the physical address
  *
  * @edid:	pointer to the EDID data
  * @size:	size in bytes of the EDID data
@@ -37,8 +37,19 @@
  *
  * Return: the physical address or CEC_PHYS_ADDR_INVALID if there is none.
  */
-u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
-			   unsigned int *offset);
+u16 cec_get_raw_edid_phys_addr(const u8 *edid, unsigned int size,
+			       unsigned int *offset);
+
+struct edid;
+
+/**
+ * cec_get_edid_phys_addr() - find and return the physical address
+ *
+ * @edid:	pointer to struct edid
+ *
+ * Return: the physical address or CEC_PHYS_ADDR_INVALID if there is none.
+ */
+u16 cec_get_edid_phys_addr(const struct edid *edid);
 
 /**
  * cec_set_edid_phys_addr() - find and set the physical address
-- 
2.11.0
