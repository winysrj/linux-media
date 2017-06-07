Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54627 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751444AbdFGOqV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/9] cec: add cec_phys_addr_invalidate() helper function
Date: Wed,  7 Jun 2017 16:46:09 +0200
Message-Id: <20170607144616.15247-3-hverkuil@xs4all.nl>
In-Reply-To: <20170607144616.15247-1-hverkuil@xs4all.nl>
References: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplifies setting the physical address to CEC_PHYS_ADDR_INVALID.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/media/cec.h b/include/media/cec.h
index a548b292eeb1..3ce73951591e 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -360,4 +360,17 @@ static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
 
 #endif
 
+/**
+ * cec_phys_addr_invalidate() - set the physical address to INVALID
+ *
+ * @adap:	the CEC adapter
+ *
+ * This is a simple helper function to invalidate the physical
+ * address.
+ */
+static inline void cec_phys_addr_invalidate(struct cec_adapter *adap)
+{
+	cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
+}
+
 #endif /* _MEDIA_CEC_H */
-- 
2.11.0
