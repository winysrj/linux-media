Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/10] [media] siano: get rid of sms_info()
Date: Sun, 22 Feb 2015 13:11:38 -0300
Message-Id: <1424621501-17466-8-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On most cases, sms_info() should actually be pr_debug(), but,
on other places, it should be pr_info().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/smscoreapi.c  | 44 +++++++++++++++-----------------
 drivers/media/common/siano/smscoreapi.h  |  8 ------
 drivers/media/common/siano/smsdvb-main.c | 10 ++++----
 drivers/media/usb/siano/smsusb.c         | 29 +++++++++++----------
 4 files changed, 40 insertions(+), 51 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index e5bde84ec0be..36b44ce1373e 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -636,10 +636,8 @@ smscore_buffer_t *smscore_createbuffer(u8 *buffer, void *common_buffer,
 	struct smscore_buffer_t *cb;
 
 	cb = kzalloc(sizeof(struct smscore_buffer_t), GFP_KERNEL);
-	if (!cb) {
-		sms_info("kzalloc(...) failed");
+	if (!cb)
 		return NULL;
-	}
 
 	cb->p = buffer;
 	cb->offset_in_common = buffer - (u8 *) common_buffer;
@@ -665,10 +663,8 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	u8 *buffer;
 
 	dev = kzalloc(sizeof(struct smscore_device_t), GFP_KERNEL);
-	if (!dev) {
-		sms_info("kzalloc(...) failed");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	/* init list entry so it could be safe in smscore_unregister_device */
 	INIT_LIST_HEAD(&dev->entry);
@@ -723,7 +719,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 		smscore_putbuffer(dev, cb);
 	}
 
-	sms_info("allocated %d buffers", dev->num_buffers);
+	pr_debug("allocated %d buffers\n", dev->num_buffers);
 
 	dev->mode = DEVICE_MODE_NONE;
 	dev->board_id = SMS_BOARD_UNKNOWN;
@@ -747,7 +743,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 
 	*coredev = dev;
 
-	sms_info("device %p created", dev);
+	pr_debug("device %p created\n", dev);
 
 	return 0;
 }
@@ -764,7 +760,7 @@ static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
 
 	rc = coredev->sendrequest_handler(coredev->context, buffer, size);
 	if (rc < 0) {
-		sms_info("sendrequest returned error %d", rc);
+		pr_info("sendrequest returned error %d\n", rc);
 		return rc;
 	}
 
@@ -787,7 +783,7 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 	coredev->ir.dev = NULL;
 	ir_io = sms_get_board(smscore_get_board_id(coredev))->board_cfg.ir;
 	if (ir_io) {/* only if IR port exist we use IR sub-module */
-		sms_info("IR loading");
+		pr_debug("IR loading\n");
 		rc = sms_ir_init(coredev);
 
 		if	(rc != 0)
@@ -816,7 +812,7 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 				pr_err("Sending IR initialization message failed\n");
 		}
 	} else
-		sms_info("IR port has not been detected");
+		pr_info("IR port has not been detected\n");
 
 	return 0;
 }
@@ -890,12 +886,12 @@ int smscore_start_device(struct smscore_device_t *coredev)
 
 	rc = smscore_set_device_mode(coredev, mode);
 	if (rc < 0) {
-		sms_info("set device mode faile , rc %d", rc);
+		pr_info("set device mode failed , rc %d\n", rc);
 		return rc;
 	}
 	rc = smscore_configure_board(coredev);
 	if (rc < 0) {
-		sms_info("configure board failed , rc %d", rc);
+		pr_info("configure board failed , rc %d\n", rc);
 		return rc;
 	}
 
@@ -904,7 +900,7 @@ int smscore_start_device(struct smscore_device_t *coredev)
 	rc = smscore_notify_callbacks(coredev, coredev->device, 1);
 	smscore_init_ir(coredev);
 
-	sms_info("device %p started, rc %d", coredev, rc);
+	pr_debug("device %p started, rc %d\n", coredev, rc);
 
 	kmutex_unlock(&g_smscore_deviceslock);
 
@@ -927,7 +923,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 
 	mem_address = firmware->start_address;
 
-	sms_info("loading FW to addr 0x%x size %d",
+	pr_debug("loading FW to addr 0x%x size %d\n",
 		 mem_address, firmware->length);
 	if (coredev->preload_handler) {
 		rc = coredev->preload_handler(coredev->context);
@@ -1169,7 +1165,7 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 		pr_err("failed to open firmware file '%s'\n", fw_filename);
 		return rc;
 	}
-	sms_info("read fw %s, buffer size=0x%zx", fw_filename, fw->size);
+	pr_debug("read fw %s, buffer size=0x%zx\n", fw_filename, fw->size);
 	fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
 			 GFP_KERNEL | GFP_DMA);
 	if (!fw_buf) {
@@ -1227,18 +1223,18 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 		if (num_buffers == coredev->num_buffers)
 			break;
 		if (++retry > 10) {
-			sms_info("exiting although not all buffers released.");
+			pr_info("exiting although not all buffers released.\n");
 			break;
 		}
 
-		sms_info("waiting for %d buffer(s)",
+		pr_debug("waiting for %d buffer(s)\n",
 			 coredev->num_buffers - num_buffers);
 		kmutex_unlock(&g_smscore_deviceslock);
 		msleep(100);
 		kmutex_lock(&g_smscore_deviceslock);
 	}
 
-	sms_info("freed %d buffers", num_buffers);
+	pr_debug("freed %d buffers\n", num_buffers);
 
 	if (coredev->common_buffer)
 		dma_free_coherent(NULL, coredev->common_buffer_size,
@@ -1251,7 +1247,7 @@ void smscore_unregister_device(struct smscore_device_t *coredev)
 
 	kmutex_unlock(&g_smscore_deviceslock);
 
-	sms_info("device %p destroyed", coredev);
+	pr_debug("device %p destroyed\n", coredev);
 }
 EXPORT_SYMBOL_GPL(smscore_unregister_device);
 
@@ -1358,7 +1354,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 		}
 
 		if (coredev->mode == mode) {
-			sms_info("device mode %d already set", mode);
+			pr_debug("device mode %d already set\n", mode);
 			return 0;
 		}
 
@@ -1366,9 +1362,9 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 			rc = smscore_load_firmware_from_file(coredev,
 							     mode, NULL);
 			if (rc >= 0)
-				sms_info("firmware download success");
+				pr_debug("firmware download success\n");
 		} else {
-			sms_info("mode %d is already supported by running firmware",
+			pr_debug("mode %d is already supported by running firmware\n",
 				 mode);
 		}
 		if (coredev->fw_version >= 0x800) {
@@ -1776,7 +1772,7 @@ void smscore_unregister_client(struct smscore_client_t *client)
 		kfree(identry);
 	}
 
-	sms_info("%p", client->context);
+	pr_debug("%p\n", client->context);
 
 	list_del(&client->entry);
 	kfree(client);
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index ef735681cb8e..6ff8f64a3794 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -1176,12 +1176,4 @@ int smscore_led_state(struct smscore_device_t *core, int led);
 
 /* ------------------------------------------------------------------------ */
 
-#define DBG_INFO 1
-#define DBG_ADV  2
-
-#define sms_info(fmt, arg...) do {\
-	if (sms_dbg & DBG_INFO) \
-		pr_info(fmt "\n", ##arg); \
-} while (0)
-
 #endif /* __SMS_CORE_API_H__ */
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 7f1d497ca298..43bd45871b95 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -591,7 +591,7 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 		is_status_update = true;
 		break;
 	default:
-		sms_info("message not handled");
+		pr_debug("message not handled\n");
 	}
 	smscore_putbuffer(client->coredev, cb);
 
@@ -884,7 +884,7 @@ static int smsdvb_dvbt_set_frontend(struct dvb_frontend *fe)
 	msg.Data[0] = c->frequency;
 	msg.Data[2] = 12000000;
 
-	sms_info("%s: freq %d band %d", __func__, c->frequency,
+	pr_debug("%s: freq %d band %d\n", __func__, c->frequency,
 		 c->bandwidth_hz);
 
 	switch (c->bandwidth_hz / 1000000) {
@@ -969,7 +969,7 @@ static int smsdvb_isdbt_set_frontend(struct dvb_frontend *fe)
 
 	c->bandwidth_hz = 6000000;
 
-	sms_info("%s: freq %d segwidth %d segindex %d", __func__,
+	pr_debug("freq %d segwidth %d segindex %d\n",
 		 c->frequency, c->isdbt_sb_segment_count,
 		 c->isdbt_sb_segment_idx);
 
@@ -1187,11 +1187,11 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	client->event_unc_state = -1;
 	sms_board_dvb3_event(client, DVB3_EVENT_HOTPLUG);
 
-	sms_info("success");
+	pr_debug("success\n");
 	sms_board_setup(coredev);
 
 	if (smsdvb_debugfs_create(client) < 0)
-		sms_info("failed to create debugfs node");
+		pr_info("failed to create debugfs node\n");
 
 	dvb_create_media_graph(coredev->media_dev);
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 454f450997a3..29ef7d8dab7b 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -275,14 +275,14 @@ static int smsusb1_load_firmware(struct usb_device *udev, int id, int board_id)
 		rc = usb_bulk_msg(udev, usb_sndbulkpipe(udev, 2),
 				  fw_buffer, fw->size, &dummy, 1000);
 
-		sms_info("sent %zu(%d) bytes, rc %d", fw->size, dummy, rc);
+		pr_debug("sent %zu(%d) bytes, rc %d\n", fw->size, dummy, rc);
 
 		kfree(fw_buffer);
 	} else {
 		pr_err("failed to allocate firmware buffer\n");
 		rc = -ENOMEM;
 	}
-	sms_info("read FW %s, size=%zu", fw_filename, fw->size);
+	pr_debug("read FW %s, size=%zu\n", fw_filename, fw->size);
 
 	release_firmware(fw);
 
@@ -308,7 +308,7 @@ static void smsusb1_detectmode(void *context, int *mode)
 	else if (strstr(product_string, "TDMB"))
 		*mode = 2;
 
-	sms_info("%d \"%s\"", *mode, product_string);
+	pr_debug("%d \"%s\"\n", *mode, product_string);
 }
 
 static int smsusb1_setmode(void *context, int mode)
@@ -337,7 +337,7 @@ static void smsusb_term_device(struct usb_interface *intf)
 		if (dev->coredev)
 			smscore_unregister_device(dev->coredev);
 
-		sms_info("device 0x%p destroyed", dev);
+		pr_debug("device 0x%p destroyed\n", dev);
 		kfree(dev);
 	}
 
@@ -375,7 +375,7 @@ static void siano_media_device_register(struct smsusb_device_t *dev)
 
 	dev->coredev->media_dev = mdev;
 
-	sms_info("media controller created");
+	pr_info("media controller created\n");
 
 #endif
 }
@@ -427,7 +427,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 			dev->out_ep = intf->cur_altsetting->endpoint[i].desc.bEndpointAddress;
 	}
 
-	sms_info("in_ep = %02x, out_ep = %02x",
+	pr_debug("in_ep = %02x, out_ep = %02x\n",
 		dev->in_ep, dev->out_ep);
 
 	params.device = &dev->udev->dev;
@@ -455,7 +455,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		usb_init_urb(&dev->surbs[i].urb);
 	}
 
-	sms_info("smsusb_start_streaming(...).");
+	pr_debug("smsusb_start_streaming(...).\n");
 	rc = smsusb_start_streaming(dev);
 	if (rc < 0) {
 		pr_err("smsusb_start_streaming(...) failed\n");
@@ -472,7 +472,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		return rc;
 	}
 
-	sms_info("device 0x%p created", dev);
+	pr_debug("device 0x%p created\n", dev);
 	siano_media_device_register(dev);
 
 	return rc;
@@ -485,7 +485,7 @@ static int smsusb_probe(struct usb_interface *intf,
 	char devpath[32];
 	int i, rc;
 
-	sms_info("board id=%lu, interface number %d",
+	pr_info("board id=%lu, interface number %d\n",
 		 id->driver_info,
 		 intf->cur_altsetting->desc.bInterfaceNumber);
 
@@ -507,10 +507,10 @@ static int smsusb_probe(struct usb_interface *intf,
 		}
 	}
 
-	sms_info("smsusb_probe %d",
+	pr_debug("smsusb_probe %d\n",
 	       intf->cur_altsetting->desc.bInterfaceNumber);
 	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
-		sms_info("endpoint %d %02x %02x %d", i,
+		pr_debug("endpoint %d %02x %02x %d\n", i,
 		       intf->cur_altsetting->endpoint[i].desc.bEndpointAddress,
 		       intf->cur_altsetting->endpoint[i].desc.bmAttributes,
 		       intf->cur_altsetting->endpoint[i].desc.wMaxPacketSize);
@@ -533,14 +533,15 @@ static int smsusb_probe(struct usb_interface *intf,
 
 		snprintf(devpath, sizeof(devpath), "usb\\%d-%s",
 			 udev->bus->busnum, udev->devpath);
-		sms_info("stellar device in cold state was found at %s.", devpath);
+		pr_info("stellar device in cold state was found at %s.\n",
+			devpath);
 		rc = smsusb1_load_firmware(
 				udev, smscore_registry_getmode(devpath),
 				id->driver_info);
 
 		/* This device will reset and gain another USB ID */
 		if (!rc)
-			sms_info("stellar device now in warm state");
+			pr_info("stellar device now in warm state\n");
 		else
 			pr_err("Failed to put stellar in warm state. Error: %d\n", rc);
 
@@ -549,7 +550,7 @@ static int smsusb_probe(struct usb_interface *intf,
 		rc = smsusb_init_device(intf, id->driver_info);
 	}
 
-	sms_info("Device initialized with return code %d", rc);
+	pr_info("Device initialized with return code %d\n", rc);
 	sms_board_load_modules(id->driver_info);
 	return rc;
 }
-- 
2.1.0

