Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:52793 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750787AbdIOHt6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 03:49:58 -0400
Subject: [PATCH 2/9] [media] tm6000: Adjust seven checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Sean Young <sean@mess.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Message-ID: <145283b1-0e7c-9cde-ca0f-64f2b12ba5c7@users.sourceforge.net>
Date: Fri, 15 Sep 2017 09:49:31 +0200
MIME-Version: 1.0
In-Reply-To: <2aade468-5dfd-76ee-f59f-c25864930f61@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 14 Sep 2017 14:51:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/tm6000/tm6000-cards.c | 2 +-
 drivers/media/usb/tm6000/tm6000-dvb.c   | 6 +++---
 drivers/media/usb/tm6000/tm6000-input.c | 2 +-
 drivers/media/usb/tm6000/tm6000-video.c | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 817bae8cb6a1..ef37fb1f05e4 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1206,7 +1206,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 
 	/* Create and initialize dev struct */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
+	if (!dev) {
 		usb_put_dev(usbdev);
 		return -ENOMEM;
 	}
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 61a4e0a52716..2bc584f75f87 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -123,7 +123,7 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 	}
 
 	dvb->bulk_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (dvb->bulk_urb == NULL)
+	if (!dvb->bulk_urb)
 		return -ENOMEM;
 
 	pipe = usb_rcvbulkpipe(dev->udev, dev->bulk_in.endp->desc.bEndpointAddress
@@ -133,7 +133,7 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 	size = size * 15; /* 512 x 8 or 12 or 15 */
 
 	dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
-	if (dvb->bulk_urb->transfer_buffer == NULL) {
+	if (!dvb->bulk_urb->transfer_buffer) {
 		usb_free_urb(dvb->bulk_urb);
 		return -ENOMEM;
 	}
@@ -360,7 +360,7 @@ static void unregister_dvb(struct tm6000_core *dev)
 {
 	struct tm6000_dvb *dvb = dev->dvb;
 
-	if (dvb->bulk_urb != NULL) {
+	if (dvb->bulk_urb) {
 		struct urb *bulk_urb = dvb->bulk_urb;
 
 		kfree(bulk_urb->transfer_buffer);
diff --git a/drivers/media/usb/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
index 91889ad9cdd7..397990afe00b 100644
--- a/drivers/media/usb/tm6000/tm6000-input.c
+++ b/drivers/media/usb/tm6000/tm6000-input.c
@@ -352,7 +352,7 @@ static int __tm6000_ir_int_start(struct rc_dev *rc)
 	dprintk(1, "IR max size: %d\n", size);
 
 	ir->int_urb->transfer_buffer = kzalloc(size, GFP_ATOMIC);
-	if (ir->int_urb->transfer_buffer == NULL) {
+	if (!ir->int_urb->transfer_buffer) {
 		usb_free_urb(ir->int_urb);
 		return err;
 	}
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 701494e72edc..0d45f35e1697 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -470,7 +470,7 @@ static int tm6000_alloc_urb_buffers(struct tm6000_core *dev)
 	int num_bufs = TM6000_NUM_URB_BUF;
 	int i;
 
-	if (dev->urb_buffer != NULL)
+	if (dev->urb_buffer)
 		return 0;
 
 	dev->urb_buffer = kmalloc(sizeof(void *)*num_bufs, GFP_KERNEL);
@@ -503,7 +503,7 @@ static int tm6000_free_urb_buffers(struct tm6000_core *dev)
 {
 	int i;
 
-	if (dev->urb_buffer == NULL)
+	if (!dev->urb_buffer)
 		return 0;
 
 	for (i = 0; i < TM6000_NUM_URB_BUF; i++) {
-- 
2.14.1
