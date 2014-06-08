Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50489 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaFHQzK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jun 2014 12:55:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 8/8] au0828: don't hardcode height/width
Date: Sun,  8 Jun 2014 13:54:58 -0300
Message-Id: <1402246498-2532-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
References: <1402246498-2532-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this device doesn't have a scaler (or have it disabled),
the screen dimentions are a function of the standard. Ok, right
now, only 480 lines standards are implemented, although it
supports other ones. Yet, let's calculate the size, to make
easier to add more standards latter.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 85d83ca5a4cd..385894a1ff68 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -791,7 +791,7 @@ static int au0828_i2s_init(struct au0828_dev *dev)
 static int au0828_analog_stream_enable(struct au0828_dev *d)
 {
 	struct usb_interface *iface;
-	int ret;
+	int ret, h, w;
 
 	dprintk(1, "au0828_analog_stream_enable called\n");
 
@@ -806,20 +806,21 @@ static int au0828_analog_stream_enable(struct au0828_dev *d)
 		}
 	}
 
-	/* FIXME: size should be calculated using d->width, d->height */
+	h = d->height / 2 + 2;
+	w = d->width * 2;
 
 	au0828_writereg(d, AU0828_SENSORCTRL_VBI_103, 0x00);
 	au0828_writereg(d, 0x106, 0x00);
 	/* set x position */
 	au0828_writereg(d, 0x110, 0x00);
 	au0828_writereg(d, 0x111, 0x00);
-	au0828_writereg(d, 0x114, 0xa0);
-	au0828_writereg(d, 0x115, 0x05);
+	au0828_writereg(d, 0x114, w & 0xff);
+	au0828_writereg(d, 0x115, w >> 8);
 	/* set y position */
 	au0828_writereg(d, 0x112, 0x00);
 	au0828_writereg(d, 0x113, 0x00);
-	au0828_writereg(d, 0x116, 0xf2);
-	au0828_writereg(d, 0x117, 0x00);
+	au0828_writereg(d, 0x116, h & 0xff);
+	au0828_writereg(d, 0x117, h >> 8);
 	au0828_writereg(d, AU0828_SENSORCTRL_100, 0xb3);
 
 	return 0;
@@ -1725,6 +1726,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 		dev->vid_timeout_running = 0;
 		del_timer_sync(&dev->vid_timeout);
 
+		au0828_analog_stream_disable(dev);
 		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
 		rc = au0828_stream_interrupt(dev);
 		if (rc != 0)
@@ -1930,7 +1932,8 @@ int au0828_analog_register(struct au0828_dev *dev,
 	struct usb_endpoint_descriptor *endpoint;
 	int i, ret;
 
-	dprintk(1, "au0828_analog_register called!\n");
+	dprintk(1, "au0828_analog_register called for intf#%d!\n",
+		interface->cur_altsetting->desc.bInterfaceNumber);
 
 	/* set au0828 usb interface0 to as5 */
 	retval = usb_set_interface(dev->usbdev,
@@ -1954,6 +1957,9 @@ int au0828_analog_register(struct au0828_dev *dev,
 			dev->max_pkt_size = (tmp & 0x07ff) *
 				(((tmp & 0x1800) >> 11) + 1);
 			dev->isoc_in_endpointaddr = endpoint->bEndpointAddress;
+			dprintk(1,
+				"Found isoc endpoint 0x%02x, max size = %d\n",
+				dev->isoc_in_endpointaddr, dev->max_pkt_size);
 		}
 	}
 	if (!(dev->isoc_in_endpointaddr)) {
-- 
1.9.3

