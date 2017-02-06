Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36134 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751776AbdBFKaI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 05:30:08 -0500
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
Subject: [PATCHv4 3/9] cec: integrate HPD notifier support
Date: Mon,  6 Feb 2017 11:29:45 +0100
Message-Id: <20170206102951.12623-4-hverkuil@xs4all.nl>
In-Reply-To: <20170206102951.12623-1-hverkuil@xs4all.nl>
References: <20170206102951.12623-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the HPD notifier framework, simplifying drivers that
depend on this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/cec/cec-core.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/cec.h          | 15 +++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 37217e205040..f055720a1c65 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -195,6 +195,52 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	put_device(&devnode->dev);
 }
 
+#ifdef CONFIG_HPD_NOTIFIER
+static u16 parse_hdmi_addr(const struct edid *edid)
+{
+	if (!edid || edid->extensions == 0)
+		return CEC_PHYS_ADDR_INVALID;
+
+	return cec_get_edid_phys_addr((u8 *)edid,
+				EDID_LENGTH * (edid->extensions + 1), NULL);
+}
+
+static int cec_hpd_notify(struct notifier_block *nb, unsigned long event,
+			   void *data)
+{
+	struct cec_adapter *adap = container_of(nb, struct cec_adapter, nb);
+	struct hpd_notifier *n = data;
+	unsigned int phys;
+
+	dprintk(1, "event %lu\n", event);
+
+	switch (event) {
+	case HPD_DISCONNECTED:
+		cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
+		break;
+
+	case HPD_NEW_EDID:
+		phys = parse_hdmi_addr(n->edid);
+		cec_s_phys_addr(adap, phys, false);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+void cec_register_hpd_notifier(struct cec_adapter *adap,
+				struct hpd_notifier *notifier)
+{
+	if (WARN_ON(!adap->devnode.registered))
+		return;
+
+	adap->nb.notifier_call = cec_hpd_notify;
+	adap->notifier = notifier;
+	hpd_notifier_register(adap->notifier, &adap->nb);
+}
+EXPORT_SYMBOL_GPL(cec_register_hpd_notifier);
+#endif
+
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 					 void *priv, const char *name, u32 caps,
 					 u8 available_las)
@@ -343,6 +389,10 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	adap->rc = NULL;
 #endif
 	debugfs_remove_recursive(adap->cec_dir);
+#ifdef CONFIG_HPD_NOTIFIER
+	if (adap->notifier)
+		hpd_notifier_unregister(adap->notifier, &adap->nb);
+#endif
 	cec_devnode_unregister(&adap->devnode);
 }
 EXPORT_SYMBOL_GPL(cec_unregister_adapter);
diff --git a/include/media/cec.h b/include/media/cec.h
index 96a0aa770d61..f87a07ee36b3 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -28,6 +28,11 @@
 #include <linux/kthread.h>
 #include <linux/timer.h>
 #include <linux/cec-funcs.h>
+#ifdef CONFIG_HPD_NOTIFIER
+#include <linux/notifier.h>
+#include <linux/hpd-notifier.h>
+#include <drm/drm_edid.h>
+#endif
 #include <media/rc-core.h>
 #include <media/cec-edid.h>
 
@@ -173,6 +178,11 @@ struct cec_adapter {
 	bool passthrough;
 	struct cec_log_addrs log_addrs;
 
+#ifdef CONFIG_HPD_NOTIFIER
+	struct hpd_notifier	*notifier;
+	struct notifier_block	nb;
+#endif
+
 	struct dentry *cec_dir;
 	struct dentry *status_file;
 
@@ -213,6 +223,11 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
 void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
 
+#ifdef CONFIG_HPD_NOTIFIER
+void cec_register_hpd_notifier(struct cec_adapter *adap,
+				struct hpd_notifier *notifier);
+#endif
+
 #else
 
 static inline int cec_register_adapter(struct cec_adapter *adap,
-- 
2.11.0

