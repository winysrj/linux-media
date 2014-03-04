Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55926 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507AbaCDIuQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Mar 2014 03:50:16 -0500
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<hverkuil@xs4all.nl>, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 2/7] v4l: ti-vpe: register video device only when firmware is loaded
Date: Tue, 4 Mar 2014 14:19:20 +0530
Message-ID: <1393922965-15967-3-git-send-email-archit@ti.com>
In-Reply-To: <1393922965-15967-1-git-send-email-archit@ti.com>
References: <1393832008-22174-1-git-send-email-archit@ti.com>
 <1393922965-15967-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vpe fops(vpe_open in particular) should be called only when VPDMA firmware
is loaded. File operations on the video device are possible the moment it is
registered.

Currently, we register the video device for VPE at driver probe, after calling
a vpdma helper to initialize VPDMA and load firmware. This function is
non-blocking(it calls request_firmware_nowait()), and doesn't ensure that the
firmware is actually loaded when it returns.

We remove the device registration from vpe probe, and move it to a callback
provided by the vpe driver to the vpdma library, through vpdma_create().

The ready field in vpdma_data is no longer needed since we always have firmware
loaded before the device is registered.

A minor problem with this approach is that if the video_register_device
fails(which doesn't really happen), the vpe platform device would be registered.
however, there won't be any v4l2 device corresponding to it.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c |  8 +++--
 drivers/media/platform/ti-vpe/vpdma.h |  7 +++--
 drivers/media/platform/ti-vpe/vpe.c   | 55 ++++++++++++++++++++---------------
 3 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index e8175e7..73dd38e 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -781,7 +781,7 @@ static void vpdma_firmware_cb(const struct firmware *f, void *context)
 	/* already initialized */
 	if (read_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
 			VPDMA_LIST_RDY_SHFT)) {
-		vpdma->ready = true;
+		vpdma->cb(vpdma->pdev);
 		return;
 	}
 
@@ -811,7 +811,7 @@ static void vpdma_firmware_cb(const struct firmware *f, void *context)
 		goto free_buf;
 	}
 
-	vpdma->ready = true;
+	vpdma->cb(vpdma->pdev);
 
 free_buf:
 	vpdma_unmap_desc_buf(vpdma, &fw_dma_buf);
@@ -839,7 +839,8 @@ static int vpdma_load_firmware(struct vpdma_data *vpdma)
 	return 0;
 }
 
-struct vpdma_data *vpdma_create(struct platform_device *pdev)
+struct vpdma_data *vpdma_create(struct platform_device *pdev,
+		void (*cb)(struct platform_device *pdev))
 {
 	struct resource *res;
 	struct vpdma_data *vpdma;
@@ -854,6 +855,7 @@ struct vpdma_data *vpdma_create(struct platform_device *pdev)
 	}
 
 	vpdma->pdev = pdev;
+	vpdma->cb = cb;
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpdma");
 	if (res == NULL) {
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index cf40f11..bf5f8bb 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -35,8 +35,8 @@ struct vpdma_data {
 
 	struct platform_device	*pdev;
 
-	/* tells whether vpdma firmware is loaded or not */
-	bool ready;
+	/* callback to VPE driver when the firmware is loaded */
+	void (*cb)(struct platform_device *pdev);
 };
 
 enum vpdma_data_format_type {
@@ -208,6 +208,7 @@ void vpdma_set_frame_start_event(struct vpdma_data *vpdma,
 void vpdma_dump_regs(struct vpdma_data *vpdma);
 
 /* initialize vpdma, passed with VPE's platform device pointer */
-struct vpdma_data *vpdma_create(struct platform_device *pdev);
+struct vpdma_data *vpdma_create(struct platform_device *pdev,
+		void (*cb)(struct platform_device *pdev));
 
 #endif
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 623e59e..4243687 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1815,11 +1815,6 @@ static int vpe_open(struct file *file)
 
 	vpe_dbg(dev, "vpe_open\n");
 
-	if (!dev->vpdma->ready) {
-		vpe_err(dev, "vpdma firmware not loaded\n");
-		return -ENODEV;
-	}
-
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
@@ -2037,10 +2032,40 @@ static void vpe_runtime_put(struct platform_device *pdev)
 	WARN_ON(r < 0 && r != -ENOSYS);
 }
 
+static void vpe_fw_cb(struct platform_device *pdev)
+{
+	struct vpe_dev *dev = platform_get_drvdata(pdev);
+	struct video_device *vfd;
+	int ret;
+
+	vfd = &dev->vfd;
+	*vfd = vpe_videodev;
+	vfd->lock = &dev->dev_mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		vpe_err(dev, "Failed to register video device\n");
+
+		vpe_set_clock_enable(dev, 0);
+		vpe_runtime_put(pdev);
+		pm_runtime_disable(&pdev->dev);
+		v4l2_m2m_release(dev->m2m_dev);
+		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+		v4l2_device_unregister(&dev->v4l2_dev);
+
+		return;
+	}
+
+	video_set_drvdata(vfd, dev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", vpe_videodev.name);
+	dev_info(dev->v4l2_dev.dev, "Device registered as /dev/video%d\n",
+		vfd->num);
+}
+
 static int vpe_probe(struct platform_device *pdev)
 {
 	struct vpe_dev *dev;
-	struct video_device *vfd;
 	int ret, irq, func;
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
@@ -2121,28 +2146,12 @@ static int vpe_probe(struct platform_device *pdev)
 		goto runtime_put;
 	}
 
-	dev->vpdma = vpdma_create(pdev);
+	dev->vpdma = vpdma_create(pdev, vpe_fw_cb);
 	if (IS_ERR(dev->vpdma)) {
 		ret = PTR_ERR(dev->vpdma);
 		goto runtime_put;
 	}
 
-	vfd = &dev->vfd;
-	*vfd = vpe_videodev;
-	vfd->lock = &dev->dev_mutex;
-	vfd->v4l2_dev = &dev->v4l2_dev;
-
-	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
-	if (ret) {
-		vpe_err(dev, "Failed to register video device\n");
-		goto runtime_put;
-	}
-
-	video_set_drvdata(vfd, dev);
-	snprintf(vfd->name, sizeof(vfd->name), "%s", vpe_videodev.name);
-	dev_info(dev->v4l2_dev.dev, "Device registered as /dev/video%d\n",
-		vfd->num);
-
 	return 0;
 
 runtime_put:
-- 
1.8.3.2

