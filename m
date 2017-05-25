Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44020 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936424AbdEYPGn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 11:06:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Clint Taylor <clinton.a.taylor@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/7] cec: add cec_s_phys_addr_from_edid helper function
Date: Thu, 25 May 2017 17:06:22 +0200
Message-Id: <20170525150626.29748-4-hverkuil@xs4all.nl>
In-Reply-To: <20170525150626.29748-1-hverkuil@xs4all.nl>
References: <20170525150626.29748-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This function simplifies the integration of CEC in DRM drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 14 ++++++++++++++
 include/media/cec.h          |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 303de0d25d2b..1b9537d8d24b 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -28,6 +28,8 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+#include <drm/drm_edid.h>
+
 #include "cec-priv.h"
 
 static void cec_fill_msg_report_features(struct cec_adapter *adap,
@@ -1412,6 +1414,18 @@ void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr, bool block)
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
index b08edb31508f..9989cdb58bd8 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -207,6 +207,8 @@ static inline bool cec_is_sink(const struct cec_adapter *adap)
 #define cec_phys_addr_exp(pa) \
 	((pa) >> 12), ((pa) >> 8) & 0xf, ((pa) >> 4) & 0xf, (pa) & 0xf
 
+struct edid;
+
 #if IS_ENABLED(CONFIG_CEC_CORE)
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		void *priv, const char *name, u32 caps, u8 available_las);
@@ -218,6 +220,8 @@ int cec_s_log_addrs(struct cec_adapter *adap, struct cec_log_addrs *log_addrs,
 		    bool block);
 void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
 		     bool block);
+void cec_s_phys_addr_from_edid(struct cec_adapter *adap,
+			       const struct edid *edid);
 int cec_transmit_msg(struct cec_adapter *adap, struct cec_msg *msg,
 		     bool block);
 
@@ -327,6 +331,11 @@ static inline void cec_s_phys_addr(struct cec_adapter *adap, u16 phys_addr,
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
