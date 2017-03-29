Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:46058 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753985AbdC2OPt (ORCPT
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
Subject: [PATCHv5 03/11] cec: integrate CEC notifier support
Date: Wed, 29 Mar 2017 16:15:35 +0200
Message-Id: <20170329141543.32935-4-hverkuil@xs4all.nl>
In-Reply-To: <20170329141543.32935-1-hverkuil@xs4all.nl>
References: <20170329141543.32935-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the CEC notifier framework, simplifying drivers that
depend on this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/cec/cec-core.c | 21 +++++++++++++++++++++
 include/media/cec.h          |  6 ++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 37217e205040..2bab6e00b663 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -195,6 +195,23 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	put_device(&devnode->dev);
 }
 
+#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+static void cec_cec_notify(struct cec_adapter *adap, u16 pa)
+{
+	cec_s_phys_addr(adap, pa, false);
+}
+
+void cec_register_cec_notifier(struct cec_adapter *adap,
+			       struct cec_notifier *notifier)
+{
+	if (WARN_ON(!adap->devnode.registered))
+		return;
+
+	cec_notifier_register(adap->notifier, adap, cec_cec_notify);
+}
+EXPORT_SYMBOL_GPL(cec_register_cec_notifier);
+#endif
+
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 					 void *priv, const char *name, u32 caps,
 					 u8 available_las)
@@ -343,6 +360,10 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	adap->rc = NULL;
 #endif
 	debugfs_remove_recursive(adap->cec_dir);
+#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+	if (adap->notifier)
+		cec_notifier_unregister(adap->notifier);
+#endif
 	cec_devnode_unregister(&adap->devnode);
 }
 EXPORT_SYMBOL_GPL(cec_unregister_adapter);
diff --git a/include/media/cec.h b/include/media/cec.h
index 96a0aa770d61..e6474b567a25 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -30,6 +30,7 @@
 #include <linux/cec-funcs.h>
 #include <media/rc-core.h>
 #include <media/cec-edid.h>
+#include <media/cec-notifier.h>
 
 /**
  * struct cec_devnode - cec device node
@@ -213,6 +214,11 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
 void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
 
+#ifdef CONFIG_MEDIA_CEC_NOTIFIER
+void cec_register_cec_notifier(struct cec_adapter *adap,
+			       struct cec_notifier *notifier);
+#endif
+
 #else
 
 static inline int cec_register_adapter(struct cec_adapter *adap,
-- 
2.11.0
