Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:59505 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751413AbdFGOqV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/9] cec: add cec_s_phys_addr_from_edid helper function
Date: Wed,  7 Jun 2017 16:46:08 +0200
Message-Id: <20170607144616.15247-2-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function simplifies the integration of CEC in DRM drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/kapi/cec-core.rst |  8 ++++++++
 drivers/media/cec/cec-adap.c          | 14 ++++++++++++++
 include/media/cec.h                   |  9 +++++++++
 3 files changed, 31 insertions(+)

diff --git a/Documentation/media/kapi/cec-core.rst b/Documentation/media/kapi/cec-core.rst
index 7a04c5386dc8..278b358b2f2e 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -307,6 +307,14 @@ to another valid physical address, then this function will first set the
 address to CEC_PHYS_ADDR_INVALID before enabling the new physical address.
 
 .. c:function::
+	void cec_s_phys_addr_from_edid(struct cec_adapter *adap,
+				       const struct edid *edid);
+
+A helper function that extracts the physical address from the edid struct
+and calls cec_s_phys_addr() with that address, or CEC_PHYS_ADDR_INVALID
+if the EDID did not contain a physical address or edid was a NULL pointer.
+
+.. c:function::
 	int cec_s_log_addrs(struct cec_adapter *adap,
 			    struct cec_log_addrs *log_addrs, bool block);
 
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index fd6d9cccade7..61e39bbe3cf9 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -28,6 +28,8 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <drm/drm_edid.h>
+
 #include "cec-priv.h"
 
 static void cec_fill_msg_report_features(struct cec_adapter *adap,
@@ -1408,6 +1410,18 @@ void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
 }
 EXPORT_SYMBOL_GPL(cec_s_phys_addr);
 
+void cec_s_phys_addr_from_edid(struct cec_adapter *adap,
+			       const struct edid *edid)
+{
+	u16 pa = CEC_PHYS_ADDR_INVALID;
+
+	if (edid && edid->extensions)
+		pa = cec_get_edid_phys_addr((const u8 *)edid,
+				EDID_LENGTH * (edid->extensions + 1), NULL);
+	cec_s_phys_addr(adap, pa, false);
+}
+EXPORT_SYMBOL_GPL(cec_s_phys_addr_from_edid);
+
 /*
  * Called from either the ioctl or a driver to set the logical addresses.
  *
diff --git a/include/media/cec.h b/include/media/cec.h
index bfa88d4d67e1..a548b292eeb1 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -206,6 +206,8 @@ static inline bool cec_is_sink(const struct cec_adapter *adap)
 #define cec_phys_addr_exp(pa) \
 	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
 
+struct edid;
+
 #if IS_ENABLED(CONFIG_CEC_CORE)
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		void *priv, const char *name, u32 caps, u8 available_las);
@@ -217,6 +219,8 @@ int cec_s_log_addrs(struct cec_adapter *adap, struct cec_log_addrs *log_addrs,
 		    bool block);
 void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
 		     bool block);
+void cec_s_phys_addr_from_edid(struct cec_adapter *adap,
+			       const struct edid *edid);
 int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
 		     bool block);
 
@@ -326,6 +330,11 @@ static inline void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
 {
 }
 
+static inline void cec_s_phys_addr_from_edid(struct cec_adapter *adap,
+					     const struct edid *edid)
+{
+}
+
 static inline u16 cec_get_edid_phys_addr(const u8 *edid, unsigned int size,
 					 unsigned int *offset)
 {
-- 
2.11.0
