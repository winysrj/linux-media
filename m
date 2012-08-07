Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52727 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2HGCrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:48 -0400
Received: by vcbfk26 with SMTP id fk26so3432709vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:48 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 03/24] au8522: properly recover from the au8522 delivering misaligned TS streams
Date: Mon,  6 Aug 2012 22:46:53 -0400
Message-Id: <1344307634-11673-4-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is an apparent bug in the au8522 TS clocking which can result in it
delivering a TS payload to the au0828 that is shifted by some number of bits.
For example, the device will announce a packet containing "FA 38 FF F8" which
if you shift left one bit is "1F 47 1F FF F0..."

This presents itself as no TS stream being delivered from the kernel to
userland, since the kernel demux will drop every packet.

In the event that this condition occurs, restart the DVB stream.

Also, this patch includes a couple of lines of cleanup to not change the
FIFO configuration while the FIFO is running (which can screw up the state
machine), and dequeue the buffers before turning off the FIFO.  This puts the
logic in sync with the Windows driver.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-dvb.c |   54 +++++++++++++++++++++++++++---
 drivers/media/video/au0828/au0828.h     |    1 +
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-dvb.c b/drivers/media/video/au0828/au0828-dvb.c
index 39ece8e..b328f65 100644
--- a/drivers/media/video/au0828/au0828-dvb.c
+++ b/drivers/media/video/au0828/au0828-dvb.c
@@ -101,11 +101,14 @@ static struct tda18271_config hauppauge_woodbury_tunerconfig = {
 	.gate    = TDA18271_GATE_DIGITAL,
 };
 
+static void au0828_restart_dvb_streaming(struct work_struct *work);
+
 /*-------------------------------------------------------------------*/
 static void urb_completion(struct urb *purb)
 {
 	struct au0828_dev *dev = purb->context;
 	int ptype = usb_pipetype(purb->pipe);
+	unsigned char *ptr;
 
 	dprintk(2, "%s()\n", __func__);
 
@@ -121,6 +124,16 @@ static void urb_completion(struct urb *purb)
 		return;
 	}
 
+	/* See if the stream is corrupted (to work around a hardware
+	   bug where the stream gets misaligned */
+	ptr = purb->transfer_buffer;
+	if (purb->actual_length > 0 && ptr[0] != 0x47) {
+		dprintk(1, "Need to restart streaming %02x len=%d!\n",
+			ptr[0], purb->actual_length);
+		schedule_work(&dev->restart_streaming);
+		return;
+	}
+
 	/* Feed the transport payload into the kernel demux */
 	dvb_dmx_swfilter_packets(&dev->dvb.demux,
 		purb->transfer_buffer, purb->actual_length / 188);
@@ -138,14 +151,13 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 
 	dprintk(2, "%s()\n", __func__);
 
+	dev->urb_streaming = 0;
 	for (i = 0; i < URB_COUNT; i++) {
 		usb_kill_urb(dev->urbs[i]);
 		kfree(dev->urbs[i]->transfer_buffer);
 		usb_free_urb(dev->urbs[i]);
 	}
 
-	dev->urb_streaming = 0;
-
 	return 0;
 }
 
@@ -246,11 +258,8 @@ static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
 		mutex_lock(&dvb->lock);
 		if (--dvb->feeding == 0) {
 			/* Stop transport */
-			au0828_write(dev, 0x608, 0x00);
-			au0828_write(dev, 0x609, 0x00);
-			au0828_write(dev, 0x60a, 0x00);
-			au0828_write(dev, 0x60b, 0x00);
 			ret = stop_urb_transfer(dev);
+			au0828_write(dev, 0x60b, 0x00);
 		}
 		mutex_unlock(&dvb->lock);
 	}
@@ -258,6 +267,37 @@ static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
 	return ret;
 }
 
+static void au0828_restart_dvb_streaming(struct work_struct *work)
+{
+	struct au0828_dev *dev = container_of(work, struct au0828_dev,
+					      restart_streaming);
+	struct au0828_dvb *dvb = &dev->dvb;
+	int ret;
+
+	if (dev->urb_streaming == 0)
+		return;
+
+	dprintk(1, "Restarting streaming...!\n");
+
+	mutex_lock(&dvb->lock);
+
+	/* Stop transport */
+	ret = stop_urb_transfer(dev);
+	au0828_write(dev, 0x608, 0x00);
+	au0828_write(dev, 0x609, 0x00);
+	au0828_write(dev, 0x60a, 0x00);
+	au0828_write(dev, 0x60b, 0x00);
+
+	/* Start transport */
+	au0828_write(dev, 0x608, 0x90);
+	au0828_write(dev, 0x609, 0x72);
+	au0828_write(dev, 0x60a, 0x71);
+	au0828_write(dev, 0x60b, 0x01);
+	ret = start_urb_transfer(dev);
+
+	mutex_unlock(&dvb->lock);
+}
+
 static int dvb_register(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
@@ -265,6 +305,8 @@ static int dvb_register(struct au0828_dev *dev)
 
 	dprintk(1, "%s()\n", __func__);
 
+	INIT_WORK(&dev->restart_streaming, au0828_restart_dvb_streaming);
+
 	/* register adapter */
 	result = dvb_register_adapter(&dvb->adapter, DRIVER_NAME, THIS_MODULE,
 				      &dev->usbdev->dev, adapter_nr);
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/video/au0828/au0828.h
index 9cde353..61cd63e 100644
--- a/drivers/media/video/au0828/au0828.h
+++ b/drivers/media/video/au0828/au0828.h
@@ -197,6 +197,7 @@ struct au0828_dev {
 
 	/* Digital */
 	struct au0828_dvb		dvb;
+	struct work_struct              restart_streaming;
 
 	/* Analog */
 	struct v4l2_device v4l2_dev;
-- 
1.7.1

