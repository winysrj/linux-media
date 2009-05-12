Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110811.mail.gq1.yahoo.com ([67.195.13.234]:38467 "HELO
	web110811.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758245AbZELLYJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 07:24:09 -0400
Message-ID: <19338.23494.qm@web110811.mail.gq1.yahoo.com>
Date: Tue, 12 May 2009 04:24:07 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_02] Siano: smsusb - handle byte ordering and big endianity
To: LinuxML <linux-media@vger.kernel.org>
Cc: Mauro Carvalho <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242127626 -10800
# Node ID 26c02c133d7e1f9932c1968f669ab0bfaf2761fa
# Parent  766d02fa7c5c42cc6480eaefb14c7dd6f9c0d370
[0905_02] Siano: smsusb - handle byte ordering and big endianity

From: Uri Shkolnik <uris@siano-ms.com>

This patch adds support for byte ordering and big endianity
handling for the USB interface driver

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 766d02fa7c5c -r 26c02c133d7e linux/drivers/media/dvb/siano/smsusb.c
--- a/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 14:00:57 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsusb.c	Tue May 12 14:27:06 2009 +0300
@@ -26,6 +26,7 @@ along with this program.  If not, see <h
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
+#include "smsendian.h"
 
 static int sms_dbg;
 module_param_named(debug, sms_dbg, int, 0644);
@@ -180,6 +181,7 @@ static int smsusb_sendrequest(void *cont
 	struct smsusb_device_t *dev = (struct smsusb_device_t *) context;
 	int dummy;
 
+	smsendian_handle_message_header((struct SmsMsgHdr_ST *)buffer);
 	return usb_bulk_msg(dev->udev, usb_sndbulkpipe(dev->udev, 2),
 			    buffer, size, &dummy, 1000);
 }
@@ -337,8 +339,8 @@ static int smsusb_init_device(struct usb
 	case SMS_VEGA:
 		dev->buffer_size = USB2_BUFFER_SIZE;
 		dev->response_alignment =
-			dev->udev->ep_in[1]->desc.wMaxPacketSize -
-			sizeof(struct SmsMsgHdr_ST);
+		    le16_to_cpu(dev->udev->ep_in[1]->desc.wMaxPacketSize) -
+		    sizeof(struct SmsMsgHdr_ST);
 
 		params.flags |= SMS_DEVICE_FAMILY2;
 		break;



      
