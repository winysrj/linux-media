Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:55776 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759139Ab2CVSxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 14:53:37 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 1/2] [resend] radio-isa: PnP support for the new ISA radio framework
Cc: linux-media@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Thu, 22 Mar 2012 19:53:01 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203221953.04904.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add PnP support to the new ISA radio framework.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 02bcead..ed9039f 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
@@ -198,56 +199,31 @@ static bool radio_isa_valid_io(const struct radio_isa_driver *drv, int io)
 	return false;
 }
 
-int radio_isa_probe(struct device *pdev, unsigned int dev)
+struct radio_isa_card *radio_isa_alloc(struct radio_isa_driver *drv,
+				struct device *pdev)
 {
-	struct radio_isa_driver *drv = pdev->platform_data;
-	const struct radio_isa_ops *ops = drv->ops;
 	struct v4l2_device *v4l2_dev;
-	struct radio_isa_card *isa;
-	int res;
+	struct radio_isa_card *isa = drv->ops->alloc();
+	if (!isa)
+		return NULL;
 
-	isa = drv->ops->alloc();
-	if (isa == NULL)
-		return -ENOMEM;
 	dev_set_drvdata(pdev, isa);
 	isa->drv = drv;
-	isa->io = drv->io_params[dev];
 	v4l2_dev = &isa->v4l2_dev;
 	strlcpy(v4l2_dev->name, dev_name(pdev), sizeof(v4l2_dev->name));
 
-	if (drv->probe && ops->probe) {
-		int i;
-
-		for (i = 0; i < drv->num_of_io_ports; ++i) {
-			int io = drv->io_ports[i];
-
-			if (request_region(io, drv->region_size, v4l2_dev->name)) {
-				bool found = ops->probe(isa, io);
-
-				release_region(io, drv->region_size);
-				if (found) {
-					isa->io = io;
-					break;
-				}
-			}
-		}
-	}
-
-	if (!radio_isa_valid_io(drv, isa->io)) {
-		int i;
+	return isa;
+}
 
-		if (isa->io < 0)
-			return -ENODEV;
-		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x%03x",
-				drv->io_ports[0]);
-		for (i = 1; i < drv->num_of_io_ports; i++)
-			printk(KERN_CONT "/0x%03x", drv->io_ports[i]);
-		printk(KERN_CONT ".\n");
-		kfree(isa);
-		return -EINVAL;
-	}
+int radio_isa_common_probe(struct radio_isa_card *isa, struct device *pdev,
+				int radio_nr, unsigned region_size)
+{
+	const struct radio_isa_driver *drv = isa->drv;
+	const struct radio_isa_ops *ops = drv->ops;
+	struct v4l2_device *v4l2_dev = &isa->v4l2_dev;
+	int res;
 
-	if (!request_region(isa->io, drv->region_size, v4l2_dev->name)) {
+	if (!request_region(isa->io, region_size, v4l2_dev->name)) {
 		v4l2_err(v4l2_dev, "port 0x%x already in use\n", isa->io);
 		kfree(isa);
 		return -EBUSY;
@@ -300,8 +276,8 @@ int radio_isa_probe(struct device *pdev, unsigned int dev)
 		v4l2_err(v4l2_dev, "Could not setup card\n");
 		goto err_node_reg;
 	}
-	res = video_register_device(&isa->vdev, VFL_TYPE_RADIO,
-					drv->radio_nr_params[dev]);
+	res = video_register_device(&isa->vdev, VFL_TYPE_RADIO, radio_nr);
+
 	if (res < 0) {
 		v4l2_err(v4l2_dev, "Could not register device node\n");
 		goto err_node_reg;
@@ -316,24 +292,110 @@ err_node_reg:
 err_hdl:
 	v4l2_device_unregister(&isa->v4l2_dev);
 err_dev_reg:
-	release_region(isa->io, drv->region_size);
+	release_region(isa->io, region_size);
 	kfree(isa);
 	return res;
 }
-EXPORT_SYMBOL_GPL(radio_isa_probe);
 
-int radio_isa_remove(struct device *pdev, unsigned int dev)
+int radio_isa_common_remove(struct radio_isa_card *isa, unsigned region_size)
 {
-	struct radio_isa_card *isa = dev_get_drvdata(pdev);
 	const struct radio_isa_ops *ops = isa->drv->ops;
 
 	ops->s_mute_volume(isa, true, isa->volume ? isa->volume->cur.val : 0);
 	video_unregister_device(&isa->vdev);
 	v4l2_ctrl_handler_free(&isa->hdl);
 	v4l2_device_unregister(&isa->v4l2_dev);
-	release_region(isa->io, isa->drv->region_size);
+	release_region(isa->io, region_size);
 	v4l2_info(&isa->v4l2_dev, "Removed radio card %s\n", isa->drv->card);
 	kfree(isa);
 	return 0;
 }
+
+int radio_isa_probe(struct device *pdev, unsigned int dev)
+{
+	struct radio_isa_driver *drv = pdev->platform_data;
+	const struct radio_isa_ops *ops = drv->ops;
+	struct v4l2_device *v4l2_dev;
+	struct radio_isa_card *isa;
+
+	isa = radio_isa_alloc(drv, pdev);
+	if (!isa)
+		return -ENOMEM;
+	isa->io = drv->io_params[dev];
+	v4l2_dev = &isa->v4l2_dev;
+
+	if (drv->probe && ops->probe) {
+		int i;
+
+		for (i = 0; i < drv->num_of_io_ports; ++i) {
+			int io = drv->io_ports[i];
+
+			if (request_region(io, drv->region_size, v4l2_dev->name)) {
+				bool found = ops->probe(isa, io);
+
+				release_region(io, drv->region_size);
+				if (found) {
+					isa->io = io;
+					break;
+				}
+			}
+		}
+	}
+
+	if (!radio_isa_valid_io(drv, isa->io)) {
+		int i;
+
+		if (isa->io < 0)
+			return -ENODEV;
+		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x%03x",
+				drv->io_ports[0]);
+		for (i = 1; i < drv->num_of_io_ports; i++)
+			printk(KERN_CONT "/0x%03x", drv->io_ports[i]);
+		printk(KERN_CONT ".\n");
+		kfree(isa);
+		return -EINVAL;
+	}
+
+	return radio_isa_common_probe(isa, pdev, drv->radio_nr_params[dev],
+					drv->region_size);
+}
+EXPORT_SYMBOL_GPL(radio_isa_probe);
+
+int radio_isa_remove(struct device *pdev, unsigned int dev)
+{
+	struct radio_isa_card *isa = dev_get_drvdata(pdev);
+
+	return radio_isa_common_remove(isa, isa->drv->region_size);
+}
 EXPORT_SYMBOL_GPL(radio_isa_remove);
+
+#ifdef CONFIG_PNP
+int radio_isa_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
+{
+	struct pnp_driver *pnp_drv = to_pnp_driver(dev->dev.driver);
+	struct radio_isa_driver *drv = container_of(pnp_drv,
+					struct radio_isa_driver, pnp_driver);
+	struct radio_isa_card *isa;
+
+	if (!pnp_port_valid(dev, 0))
+		return -ENODEV;
+
+	isa = radio_isa_alloc(drv, &dev->dev);
+	if (!isa)
+		return -ENOMEM;
+
+	isa->io = pnp_port_start(dev, 0);
+
+	return radio_isa_common_probe(isa, &dev->dev, drv->radio_nr_params[0],
+					pnp_port_len(dev, 0));
+}
+EXPORT_SYMBOL_GPL(radio_isa_pnp_probe);
+
+void radio_isa_pnp_remove(struct pnp_dev *dev)
+{
+	struct radio_isa_card *isa = dev_get_drvdata(&dev->dev);
+
+	radio_isa_common_remove(isa, pnp_port_len(dev, 0));
+}
+EXPORT_SYMBOL_GPL(radio_isa_pnp_remove);
+#endif
diff --git a/drivers/media/radio/radio-isa.h b/drivers/media/radio/radio-isa.h
index 8a0ea84..ba4c01f 100644
--- a/drivers/media/radio/radio-isa.h
+++ b/drivers/media/radio/radio-isa.h
@@ -24,6 +24,7 @@
 #define _RADIO_ISA_H_
 
 #include <linux/isa.h>
+#include <linux/pnp.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
@@ -76,6 +77,9 @@ struct radio_isa_ops {
 /* Top level structure needed to instantiate the cards */
 struct radio_isa_driver {
 	struct isa_driver driver;
+#ifdef CONFIG_PNP
+	struct pnp_driver pnp_driver;
+#endif
 	const struct radio_isa_ops *ops;
 	/* The module_param_array with the specified I/O ports */
 	int *io_params;
@@ -101,5 +105,10 @@ struct radio_isa_driver {
 int radio_isa_match(struct device *pdev, unsigned int dev);
 int radio_isa_probe(struct device *pdev, unsigned int dev);
 int radio_isa_remove(struct device *pdev, unsigned int dev);
+#ifdef CONFIG_PNP
+int radio_isa_pnp_probe(struct pnp_dev *dev,
+			const struct pnp_device_id *dev_id);
+void radio_isa_pnp_remove(struct pnp_dev *dev);
+#endif
 
 #endif


-- 
Ondrej Zary
