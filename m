Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39897 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbeFFNWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 09:22:25 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [RFC] media: renesas-ceu: Add media-controller support
Date: Wed,  6 Jun 2018 15:22:13 +0200
Message-Id: <1528291333-20562-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add initial support for media controller framework to the renesas-ceu driver.

Adding media-controller support allows to operate sensors that expose advanced
functionalities through the v4l2-subdev APIs.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
Hello,
   I'm in the process of adding support to a sensor driver that exposes advanced
functionalities through the v4l2-subdev APIs.

In order to operate on it, I had to add initial media-controller support to the
host driver (renesas-ceu) to have the subdevice video nodes properly created.

The current implementation allows to create and operate on the media graph, but
the result is a lot of #ifdef in the driver code I don't see in any other
mainline platform driver.

As there are more media-controller specificities to be supported (eg. set_fmt
that should not call into the subdev operations etc) before going too far I
decided to send this out to collect suggestions.

What is the best way to add media-controller support to a non-mc driver?

Ideally I would like this to continue working with all sensor drivers, and thus
I see a few ways of doing this:

- Keep using #ifdef CONFIG_MEDIA_CONTROLLER, but I don't see it in any other
  driver in mainline
- Add a media-controller compatible string, and decide at runtime if we should
  use media-controller or not (similar to what VIN driver does)
- Make the driver media controller only, but I fear 'old-style' sensor driver
  won't be usable anymore with this new version.

Any pointer/opinion is welcome.

Thanks
  j
---
 drivers/media/platform/renesas-ceu.c | 111 +++++++++++++++++++++++++++++++++++
 1 file changed, 111 insertions(+)

diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index 46b0639..5911f097 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -39,6 +39,7 @@
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-image-sizes.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
 #include <media/v4l2-mediabus.h>
 #include <media/videobuf2-dma-contig.h>

@@ -158,6 +159,9 @@ struct ceu_subdev {
 	/* per-subdevice mbus configuration options */
 	unsigned int mbus_flags;
 	struct ceu_mbus_fmt mbus_fmt;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	int source_pad;
+#endif
 };

 static struct ceu_subdev *to_ceu_subdev(struct v4l2_async_subdev *asd)
@@ -173,6 +177,11 @@ struct ceu_device {
 	struct video_device	vdev;
 	struct v4l2_device	v4l2_dev;

+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device	mdev;
+	struct media_pad	pad;
+#endif
+
 	/* subdevices descriptors */
 	struct ceu_subdev	*subdevs;
 	/* the subdevice currently in use */
@@ -1381,6 +1390,60 @@ static void ceu_vdev_release(struct video_device *vdev)
 	kfree(ceudev);
 }

+#ifdef CONFIG_MEDIA_CONTROLLER
+static int ceu_find_pad(struct v4l2_subdev *sd, int direction)
+{
+	unsigned int pad;
+
+	if (sd->entity.num_pads <= 1)
+		return 0;
+
+	for (pad = 0; pad < sd->entity.num_pads; pad++)
+		if (sd->entity.pads[pad].flags & direction)
+			return pad;
+
+	return -EINVAL;
+}
+
+static int ceu_notify_complete_mc(struct ceu_device *ceudev)
+{
+	struct video_device *vdev = &ceudev->vdev;
+	struct media_entity *source;
+	struct media_entity *sink;
+
+	unsigned int i;
+	int ret;
+
+	ret = media_device_register(&ceudev->mdev);
+	if (ret) {
+		v4l2_err(vdev->v4l2_dev,
+			 "media_device_register failed : %d\n", ret);
+		return ret;
+	}
+
+	ret = v4l2_device_register_subdev_nodes(&ceudev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	/* Link subdev's first available source pad to CEU sink one. */
+	for (i = 0; i < ceudev->num_sd; i++) {
+		int source_pad = ceudev->subdevs[i].source_pad;
+
+		if (source_pad < 0)
+			continue;
+
+		source = &ceudev->subdevs[i].v4l2_sd->entity;
+		sink = &vdev->entity;
+
+		ret = media_create_pad_link(source, source_pad, sink, 0, 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+#endif
+
 static int ceu_notify_bound(struct v4l2_async_notifier *notifier,
 			    struct v4l2_subdev *v4l2_sd,
 			    struct v4l2_async_subdev *asd)
@@ -1392,6 +1455,11 @@ static int ceu_notify_bound(struct v4l2_async_notifier *notifier,
 	ceu_sd->v4l2_sd = v4l2_sd;
 	ceudev->num_sd++;

+#ifdef CONFIG_MEDIA_CONTROLLER
+	/* Cache the entity source pad for later link creation. */
+	ceu_sd->source_pad = ceu_find_pad(v4l2_sd, MEDIA_PAD_FL_SOURCE);
+#endif
+
 	return 0;
 }

@@ -1459,6 +1527,14 @@ static int ceu_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 	}

+#ifdef CONFIG_MEDIA_CONTROLLER
+	ret = ceu_notify_complete_mc(ceudev);
+	if (ret) {
+		video_unregister_device(&ceudev->vdev);
+		return ret;
+	}
+#endif
+
 	return 0;
 }

@@ -1467,6 +1543,12 @@ static const struct v4l2_async_notifier_operations ceu_notify_ops = {
 	.complete	= ceu_notify_complete,
 };

+#ifdef CONFIG_MEDIA_CONTROLLER
+static const struct media_device_ops ceu_media_ops = {
+	.link_notify = v4l2_pipeline_link_notify,
+};
+#endif
+
 /*
  * ceu_init_async_subdevs() - Initialize CEU subdevices and async_subdevs in
  *			      ceu device. Both DT and platform data parsing use
@@ -1631,6 +1713,9 @@ static int ceu_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	const struct ceu_data *ceu_data;
 	struct ceu_device *ceudev;
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev;
+#endif
 	struct resource *res;
 	unsigned int irq;
 	int num_subdevs;
@@ -1670,6 +1755,24 @@ static int ceu_probe(struct platform_device *pdev)

 	pm_runtime_enable(dev);

+#ifdef CONFIG_MEDIA_CONTROLLER
+	mdev = &ceudev->mdev;
+	mdev->dev = dev;
+	mdev->ops = &ceu_media_ops;
+	strlcpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name));
+	strlcpy(mdev->model, KBUILD_MODNAME, sizeof(mdev->model));
+	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
+		 dev_name(mdev->dev));
+
+	media_device_init(mdev);
+	ceudev->v4l2_dev.mdev = mdev;
+
+	ceudev->pad.flags = MEDIA_PAD_FL_SINK;
+	ret = media_entity_pads_init(&ceudev->vdev.entity, 1, &ceudev->pad);
+	if (ret)
+		goto error_pm_disable;
+#endif
+
 	ret = v4l2_device_register(dev, &ceudev->v4l2_dev);
 	if (ret)
 		goto error_pm_disable;
@@ -1709,6 +1812,9 @@ static int ceu_probe(struct platform_device *pdev)
 	v4l2_device_unregister(&ceudev->v4l2_dev);
 error_pm_disable:
 	pm_runtime_disable(dev);
+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_cleanup(&ceudev->mdev);
+#endif
 error_free_ceudev:
 	kfree(ceudev);

@@ -1723,6 +1829,11 @@ static int ceu_remove(struct platform_device *pdev)

 	v4l2_async_notifier_unregister(&ceudev->notifier);

+#ifdef CONFIG_MEDIA_CONTROLLER
+	media_device_cleanup(&ceudev->mdev);
+	media_device_unregister(&ceudev->mdev);
+#endif
+
 	v4l2_device_unregister(&ceudev->v4l2_dev);

 	video_unregister_device(&ceudev->vdev);
--
2.7.4
