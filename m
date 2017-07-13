Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51001 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750807AbdGMHH0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 03:07:26 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: move cec_register_cec_notifier to cec-notifier.h
Message-ID: <a3cf3b44-2c77-0386-b71c-b25e2104b830@xs4all.nl>
Date: Thu, 13 Jul 2017 09:07:23 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec_register_cec_notifier function was in media/cec.h, but it
has to be in cec-notifier.h.

While we are at it, also document it and add a stub function for when
the notifier is disabled or the CEC core code is unreachable.

Based on an earlier patch from Jose Abreu <Jose.Abreu@synopsys.com>.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec-notifier.h | 12 ++++++++++++
 include/media/cec.h          |  5 -----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
index 298f996969df..73bc98b90afc 100644
--- a/include/media/cec-notifier.h
+++ b/include/media/cec-notifier.h
@@ -86,6 +86,14 @@ void cec_notifier_register(struct cec_notifier *n,
  */
 void cec_notifier_unregister(struct cec_notifier *n);

+/**
+ * cec_register_cec_notifier - register the notifier with the cec adapter.
+ * @adap: the CEC adapter
+ * @notifier: the CEC notifier
+ */
+void cec_register_cec_notifier(struct cec_adapter *adap,
+			       struct cec_notifier *notifier);
+
 #else
 static inline struct cec_notifier *cec_notifier_get(struct device *dev)
 {
@@ -116,6 +124,10 @@ static inline void cec_notifier_unregister(struct cec_notifier *n)
 {
 }

+static inline void cec_register_cec_notifier(struct cec_adapter *adap,
+					     struct cec_notifier *notifier)
+{
+}
 #endif

 #endif
diff --git a/include/media/cec.h b/include/media/cec.h
index 56643b27e4b8..6a1c2515bb91 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -311,11 +311,6 @@ u16 cec_phys_addr_for_input(u16 phys_addr, u8 input);
  */
 int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port);

-#ifdef CONFIG_CEC_NOTIFIER
-void cec_register_cec_notifier(struct cec_adapter *adap,
-			       struct cec_notifier *notifier);
-#endif
-
 #else

 static inline int cec_register_adapter(struct cec_adapter *adap,
-- 
2.11.0
