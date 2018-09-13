Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46842 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727383AbeIMR7K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 13:59:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] cec/v4l2: move V4L2 specific CEC functions to V4L2
Date: Thu, 13 Sep 2018 14:49:43 +0200
Message-Id: <20180913124944.39863-4-hverkuil@xs4all.nl>
In-Reply-To: <20180913124944.39863-1-hverkuil@xs4all.nl>
References: <20180913124944.39863-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Several CEC functions are actually specific for use with receivers,
i.e. they should be part of the V4L2 subsystem, not CEC.

These functions deal with validating and modifying EDIDs for (HDMI)
receivers, and they do not actually have anything to do with the CEC
subsystem and whether or not CEC is enabled. The problem was that if
the CEC_CORE config option was not set, then these functions would
become stubs, but that's not right: they should always be valid.

So replace the cec_ prefix by v4l2_ and move them to v4l2-dv-timings.c.
Update all drivers that call these accordingly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/cec/cec-edid.c                  |  71 --------
 drivers/media/i2c/adv7604.c                   |   4 +-
 drivers/media/i2c/adv7842.c                   |   4 +-
 drivers/media/i2c/tc358743.c                  |   2 +-
 drivers/media/platform/vivid/vivid-vid-cap.c  |   4 +-
 .../media/platform/vivid/vivid-vid-common.c   |   2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c     | 151 ++++++++++++++++++
 include/media/cec.h                           |  80 ----------
 include/media/v4l2-dv-timings.h               |   6 +
 9 files changed, 165 insertions(+), 159 deletions(-)

diff --git a/drivers/media/cec/cec-edid.c b/drivers/media/cec/cec-edid.c
index f587e8eaefd8..e2f54eec0829 100644
--- a/drivers/media/cec/cec-edid.c
+++ b/drivers/media/cec/cec-edid.c
@@ -22,74 +22,3 @@ u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 	return (edid[loc] << 8) | edid[loc + 1];
 }
 EXPORT_SYMBOL_GPL(cec_get_edid_phys_addr);
-
-void cec_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr)
-{
-	unsigned int loc = cec_get_edid_spa_location(edid, size);
-	u8 sum = 0;
-	unsigned int i;
-
-	if (loc == 0)
-		return;
-	edid[loc] = phys_addr >> 8;
-	edid[loc + 1] = phys_addr & 0xff;
-	loc &= ~0x7f;
-
-	/* update the checksum */
-	for (i = loc; i < loc + 127; i++)
-		sum += edid[i];
-	edid[i] = 256 - sum;
-}
-EXPORT_SYMBOL_GPL(cec_set_edid_phys_addr);
-
-u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
-{
-	/* Check if input is sane */
-	if (WARN_ON(input == 0 || input > 0xf))
-		return CEC_PHYS_ADDR_INVALID;
-
-	if (phys_addr == 0)
-		return input << 12;
-
-	if ((phys_addr & 0x0fff) == 0)
-		return phys_addr | (input << 8);
-
-	if ((phys_addr & 0x00ff) == 0)
-		return phys_addr | (input << 4);
-
-	if ((phys_addr & 0x000f) == 0)
-		return phys_addr | input;
-
-	/*
-	 * All nibbles are used so no valid physical addresses can be assigned
-	 * to the input.
-	 */
-	return CEC_PHYS_ADDR_INVALID;
-}
-EXPORT_SYMBOL_GPL(cec_phys_addr_for_input);
-
-int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
-{
-	int i;
-
-	if (parent)
-		*parent = phys_addr;
-	if (port)
-		*port = 0;
-	if (phys_addr == CEC_PHYS_ADDR_INVALID)
-		return 0;
-	for (i = 0; i < 16; i += 4)
-		if (phys_addr & (0xf << i))
-			break;
-	if (i == 16)
-		return 0;
-	if (parent)
-		*parent = phys_addr & (0xfff0 << i);
-	if (port)
-		*port = (phys_addr >> i) & 0xf;
-	for (i += 4; i < 16; i += 4)
-		if ((phys_addr & (0xf << i)) == 0)
-			return -EINVAL;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(cec_phys_addr_validate);
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 668be2bca57a..c31673fcd5c1 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2295,8 +2295,8 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		edid->blocks = 2;
 		return -E2BIG;
 	}
-	pa = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, &spa_loc);
-	err = cec_phys_addr_validate(pa, &pa, NULL);
+	pa = v4l2_get_edid_phys_addr(edid->edid, edid->blocks * 128, &spa_loc);
+	err = v4l2_phys_addr_validate(pa, &pa, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index f1c168bfaaa4..cd63cc6564e9 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -789,8 +789,8 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	if (!state->hdmi_edid.present)
 		return 0;
 
-	pa = cec_get_edid_phys_addr(edid, 256, &spa_loc);
-	err = cec_phys_addr_validate(pa, &pa, NULL);
+	pa = v4l2_get_edid_phys_addr(edid, 256, &spa_loc);
+	err = v4l2_phys_addr_validate(pa, &pa, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 44c41933415a..ef4dbac6bb58 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1789,7 +1789,7 @@ static int tc358743_s_edid(struct v4l2_subdev *sd,
 		return -E2BIG;
 	}
 	pa = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, NULL);
-	err = cec_phys_addr_validate(pa, &pa, NULL);
+	err = v4l2_phys_addr_validate(pa, &pa, NULL);
 	if (err)
 		return err;
 
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index f2c37e959bea..58e14dd1dcd3 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1722,7 +1722,7 @@ int vidioc_s_edid(struct file *file, void *_fh,
 		return -E2BIG;
 	}
 	phys_addr = cec_get_edid_phys_addr(edid->edid, edid->blocks * 128, NULL);
-	ret = cec_phys_addr_validate(phys_addr, &phys_addr, NULL);
+	ret = v4l2_phys_addr_validate(phys_addr, &phys_addr, NULL);
 	if (ret)
 		return ret;
 
@@ -1738,7 +1738,7 @@ int vidioc_s_edid(struct file *file, void *_fh,
 
 	for (i = 0; i < MAX_OUTPUTS && dev->cec_tx_adap[i]; i++)
 		cec_s_phys_addr(dev->cec_tx_adap[i],
-				cec_phys_addr_for_input(phys_addr, i + 1),
+				v4l2_phys_addr_for_input(phys_addr, i + 1),
 				false);
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index be531caa2cdf..27a0000a5973 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -863,7 +863,7 @@ int vidioc_g_edid(struct file *file, void *_fh,
 	if (edid->blocks > dev->edid_blocks - edid->start_block)
 		edid->blocks = dev->edid_blocks - edid->start_block;
 	if (adap)
-		cec_set_edid_phys_addr(dev->edid, dev->edid_blocks * 128, adap->phys_addr);
+		v4l2_set_edid_phys_addr(dev->edid, dev->edid_blocks * 128, adap->phys_addr);
 	memcpy(edid->edid, dev->edid + edid->start_block * 128, edid->blocks * 128);
 	return 0;
 }
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 8f52353b0881..b4e50c5509b7 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -15,6 +15,7 @@
 #include <media/v4l2-dv-timings.h>
 #include <linux/math64.h>
 #include <linux/hdmi.h>
+#include <media/cec.h>
 
 MODULE_AUTHOR("Hans Verkuil");
 MODULE_DESCRIPTION("V4L2 DV Timings Helper Functions");
@@ -981,3 +982,153 @@ v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
 	return c;
 }
 EXPORT_SYMBOL_GPL(v4l2_hdmi_rx_colorimetry);
+
+/**
+ * v4l2_get_edid_phys_addr() - find and return the physical address
+ *
+ * @edid:	pointer to the EDID data
+ * @size:	size in bytes of the EDID data
+ * @offset:	If not %NULL then the location of the physical address
+ *		bytes in the EDID will be returned here. This is set to 0
+ *		if there is no physical address found.
+ *
+ * Return: the physical address or CEC_PHYS_ADDR_INVALID if there is none.
+ */
+u16 v4l2_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			    unsigned int *offset)
+{
+	unsigned int loc = cec_get_edid_spa_location(edid, size);
+
+	if (offset)
+		*offset = loc;
+	if (loc == 0)
+		return CEC_PHYS_ADDR_INVALID;
+	return (edid[loc] << 8) | edid[loc + 1];
+}
+EXPORT_SYMBOL_GPL(v4l2_get_edid_phys_addr);
+
+/**
+ * v4l2_set_edid_phys_addr() - find and set the physical address
+ *
+ * @edid:	pointer to the EDID data
+ * @size:	size in bytes of the EDID data
+ * @phys_addr:	the new physical address
+ *
+ * This function finds the location of the physical address in the EDID
+ * and fills in the given physical address and updates the checksum
+ * at the end of the EDID block. It does nothing if the EDID doesn't
+ * contain a physical address.
+ */
+void v4l2_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr)
+{
+	unsigned int loc = cec_get_edid_spa_location(edid, size);
+	u8 sum = 0;
+	unsigned int i;
+
+	if (loc == 0)
+		return;
+	edid[loc] = phys_addr >> 8;
+	edid[loc + 1] = phys_addr & 0xff;
+	loc &= ~0x7f;
+
+	/* update the checksum */
+	for (i = loc; i < loc + 127; i++)
+		sum += edid[i];
+	edid[i] = 256 - sum;
+}
+EXPORT_SYMBOL_GPL(v4l2_set_edid_phys_addr);
+
+/**
+ * v4l2_phys_addr_for_input() - calculate the PA for an input
+ *
+ * @phys_addr:	the physical address of the parent
+ * @input:	the number of the input port, must be between 1 and 15
+ *
+ * This function calculates a new physical address based on the input
+ * port number. For example:
+ *
+ * PA = 0.0.0.0 and input = 2 becomes 2.0.0.0
+ *
+ * PA = 3.0.0.0 and input = 1 becomes 3.1.0.0
+ *
+ * PA = 3.2.1.0 and input = 5 becomes 3.2.1.5
+ *
+ * PA = 3.2.1.3 and input = 5 becomes f.f.f.f since it maxed out the depth.
+ *
+ * Return: the new physical address or CEC_PHYS_ADDR_INVALID.
+ */
+u16 v4l2_phys_addr_for_input(u16 phys_addr, u8 input)
+{
+	/* Check if input is sane */
+	if (WARN_ON(input == 0 || input > 0xf))
+		return CEC_PHYS_ADDR_INVALID;
+
+	if (phys_addr == 0)
+		return input << 12;
+
+	if ((phys_addr & 0x0fff) == 0)
+		return phys_addr | (input << 8);
+
+	if ((phys_addr & 0x00ff) == 0)
+		return phys_addr | (input << 4);
+
+	if ((phys_addr & 0x000f) == 0)
+		return phys_addr | input;
+
+	/*
+	 * All nibbles are used so no valid physical addresses can be assigned
+	 * to the input.
+	 */
+	return CEC_PHYS_ADDR_INVALID;
+}
+EXPORT_SYMBOL_GPL(v4l2_phys_addr_for_input);
+
+/**
+ * v4l2_phys_addr_validate() - validate a physical address from an EDID
+ *
+ * @phys_addr:	the physical address to validate
+ * @parent:	if not %NULL, then this is filled with the parents PA.
+ * @port:	if not %NULL, then this is filled with the input port.
+ *
+ * This validates a physical address as read from an EDID. If the
+ * PA is invalid (such as 1.0.1.0 since '0' is only allowed at the end),
+ * then it will return -EINVAL.
+ *
+ * The parent PA is passed into %parent and the input port is passed into
+ * %port. For example:
+ *
+ * PA = 0.0.0.0: has parent 0.0.0.0 and input port 0.
+ *
+ * PA = 1.0.0.0: has parent 0.0.0.0 and input port 1.
+ *
+ * PA = 3.2.0.0: has parent 3.0.0.0 and input port 2.
+ *
+ * PA = f.f.f.f: has parent f.f.f.f and input port 0.
+ *
+ * Return: 0 if the PA is valid, -EINVAL if not.
+ */
+int v4l2_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
+{
+	int i;
+
+	if (parent)
+		*parent = phys_addr;
+	if (port)
+		*port = 0;
+	if (phys_addr == CEC_PHYS_ADDR_INVALID)
+		return 0;
+	for (i = 0; i < 16; i += 4)
+		if (phys_addr & (0xf << i))
+			break;
+	if (i == 16)
+		return 0;
+	if (parent)
+		*parent = phys_addr & (0xfff0 << i);
+	if (port)
+		*port = (phys_addr >> i) & 0xf;
+	for (i += 4; i < 16; i += 4)
+		if ((phys_addr & (0xf << i)) == 0)
+			return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_phys_addr_validate);
diff --git a/include/media/cec.h b/include/media/cec.h
index 603f2fa08f62..9f382f0c2970 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -332,67 +332,6 @@ void cec_queue_pin_5v_event(struct cec_adapter *adap, bool is_high, ktime_t ts);
 u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 			   unsigned int *offset);
 
-/**
- * cec_set_edid_phys_addr() - find and set the physical address
- *
- * @edid:	pointer to the EDID data
- * @size:	size in bytes of the EDID data
- * @phys_addr:	the new physical address
- *
- * This function finds the location of the physical address in the EDID
- * and fills in the given physical address and updates the checksum
- * at the end of the EDID block. It does nothing if the EDID doesn't
- * contain a physical address.
- */
-void cec_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr);
-
-/**
- * cec_phys_addr_for_input() - calculate the PA for an input
- *
- * @phys_addr:	the physical address of the parent
- * @input:	the number of the input port, must be between 1 and 15
- *
- * This function calculates a new physical address based on the input
- * port number. For example:
- *
- * PA = 0.0.0.0 and input = 2 becomes 2.0.0.0
- *
- * PA = 3.0.0.0 and input = 1 becomes 3.1.0.0
- *
- * PA = 3.2.1.0 and input = 5 becomes 3.2.1.5
- *
- * PA = 3.2.1.3 and input = 5 becomes f.f.f.f since it maxed out the depth.
- *
- * Return: the new physical address or CEC_PHYS_ADDR_INVALID.
- */
-u16 cec_phys_addr_for_input(u16 phys_addr, u8 input);
-
-/**
- * cec_phys_addr_validate() - validate a physical address from an EDID
- *
- * @phys_addr:	the physical address to validate
- * @parent:	if not %NULL, then this is filled with the parents PA.
- * @port:	if not %NULL, then this is filled with the input port.
- *
- * This validates a physical address as read from an EDID. If the
- * PA is invalid (such as 1.0.1.0 since '0' is only allowed at the end),
- * then it will return -EINVAL.
- *
- * The parent PA is passed into %parent and the input port is passed into
- * %port. For example:
- *
- * PA = 0.0.0.0: has parent 0.0.0.0 and input port 0.
- *
- * PA = 1.0.0.0: has parent 0.0.0.0 and input port 1.
- *
- * PA = 3.2.0.0: has parent 3.0.0.0 and input port 2.
- *
- * PA = f.f.f.f: has parent f.f.f.f and input port 0.
- *
- * Return: 0 if the PA is valid, -EINVAL if not.
- */
-int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
-
 #else
 
 static inline int cec_register_adapter(struct cec_adapter *adap,
@@ -427,25 +366,6 @@ static inline u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 	return CEC_PHYS_ADDR_INVALID;
 }
 
-static inline void cec_set_edid_phys_addr(u8 *edid, unsigned int size,
-					  u16 phys_addr)
-{
-}
-
-static inline u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
-{
-	return CEC_PHYS_ADDR_INVALID;
-}
-
-static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
-{
-	if (parent)
-		*parent = phys_addr;
-	if (port)
-		*port = 0;
-	return 0;
-}
-
 #endif
 
 /**
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index fb355d9577a4..2cc0cabc124f 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -245,4 +245,10 @@ v4l2_hdmi_rx_colorimetry(const struct hdmi_avi_infoframe *avi,
 			 const struct hdmi_vendor_infoframe *hdmi,
 			 unsigned int height);
 
+u16 v4l2_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			    unsigned int *offset);
+void v4l2_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr);
+u16 v4l2_phys_addr_for_input(u16 phys_addr, u8 input);
+int v4l2_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
+
 #endif
-- 
2.18.0
