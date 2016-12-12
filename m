Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57841 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932272AbcLLJcw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 04:32:52 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2] [media] em28xx: don't store usb_device at struct em28xx
Date: Mon, 12 Dec 2016 07:32:33 -0200
Message-Id: <c6d48134cb2682516ed50ca0cea2675d27d985e8.1481535142.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Now that we're storing usb_interface at em28xx struct,
there's no good reason to keep storing usb_device, as we can
get it from usb_interface. So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 23 ++++++++++++++---------
 drivers/media/usb/em28xx/em28xx-cards.c | 10 +++++-----
 drivers/media/usb/em28xx/em28xx-core.c  | 29 +++++++++++++++++------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |  3 ++-
 drivers/media/usb/em28xx/em28xx-input.c | 14 ++++++++------
 drivers/media/usb/em28xx/em28xx-video.c |  9 ++++++---
 drivers/media/usb/em28xx/em28xx.h       |  1 -
 7 files changed, 52 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 7f8601427b7f..7969ddb9e2dd 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -279,6 +279,8 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 
 	if (dev->adev.users == 0) {
 		if (dev->alt == 0 || dev->is_audio_only) {
+			struct usb_device *udev = interface_to_usbdev(dev->intf);
+
 			if (dev->is_audio_only)
 				/* audio is on a separate interface */
 				dev->alt = 1;
@@ -296,7 +298,7 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 				 */
 			dprintk("changing alternate number on interface %d to %d\n",
 				dev->ifnum, dev->alt);
-			usb_set_interface(dev->udev, dev->ifnum, dev->alt);
+			usb_set_interface(udev, dev->ifnum, dev->alt);
 		}
 
 		/* Sets volume, mute, etc */
@@ -714,6 +716,7 @@ static const struct snd_pcm_ops snd_em28xx_pcm_capture = {
 
 static void em28xx_audio_free_urb(struct em28xx *dev)
 {
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int i;
 
 	for (i = 0; i < dev->adev.num_urb; i++) {
@@ -722,7 +725,7 @@ static void em28xx_audio_free_urb(struct em28xx *dev)
 		if (!urb)
 			continue;
 
-		usb_free_coherent(dev->udev, urb->transfer_buffer_length,
+		usb_free_coherent(udev, urb->transfer_buffer_length,
 				  dev->adev.transfer_buffer[i],
 				  urb->transfer_dma);
 
@@ -749,6 +752,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 {
 	struct usb_interface *intf;
 	struct usb_endpoint_descriptor *e, *ep = NULL;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int                 i, ep_size, interval, num_urb, npackets;
 	int		    urb_size, bytes_per_transfer;
 	u8 alt;
@@ -758,7 +762,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	else
 		alt = 7;
 
-	intf = usb_ifnum_to_if(dev->udev, dev->ifnum);
+	intf = usb_ifnum_to_if(udev, dev->ifnum);
 
 	if (intf->num_altsetting <= alt) {
 		dev_err(&dev->intf->dev, "alt %d doesn't exist on interface %d\n",
@@ -781,12 +785,12 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		return -ENODEV;
 	}
 
-	ep_size = em28xx_audio_ep_packet_size(dev->udev, ep);
+	ep_size = em28xx_audio_ep_packet_size(udev, ep);
 	interval = 1 << (ep->bInterval - 1);
 
 	dev_info(&dev->intf->dev,
 		 "Endpoint 0x%02x %s on intf %d alt %d interval = %d, size %d\n",
-		 EM28XX_EP_AUDIO, usb_speed_string(dev->udev->speed),
+		 EM28XX_EP_AUDIO, usb_speed_string(udev->speed),
 		 dev->ifnum, alt, interval, ep_size);
 
 	/* Calculate the number and size of URBs to better fit the audio samples */
@@ -860,7 +864,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		}
 		dev->adev.urb[i] = urb;
 
-		buf = usb_alloc_coherent(dev->udev, npackets * ep_size, GFP_ATOMIC,
+		buf = usb_alloc_coherent(udev, npackets * ep_size, GFP_ATOMIC,
 					 &urb->transfer_dma);
 		if (!buf) {
 			dev_err(&dev->intf->dev,
@@ -870,9 +874,9 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 		}
 		dev->adev.transfer_buffer[i] = buf;
 
-		urb->dev = dev->udev;
+		urb->dev = udev;
 		urb->context = dev;
-		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
+		urb->pipe = usb_rcvisocpipe(udev, EM28XX_EP_AUDIO);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer = buf;
 		urb->interval = interval;
@@ -892,6 +896,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 static int em28xx_audio_init(struct em28xx *dev)
 {
 	struct em28xx_audio *adev = &dev->adev;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	struct snd_pcm      *pcm;
 	struct snd_card     *card;
 	static int          devnr;
@@ -920,7 +925,7 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 	spin_lock_init(&adev->slock);
 	adev->sndcard = card;
-	adev->udev = dev->udev;
+	adev->udev = udev;
 
 	err = snd_pcm_new(card, "Em28xx Audio", 0, 0, 1, &pcm);
 	if (err < 0)
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 56739ce6ce16..23c67494762d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3188,6 +3188,8 @@ static void em28xx_unregister_media_device(struct em28xx *dev)
 */
 static void em28xx_release_resources(struct em28xx *dev)
 {
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
+
 	/*FIXME: I2C IR should be disconnected */
 
 	mutex_lock(&dev->lock);
@@ -3198,7 +3200,7 @@ static void em28xx_release_resources(struct em28xx *dev)
 		em28xx_i2c_unregister(dev, 1);
 	em28xx_i2c_unregister(dev, 0);
 
-	usb_put_dev(dev->udev);
+	usb_put_dev(udev);
 
 	/* Mark device as unused */
 	clear_bit(dev->devno, em28xx_devused);
@@ -3238,7 +3240,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	int retval;
 	const char *chip_name = NULL;
 
-	dev->udev = udev;
 	dev->intf = interface;
 	mutex_init(&dev->ctrl_urb_lock);
 	spin_lock_init(&dev->slock);
@@ -3277,9 +3278,8 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 			break;
 		case CHIP_ID_EM2820:
 			chip_name = "em2710/2820";
-			if (le16_to_cpu(dev->udev->descriptor.idVendor)
-								    == 0xeb1a) {
-				__le16 idProd = dev->udev->descriptor.idProduct;
+			if (le16_to_cpu(udev->descriptor.idVendor) == 0xeb1a) {
+				__le16 idProd = udev->descriptor.idProduct;
 
 				if (le16_to_cpu(idProd) == 0x2710)
 					chip_name = "em2710";
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index f1b4681f3c90..19ccff41c7eb 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -82,7 +82,8 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 			    char *buf, int len)
 {
 	int ret;
-	int pipe = usb_rcvctrlpipe(dev->udev, 0);
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
+	int pipe = usb_rcvctrlpipe(udev, 0);
 
 	if (dev->disconnected)
 		return -ENODEV;
@@ -97,7 +98,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 		     len & 0xff, len >> 8);
 
 	mutex_lock(&dev->ctrl_urb_lock);
-	ret = usb_control_msg(dev->udev, pipe, req,
+	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	if (ret < 0) {
@@ -154,7 +155,8 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 			  int len)
 {
 	int ret;
-	int pipe = usb_sndctrlpipe(dev->udev, 0);
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
+	int pipe = usb_sndctrlpipe(udev, 0);
 
 	if (dev->disconnected)
 		return -ENODEV;
@@ -171,7 +173,7 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 
 	mutex_lock(&dev->ctrl_urb_lock);
 	memcpy(dev->urb_buf, buf, len);
-	ret = usb_control_msg(dev->udev, pipe, req,
+	ret = usb_control_msg(udev, pipe, req,
 			      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 			      0x0000, reg, dev->urb_buf, len, HZ);
 	mutex_unlock(&dev->ctrl_urb_lock);
@@ -797,6 +799,7 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode)
 {
 	struct urb *urb;
 	struct em28xx_usb_bufs *usb_bufs;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int i;
 
 	em28xx_isocdbg("em28xx: called em28xx_uninit_usb_xfer in mode %d\n",
@@ -816,7 +819,7 @@ void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode)
 				usb_unlink_urb(urb);
 
 			if (usb_bufs->transfer_buffer[i]) {
-				usb_free_coherent(dev->udev,
+				usb_free_coherent(udev,
 						  urb->transfer_buffer_length,
 						  usb_bufs->transfer_buffer[i],
 						  urb->transfer_dma);
@@ -870,9 +873,10 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		      int num_bufs, int max_pkt_size, int packet_multiplier)
 {
 	struct em28xx_usb_bufs *usb_bufs;
+	struct urb *urb;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int i;
 	int sb_size, pipe;
-	struct urb *urb;
 	int j, k;
 
 	em28xx_isocdbg("em28xx: called em28xx_alloc_isoc in mode %d\n", mode);
@@ -937,7 +941,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		}
 		usb_bufs->urb[i] = urb;
 
-		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(dev->udev,
+		usb_bufs->transfer_buffer[i] = usb_alloc_coherent(udev,
 			sb_size, GFP_KERNEL, &urb->transfer_dma);
 		if (!usb_bufs->transfer_buffer[i]) {
 			dev_err(&dev->intf->dev,
@@ -950,20 +954,20 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 		memset(usb_bufs->transfer_buffer[i], 0, sb_size);
 
 		if (xfer_bulk) { /* bulk */
-			pipe = usb_rcvbulkpipe(dev->udev,
+			pipe = usb_rcvbulkpipe(udev,
 					       mode == EM28XX_ANALOG_MODE ?
 					       dev->analog_ep_bulk :
 					       dev->dvb_ep_bulk);
-			usb_fill_bulk_urb(urb, dev->udev, pipe,
+			usb_fill_bulk_urb(urb, udev, pipe,
 					  usb_bufs->transfer_buffer[i], sb_size,
 					  em28xx_irq_callback, dev);
 			urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
 		} else { /* isoc */
-			pipe = usb_rcvisocpipe(dev->udev,
+			pipe = usb_rcvisocpipe(udev,
 					       mode == EM28XX_ANALOG_MODE ?
 					       dev->analog_ep_isoc :
 					       dev->dvb_ep_isoc);
-			usb_fill_int_urb(urb, dev->udev, pipe,
+			usb_fill_int_urb(urb, udev, pipe,
 					 usb_bufs->transfer_buffer[i], sb_size,
 					 em28xx_irq_callback, dev, 1);
 			urb->transfer_flags = URB_ISO_ASAP |
@@ -995,6 +999,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	struct em28xx_dmaqueue *dma_q = &dev->vidq;
 	struct em28xx_dmaqueue *vbi_dma_q = &dev->vbiq;
 	struct em28xx_usb_bufs *usb_bufs;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int i;
 	int rc;
 	int alloc;
@@ -1021,7 +1026,7 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
 	}
 
 	if (xfer_bulk) {
-		rc = usb_clear_halt(dev->udev, usb_bufs->urb[0]->pipe);
+		rc = usb_clear_halt(udev, usb_bufs->urb[0]->pipe);
 		if (rc < 0) {
 			dev_err(&dev->intf->dev,
 				"failed to clear USB bulk endpoint stall/halt condition (error=%i)\n",
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index d7cfcbe3bf19..75a75dab2e8e 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -198,6 +198,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 	int rc;
 	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
 	struct em28xx *dev = i2c_bus->dev;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int dvb_max_packet_size, packet_multiplier, dvb_alt;
 
 	if (dev->dvb_xfer_bulk) {
@@ -216,7 +217,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		dvb_alt = dev->dvb_alt_isoc;
 	}
 
-	usb_set_interface(dev->udev, dev->ifnum, dvb_alt);
+	usb_set_interface(udev, dev->ifnum, dvb_alt);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 0082ea6d6c08..782ce095c8c5 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -566,6 +566,7 @@ static void em28xx_query_buttons(struct work_struct *work)
 
 static int em28xx_register_snapshot_button(struct em28xx *dev)
 {
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	struct input_dev *input_dev;
 	int err;
 
@@ -574,7 +575,7 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
 	if (!input_dev)
 		return -ENOMEM;
 
-	usb_make_path(dev->udev, dev->snapshot_button_path,
+	usb_make_path(udev, dev->snapshot_button_path,
 		      sizeof(dev->snapshot_button_path));
 	strlcat(dev->snapshot_button_path, "/sbutton",
 		sizeof(dev->snapshot_button_path));
@@ -586,8 +587,8 @@ static int em28xx_register_snapshot_button(struct em28xx *dev)
 	input_dev->keycodesize = 0;
 	input_dev->keycodemax = 0;
 	input_dev->id.bustype = BUS_USB;
-	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	input_dev->id.vendor = le16_to_cpu(udev->descriptor.idVendor);
+	input_dev->id.product = le16_to_cpu(udev->descriptor.idProduct);
 	input_dev->id.version = 1;
 	input_dev->dev.parent = &dev->intf->dev;
 
@@ -678,6 +679,7 @@ static void em28xx_shutdown_buttons(struct em28xx *dev)
 
 static int em28xx_ir_init(struct em28xx *dev)
 {
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	struct em28xx_IR *ir;
 	struct rc_dev *rc;
 	int err = -ENOMEM;
@@ -799,15 +801,15 @@ static int em28xx_ir_init(struct em28xx *dev)
 	snprintf(ir->name, sizeof(ir->name), "%s IR",
 		 dev_name(&dev->intf->dev));
 
-	usb_make_path(dev->udev, ir->phys, sizeof(ir->phys));
+	usb_make_path(udev, ir->phys, sizeof(ir->phys));
 	strlcat(ir->phys, "/input0", sizeof(ir->phys));
 
 	rc->input_name = ir->name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_USB;
 	rc->input_id.version = 1;
-	rc->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	rc->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+	rc->input_id.vendor = le16_to_cpu(udev->descriptor.idVendor);
+	rc->input_id.product = le16_to_cpu(udev->descriptor.idProduct);
 	rc->dev.parent = &dev->intf->dev;
 	rc->driver_name = MODULE_NAME;
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4780f6492329..8d93100334ea 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -360,6 +360,7 @@ static int em28xx_resolution_set(struct em28xx *dev)
 static int em28xx_set_alternate(struct em28xx *dev)
 {
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int errCode;
 	int i;
 	unsigned int min_pkt_size = v4l2->width * 2 + 4;
@@ -411,7 +412,7 @@ static int em28xx_set_alternate(struct em28xx *dev)
 	}
 	em28xx_videodbg("setting alternate %d with wMaxPacketSize=%u\n",
 			dev->alt, dev->max_pkt_size);
-	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
+	errCode = usb_set_interface(udev, dev->ifnum, dev->alt);
 	if (errCode < 0) {
 		dev_err(&dev->intf->dev,
 			"cannot change alternate number to %d (error=%i)\n",
@@ -1859,10 +1860,11 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct video_device   *vdev = video_devdata(file);
 	struct em28xx         *dev  = video_drvdata(file);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 
 	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
 	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
-	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
+	usb_make_path(udev, cap->bus_info, sizeof(cap->bus_info));
 
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		cap->device_caps = V4L2_CAP_READWRITE |
@@ -2187,6 +2189,7 @@ static int em28xx_v4l2_close(struct file *filp)
 {
 	struct em28xx         *dev  = video_drvdata(filp);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int              errCode;
 
 	em28xx_videodbg("users=%d\n", v4l2->users);
@@ -2208,7 +2211,7 @@ static int em28xx_v4l2_close(struct file *filp)
 		/* set alternate 0 */
 		dev->alt = 0;
 		em28xx_videodbg("setting alternate 0\n");
-		errCode = usb_set_interface(dev->udev, 0, 0);
+		errCode = usb_set_interface(udev, 0, 0);
 		if (errCode < 0) {
 			dev_err(&dev->intf->dev,
 				"cannot change alternate number to 0 (error=%i)\n",
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 5182b1bf0d15..ca59e2d4fccf 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -677,7 +677,6 @@ struct em28xx {
 	spinlock_t slock;
 
 	/* usb transfer */
-	struct usb_device *udev;	/* the usb device */
 	struct usb_interface *intf;	/* the usb interface */
 	u8 ifnum;		/* number of the assigned usb interface */
 	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
-- 
2.9.3


