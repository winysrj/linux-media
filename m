Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5P9f8lr015665
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 05:41:08 -0400
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5P9etrh021299
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 05:40:56 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KBRUk-000411-Vi
	for video4linux-list@redhat.com; Wed, 25 Jun 2008 09:40:54 +0000
Received: from 82-135-208-232.static.zebra.lt ([82.135.208.232])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 09:40:54 +0000
Received: from paulius.zaleckas by 82-135-208-232.static.zebra.lt with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <video4linux-list@redhat.com>; Wed, 25 Jun 2008 09:40:54 +0000
To: video4linux-list@redhat.com
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Date: Wed, 25 Jun 2008 12:40:27 +0300
Message-ID: <4862128B.9050706@teltonika.lt>
Mime-Version: 1.0
Content-Type: text/plain;
 name="patch-soc_camera_videobuf_type"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-soc_camera_videobuf_type"
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Subject: [PATCH] soc_camera: make videobuf independent
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Makes SoC camera videobuf independent. Includes all necessary changes for
PXA camera driver (currently the only driver using soc_camera in the mainline).
These changes are important for the future soc_camera based drivers.

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Index: linux-2.6.26-rc4/drivers/media/video/Kconfig
===================================================================
--- linux-2.6.26-rc4.orig/drivers/media/video/Kconfig
+++ linux-2.6.26-rc4/drivers/media/video/Kconfig
@@ -902,7 +902,7 @@ endif # V4L_USB_DRIVERS
 config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA
-	select VIDEOBUF_DMA_SG
+	select VIDEOBUF_GEN
 	help
 	  SoC Camera is a common API to several cameras, not connecting
 	  over a bus like PCI or USB. For example some i2c camera connected
@@ -941,6 +941,7 @@ config VIDEO_PXA27x
 	tristate "PXA27x Quick Capture Interface driver"
 	depends on VIDEO_DEV && PXA27x
 	select SOC_CAMERA
+	select VIDEOBUF_DMA_SG
 	---help---
 	  This is a v4l2 driver for the PXA27x Quick Capture Interface
 
Index: linux-2.6.26-rc4/include/media/soc_camera.h
===================================================================
--- linux-2.6.26-rc4.orig/include/media/soc_camera.h
+++ linux-2.6.26-rc4/include/media/soc_camera.h
@@ -13,7 +13,7 @@
 #define SOC_CAMERA_H
 
 #include <linux/videodev2.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf-core.h>
 
 struct soc_camera_device {
 	struct list_head list;
@@ -55,8 +55,6 @@ struct soc_camera_host {
 	struct list_head list;
 	struct device dev;
 	unsigned char nr;				/* Host number */
-	size_t msize;
-	struct videobuf_queue_ops *vbq_ops;
 	void *priv;
 	char *drv_name;
 	struct soc_camera_host_ops *ops;
@@ -69,6 +67,8 @@ struct soc_camera_host_ops {
 	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
 			   struct v4l2_rect *);
 	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
+	void (*init_videobuf)(struct videobuf_queue*, spinlock_t *,
+			      struct soc_camera_device *);
 	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*try_bus_param)(struct soc_camera_device *, __u32);
Index: linux-2.6.26-rc4/drivers/media/video/pxa_camera.c
===================================================================
--- linux-2.6.26-rc4.orig/drivers/media/video/pxa_camera.c
+++ linux-2.6.26-rc4/drivers/media/video/pxa_camera.c
@@ -30,6 +30,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
+#include <media/videobuf-dma-sg.h>
 #include <media/soc_camera.h>
 
 #include <linux/videodev2.h>
@@ -582,6 +583,16 @@ static struct videobuf_queue_ops pxa_vid
 	.buf_release    = pxa_videobuf_release,
 };
 
+static void pxa_camera_init_videobuf(struct videobuf_queue *q, spinlock_t *lock,
+			      struct soc_camera_device *icd)
+{
+	/* We must pass NULL as dev pointer, then all pci_* dma operations
+	 * transform to normal dma_* ones. */
+	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, lock,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
+				sizeof(struct pxa_buffer), icd);
+}
+
 static int mclk_get_divisor(struct pxa_camera_dev *pcdev)
 {
 	unsigned int mclk_10khz = pcdev->platform_mclk_10khz;
@@ -998,6 +1009,7 @@ static struct soc_camera_host_ops pxa_so
 	.remove		= pxa_camera_remove_device,
 	.set_fmt_cap	= pxa_camera_set_fmt_cap,
 	.try_fmt_cap	= pxa_camera_try_fmt_cap,
+	.init_videobuf	= pxa_camera_init_videobuf,
 	.reqbufs	= pxa_camera_reqbufs,
 	.poll		= pxa_camera_poll,
 	.querycap	= pxa_camera_querycap,
@@ -1009,8 +1021,6 @@ static struct soc_camera_host_ops pxa_so
 /* Should be allocated dynamically too, but we have only one. */
 static struct soc_camera_host pxa_soc_camera_host = {
 	.drv_name		= PXA_CAM_DRV_NAME,
-	.vbq_ops		= &pxa_videobuf_ops,
-	.msize			= sizeof(struct pxa_buffer),
 	.ops			= &pxa_soc_camera_host_ops,
 };
 
Index: linux-2.6.26-rc4/drivers/media/video/soc_camera.c
===================================================================
--- linux-2.6.26-rc4.orig/drivers/media/video/soc_camera.c
+++ linux-2.6.26-rc4/drivers/media/video/soc_camera.c
@@ -26,6 +26,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
+#include <media/videobuf-core.h>
 #include <media/soc_camera.h>
 
 static LIST_HEAD(hosts);
@@ -233,11 +234,7 @@ static int soc_camera_open(struct inode 
 	file->private_data = icf;
 	dev_dbg(&icd->dev, "camera device open\n");
 
-	/* We must pass NULL as dev pointer, then all pci_* dma operations
-	 * transform to normal dma_* ones. */
-	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, icf->lock,
-				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				ici->msize, icd);
+	ici->ops->init_videobuf(&icf->vb_vidq, icf->lock, icd);
 
 	return 0;
 
@@ -796,7 +793,7 @@ int soc_camera_host_register(struct soc_
 	int ret;
 	struct soc_camera_host *ix;
 
-	if (!ici->vbq_ops || !ici->ops->add || !ici->ops->remove)
+	if (!ici->ops->init_videobuf || !ici->ops->add || !ici->ops->remove)
 		return -EINVAL;
 
 	/* Number might be equal to the platform device ID */
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
