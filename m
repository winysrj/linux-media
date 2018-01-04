Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:44326 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753284AbeADW0D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 17:26:03 -0500
From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tomoki.sekiyama@gmail.com
Subject: [PATCH] media: siano: Fix coherent memory allocation failure on some arch
Date: Thu,  4 Jan 2018 22:24:40 +0000
Message-Id: <1515104680-17054-1-git-send-email-tomoki.sekiyama@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On some architectures like arm64, coherent memory allocation for
USB devices fails by following error:

[  663.556135] usbcore: deregistering interface driver smsusb
[  683.624809] smsusb:smsusb_probe: board id=18, interface number 0
[  683.633530] smsusb:smsusb_init_device: smscore_register_device(...) failed, rc -12
[  683.641501] smsusb:smsusb_probe: Device initialized with return code -12
[  683.652978] smsusb: probe of 1-1:1.0 failed with error -12

This is caused by dma_alloc_coherent(NULL, ...) returning NULL in
smscoreapi.c.

To fix this error, usb_alloc_coherent() must be used for DMA
memory allocation for USB devices in such architectures.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
---
 drivers/media/common/siano/smscoreapi.c | 34 +++++++++++++++++++++++----------
 drivers/media/common/siano/smscoreapi.h |  2 ++
 drivers/media/usb/siano/smsusb.c        |  1 +
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index c5c827e..8d0e7a6 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -690,17 +690,23 @@ int smscore_register_device(struct smsdevice_params_t *params,
 
 	/* alloc common buffer */
 	dev->common_buffer_size = params->buffer_size * params->num_buffers;
-	dev->common_buffer = dma_alloc_coherent(NULL, dev->common_buffer_size,
-						&dev->common_buffer_phys,
-						GFP_KERNEL | GFP_DMA);
-	if (!dev->common_buffer) {
+	if (params->usb_device)
+		buffer = usb_alloc_coherent(params->usb_device,
+					    dev->common_buffer_size,
+					    GFP_KERNEL | GFP_DMA,
+					    &dev->common_buffer_phys);
+	else
+		buffer = dma_alloc_coherent(NULL, dev->common_buffer_size,
+					    &dev->common_buffer_phys,
+					    GFP_KERNEL | GFP_DMA);
+	if (!buffer) {
 		smscore_unregister_device(dev);
 		return -ENOMEM;
 	}
+	dev->common_buffer = buffer;
 
 	/* prepare dma buffers */
-	for (buffer = dev->common_buffer;
-	     dev->num_buffers < params->num_buffers;
+	for (; dev->num_buffers < params->num_buffers;
 	     dev->num_buffers++, buffer += params->buffer_size) {
 		struct smscore_buffer_t *cb;
 
@@ -720,6 +726,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	dev->board_id = SMS_BOARD_UNKNOWN;
 	dev->context = params->context;
 	dev->device = params->device;
+	dev->usb_device = params->usb_device;
 	dev->setmode_handler = params->setmode_handler;
 	dev->detectmode_handler = params->detectmode_handler;
 	dev->sendrequest_handler = params->sendrequest_handler;
@@ -1231,10 +1238,17 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 
 	pr_debug("freed %d buffers\n", num_buffers);
 
-	if (coredev->common_buffer)
-		dma_free_coherent(NULL, coredev->common_buffer_size,
-			coredev->common_buffer, coredev->common_buffer_phys);
-
+	if (coredev->common_buffer) {
+		if (coredev->usb_device)
+			usb_free_coherent(coredev->usb_device,
+					  coredev->common_buffer_size,
+					  coredev->common_buffer,
+					  coredev->common_buffer_phys);
+		else
+			dma_free_coherent(NULL, coredev->common_buffer_size,
+					  coredev->common_buffer,
+					  coredev->common_buffer_phys);
+	}
 	kfree(coredev->fw_buf);
 
 	list_del(&coredev->entry);
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 4cc39e4..134c69f 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -134,6 +134,7 @@ struct smscore_buffer_t {
 
 struct smsdevice_params_t {
 	struct device	*device;
+	struct usb_device	*usb_device;
 
 	int				buffer_size;
 	int				num_buffers;
@@ -176,6 +177,7 @@ struct smscore_device_t {
 
 	void *context;
 	struct device *device;
+	struct usb_device *usb_device;
 
 	char devpath[32];
 	unsigned long device_flags;
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index d07349c..7e8e803 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -446,6 +446,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		dev->in_ep, dev->out_ep);
 
 	params.device = &dev->udev->dev;
+	params.usb_device = dev->udev;
 	params.buffer_size = dev->buffer_size;
 	params.num_buffers = MAX_BUFFERS;
 	params.sendrequest_handler = smsusb_sendrequest;
-- 
2.7.4
