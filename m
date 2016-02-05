Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55734 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbcBEQGT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 11:06:19 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/6] [media] v4l2-mc: add an ancillary routine for PCI-based MC
Date: Fri,  5 Feb 2016 14:04:59 -0200
Message-Id: <e861d9c437dd6c469f3aff23df78949e85e23c54.1454688188.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of copyping the same code on all PCI devices that
would have a media controller, add a core ancillary routine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 35 +++++++++++++++++++++++++++++++++++
 include/media/v4l2-mc.h           | 24 +++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 7276dbbbe830..e8dc3cfac666 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -15,9 +15,44 @@
  */
 
 #include <linux/module.h>
+#include <linux/pci.h>
 #include <media/media-entity.h>
 #include <media/v4l2-mc.h>
 
+
+struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
+						   char *name)
+{
+#ifdef CONFIG_PCI
+	struct media_device *mdev;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return NULL;
+
+	mdev->dev = &pci_dev->dev;
+
+	if (name)
+		strlcpy(mdev->model, name, sizeof(mdev->model));
+	else
+		strlcpy(mdev->model, pci_name(pci_dev), sizeof(mdev->model));
+
+	sprintf(mdev->bus_info, "PCI:%s", pci_name(pci_dev));
+
+	mdev->hw_revision = pci_dev->subsystem_vendor << 16
+			    || pci_dev->subsystem_device;
+
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	media_device_init(mdev);
+
+	return mdev;
+#else
+	return NULL;
+#endif
+}
+EXPORT_SYMBOL_GPL(v4l2_mc_pci_media_device_init);
+
 int v4l2_mc_create_media_graph(struct media_device *mdev)
 
 {
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index 3097493e6cf1..18bcdbb300d4 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -92,6 +92,10 @@ enum demod_pad_index {
 	DEMOD_NUM_PADS
 };
 
+
+struct pci_dev;		/* We don't need to include pci.h here */
+
+#ifdef CONFIG_MEDIA_CONTROLLER
 /**
  * v4l2_mc_create_media_graph() - create Media Controller links at the graph.
  *
@@ -106,10 +110,28 @@ enum demod_pad_index {
  * interface centric PC-consumer's hardware, V4L2 subdev centric camera
  * hardware should not use this routine, as it will not build the right graph.
  */
-#ifdef CONFIG_MEDIA_CONTROLLER
 int v4l2_mc_create_media_graph(struct media_device *mdev);
+
+/**
+ * v4l2_mc_pci_media_device_init() - create and initialize a
+ *	struct &media_device from a PCI device.
+ *
+ * @pci_dev:	pointer to struct pci_dev
+ * @name:	media device name. If %NULL, the routine will use the default
+ *		name for the pci device, given by pci_name() macro.
+ */
+struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
+						   char *name);
+
+
 #else
 static inline int v4l2_mc_create_media_graph(struct media_device *mdev) {
 	return 0;
 }
+
+struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
+						   char *name) {
+	return NULL;
+}
+
 #endif
-- 
2.5.0


