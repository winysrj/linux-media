Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbcKRPQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 10:16:16 -0500
Subject: patch "media: usbtv: core: make use of new usb_endpoint_maxp_mult()" added to usb-next
To: felipe.balbi@linux.intel.com, linux-media@vger.kernel.org,
        mchehab@kernel.org
From: <gregkh@linuxfoundation.org>
Date: Fri, 18 Nov 2016 16:09:59 +0100
Message-ID: <1479481799152163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    media: usbtv: core: make use of new usb_endpoint_maxp_mult()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


>From b72b7979c356f06a85ac1de03e5086b5bf461702 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@linux.intel.com>
Date: Wed, 28 Sep 2016 13:20:17 +0300
Subject: media: usbtv: core: make use of new usb_endpoint_maxp_mult()

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
2.10.2


