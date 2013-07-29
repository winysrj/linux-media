Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3265 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab3G2Mlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 08:41:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/8] v4l2-dv-timings: add new helper module.
Date: Mon, 29 Jul 2013 14:40:55 +0200
Message-Id: <1375101661-6493-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This module makes it easy to filter valid timings from the full list of
CEA and DMT timings based on the timings capabilities.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/Makefile          |   1 +
 drivers/media/v4l2-core/v4l2-dv-timings.c | 192 ++++++++++++++++++++++++++++++
 include/media/v4l2-dv-timings.h           |  67 +++++++++++
 3 files changed, 260 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-dv-timings.c
 create mode 100644 include/media/v4l2-dv-timings.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 4c33b8d6..1a85eee 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -17,6 +17,7 @@ endif
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
+obj-$(CONFIG_VIDEO_V4L2) += v4l2-dv-timings.o
 
 obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
new file mode 100644
index 0000000..5827946
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -0,0 +1,192 @@
+/*
+ * v4l2-dv-timings - dv-timings helper functions
+ *
+ * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/videodev2.h>
+#include <linux/v4l2-dv-timings.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-dv-timings.h>
+
+static const struct v4l2_dv_timings timings[] = {
+	V4L2_DV_BT_CEA_640X480P59_94,
+	V4L2_DV_BT_CEA_720X480I59_94,
+	V4L2_DV_BT_CEA_720X480P59_94,
+	V4L2_DV_BT_CEA_720X576I50,
+	V4L2_DV_BT_CEA_720X576P50,
+	V4L2_DV_BT_CEA_1280X720P24,
+	V4L2_DV_BT_CEA_1280X720P25,
+	V4L2_DV_BT_CEA_1280X720P30,
+	V4L2_DV_BT_CEA_1280X720P50,
+	V4L2_DV_BT_CEA_1280X720P60,
+	V4L2_DV_BT_CEA_1920X1080P24,
+	V4L2_DV_BT_CEA_1920X1080P25,
+	V4L2_DV_BT_CEA_1920X1080P30,
+	V4L2_DV_BT_CEA_1920X1080I50,
+	V4L2_DV_BT_CEA_1920X1080P50,
+	V4L2_DV_BT_CEA_1920X1080I60,
+	V4L2_DV_BT_CEA_1920X1080P60,
+	V4L2_DV_BT_DMT_640X350P85,
+	V4L2_DV_BT_DMT_640X400P85,
+	V4L2_DV_BT_DMT_720X400P85,
+	V4L2_DV_BT_DMT_640X480P72,
+	V4L2_DV_BT_DMT_640X480P75,
+	V4L2_DV_BT_DMT_640X480P85,
+	V4L2_DV_BT_DMT_800X600P56,
+	V4L2_DV_BT_DMT_800X600P60,
+	V4L2_DV_BT_DMT_800X600P72,
+	V4L2_DV_BT_DMT_800X600P75,
+	V4L2_DV_BT_DMT_800X600P85,
+	V4L2_DV_BT_DMT_800X600P120_RB,
+	V4L2_DV_BT_DMT_848X480P60,
+	V4L2_DV_BT_DMT_1024X768I43,
+	V4L2_DV_BT_DMT_1024X768P60,
+	V4L2_DV_BT_DMT_1024X768P70,
+	V4L2_DV_BT_DMT_1024X768P75,
+	V4L2_DV_BT_DMT_1024X768P85,
+	V4L2_DV_BT_DMT_1024X768P120_RB,
+	V4L2_DV_BT_DMT_1152X864P75,
+	V4L2_DV_BT_DMT_1280X768P60_RB,
+	V4L2_DV_BT_DMT_1280X768P60,
+	V4L2_DV_BT_DMT_1280X768P75,
+	V4L2_DV_BT_DMT_1280X768P85,
+	V4L2_DV_BT_DMT_1280X768P120_RB,
+	V4L2_DV_BT_DMT_1280X800P60_RB,
+	V4L2_DV_BT_DMT_1280X800P60,
+	V4L2_DV_BT_DMT_1280X800P75,
+	V4L2_DV_BT_DMT_1280X800P85,
+	V4L2_DV_BT_DMT_1280X800P120_RB,
+	V4L2_DV_BT_DMT_1280X960P60,
+	V4L2_DV_BT_DMT_1280X960P85,
+	V4L2_DV_BT_DMT_1280X960P120_RB,
+	V4L2_DV_BT_DMT_1280X1024P60,
+	V4L2_DV_BT_DMT_1280X1024P75,
+	V4L2_DV_BT_DMT_1280X1024P85,
+	V4L2_DV_BT_DMT_1280X1024P120_RB,
+	V4L2_DV_BT_DMT_1360X768P60,
+	V4L2_DV_BT_DMT_1360X768P120_RB,
+	V4L2_DV_BT_DMT_1366X768P60,
+	V4L2_DV_BT_DMT_1366X768P60_RB,
+	V4L2_DV_BT_DMT_1400X1050P60_RB,
+	V4L2_DV_BT_DMT_1400X1050P60,
+	V4L2_DV_BT_DMT_1400X1050P75,
+	V4L2_DV_BT_DMT_1400X1050P85,
+	V4L2_DV_BT_DMT_1400X1050P120_RB,
+	V4L2_DV_BT_DMT_1440X900P60_RB,
+	V4L2_DV_BT_DMT_1440X900P60,
+	V4L2_DV_BT_DMT_1440X900P75,
+	V4L2_DV_BT_DMT_1440X900P85,
+	V4L2_DV_BT_DMT_1440X900P120_RB,
+	V4L2_DV_BT_DMT_1600X900P60_RB,
+	V4L2_DV_BT_DMT_1600X1200P60,
+	V4L2_DV_BT_DMT_1600X1200P65,
+	V4L2_DV_BT_DMT_1600X1200P70,
+	V4L2_DV_BT_DMT_1600X1200P75,
+	V4L2_DV_BT_DMT_1600X1200P85,
+	V4L2_DV_BT_DMT_1600X1200P120_RB,
+	V4L2_DV_BT_DMT_1680X1050P60_RB,
+	V4L2_DV_BT_DMT_1680X1050P60,
+	V4L2_DV_BT_DMT_1680X1050P75,
+	V4L2_DV_BT_DMT_1680X1050P85,
+	V4L2_DV_BT_DMT_1680X1050P120_RB,
+	V4L2_DV_BT_DMT_1792X1344P60,
+	V4L2_DV_BT_DMT_1792X1344P75,
+	V4L2_DV_BT_DMT_1792X1344P120_RB,
+	V4L2_DV_BT_DMT_1856X1392P60,
+	V4L2_DV_BT_DMT_1856X1392P75,
+	V4L2_DV_BT_DMT_1856X1392P120_RB,
+	V4L2_DV_BT_DMT_1920X1200P60_RB,
+	V4L2_DV_BT_DMT_1920X1200P60,
+	V4L2_DV_BT_DMT_1920X1200P75,
+	V4L2_DV_BT_DMT_1920X1200P85,
+	V4L2_DV_BT_DMT_1920X1200P120_RB,
+	V4L2_DV_BT_DMT_1920X1440P60,
+	V4L2_DV_BT_DMT_1920X1440P75,
+	V4L2_DV_BT_DMT_1920X1440P120_RB,
+	V4L2_DV_BT_DMT_2048X1152P60_RB,
+	V4L2_DV_BT_DMT_2560X1600P60_RB,
+	V4L2_DV_BT_DMT_2560X1600P60,
+	V4L2_DV_BT_DMT_2560X1600P75,
+	V4L2_DV_BT_DMT_2560X1600P85,
+	V4L2_DV_BT_DMT_2560X1600P120_RB,
+};
+
+bool v4l2_dv_valid_timings(const struct v4l2_dv_timings *t,
+			   const struct v4l2_dv_timings_cap *dvcap)
+{
+	const struct v4l2_bt_timings *bt = &t->bt;
+	const struct v4l2_bt_timings_cap *cap = &dvcap->bt;
+	u32 caps = cap->capabilities;
+
+	if (t->type != V4L2_DV_BT_656_1120)
+		return false;
+	if (t->type != dvcap->type ||
+	    bt->height < cap->min_height ||
+	    bt->height > cap->max_height ||
+	    bt->width < cap->min_width ||
+	    bt->width > cap->max_width ||
+	    bt->pixelclock < cap->min_pixelclock ||
+	    bt->pixelclock > cap->max_pixelclock ||
+	    (cap->standards && !(bt->standards & cap->standards)) ||
+	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
+	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
+		return false;
+	return true;
+}
+EXPORT_SYMBOL_GPL(v4l2_dv_valid_timings);
+
+int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
+			     const struct v4l2_dv_timings_cap *cap)
+{
+	u32 i, idx;
+
+	memset(t->reserved, 0, sizeof(t->reserved));
+	for (i = idx = 0; i < ARRAY_SIZE(timings); i++) {
+		if (v4l2_dv_valid_timings(timings + i, cap) &&
+		    idx++ == t->index) {
+			t->timings = timings[i];
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(v4l2_enum_dv_timings_cap);
+
+bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
+			      const struct v4l2_dv_timings_cap *cap,
+			      unsigned pclock_delta)
+{
+	int i;
+
+	if (!v4l2_dv_valid_timings(t, cap))
+		return false;
+
+	for (i = 0; i < ARRAY_SIZE(timings); i++) {
+		if (v4l2_dv_valid_timings(timings + i, cap) &&
+		    v4l_match_dv_timings(t, timings + i, pclock_delta)) {
+			*t = timings[i];
+			return true;
+		}
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cap);
diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
new file mode 100644
index 0000000..41075fa
--- /dev/null
+++ b/include/media/v4l2-dv-timings.h
@@ -0,0 +1,67 @@
+/*
+ * v4l2-dv-timings - Internal header with dv-timings helper functions
+ *
+ * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#ifndef __V4L2_DV_TIMINGS_H
+#define __V4L2_DV_TIMINGS_H
+
+#include <linux/videodev2.h>
+
+/** v4l2_dv_valid_timings() - are these timings valid?
+  * @t:	  the v4l2_dv_timings struct.
+  * @cap: the v4l2_dv_timings_cap capabilities.
+  *
+  * Returns true if the given dv_timings struct is supported by the
+  * hardware capabilities, returns false otherwise.
+  */
+bool v4l2_dv_valid_timings(const struct v4l2_dv_timings *t,
+			   const struct v4l2_dv_timings_cap *cap);
+
+/** v4l2_enum_dv_timings_cap() - Helper function to enumerate possible DV timings based on capabilities
+  * @t:	  the v4l2_enum_dv_timings struct.
+  * @cap: the v4l2_dv_timings_cap capabilities.
+  *
+  * This enumerates dv_timings using the full list of possible CEA-861 and DMT
+  * timings, filtering out any timings that are not supported based on the
+  * hardware capabilities.
+  *
+  * If a valid timing for the given index is found, it will fill in @t and
+  * return 0, otherwise it returns -EINVAL.
+  */
+int v4l2_enum_dv_timings_cap(struct v4l2_enum_dv_timings *t,
+			     const struct v4l2_dv_timings_cap *cap);
+
+/** v4l2_find_dv_timings_cap() - Find the closest timings struct
+  * @t:	  the v4l2_enum_dv_timings struct.
+  * @cap: the v4l2_dv_timings_cap capabilities.
+  * @pclock_delta: maximum delta between t->pixelclock and the timing struct
+  *		under consideration.
+  *
+  * This function tries to map the given timings to an entry in the
+  * full list of possible CEA-861 and DMT timings, filtering out any timings
+  * that are not supported based on the hardware capabilities.
+  *
+  * On success it will fill in @t with the found timings and it returns true.
+  * On failure it will return false.
+  */
+bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
+			      const struct v4l2_dv_timings_cap *cap,
+			      unsigned pclock_delta);
+
+#endif
-- 
1.8.3.2

