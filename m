Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab0HBV0x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 17:26:53 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o72LQqgc014614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 2 Aug 2010 17:26:53 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o72LQpcb007900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 2 Aug 2010 17:26:52 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o72LQpHk017740
	for <linux-media@vger.kernel.org>; Mon, 2 Aug 2010 17:26:51 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o72LQp3G017738
	for linux-media@vger.kernel.org; Mon, 2 Aug 2010 17:26:51 -0400
Date: Mon, 2 Aug 2010 17:26:50 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/mceusb: less generic callback name and remove cruft
Message-ID: <20100802212650.GA17726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/mceusb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
index 65b0738..ac6bb2c 100644
--- a/drivers/media/IR/mceusb.c
+++ b/drivers/media/IR/mceusb.c
@@ -427,7 +427,7 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 	}
 }
 
-static void usb_async_callback(struct urb *urb, struct pt_regs *regs)
+static void mce_async_callback(struct urb *urb, struct pt_regs *regs)
 {
 	struct mceusb_dev *ir;
 	int len;
@@ -476,7 +476,7 @@ static void mce_request_packet(struct mceusb_dev *ir,
 		/* outbound data */
 		usb_fill_int_urb(async_urb, ir->usbdev,
 			usb_sndintpipe(ir->usbdev, ep->bEndpointAddress),
-			async_buf, size, (usb_complete_t) usb_async_callback,
+			async_buf, size, (usb_complete_t)mce_async_callback,
 			ir, ep->bInterval);
 		memcpy(async_buf, data, size);
 
@@ -919,7 +919,6 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	struct usb_endpoint_descriptor *ep = NULL;
 	struct usb_endpoint_descriptor *ep_in = NULL;
 	struct usb_endpoint_descriptor *ep_out = NULL;
-	struct usb_host_config *config;
 	struct mceusb_dev *ir = NULL;
 	int pipe, maxp, i;
 	char buf[63], name[128] = "";
@@ -929,7 +928,6 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	dev_dbg(&intf->dev, ": %s called\n", __func__);
 
-	config = dev->actconfig;
 	idesc  = intf->cur_altsetting;
 
 	is_gen3 = usb_match_id(intf, gen3_list) ? 1 : 0;
-- 
1.7.2

-- 
Jarod Wilson
jarod@redhat.com

