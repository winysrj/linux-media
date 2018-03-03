Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:45738 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751827AbeCCSVq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 13:21:46 -0500
From: tomoki.sekiyama@gmail.com
To: mchehab@s-opensource.com
Cc: elfring@users.sourceforge.net, tomoki.sekiyama@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] media: siano: Fix coherent memory allocation failure on arm64
Date: Sun,  4 Mar 2018 03:20:56 +0900
Message-Id: <20180303182056.5109-1-tomoki.sekiyama@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

On some architectures such as arm64, siano chip based TV-tuner
USB devices are not recognized correctly due to coherent memory
allocation failure with the following error:

[  663.556135] usbcore: deregistering interface driver smsusb
[  683.624809] smsusb:smsusb_probe: board id=18, interface number 0
[  683.633530] smsusb:smsusb_init_device: smscore_register_device(...) failed, rc -12
[  683.641501] smsusb:smsusb_probe: Device initialized with return code -12
[  683.652978] smsusb: probe of 1-1:1.0 failed with error -12

This is caused by dma_alloc_coherent(NULL, ...) returning NULL in
smscoreapi.c.

To fix this error, allocate the buffer memory for the USB devices
via kmalloc() and let the USB core do the DMA mapping and free.

v3: let the usb core do the DMA mapping and free
v2: non-usb `device' is also be passed to dma_alloc_coherent()

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
---
 drivers/media/common/siano/smscoreapi.c | 33 ++++++++++++++++++++++-----------
 drivers/media/common/siano/smscoreapi.h |  2 ++
 drivers/media/usb/siano/smsusb.c        |  4 ++--
 3 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index c5c827e11b64..b5dcc6d1fe90 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -631,7 +631,8 @@ smscore_buffer_t *smscore_createbuffer(u8 *buffer, void *common_buffer,
 
 	cb->p = buffer;
 	cb->offset_in_common = buffer - (u8 *) common_buffer;
-	cb->phys = common_buffer_phys + cb->offset_in_common;
+	if (common_buffer_phys)
+		cb->phys = common_buffer_phys + cb->offset_in_common;
 
 	return cb;
 }
@@ -690,17 +691,21 @@ int smscore_register_device(struct smsdevice_params_t *params,
 
 	/* alloc common buffer */
 	dev->common_buffer_size = params->buffer_size * params->num_buffers;
-	dev->common_buffer = dma_alloc_coherent(NULL, dev->common_buffer_size,
-						&dev->common_buffer_phys,
-						GFP_KERNEL | GFP_DMA);
-	if (!dev->common_buffer) {
+	if (params->usb_device)
+		buffer = kzalloc(dev->common_buffer_size, GFP_KERNEL);
+	else
+		buffer = dma_alloc_coherent(params->device,
+					    dev->common_buffer_size,
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
 
@@ -720,6 +725,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	dev->board_id = SMS_BOARD_UNKNOWN;
 	dev->context = params->context;
 	dev->device = params->device;
+	dev->usb_device = params->usb_device;
 	dev->setmode_handler = params->setmode_handler;
 	dev->detectmode_handler = params->detectmode_handler;
 	dev->sendrequest_handler = params->sendrequest_handler;
@@ -1231,10 +1237,15 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 
 	pr_debug("freed %d buffers\n", num_buffers);
 
-	if (coredev->common_buffer)
-		dma_free_coherent(NULL, coredev->common_buffer_size,
-			coredev->common_buffer, coredev->common_buffer_phys);
-
+	if (coredev->common_buffer) {
+		if (coredev->usb_device)
+			kfree(coredev->common_buffer);
+		else
+			dma_free_coherent(coredev->device,
+					  coredev->common_buffer_size,
+					  coredev->common_buffer,
+					  coredev->common_buffer_phys);
+	}
 	kfree(coredev->fw_buf);
 
 	list_del(&coredev->entry);
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 4cc39e4a8318..134c69f7ea7b 100644
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
index f13e4b01b5a5..6d436e9e454f 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -179,8 +179,7 @@ static int smsusb_submit_urb(struct smsusb_device_t *dev,
 		smsusb_onresponse,
 		surb
 	);
-	surb->urb.transfer_dma = surb->cb->phys;
-	surb->urb.transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	surb->urb.transfer_flags |= URB_FREE_BUFFER;
 
 	return usb_submit_urb(&surb->urb, GFP_ATOMIC);
 }
@@ -446,6 +445,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		dev->in_ep, dev->out_ep);
 
 	params.device = &dev->udev->dev;
+	params.usb_device = dev->udev;
 	params.buffer_size = dev->buffer_size;
 	params.num_buffers = MAX_BUFFERS;
 	params.sendrequest_handler = smsusb_sendrequest;
-- 
2.14.3
