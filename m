Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110805.mail.gq1.yahoo.com ([67.195.13.228]:44591 "HELO
	web110805.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751071AbZDEMFJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 08:05:09 -0400
Message-ID: <308390.97983.qm@web110805.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 05:05:05 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_18] Siano: smsusb - byte ordering and big endian support
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238760032 -10800
# Node ID ab731e3cec5cb076b8f87f827c3c97a4dd84e0ca
# Parent  73c6299ef5f518beb07b6eb371402fe1be4e26ea
[PATCH] [0904_18] Siano: smsusb - byte ordering and big endian support

From: Uri Shkolnik <uris@siano-ms.com>

This patch add support for Siano's messaging in big endian systems.
Few indentations (without implementation impact) have been added.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 73c6299ef5f5 -r ab731e3cec5c linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Fri Apr 03 14:50:58 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Fri Apr 03 15:00:32 2009 +0300
@@ -27,7 +27,6 @@ along with this program.  If not, see <h
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
-
 #include "smsendian.h"
 
 #define USB1_BUFFER_SIZE		0x1000
@@ -64,7 +63,7 @@ static void smsusb_onresponse(struct urb
 static void smsusb_onresponse(struct urb *urb, struct pt_regs *regs)
 #endif
 {
-	struct smsusb_urb_t *surb = (struct smsusb_urb_t *) urb->context;
+	struct smsusb_urb_t *surb = (struct smsusb_urb_t *)urb->context;
 	struct smsusb_device_t *dev = surb->dev;
 
 	if (urb->status < 0) {
@@ -76,6 +75,7 @@ static void smsusb_onresponse(struct urb
 	if (urb->actual_length > 0) {
 		struct SmsMsgHdr_ST *phdr = (struct SmsMsgHdr_ST *)surb->cb->p;
 
+		smsendian_handle_message_header(phdr);
 		if (urb->actual_length >= phdr->msgLength) {
 			surb->cb->size = phdr->msgLength;
 
@@ -179,6 +179,7 @@ static int smsusb_sendrequest(void *cont
 	struct smsusb_device_t *dev = (struct smsusb_device_t *)context;
 	int dummy;
 
+	smsendian_handle_message_header((struct SmsMsgHdr_ST *)buffer);
 	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
 			    buffer, size, &dummy, 1000);
 }
@@ -336,8 +337,8 @@ static int smsusb_init_device(struct usb
 	case SMS_VEGA:
 		dev->buffer_size = USB2_BUFFER_SIZE;
 		dev->response_alignment =
-			dev->udev->ep_in[1]->desc.wMaxPacketSize -
-			sizeof(struct SmsMsgHdr_ST);
+		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
+		    sizeof(struct SmsMsgHdr_ST);
 
 		params.flags |= SMS_DEVICE_FAMILY2;
 		break;
@@ -532,13 +533,12 @@ MODULE_DEVICE_TABLE(usb, smsusb_id_table
 MODULE_DEVICE_TABLE(usb, smsusb_id_table);
 
 static struct usb_driver smsusb_driver = {
-	.name			= "smsusb",
-	.probe			= smsusb_probe,
-	.disconnect		= smsusb_disconnect,
-	.id_table		= smsusb_id_table,
-
-	.suspend		= smsusb_suspend,
-	.resume			= smsusb_resume,
+	.name = "smsusb",
+	.probe = smsusb_probe,
+	.disconnect = smsusb_disconnect,
+	.suspend = smsusb_suspend,
+	.resume = smsusb_resume,
+	.id_table = smsusb_id_table,
 };
 
 int smsusb_register(void)



      
