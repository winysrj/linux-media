Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4998 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3CKLzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:55:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 22/42] go7007: fix DMA related errors.
Date: Mon, 11 Mar 2013 12:46:00 +0100
Message-Id: <8651ee3d9d126c8a187b41c57264c94fe22e19b6.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Don't pass data allocated on the stack to usb_control_msg.
- Use dma_mapping_error after calling dma_map_page().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-priv.h    |    1 +
 drivers/staging/media/go7007/go7007-usb.c     |   36 +++++++++++--------------
 drivers/staging/media/go7007/s2250-board.c    |    2 +-
 drivers/staging/media/go7007/saa7134-go7007.c |    4 +--
 4 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 1c4b049..daae6dd 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -188,6 +188,7 @@ struct go7007 {
 	int audio_enabled;
 	struct v4l2_subdev *sd_video;
 	struct v4l2_subdev *sd_audio;
+	u8 usb_buf[16];
 
 	/* Video input */
 	int input;
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 0b1af50..f496720 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -652,7 +652,7 @@ static int go7007_usb_ezusb_write_interrupt(struct go7007 *go,
 {
 	struct go7007_usb *usb = go->hpi_context;
 	int i, r;
-	u16 status_reg;
+	u16 status_reg = 0;
 	int timeout = 500;
 
 #ifdef GO7007_USB_DEBUG
@@ -664,15 +664,17 @@ static int go7007_usb_ezusb_write_interrupt(struct go7007 *go,
 		r = usb_control_msg(usb->usbdev,
 				usb_rcvctrlpipe(usb->usbdev, 0), 0x14,
 				USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-				0, HPI_STATUS_ADDR, &status_reg,
+				0, HPI_STATUS_ADDR, go->usb_buf,
 				sizeof(status_reg), timeout);
 		if (r < 0)
-			goto write_int_error;
-		__le16_to_cpus(&status_reg);
+			break;
+		status_reg = le16_to_cpu(*((u16 *)go->usb_buf));
 		if (!(status_reg & 0x0010))
 			break;
 		msleep(10);
 	}
+	if (r < 0)
+		goto write_int_error;
 	if (i == 100) {
 		printk(KERN_ERR
 			"go7007-usb: device is hung, status reg = 0x%04x\n",
@@ -700,7 +702,6 @@ static int go7007_usb_onboard_write_interrupt(struct go7007 *go,
 						int addr, int data)
 {
 	struct go7007_usb *usb = go->hpi_context;
-	u8 *tbuf;
 	int r;
 	int timeout = 500;
 
@@ -709,17 +710,14 @@ static int go7007_usb_onboard_write_interrupt(struct go7007 *go,
 		"go7007-usb: WriteInterrupt: %04x %04x\n", addr, data);
 #endif
 
-	tbuf = kzalloc(8, GFP_KERNEL);
-	if (tbuf == NULL)
-		return -ENOMEM;
-	tbuf[0] = data & 0xff;
-	tbuf[1] = data >> 8;
-	tbuf[2] = addr & 0xff;
-	tbuf[3] = addr >> 8;
+	go->usb_buf[0] = data & 0xff;
+	go->usb_buf[1] = data >> 8;
+	go->usb_buf[2] = addr & 0xff;
+	go->usb_buf[3] = addr >> 8;
+	go->usb_buf[4] = go->usb_buf[5] = go->usb_buf[6] = go->usb_buf[7] = 0;
 	r = usb_control_msg(usb->usbdev, usb_sndctrlpipe(usb->usbdev, 2), 0x00,
 			USB_TYPE_VENDOR | USB_RECIP_ENDPOINT, 0x55aa,
-			0xf0f0, tbuf, 8, timeout);
-	kfree(tbuf);
+			0xf0f0, go->usb_buf, 8, timeout);
 	if (r < 0) {
 		printk(KERN_ERR "go7007-usb: error in WriteInterrupt: %d\n", r);
 		return r;
@@ -913,7 +911,7 @@ static int go7007_usb_i2c_master_xfer(struct i2c_adapter *adapter,
 {
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct go7007_usb *usb = go->hpi_context;
-	u8 buf[16];
+	u8 *buf = go->usb_buf;
 	int buf_len, i;
 	int ret = -EIO;
 
@@ -1169,14 +1167,12 @@ static int go7007_usb_probe(struct usb_interface *intf,
 
 	/* Probe the tuner model on the TV402U */
 	if (go->board_id == GO7007_BOARDID_PX_TV402U_ANY) {
-		u8 data[3];
-
 		/* Board strapping indicates tuner model */
-		if (go7007_usb_vendor_request(go, 0x41, 0, 0, data, 3, 1) < 0) {
+		if (go7007_usb_vendor_request(go, 0x41, 0, 0, go->usb_buf, 3, 1) < 0) {
 			printk(KERN_ERR "go7007-usb: GPIO read failed!\n");
 			goto initfail;
 		}
-		switch (data[0] >> 6) {
+		switch (go->usb_buf[0] >> 6) {
 		case 1:
 			go->board_id = GO7007_BOARDID_PX_TV402U_EU;
 			go->tuner_type = TUNER_SONY_BTF_PG472Z;
@@ -1309,8 +1305,8 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 
 	kfree(go->hpi_context);
 
-	go7007_remove(go);
 	go->status = STATUS_SHUTDOWN;
+	go7007_remove(go);
 }
 
 static struct usb_driver go7007_usb_driver = {
diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index 37400bf..2266e1b 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -584,7 +584,7 @@ static int s2250_probe(struct i2c_client *client,
 	if (audio == NULL)
 		return -ENOMEM;
 
-	state = kmalloc(sizeof(struct s2250), GFP_KERNEL);
+	state = kzalloc(sizeof(struct s2250), GFP_KERNEL);
 	if (state == NULL) {
 		i2c_unregister_device(audio);
 		return -ENOMEM;
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index d65e17a..afe21f3 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -261,12 +261,12 @@ static int saa7134_go7007_stream_start(struct go7007 *go)
 
 	saa->top_dma = dma_map_page(&dev->pci->dev, virt_to_page(saa->top),
 			0, PAGE_SIZE, DMA_FROM_DEVICE);
-	if (!saa->top_dma)
+	if (dma_mapping_error(&dev->pci->dev, saa->top_dma))
 		return -ENOMEM;
 	saa->bottom_dma = dma_map_page(&dev->pci->dev,
 			virt_to_page(saa->bottom),
 			0, PAGE_SIZE, DMA_FROM_DEVICE);
-	if (!saa->bottom_dma) {
+	if (dma_mapping_error(&dev->pci->dev, saa->bottom_dma)) {
 		dma_unmap_page(&dev->pci->dev, saa->top_dma, PAGE_SIZE,
 				DMA_FROM_DEVICE);
 		return -ENOMEM;
-- 
1.7.10.4

