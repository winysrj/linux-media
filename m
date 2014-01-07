Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36366 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaAGE3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 23:29:54 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so19002689pdj.15
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 20:29:54 -0800 (PST)
From: Tim Mester <ttmesterr@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tim Mester <tmester@ieee.org>
Subject: [PATCH 1/3] au8028: Fix cleanup on kzalloc fail
Date: Mon,  6 Jan 2014 21:29:24 -0700
Message-Id: <1389068966-14594-1-git-send-email-tmester@ieee.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Free what was allocated if there is a failure allocating
transfer buffers.

Stop the feed on a start feed error.  The stop feed is not always called
if start feed fails.  If the feed is not stopped on error, then the driver
will be stuck so that it can never start feeding again.

Signed-off-by: Tim Mester <tmester@ieee.org>
---
 linux/drivers/media/usb/au0828/au0828-dvb.c | 70 +++++++++++++++++++++--------
 linux/drivers/media/usb/au0828/au0828.h     |  2 +
 2 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/linux/drivers/media/usb/au0828/au0828-dvb.c b/linux/drivers/media/usb/au0828/au0828-dvb.c
index 9a6f156..2312381 100644
--- a/linux/drivers/media/usb/au0828/au0828-dvb.c
+++ b/linux/drivers/media/usb/au0828/au0828-dvb.c
@@ -153,9 +153,11 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 
 	dev->urb_streaming = 0;
 	for (i = 0; i < URB_COUNT; i++) {
-		usb_kill_urb(dev->urbs[i]);
-		kfree(dev->urbs[i]->transfer_buffer);
-		usb_free_urb(dev->urbs[i]);
+		if (dev->urbs[i]) {
+			usb_kill_urb(dev->urbs[i]);
+			kfree(dev->urbs[i]->transfer_buffer);
+			usb_free_urb(dev->urbs[i]);
+		}
 	}
 
 	return 0;
@@ -185,6 +187,8 @@ static int start_urb_transfer(struct au0828_dev *dev)
 		if (!purb->transfer_buffer) {
 			usb_free_urb(purb);
 			dev->urbs[i] = NULL;
+			printk(KERN_ERR "%s: failed big buffer allocation, "
+			       "err = %d\n", __func__, ret);
 			goto err;
 		}
 
@@ -217,6 +221,27 @@ err:
 	return ret;
 }
 
+static void au0828_start_transport(struct au0828_dev *dev)
+{
+	au0828_write(dev, 0x608, 0x90);
+	au0828_write(dev, 0x609, 0x72);
+	au0828_write(dev, 0x60a, 0x71);
+	au0828_write(dev, 0x60b, 0x01);
+
+}
+
+static void au0828_stop_transport(struct au0828_dev *dev, int full_stop)
+{
+	if (full_stop) {
+		au0828_write(dev, 0x608, 0x00);
+		au0828_write(dev, 0x609, 0x00);
+		au0828_write(dev, 0x60a, 0x00);
+	}
+	au0828_write(dev, 0x60b, 0x00);
+}
+
+
+
 static int au0828_dvb_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
@@ -231,13 +256,17 @@ static int au0828_dvb_start_feed(struct dvb_demux_feed *feed)
 
 	if (dvb) {
 		mutex_lock(&dvb->lock);
+		dvb->start_count++;
+		dprintk(1, "%s(), start_count: %d, stop_count: %d\n", __func__,
+			dvb->start_count, dvb->stop_count);
 		if (dvb->feeding++ == 0) {
 			/* Start transport */
-			au0828_write(dev, 0x608, 0x90);
-			au0828_write(dev, 0x609, 0x72);
-			au0828_write(dev, 0x60a, 0x71);
-			au0828_write(dev, 0x60b, 0x01);
+			au0828_start_transport(dev);
 			ret = start_urb_transfer(dev);
+			if (ret < 0) {
+				au0828_stop_transport(dev, 0);
+				dvb->feeding--;	/* We ran out of memory... */
+			}
 		}
 		mutex_unlock(&dvb->lock);
 	}
@@ -256,10 +285,16 @@ static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
 
 	if (dvb) {
 		mutex_lock(&dvb->lock);
-		if (--dvb->feeding == 0) {
-			/* Stop transport */
-			ret = stop_urb_transfer(dev);
-			au0828_write(dev, 0x60b, 0x00);
+		dvb->stop_count++;
+		dprintk(1, "%s(), start_count: %d, stop_count: %d\n", __func__,
+			dvb->start_count, dvb->stop_count);
+		if (dvb->feeding > 0) {
+			dvb->feeding--;
+			if (dvb->feeding == 0) {
+				/* Stop transport */
+				ret = stop_urb_transfer(dev);
+				au0828_stop_transport(dev, 0);
+			}
 		}
 		mutex_unlock(&dvb->lock);
 	}
@@ -282,16 +317,10 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 
 	/* Stop transport */
 	stop_urb_transfer(dev);
-	au0828_write(dev, 0x608, 0x00);
-	au0828_write(dev, 0x609, 0x00);
-	au0828_write(dev, 0x60a, 0x00);
-	au0828_write(dev, 0x60b, 0x00);
+	au0828_stop_transport(dev, 1);
 
 	/* Start transport */
-	au0828_write(dev, 0x608, 0x90);
-	au0828_write(dev, 0x609, 0x72);
-	au0828_write(dev, 0x60a, 0x71);
-	au0828_write(dev, 0x60b, 0x01);
+	au0828_start_transport(dev);
 	start_urb_transfer(dev);
 
 	mutex_unlock(&dvb->lock);
@@ -375,6 +404,9 @@ static int dvb_register(struct au0828_dev *dev)
 
 	/* register network adapter */
 	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
+
+	dvb->start_count = 0;
+	dvb->stop_count = 0;
 	return 0;
 
 fail_fe_conn:
diff --git a/linux/drivers/media/usb/au0828/au0828.h b/linux/drivers/media/usb/au0828/au0828.h
index ef1f57f..a00b400 100644
--- a/linux/drivers/media/usb/au0828/au0828.h
+++ b/linux/drivers/media/usb/au0828/au0828.h
@@ -102,6 +102,8 @@ struct au0828_dvb {
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
 	int feeding;
+	int start_count;
+	int stop_count;
 };
 
 enum au0828_stream_state {
-- 
1.8.1.4

