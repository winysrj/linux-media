Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab3CSQuf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:50:35 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/46] [media] siano: use USB endpoint descriptors for in/out endp
Date: Tue, 19 Mar 2013 13:48:58 -0300
Message-Id: <1363711775-2120-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using hardcoded descriptors, detect them from the
USB descriptors.

This patch is rebased form Doron Cohen's patch:
	http://patchwork.linuxtv.org/patch/7883/

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/siano/smsusb.c | 99 +++++++++++++++++++++++++++++-----------
 1 file changed, 73 insertions(+), 26 deletions(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 2050e4c..a31bf74 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -35,16 +35,23 @@ module_param_named(debug, sms_dbg, int, 0644);
 MODULE_PARM_DESC(debug, "set debug level (info=1, adv=2 (or-able))");
 
 #define USB1_BUFFER_SIZE		0x1000
-#define USB2_BUFFER_SIZE		0x4000
+#define USB2_BUFFER_SIZE		0x2000
 
 #define MAX_BUFFERS		50
 #define MAX_URBS		10
 
 struct smsusb_device_t;
 
+enum smsusb_state {
+	SMSUSB_DISCONNECTED,
+	SMSUSB_SUSPENDED,
+	SMSUSB_ACTIVE
+};
+
 struct smsusb_urb_t {
+	struct list_head entry;
 	struct smscore_buffer_t *cb;
-	struct smsusb_device_t	*dev;
+	struct smsusb_device_t *dev;
 
 	struct urb urb;
 };
@@ -57,11 +64,23 @@ struct smsusb_device_t {
 
 	int		response_alignment;
 	int		buffer_size;
+
+	unsigned char in_ep;
+	unsigned char out_ep;
+	enum smsusb_state state;
 };
 
 static int smsusb_submit_urb(struct smsusb_device_t *dev,
 			     struct smsusb_urb_t *surb);
 
+/**
+ * Completing URB's callback handler - top half (interrupt context)
+ * adds completing sms urb to the global surbs list and activtes the worker
+ * thread the surb
+ * IMPORTANT - blocking functions must not be called from here !!!
+
+ * @param urb pointer to a completing urb object
+ */
 static void smsusb_onresponse(struct urb *urb)
 {
 	struct smsusb_urb_t *surb = (struct smsusb_urb_t *) urb->context;
@@ -140,7 +159,7 @@ static int smsusb_submit_urb(struct smsusb_device_t *dev,
 	usb_fill_bulk_urb(
 		&surb->urb,
 		dev->udev,
-		usb_rcvbulkpipe(dev->udev, 0x81),
+		usb_rcvbulkpipe(dev->udev, dev->in_ep),
 		surb->cb->p,
 		dev->buffer_size,
 		smsusb_onresponse,
@@ -192,6 +211,9 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 		  smscore_translate_msg(phdr->msgType), phdr->msgType,
 		  phdr->msgLength);
 
+	if (dev->state != SMSUSB_ACTIVE)
+		return -ENOENT;
+
 	smsendian_handle_message_header((struct SmsMsgHdr_ST *)buffer);
 	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
 			    buffer, size, &dummy, 1000);
@@ -301,13 +323,15 @@ static void smsusb_term_device(struct usb_interface *intf)
 	struct smsusb_device_t *dev = usb_get_intfdata(intf);
 
 	if (dev) {
+		dev->state = SMSUSB_DISCONNECTED;
+
 		smsusb_stop_streaming(dev);
 
 		/* unregister from smscore */
 		if (dev->coredev)
 			smscore_unregister_device(dev->coredev);
 
-		sms_info("device %p destroyed", dev);
+		sms_info("device 0x%p destroyed", dev);
 		kfree(dev);
 	}
 
@@ -330,6 +354,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	memset(&params, 0, sizeof(params));
 	usb_set_intfdata(intf, dev);
 	dev->udev = interface_to_usbdev(intf);
+	dev->state = SMSUSB_DISCONNECTED;
 
 	params.device_type = sms_get_board(board_id)->type;
 
@@ -346,6 +371,8 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	case SMS_NOVA_A0:
 	case SMS_NOVA_B0:
 	case SMS_VEGA:
+	case SMS_VENICE:
+	case SMS_DENVER_1530:
 		dev->buffer_size = USB2_BUFFER_SIZE;
 		dev->response_alignment =
 		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
@@ -355,6 +382,16 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		break;
 	}
 
+	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
+		if (intf->cur_altsetting->endpoint[i].desc. bEndpointAddress & USB_DIR_IN)
+			dev->in_ep = intf->cur_altsetting->endpoint[i].desc.bEndpointAddress;
+		else
+			dev->out_ep = intf->cur_altsetting->endpoint[i].desc.bEndpointAddress;
+	}
+
+	sms_info("in_ep = %02x, out_ep = %02x",
+		dev->in_ep, dev->out_ep);
+
 	params.device = &dev->udev->dev;
 	params.buffer_size = dev->buffer_size;
 	params.num_buffers = MAX_BUFFERS;
@@ -386,6 +423,8 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		return rc;
 	}
 
+	dev->state = SMSUSB_ACTIVE;
+
 	rc = smscore_start_device(dev->coredev);
 	if (rc < 0) {
 		sms_err("smscore_start_device(...) failed");
@@ -393,7 +432,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		return rc;
 	}
 
-	sms_info("device %p created", dev);
+	sms_info("device 0x%p created", dev);
 
 	return rc;
 }
@@ -402,15 +441,23 @@ static int smsusb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	char devpath[32];
 	int i, rc;
 
-	rc = usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x81));
-	rc = usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x02));
+	sms_info("interface number %d",
+		 intf->cur_altsetting->desc.bInterfaceNumber);
 
-	if (intf->num_altsetting > 0) {
-		rc = usb_set_interface(
-			udev, intf->cur_altsetting->desc.bInterfaceNumber, 0);
+	if (sms_get_board(id->driver_info)->intf_num !=
+	    intf->cur_altsetting->desc.bInterfaceNumber) {
+		sms_err("interface number is %d expecting %d",
+			sms_get_board(id->driver_info)->intf_num,
+			intf->cur_altsetting->desc.bInterfaceNumber);
+		return -ENODEV;
+	}
+
+	if (intf->num_altsetting > 1) {
+		rc = usb_set_interface(udev,
+				       intf->cur_altsetting->desc.bInterfaceNumber,
+				       0);
 		if (rc < 0) {
 			sms_err("usb_set_interface failed, rc %d", rc);
 			return rc;
@@ -419,27 +466,25 @@ static int smsusb_probe(struct usb_interface *intf,
 
 	sms_info("smsusb_probe %d",
 	       intf->cur_altsetting->desc.bInterfaceNumber);
-	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++)
+	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++) {
 		sms_info("endpoint %d %02x %02x %d", i,
 		       intf->cur_altsetting->endpoint[i].desc.bEndpointAddress,
 		       intf->cur_altsetting->endpoint[i].desc.bmAttributes,
 		       intf->cur_altsetting->endpoint[i].desc.wMaxPacketSize);
-
+		if (intf->cur_altsetting->endpoint[i].desc.bEndpointAddress &
+		    USB_DIR_IN)
+			rc = usb_clear_halt(udev, usb_rcvbulkpipe(udev,
+				intf->cur_altsetting->endpoint[i].desc.bEndpointAddress));
+		else
+			rc = usb_clear_halt(udev, usb_sndbulkpipe(udev,
+				intf->cur_altsetting->endpoint[i].desc.bEndpointAddress));
+	}
 	if ((udev->actconfig->desc.bNumInterfaces == 2) &&
 	    (intf->cur_altsetting->desc.bInterfaceNumber == 0)) {
 		sms_err("rom interface 0 is not used");
 		return -ENODEV;
 	}
 
-	if (intf->cur_altsetting->desc.bInterfaceNumber == 1) {
-		snprintf(devpath, sizeof(devpath), "usb\\%d-%s",
-			 udev->bus->busnum, udev->devpath);
-		sms_info("stellar device was found.");
-		return smsusb1_load_firmware(
-				udev, smscore_registry_getmode(devpath),
-				id->driver_info);
-	}
-
 	rc = smsusb_init_device(intf, id->driver_info);
 	sms_info("rc %d", rc);
 	sms_board_load_modules(id->driver_info);
@@ -454,7 +499,9 @@ static void smsusb_disconnect(struct usb_interface *intf)
 static int smsusb_suspend(struct usb_interface *intf, pm_message_t msg)
 {
 	struct smsusb_device_t *dev = usb_get_intfdata(intf);
-	printk(KERN_INFO "%s: Entering status %d.\n", __func__, msg.event);
+	printk(KERN_INFO "%s  Entering status %d.\n", __func__, msg.event);
+	dev->state = SMSUSB_SUSPENDED;
+	/*smscore_set_power_mode(dev, SMS_POWER_MODE_SUSPENDED);*/
 	smsusb_stop_streaming(dev);
 	return 0;
 }
@@ -465,9 +512,9 @@ static int smsusb_resume(struct usb_interface *intf)
 	struct smsusb_device_t *dev = usb_get_intfdata(intf);
 	struct usb_device *udev = interface_to_usbdev(intf);
 
-	printk(KERN_INFO "%s: Entering.\n", __func__);
-	usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x81));
-	usb_clear_halt(udev, usb_rcvbulkpipe(udev, 0x02));
+	printk(KERN_INFO "%s  Entering.\n", __func__);
+	usb_clear_halt(udev, usb_rcvbulkpipe(udev, dev->in_ep));
+	usb_clear_halt(udev, usb_sndbulkpipe(udev, dev->out_ep));
 
 	for (i = 0; i < intf->cur_altsetting->desc.bNumEndpoints; i++)
 		printk(KERN_INFO "endpoint %d %02x %02x %d\n", i,
-- 
1.8.1.4

