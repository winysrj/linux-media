Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab0DZOYX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 10:24:23 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3QEOMiv024211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 10:24:23 -0400
Received: from [10.11.11.130] (vpn-11-130.rdu.redhat.com [10.11.11.130])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o3QEOJIC004870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 10:24:21 -0400
Message-ID: <4BD5A212.10104@redhat.com>
Date: Mon, 26 Apr 2010 11:24:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tm6000: Properly set alternate when preparing to stream
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Although the code is getting the better alternates, it is not really using
it. Get the interface/alternate numbers and use it where needed.

This patch implements also one small fix at the last_line set, as 
proposed by Bee Hock Goh <behock@gmail.com>.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
-- 

Cheers,
Mauro
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index f795a3e..a7e9556 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -634,21 +634,24 @@ err:
 /* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
 #define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))
 
-static void get_max_endpoint (  struct usb_device *usbdev,
-				char *msgtype,
-				struct usb_host_endpoint *curr_e,
-				unsigned int *maxsize,
-				struct usb_host_endpoint **ep  )
+static void get_max_endpoint(struct usb_device *udev,
+			     struct usb_host_interface *alt,
+			     char *msgtype,
+			     struct usb_host_endpoint *curr_e,
+			     struct tm6000_endpoint *tm_ep)
 {
 	u16 tmp = le16_to_cpu(curr_e->desc.wMaxPacketSize);
 	unsigned int size = tmp & 0x7ff;
 
-	if (usbdev->speed == USB_SPEED_HIGH)
+	if (udev->speed == USB_SPEED_HIGH)
 		size = size * hb_mult (tmp);
 
-	if (size>*maxsize) {
-		*ep = curr_e;
-		*maxsize = size;
+	if (size > tm_ep->maxsize) {
+		tm_ep->endp = curr_e;
+		tm_ep->maxsize = size;
+		tm_ep->bInterfaceNumber = alt->desc.bInterfaceNumber;
+		tm_ep->bAlternateSetting = alt->desc.bAlternateSetting;
+
 		printk("tm6000: %s endpoint: 0x%02x (max size=%u bytes)\n",
 					msgtype, curr_e->desc.bEndpointAddress,
 					size);
@@ -743,24 +746,28 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 			switch (e->desc.bmAttributes) {
 			case USB_ENDPOINT_XFER_BULK:
 				if (!dir_out) {
-					get_max_endpoint (usbdev, "Bulk IN", e,
-							&dev->max_bulk_in,
-							&dev->bulk_in);
+					get_max_endpoint(usbdev,
+							 &interface->altsetting[i],
+							 "Bulk IN", e,
+							 &dev->bulk_in);
 				} else {
-					get_max_endpoint (usbdev, "Bulk OUT", e,
-							&dev->max_bulk_out,
-							&dev->bulk_out);
+					get_max_endpoint(usbdev,
+							 &interface->altsetting[i],
+							 "Bulk OUT", e,
+							 &dev->bulk_out);
 				}
 				break;
 			case USB_ENDPOINT_XFER_ISOC:
 				if (!dir_out) {
-					get_max_endpoint (usbdev, "ISOC IN", e,
-							&dev->max_isoc_in,
-							&dev->isoc_in);
+					get_max_endpoint(usbdev,
+							 &interface->altsetting[i],
+							 "ISOC IN", e,
+							 &dev->isoc_in);
 				} else {
-					get_max_endpoint (usbdev, "ISOC OUT", e,
-							&dev->max_isoc_out,
-							&dev->isoc_out);
+					get_max_endpoint(usbdev,
+							 &interface->altsetting[i],
+							 "ISOC OUT", e,
+							 &dev->isoc_out);
 				}
 				break;
 			}
@@ -775,7 +782,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 		interface->altsetting->desc.bInterfaceNumber);
 
 /* check if the the device has the iso in endpoint at the correct place */
-	if (!dev->isoc_in) {
+	if (!dev->isoc_in.endp) {
 		printk("tm6000: probing error: no IN ISOC endpoint!\n");
 		rc= -ENODEV;
 
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c53de47..96358b2 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -149,7 +149,8 @@ static inline void get_next_buf(struct tm6000_dmaqueue *dma_q,
 
 	/* Cleans up buffer - Usefull for testing for frame/URB loss */
 	outp = videobuf_to_vmalloc(&(*buf)->vb);
-	memset(outp, 0, (*buf)->vb.size);
+	if (outp)
+		memset(outp, 0, (*buf)->vb.size);
 
 	return;
 }
@@ -282,7 +283,8 @@ static int copy_packet(struct urb *urb, u32 header, u8 **ptr, u8 *endp,
 			start_line=line;
 			last_field=field;
 		}
-		last_line=line;
+		if (cmd == TM6000_URB_MSG_VIDEO)
+			last_line = line;
 
 		pktsize = TM6000_URB_MSG_LEN;
 	} else {
@@ -614,14 +616,18 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 	/* De-allocates all pending stuff */
 	tm6000_uninit_isoc(dev);
 
+	usb_set_interface(dev->udev,
+			  dev->isoc_in.bInterfaceNumber,
+			  dev->isoc_in.bAlternateSetting);
+
 	pipe = usb_rcvisocpipe(dev->udev,
-			       dev->isoc_in->desc.bEndpointAddress &
+			       dev->isoc_in.endp->desc.bEndpointAddress &
 			       USB_ENDPOINT_NUMBER_MASK);
 
 	size = usb_maxpacket(dev->udev, pipe, usb_pipeout(pipe));
 
-	if (size > dev->max_isoc_in)
-		size = dev->max_isoc_in;
+	if (size > dev->isoc_in.maxsize)
+		size = dev->isoc_in.maxsize;
 
 	dev->isoc_ctl.max_pkt_size = size;
 
@@ -651,8 +657,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 	dprintk(dev, V4L2_DEBUG_QUEUE, "Allocating %d x %d packets"
 		    " (%d bytes) of %d bytes each to handle %u size\n",
 		    max_packets, num_bufs, sb_size,
-		    dev->max_isoc_in, size);
-
+		    dev->isoc_in.maxsize, size);
 
 	/* allocate urbs and transfer buffers */
 	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
@@ -680,7 +685,7 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev, unsigned int framesize)
 		usb_fill_bulk_urb(urb, dev->udev, pipe,
 				  dev->isoc_ctl.transfer_buffer[i], sb_size,
 				  tm6000_irq_callback, dma_q);
-		urb->interval = dev->isoc_in->desc.bInterval;
+		urb->interval = dev->isoc_in.endp->desc.bInterval;
 		urb->number_of_packets = max_packets;
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 7aeded8..13d5a3e 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -132,6 +132,13 @@ struct tm6000_dvb {
 	struct mutex		mutex;
 };
 
+struct tm6000_endpoint {
+	struct usb_host_endpoint	*endp;
+	__u8				bInterfaceNumber;
+	__u8				bAlternateSetting;
+	unsigned			maxsize;
+};
+
 struct tm6000_core {
 	/* generic device properties */
 	char				name[30];	/* name (including minor) of the device */
@@ -185,9 +192,7 @@ struct tm6000_core {
 	/* usb transfer */
 	struct usb_device		*udev;		/* the usb device */
 
-	struct usb_host_endpoint	*bulk_in, *bulk_out, *isoc_in, *isoc_out;
-	unsigned int			max_bulk_in, max_bulk_out;
-	unsigned int			max_isoc_in, max_isoc_out;
+	struct tm6000_endpoint		bulk_in, bulk_out, isoc_in, isoc_out;
 
 	/* scaler!=0 if scaler is active*/
 	int				scaler;
