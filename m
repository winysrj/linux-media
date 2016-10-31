Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:24971 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934983AbcJaKuB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 06:50:01 -0400
From: Felipe Balbi <felipe.balbi@linux.intel.com>
To: Linux USB <linux-usb@vger.kernel.org>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 13/82] media: usbtv: core: make use of new usb_endpoint_maxp_mult()
Date: Mon, 31 Oct 2016 12:48:05 +0200
Message-Id: <20161031104914.1990-14-felipe.balbi@linux.intel.com>
In-Reply-To: <20161031104914.1990-1-felipe.balbi@linux.intel.com>
References: <20161031104914.1990-1-felipe.balbi@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have introduced a helper to calculate multiplier
value from wMaxPacketSize. Start using it.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: <linux-media@vger.kernel.org>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
---
 drivers/media/usb/usbtv/usbtv-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index dc76fd41e00f..ceb953be0770 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -71,6 +71,7 @@ static int usbtv_probe(struct usb_interface *intf,
 	int size;
 	struct device *dev = &intf->dev;
 	struct usbtv *usbtv;
+	struct usb_host_endpoint *ep;
 
 	/* Checks that the device is what we think it is. */
 	if (intf->num_altsetting != 2)
@@ -78,10 +79,12 @@ static int usbtv_probe(struct usb_interface *intf,
 	if (intf->altsetting[1].desc.bNumEndpoints != 4)
 		return -ENODEV;
 
+	ep = &intf->altsetting[1].endpoint[0];
+
 	/* Packet size is split into 11 bits of base size and count of
 	 * extra multiplies of it.*/
-	size = usb_endpoint_maxp(&intf->altsetting[1].endpoint[0].desc);
-	size = (size & 0x07ff) * (((size & 0x1800) >> 11) + 1);
+	size = usb_endpoint_maxp(&ep->desc);
+	size = (size & 0x07ff) * usb_endpoint_maxp_mult(&ep->desc);
 
 	/* Device structure */
 	usbtv = kzalloc(sizeof(struct usbtv), GFP_KERNEL);
-- 
2.10.1

