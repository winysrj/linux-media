Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:51644 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751200AbdGOMc6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 08:32:58 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for 4.13] cec-notifier: small improvements
Message-ID: <1a95a512-c1d5-6245-1fad-2971ec7d08cf@xs4all.nl>
Date: Sat, 15 Jul 2017 14:32:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow calling cec_notifier_set_phys_addr and
cec_notifier_set_phys_addr_from_edid with a NULL notifier, in which
case these functions do nothing.

Add a cec_notifier_phys_addr_invalidate helper function (the notifier
equivalent of cec_phys_addr_invalidate).

These changes simplify drm CEC driver support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-notifier.c |  6 ++++++
 include/media/cec-notifier.h     | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
index 74dc1c32080e..08b619d0ea1e 100644
--- a/drivers/media/cec/cec-notifier.c
+++ b/drivers/media/cec/cec-notifier.c
@@ -87,6 +87,9 @@ EXPORT_SYMBOL_GPL(cec_notifier_put);

 void cec_notifier_set_phys_addr(struct cec_notifier *n, u16 pa)
 {
+	if (n == NULL)
+		return;
+
 	mutex_lock(&n->lock);
 	n->phys_addr = pa;
 	if (n->callback)
@@ -100,6 +103,9 @@ void cec_notifier_set_phys_addr_from_edid(struct cec_notifier *n,
 {
 	u16 pa = CEC_PHYS_ADDR_INVALID;

+	if (n == NULL)
+		return;
+
 	if (edid && edid->extensions)
 		pa = cec_get_edid_phys_addr((const u8 *)edid,
 				EDID_LENGTH * (edid->extensions + 1), NULL);
diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index 298f996969df..a4f7429c4ae5 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -57,6 +57,7 @@ void cec_notifier_put(struct cec_notifier *n);
  * @pa: the CEC physical address
  *
  * Set a new CEC physical address.
+ * Does nothing if @n == NULL.
  */
 void cec_notifier_set_phys_addr(struct cec_notifier *n, u16 pa);

@@ -66,6 +67,7 @@ void cec_notifier_set_phys_addr(struct cec_notifier *n, u16 pa);
  * @edid: the struct edid pointer
  *
  * Parses the EDID to obtain the new CEC physical address and set it.
+ * Does nothing if @n == NULL.
  */
 void cec_notifier_set_phys_addr_from_edid(struct cec_notifier *n,
 					  const struct edid *edid);
@@ -118,4 +120,17 @@ static inline void cec_notifier_unregister(struct cec_notifier *n)

 #endif

+/**
+ * cec_notifier_phys_addr_invalidate() - set the physical address to INVALID
+ *
+ * @n: the CEC notifier
+ *
+ * This is a simple helper function to invalidate the physical
+ * address. Does nothing if @n == NULL.
+ */
+static inline void cec_notifier_phys_addr_invalidate(struct cec_notifier *n)
+{
+	cec_notifier_set_phys_addr(n, CEC_PHYS_ADDR_INVALID);
+}
+
 #endif
-- 
2.11.0
