Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:52137 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756663AbcJMQ0Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 12:26:24 -0400
Subject: [PATCH 05/18] [media] RedRat3: Delete six messages for a failed
 memory allocation
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <da435f95-347a-16b3-2fba-1639996557cd@users.sourceforge.net>
Date: Thu, 13 Oct 2016 18:26:11 +0200
MIME-Version: 1.0
In-Reply-To: <81cef537-4ad0-3a74-8bde-94707dcd03f4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 13 Oct 2016 13:20:19 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Possible unnecessary 'out of memory' message

Thus remove such a logging statement in five functions.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/redrat3.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 71e901d..2e31c18 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -453,10 +453,8 @@ static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 
 	len = sizeof(*tmp);
 	tmp = kzalloc(len, GFP_KERNEL);
-	if (!tmp) {
-		dev_warn(rr3->dev, "Memory allocation faillure\n");
+	if (!tmp)
 		return timeout;
-	}
 
 	pipe = usb_rcvctrlpipe(rr3->udev, 0);
 	ret = usb_control_msg(rr3->udev, pipe, RR3_GET_IR_PARAM,
@@ -518,10 +516,8 @@ static void redrat3_reset(struct redrat3_dev *rr3)
 	txpipe = usb_sndctrlpipe(udev, 0);
 
 	val = kmalloc(len, GFP_KERNEL);
-	if (!val) {
-		dev_err(dev, "Memory allocation failure\n");
+	if (!val)
 		return;
-	}
 
 	*val = 0x01;
 	rc = usb_control_msg(udev, rxpipe, RR3_RESET,
@@ -550,10 +546,8 @@ static void redrat3_get_firmware_rev(struct redrat3_dev *rr3)
 	char *buffer;
 
 	buffer = kcalloc(RR3_FW_VERSION_LEN + 1, sizeof(*buffer), GFP_KERNEL);
-	if (!buffer) {
-		dev_err(rr3->dev, "Memory allocation failure\n");
+	if (!buffer)
 		return;
-	}
 
 	rc = usb_control_msg(rr3->udev, usb_rcvctrlpipe(rr3->udev, 0),
 			     RR3_FW_VERSION,
@@ -866,10 +860,8 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	u16 prod = le16_to_cpu(rr3->udev->descriptor.idProduct);
 
 	rc = rc_allocate_device();
-	if (!rc) {
-		dev_err(dev, "remote input dev allocation failed\n");
+	if (!rc)
 		goto out;
-	}
 
 	snprintf(rr3->name, sizeof(rr3->name), "RedRat3%s "
 		 "Infrared Remote Transceiver (%04x:%04x)",
@@ -959,10 +951,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 
 	/* allocate memory for our device state and initialize it */
 	rr3 = kzalloc(sizeof(*rr3), GFP_KERNEL);
-	if (rr3 == NULL) {
-		dev_err(dev, "Memory allocation failure\n");
+	if (!rr3)
 		goto no_endpoints;
-	}
 
 	rr3->dev = &intf->dev;
 
@@ -974,10 +964,8 @@ static int redrat3_dev_probe(struct usb_interface *intf,
 	rr3->ep_in = ep_in;
 	rr3->bulk_in_buf = usb_alloc_coherent(udev,
 		le16_to_cpu(ep_in->wMaxPacketSize), GFP_KERNEL, &rr3->dma_in);
-	if (!rr3->bulk_in_buf) {
-		dev_err(dev, "Read buffer allocation failure\n");
+	if (!rr3->bulk_in_buf)
 		goto error;
-	}
 
 	pipe = usb_rcvbulkpipe(udev, ep_in->bEndpointAddress);
 	usb_fill_bulk_urb(rr3->read_urb, udev, pipe, rr3->bulk_in_buf,
-- 
2.10.1

