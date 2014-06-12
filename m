Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaFLRGp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:45 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 14/26] [media] Add i.MX SoC wide media device driver
Date: Thu, 12 Jun 2014 19:06:28 +0200
Message-Id: <1402592800-2925-15-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver registers a single, SoC wide media device, which all entities
in the media graph can be registered with via OF graph bindings.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/Kconfig         |   2 +
 drivers/media/platform/imx/Kconfig     |  13 +++
 drivers/media/platform/imx/Makefile    |   1 +
 drivers/media/platform/imx/imx-media.c | 174 +++++++++++++++++++++++++++++++++
 include/media/imx.h                    |  25 +++++
 5 files changed, 215 insertions(+)
 create mode 100644 drivers/media/platform/imx/imx-media.c
 create mode 100644 include/media/imx.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 8e9c26c..3fe7e28 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -35,6 +35,8 @@ source "drivers/media/platform/omap/Kconfig"
 
 source "drivers/media/platform/blackfin/Kconfig"
 
+source "drivers/media/platform/imx/Kconfig"
+
 config VIDEO_SH_VOU
 	tristate "SuperH VOU video output driver"
 	depends on MEDIA_CAMERA_SUPPORT
diff --git a/drivers/media/platform/imx/Kconfig b/drivers/media/platform/imx/Kconfig
index 506326a..d2f1693 100644
--- a/drivers/media/platform/imx/Kconfig
+++ b/drivers/media/platform/imx/Kconfig
@@ -1,3 +1,16 @@
+config MEDIA_IMX
+	tristate "Multimedia Support for Freescale i.MX"
+	depends on MEDIA_CONTROLLER
+	---help---
+	  This driver provides a SoC wide media controller device that all
+	  multimedia components in i.MX5 and i.MX6 SoCs can register with.
+
+config MEDIA_IMX_IPU
+	tristate "i.MX Image Processing Unit (v3) core driver"
+	---help---
+	  This driver provides core support for the i.MX IPUv3 contained in
+	  i.MX5 and i.MX6 SoCs.
+
 config VIDEO_IMX_IPU_COMMON
 	tristate
 
diff --git a/drivers/media/platform/imx/Makefile b/drivers/media/platform/imx/Makefile
index 5c9da82..60f451a 100644
--- a/drivers/media/platform/imx/Makefile
+++ b/drivers/media/platform/imx/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_MEDIA_IMX)			+= imx-media.o
 obj-$(CONFIG_VIDEO_IMX_IPU_COMMON)	+= imx-ipu.o
 obj-$(CONFIG_VIDEO_IMX_IPU_SCALER)	+= imx-ipu-scaler.o
 obj-$(CONFIG_VIDEO_IMX_IPU_VDIC)	+= imx-ipu-vdic.o
diff --git a/drivers/media/platform/imx/imx-media.c b/drivers/media/platform/imx/imx-media.c
new file mode 100644
index 0000000..ae63c49
--- /dev/null
+++ b/drivers/media/platform/imx/imx-media.c
@@ -0,0 +1,174 @@
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of_device.h>
+#include <linux/of_graph.h>
+#include <media/media-device.h>
+#include <media/v4l2-device.h>
+#include <video/imx-ipu-v3.h>
+
+struct ipu_media_controller {
+	struct v4l2_device v4l2_dev;
+	struct media_device mdev;
+};
+
+static struct ipu_media_controller *ipu_media;
+
+struct media_device *ipu_find_media_device(void)
+{
+	return &ipu_media->mdev;
+}
+EXPORT_SYMBOL_GPL(ipu_find_media_device);
+
+struct ipu_media_link {
+	struct v4l2_async_notifier	asn;
+	struct v4l2_async_subdev	asd;
+	struct v4l2_async_subdev	*asdp;
+	struct v4l2_subdev		*sd;
+	int padno;
+	struct device_node		*endpoint;
+	u32				media_link_flags;
+};
+
+static int ipu_media_bound(struct v4l2_async_notifier *notifier,
+			   struct v4l2_subdev *sd,
+			   struct v4l2_async_subdev *asd)
+{
+	struct ipu_media_controller *im = ipu_media;
+	struct ipu_media_link *link = container_of(notifier,
+						   struct ipu_media_link, asn);
+	struct device_node *np, *rp;
+	uint32_t portno = 0;
+	int ret;
+
+	if ((sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE)) {
+		ret = v4l2_device_register_subdev_node(&im->v4l2_dev, sd);
+		if (ret)
+			return ret;
+	}
+
+	np = link->endpoint;
+	rp = of_graph_get_remote_port(np);
+	of_property_read_u32(rp, "reg", &portno);
+
+	ret = media_entity_create_link(&sd->entity, portno, &link->sd->entity,
+			link->padno, link->media_link_flags);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void ipu_media_unbind(struct v4l2_async_notifier *notifier,
+			     struct v4l2_subdev *sd,
+			     struct v4l2_async_subdev *asd)
+{
+	if ((sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE)) {
+		video_unregister_device(sd->devnode);
+		kfree(sd->devnode);
+	}
+}
+
+struct ipu_media_link *ipu_media_entity_create_link(struct v4l2_subdev *sd,
+		int padno, struct device_node *endpoint,
+		u32 media_link_flags)
+{
+	struct ipu_media_controller *im = ipu_media;
+	struct ipu_media_link *link;
+	int ret;
+	struct device_node *rpp;
+
+	rpp = of_graph_get_remote_port_parent(endpoint);
+	if (!rpp)
+		return ERR_PTR(-EINVAL);
+
+	pr_info("%s: link on %s pad %d endpoint: %s remotenodeparent: %s\n",
+		__func__, sd->name, padno, endpoint->full_name, rpp->full_name);
+	if (!im)
+		return ERR_PTR(-ENODEV);
+
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+
+	link->sd = sd;
+	link->padno = padno;
+	link->endpoint = endpoint;
+	link->media_link_flags = media_link_flags;
+
+	link->asd.match_type = V4L2_ASYNC_MATCH_OF;
+	link->asd.match.of.node = rpp;
+
+	link->asdp = &link->asd;
+
+	link->asn.bound = ipu_media_bound;
+	link->asn.unbind = ipu_media_unbind;
+	link->asn.subdevs = &link->asdp;
+	link->asn.num_subdevs = 1;
+	link->asn.v4l2_dev = &im->v4l2_dev;
+
+	ret = v4l2_async_notifier_register(&im->v4l2_dev, &link->asn);
+	if (ret) {
+		kfree(link);
+		return ERR_PTR(ret);
+	}
+
+	return link;
+}
+EXPORT_SYMBOL_GPL(ipu_media_entity_create_link);
+
+void ipu_media_entity_remove_link(struct ipu_media_link *link)
+{
+	v4l2_async_notifier_unregister(&link->asn);
+
+	kfree(link);
+}
+EXPORT_SYMBOL_GPL(ipu_media_entity_remove_link);
+
+struct v4l2_device *ipu_media_get_v4l2_dev(void)
+{
+	if (!ipu_media)
+		return NULL;
+
+	return &ipu_media->v4l2_dev;
+}
+EXPORT_SYMBOL_GPL(ipu_media_get_v4l2_dev);
+
+int ipu_media_device_register(struct device *dev)
+{
+	struct media_device *mdev;
+	int ret;
+
+	if (ipu_media)
+		return 0;
+
+	ipu_media = devm_kzalloc(dev, sizeof(*ipu_media), GFP_KERNEL);
+	if (!ipu_media)
+		return -ENOMEM;
+
+	mdev = &ipu_media->mdev;
+
+	mdev->dev = dev;
+
+	strlcpy(mdev->model, "i.MX IPUv3", sizeof(mdev->model));
+
+	ret = media_device_register(mdev);
+	if (ret)
+		return ret;
+
+	ipu_media->v4l2_dev.mdev = mdev;
+
+	ret = v4l2_device_register(mdev->dev, &ipu_media->v4l2_dev);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_media_device_register);
diff --git a/include/media/imx.h b/include/media/imx.h
new file mode 100644
index 0000000..42be5f4
--- /dev/null
+++ b/include/media/imx.h
@@ -0,0 +1,25 @@
+struct v4l2_subdev;
+struct device_node;
+struct ipu_media_link;
+struct v4l2_device;
+struct media_device;
+struct device;
+
+struct ipu_media_link *ipu_media_entity_create_link(struct v4l2_subdev *sd,
+		int padno, struct device_node *remote_node,
+		u32 media_link_flags);
+
+void ipu_media_entity_remove_link(struct ipu_media_link *link);
+
+struct v4l2_device *ipu_media_get_v4l2_dev(void);
+
+struct media_device *ipu_find_media_device(void);
+
+#ifdef CONFIG_MEDIA_IMX
+int ipu_media_device_register(struct device *dev);
+#else
+static inline int ipu_media_device_register(struct device *dev)
+{
+	return 0;
+}
+#endif
-- 
2.0.0.rc2

