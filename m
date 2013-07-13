Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49765 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3GMWqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Jul 2013 18:46:24 -0400
From: Alexey Khoroshilov <alexey.khoroshilov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] [media] dvb-usb: fix error handling in ttusb_dec_probe()
Date: Sun, 14 Jul 2013 02:45:52 +0400
Message-Id: <1373755552-25337-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is an asymmetry in ttusb_dec_init_usb()-ttusb_init_rc()
and ttusb_dec_exit_usb()-ttusb_dec_exit_rc() in terms of resources
allocated-deallocated. irq_urb and irq_buffer are allocated in
ttusb_dec_init_usb(), while they are deallocated in ttusb_dec_exit_rc().
As a result there is a leak of them in ttusb_dec_probe().

The patch fixes the asymmetry and a leak on a failure path in ttusb_dec_init_usb().
By the way, it
- removes usage of -1 as a custom error code,
- replaces GFP_ATOMIC by GFP_KERNEL in usb_alloc_coherent() in ttusb_dec_init_usb()
  as soon as all other memory allocation done with GFP_KERNEL;
- refactors ttusb_dec_boot_dsp() in an equivalent way except for returning 0
  instead of 1 if ttusb_dec_boot_dsp() succeed in (!mode) branch.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 152 +++++++++++++++++---------------
 1 file changed, 82 insertions(+), 70 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index e52c3b9..29724af 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -366,7 +366,7 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
 		}
 		return 0;
 	} else {
-		return -1;
+		return -ENOENT;
 	}
 }
 
@@ -1241,6 +1241,8 @@ static void ttusb_dec_init_v_pes(struct ttusb_dec *dec)
 
 static int ttusb_dec_init_usb(struct ttusb_dec *dec)
 {
+	int result;
+
 	dprintk("%s\n", __func__);
 
 	mutex_init(&dec->usb_mutex);
@@ -1258,7 +1260,7 @@ static int ttusb_dec_init_usb(struct ttusb_dec *dec)
 			return -ENOMEM;
 		}
 		dec->irq_buffer = usb_alloc_coherent(dec->udev,IRQ_PACKET_SIZE,
-					GFP_ATOMIC, &dec->irq_dma_handle);
+					GFP_KERNEL, &dec->irq_dma_handle);
 		if(!dec->irq_buffer) {
 			usb_free_urb(dec->irq_urb);
 			return -ENOMEM;
@@ -1270,7 +1272,13 @@ static int ttusb_dec_init_usb(struct ttusb_dec *dec)
 		dec->irq_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 	}
 
-	return ttusb_dec_alloc_iso_urbs(dec);
+	result = ttusb_dec_alloc_iso_urbs(dec);
+	if (result) {
+		usb_free_urb(dec->irq_urb);
+		usb_free_coherent(dec->udev, IRQ_PACKET_SIZE,
+				  dec->irq_buffer, dec->irq_dma_handle);
+	}
+	return result;
 }
 
 static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
@@ -1293,10 +1301,11 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 
 	dprintk("%s\n", __func__);
 
-	if (request_firmware(&fw_entry, dec->firmware_name, &dec->udev->dev)) {
+	result = request_firmware(&fw_entry, dec->firmware_name, &dec->udev->dev);
+	if (result) {
 		printk(KERN_ERR "%s: Firmware (%s) unavailable.\n",
 		       __func__, dec->firmware_name);
-		return 1;
+		return result;
 	}
 
 	firmware = fw_entry->data;
@@ -1306,7 +1315,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 		printk("%s: firmware size too small for DSP code (%zu < 60).\n",
 			__func__, firmware_size);
 		release_firmware(fw_entry);
-		return -1;
+		return -ENOENT;
 	}
 
 	/* a 32 bit checksum over the first 56 bytes of the DSP Code is stored
@@ -1320,7 +1329,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 		       "0x%08x != 0x%08x in file), file invalid.\n",
 			__func__, crc32_csum, crc32_check);
 		release_firmware(fw_entry);
-		return -1;
+		return -ENOENT;
 	}
 	memcpy(idstring, &firmware[36], 20);
 	idstring[20] = '\0';
@@ -1389,55 +1398,48 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 	dprintk("%s\n", __func__);
 
 	result = ttusb_dec_get_stb_state(dec, &mode, &model, &version);
+	if (result)
+		return result;
 
-	if (!result) {
-		if (!mode) {
-			if (version == 0xABCDEFAB)
-				printk(KERN_INFO "ttusb_dec: no version "
-				       "info in Firmware\n");
-			else
-				printk(KERN_INFO "ttusb_dec: Firmware "
-				       "%x.%02x%c%c\n",
-				       version >> 24, (version >> 16) & 0xff,
-				       (version >> 8) & 0xff, version & 0xff);
-
-			result = ttusb_dec_boot_dsp(dec);
-			if (result)
-				return result;
-			else
-				return 1;
-		} else {
-			/* We can't trust the USB IDs that some firmwares
-			   give the box */
-			switch (model) {
-			case 0x00070001:
-			case 0x00070008:
-			case 0x0007000c:
-				ttusb_dec_set_model(dec, TTUSB_DEC3000S);
-				break;
-			case 0x00070009:
-			case 0x00070013:
-				ttusb_dec_set_model(dec, TTUSB_DEC2000T);
-				break;
-			case 0x00070011:
-				ttusb_dec_set_model(dec, TTUSB_DEC2540T);
-				break;
-			default:
-				printk(KERN_ERR "%s: unknown model returned "
-				       "by firmware (%08x) - please report\n",
-				       __func__, model);
-				return -1;
-				break;
-			}
+	if (!mode) {
+		if (version == 0xABCDEFAB)
+			printk(KERN_INFO "ttusb_dec: no version "
+			       "info in Firmware\n");
+		else
+			printk(KERN_INFO "ttusb_dec: Firmware "
+			       "%x.%02x%c%c\n",
+			       version >> 24, (version >> 16) & 0xff,
+			       (version >> 8) & 0xff, version & 0xff);
 
+		result = ttusb_dec_boot_dsp(dec);
+		if (result)
+			return result;
+	} else {
+		/* We can't trust the USB IDs that some firmwares
+		   give the box */
+		switch (model) {
+		case 0x00070001:
+		case 0x00070008:
+		case 0x0007000c:
+			ttusb_dec_set_model(dec, TTUSB_DEC3000S);
+			break;
+		case 0x00070009:
+		case 0x00070013:
+			ttusb_dec_set_model(dec, TTUSB_DEC2000T);
+			break;
+		case 0x00070011:
+			ttusb_dec_set_model(dec, TTUSB_DEC2540T);
+			break;
+		default:
+			printk(KERN_ERR "%s: unknown model returned "
+			       "by firmware (%08x) - please report\n",
+			       __func__, model);
+			return -ENOENT;
+		}
 			if (version >= 0x01770000)
 				dec->can_playback = 1;
-
-			return 0;
-		}
 	}
-	else
-		return result;
+	return 0;
 }
 
 static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
@@ -1539,19 +1541,7 @@ static void ttusb_dec_exit_dvb(struct ttusb_dec *dec)
 
 static void ttusb_dec_exit_rc(struct ttusb_dec *dec)
 {
-
 	dprintk("%s\n", __func__);
-	/* we have to check whether the irq URB is already submitted.
-	  * As the irq is submitted after the interface is changed,
-	  * this is the best method i figured out.
-	  * Any others?*/
-	if (dec->interface == TTUSB_DEC_INTERFACE_IN)
-		usb_kill_urb(dec->irq_urb);
-
-	usb_free_urb(dec->irq_urb);
-
-	usb_free_coherent(dec->udev,IRQ_PACKET_SIZE,
-			  dec->irq_buffer, dec->irq_dma_handle);
 
 	if (dec->rc_input_dev) {
 		input_unregister_device(dec->rc_input_dev);
@@ -1566,6 +1556,20 @@ static void ttusb_dec_exit_usb(struct ttusb_dec *dec)
 
 	dprintk("%s\n", __func__);
 
+	if (enable_rc) {
+		/* we have to check whether the irq URB is already submitted.
+		 * As the irq is submitted after the interface is changed,
+		 * this is the best method i figured out.
+		 * Any others?*/
+		if (dec->interface == TTUSB_DEC_INTERFACE_IN)
+			usb_kill_urb(dec->irq_urb);
+
+		usb_free_urb(dec->irq_urb);
+
+		usb_free_coherent(dec->udev, IRQ_PACKET_SIZE,
+				  dec->irq_buffer, dec->irq_dma_handle);
+	}
+
 	dec->iso_stream_count = 0;
 
 	for (i = 0; i < ISO_BUF_COUNT; i++)
@@ -1623,6 +1627,7 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev;
 	struct ttusb_dec *dec;
+	int result;
 
 	dprintk("%s\n", __func__);
 
@@ -1651,13 +1656,15 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 
 	dec->udev = udev;
 
-	if (ttusb_dec_init_usb(dec))
-		return 0;
-	if (ttusb_dec_init_stb(dec)) {
-		ttusb_dec_exit_usb(dec);
-		return 0;
-	}
-	ttusb_dec_init_dvb(dec);
+	result = ttusb_dec_init_usb(dec);
+	if (result)
+		goto err_usb;
+	result = ttusb_dec_init_stb(dec);
+	if (result)
+		goto err_stb;
+	result = ttusb_dec_init_dvb(dec);
+	if (result)
+		goto err_stb;
 
 	dec->adapter.priv = dec;
 	switch (id->idProduct) {
@@ -1696,6 +1703,11 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 		ttusb_init_rc(dec);
 
 	return 0;
+err_stb:
+	ttusb_dec_exit_usb(dec);
+err_usb:
+	kfree(dec);
+	return result;
 }
 
 static void ttusb_dec_disconnect(struct usb_interface *intf)
-- 
1.8.1.2

