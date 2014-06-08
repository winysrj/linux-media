Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543AbaFIRVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 13:21:46 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH 7/8] au0828: Only alt setting logic when needed
Date: Sun,  8 Jun 2014 13:54:57 -0300
Message-Id: <1402246498-2532-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that there's a bug at au0828 hardware/firmware
related to alternate setting: when the device is already at
alt 5, a further call causes the URBs to receive -ESHUTDOWN.

I found two different encarnations of this issue:

1) at qv4l2, it fails the second time we try to open the
video screen;
2) at xawtv, when audio underrun occurs, with is very
frequent, at least on my test machine.

The fix is simple: just check if alt=5 before calling
set_usb_interface().

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 34 ++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 4aa1d7a1641b..85d83ca5a4cd 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -787,11 +787,27 @@ static int au0828_i2s_init(struct au0828_dev *dev)
 
 /*
  * Auvitek au0828 analog stream enable
- * Please set interface0 to AS5 before enable the stream
  */
 static int au0828_analog_stream_enable(struct au0828_dev *d)
 {
+	struct usb_interface *iface;
+	int ret;
+
 	dprintk(1, "au0828_analog_stream_enable called\n");
+
+	iface = usb_ifnum_to_if(d->usbdev, 0);
+	if (iface && iface->cur_altsetting->desc.bAlternateSetting != 5) {
+		dprintk(1, "Changing intf#0 to alt 5\n");
+		/* set au0828 interface0 to AS5 here again */
+		ret = usb_set_interface(d->usbdev, 0, 5);
+		if (ret < 0) {
+			printk(KERN_INFO "Au0828 can't set alt setting to 5!\n");
+			return -EBUSY;
+		}
+	}
+
+	/* FIXME: size should be calculated using d->width, d->height */
+
 	au0828_writereg(d, AU0828_SENSORCTRL_VBI_103, 0x00);
 	au0828_writereg(d, 0x106, 0x00);
 	/* set x position */
@@ -1002,15 +1018,6 @@ static int au0828_v4l2_open(struct file *filp)
 		return -ERESTARTSYS;
 	}
 	if (dev->users == 0) {
-		/* set au0828 interface0 to AS5 here again */
-		ret = usb_set_interface(dev->usbdev, 0, 5);
-		if (ret < 0) {
-			mutex_unlock(&dev->lock);
-			printk(KERN_INFO "Au0828 can't set alternate to 5!\n");
-			kfree(fh);
-			return -EBUSY;
-		}
-
 		au0828_analog_stream_enable(dev);
 		au0828_analog_stream_reset(dev);
 
@@ -1252,13 +1259,6 @@ static int au0828_set_format(struct au0828_dev *dev, unsigned int cmd,
 		}
 	}
 
-	/* set au0828 interface0 to AS5 here again */
-	ret = usb_set_interface(dev->usbdev, 0, 5);
-	if (ret < 0) {
-		printk(KERN_INFO "Au0828 can't set alt setting to 5!\n");
-		return -EBUSY;
-	}
-
 	au0828_analog_stream_enable(dev);
 
 	return 0;
-- 
1.9.3

