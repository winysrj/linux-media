Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59227 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753269AbcLMPIW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 10:08:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/4] cec: integrate HDMI notifier support
Date: Tue, 13 Dec 2016 16:08:12 +0100
Message-Id: <20161213150813.37966-4-hverkuil@xs4all.nl>
In-Reply-To: <20161213150813.37966-1-hverkuil@xs4all.nl>
References: <20161213150813.37966-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Support the HDMI notifier framework, simplifying drivers that
depend on this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-core.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/cec.h          | 15 +++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index aca3ab8..c620a4c 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -195,6 +195,52 @@ static void cec_devnode_unregister(struct cec_devnode *devnode)
 	put_device(&devnode->dev);
 }
 
+#ifdef CONFIG_HDMI_NOTIFIERS
+static u16 parse_hdmi_addr(const struct edid *edid)
+{
+	if (!edid || edid->extensions == 0)
+		return CEC_PHYS_ADDR_INVALID;
+
+	return cec_get_edid_phys_addr((u8 *)edid,
+				EDID_LENGTH * (edid->extensions + 1), NULL);
+}
+
+static int cec_hdmi_notify(struct notifier_block *nb, unsigned long event,
+			   void *data)
+{
+	struct cec_adapter *adap = container_of(nb, struct cec_adapter, nb);
+	struct hdmi_notifier *n = data;
+	unsigned int phys;
+
+	dprintk(1, "event %lu\n", event);
+
+	switch (event) {
+	case HDMI_DISCONNECTED:
+		cec_s_phys_addr(adap, CEC_PHYS_ADDR_INVALID, false);
+		break;
+
+	case HDMI_NEW_EDID:
+		phys = parse_hdmi_addr(n->edid);
+		cec_s_phys_addr(adap, phys, false);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+void cec_register_hdmi_notifier(struct cec_adapter *adap,
+				struct hdmi_notifier *notifier)
+{
+	if (WARN_ON(!adap->devnode.registered))
+		return;
+
+	adap->nb.notifier_call = cec_hdmi_notify;
+	adap->notifier = notifier;
+	hdmi_notifier_register(adap->notifier, &adap->nb);
+}
+EXPORT_SYMBOL_GPL(cec_register_hdmi_notifier);
+#endif
+
 struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 					 void *priv, const char *name, u32 caps,
 					 u8 available_las)
@@ -344,6 +390,10 @@ void cec_unregister_adapter(struct cec_adapter *adap)
 	adap->rc = NULL;
 #endif
 	debugfs_remove_recursive(adap->cec_dir);
+#ifdef CONFIG_HDMI_NOTIFIERS
+	if (adap->notifier)
+		hdmi_notifier_unregister(adap->notifier, &adap->nb);
+#endif
 	cec_devnode_unregister(&adap->devnode);
 }
 EXPORT_SYMBOL_GPL(cec_unregister_adapter);
diff --git a/include/media/cec.h b/include/media/cec.h
index 96a0aa7..3b4860d 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -28,6 +28,11 @@
 #include <linux/kthread.h>
 #include <linux/timer.h>
 #include <linux/cec-funcs.h>
+#ifdef CONFIG_HDMI_NOTIFIERS
+#include <linux/notifier.h>
+#include <linux/hdmi-notifier.h>
+#include <drm/drm_edid.h>
+#endif
 #include <media/rc-core.h>
 #include <media/cec-edid.h>
 
@@ -173,6 +178,11 @@ struct cec_adapter {
 	bool passthrough;
 	struct cec_log_addrs log_addrs;
 
+#ifdef CONFIG_HDMI_NOTIFIERS
+	struct hdmi_notifier	*notifier;
+	struct notifier_block	nb;
+#endif
+
 	struct dentry *cec_dir;
 	struct dentry *status_file;
 
@@ -213,6 +223,11 @@ void cec_transmit_done(struct cec_adapter *adap, u8 status, u8 arb_lost_cnt,
 		       u8 nack_cnt, u8 low_drive_cnt, u8 error_cnt);
 void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg);
 
+#ifdef CONFIG_HDMI_NOTIFIERS
+void cec_register_hdmi_notifier(struct cec_adapter *adap,
+				struct hdmi_notifier *notifier);
+#endif
+
 #else
 
 static inline int cec_register_adapter(struct cec_adapter *adap,
-- 
2.10.2

