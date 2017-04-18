Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:39198 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932143AbdDRIqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Apr 2017 04:46:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v4.12 2/3] cec.h: merge cec-edid.h into cec.h
Date: Tue, 18 Apr 2017 10:46:00 +0200
Message-Id: <20170418084601.1590-3-hverkuil@xs4all.nl>
In-Reply-To: <20170418084601.1590-1-hverkuil@xs4all.nl>
References: <20170418084601.1590-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the separate cec-edid.h header and merge it into cec.h.

There was really no need to have a separate header for this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                              |   1 -
 drivers/media/cec/cec-edid.c             |   2 +-
 drivers/media/cec/cec-notifier.c         |   1 +
 drivers/media/platform/s5p-cec/s5p_cec.c |   1 -
 include/media/cec-edid.h                 | 133 -------------------------------
 include/media/cec-notifier.h             |   2 +-
 include/media/cec.h                      | 102 +++++++++++++++++++++++-
 7 files changed, 104 insertions(+), 138 deletions(-)
 delete mode 100644 include/media/cec-edid.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 1b0049934cf9..8cc0104f14aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3077,7 +3077,6 @@ F:	Documentation/media/uapi/cec
 F:	drivers/media/cec/
 F:	drivers/media/rc/keymaps/rc-cec.c
 F:	include/media/cec.h
-F:	include/media/cec-edid.h
 F:	include/media/cec-notifier.h
 F:	include/uapi/linux/cec.h
 F:	include/uapi/linux/cec-funcs.h
diff --git a/drivers/media/cec/cec-edid.c b/drivers/media/cec/cec-edid.c
index c63dc81d2a29..38e3fec6152b 100644
--- a/drivers/media/cec/cec-edid.c
+++ b/drivers/media/cec/cec-edid.c
@@ -20,7 +20,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <media/cec-edid.h>
+#include <media/cec.h>
 
 /*
  * This EDID is expected to be a CEA-861 compliant, which means that there are
diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
index 5f5209a73665..74dc1c32080e 100644
--- a/drivers/media/cec/cec-notifier.c
+++ b/drivers/media/cec/cec-notifier.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <linux/kref.h>
 
+#include <media/cec.h>
 #include <media/cec-notifier.h>
 #include <drm/drm_edid.h>
 
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 4688f0879f55..664937b61fa4 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -25,7 +25,6 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <media/cec.h>
-#include <media/cec-edid.h>
 #include <media/cec-notifier.h>
 
 #include "exynos_hdmi_cec.h"
diff --git a/include/media/cec-edid.h b/include/media/cec-edid.h
deleted file mode 100644
index 242781fd377f..000000000000
--- a/include/media/cec-edid.h
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- * cec-edid - HDMI Consumer Electronics Control & EDID helpers
- *
- * Copyright 2016 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
- *
- * This program is free software; you may redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- */
-
-#ifndef _MEDIA_CEC_EDID_H
-#define _MEDIA_CEC_EDID_H
-
-#include <linux/types.h>
-
-#define CEC_PHYS_ADDR_INVALID		0xffff
-#define cec_phys_addr_exp(pa) \
-	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
-
-#if IS_ENABLED(CONFIG_CEC_CORE)
-
-/**
- * cec_get_edid_phys_addr() - find and return the physical address
- *
- * @edid:	pointer to the EDID data
- * @size:	size in bytes of the EDID data
- * @offset:	If not %NULL then the location of the physical address
- *		bytes in the EDID will be returned here. This is set to 0
- *		if there is no physical address found.
- *
- * Return: the physical address or CEC_PHYS_ADDR_INVALID if there is none.
- */
-u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
-			   unsigned int *offset);
-
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
-#else
-
-static inline u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
-					 unsigned int *offset)
-{
-	if (offset)
-		*offset = 0;
-	return CEC_PHYS_ADDR_INVALID;
-}
-
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
-	return 0;
-}
-
-#endif
-
-#endif /* _MEDIA_CEC_EDID_H */
diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index 035712e0993d..eb50ce54b759 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -22,7 +22,7 @@
 #define LINUX_CEC_NOTIFIER_H
 
 #include <linux/types.h>
-#include <media/cec-edid.h>
+#include <media/cec.h>
 
 struct device;
 struct edid;
diff --git a/include/media/cec.h b/include/media/cec.h
index bae8d0153de7..b8eb895731d5 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -29,7 +29,6 @@
 #include <linux/timer.h>
 #include <linux/cec-funcs.h>
 #include <media/rc-core.h>
-#include <media/cec-edid.h>
 #include <media/cec-notifier.h>
 
 /**
@@ -204,6 +203,9 @@ static inline bool cec_is_sink(const struct cec_adapter *adap)
 	return adap->phys_addr == 0;
 }
 
+#define cec_phys_addr_exp(pa) \
+	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
+
 #if IS_ENABLED(CONFIG_CEC_CORE)
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		void *priv, const char *name, u32 caps, u8 available_las);
@@ -223,6 +225,81 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
 void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
 
+/**
+ * cec_get_edid_phys_addr() - find and return the physical address
+ *
+ * @edid:	pointer to the EDID data
+ * @size:	size in bytes of the EDID data
+ * @offset:	If not %NULL then the location of the physical address
+ *		bytes in the EDID will be returned here. This is set to 0
+ *		if there is no physical address found.
+ *
+ * Return: the physical address or CEC_PHYS_ADDR_INVALID if there is none.
+ */
+u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
+			   unsigned int *offset);
+
+/**
+ * cec_set_edid_phys_addr() - find and set the physical address
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
+void cec_set_edid_phys_addr(u8 *edid, unsigned int size, u16 phys_addr);
+
+/**
+ * cec_phys_addr_for_input() - calculate the PA for an input
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
+u16 cec_phys_addr_for_input(u16 phys_addr, u8 input);
+
+/**
+ * cec_phys_addr_validate() - validate a physical address from an EDID
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
+int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);
+
 #ifdef CONFIG_MEDIA_CEC_NOTIFIER
 void cec_register_cec_notifier(struct cec_adapter *adap,
 			       struct cec_notifier *notifier);
@@ -249,6 +326,29 @@ static inline void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
 {
 }
 
+static inline u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
+					 unsigned int *offset)
+{
+	if (offset)
+		*offset = 0;
+	return CEC_PHYS_ADDR_INVALID;
+}
+
+static inline void cec_set_edid_phys_addr(u8 *edid, unsigned int size,
+					  u16 phys_addr)
+{
+}
+
+static inline u16 cec_phys_addr_for_input(u16 phys_addr, u8 input)
+{
+	return CEC_PHYS_ADDR_INVALID;
+}
+
+static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
+{
+	return 0;
+}
+
 #endif
 
 #endif /* _MEDIA_CEC_H */
-- 
2.11.0
