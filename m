Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:45672 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaEGD6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 May 2014 23:58:33 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N560021AR15W620@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 May 2014 12:58:17 +0900 (KST)
From: cb.xiong@samsung.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, dheitmueller@kernellabs.com,
	Changbing Xiong <cb.xiong@samsung.com>
Subject: [PATCH] au0828: fix logic of tuner disconnection
Date: Wed, 07 May 2014 11:58:02 +0800
Message-id: <1399435082-5416-1-git-send-email-cb.xiong@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Changbing Xiong <cb.xiong@samsung.com>

The driver crashed when the tuner was disconnected while restart stream
operations are still being performed. Fixed by adding a flag in struct
au0828_dvb to indicate whether restart stream operations can be performed.

If the stream gets misaligned, the work of restart stream operations are
 usually scheduled for many times in a row. If tuner is disconnected at
this time and some of restart stream operations are still not flushed,
then the driver crashed due to accessing the resource which used in
restart stream operations has been released.

Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c |   13 +++++++++++++
 drivers/media/usb/au0828/au0828.h     |    1 +
 2 files changed, 14 insertions(+)
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828.h

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
old mode 100644
new mode 100755
index 9a6f156..90cdde5
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -280,6 +280,11 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)

 	mutex_lock(&dvb->lock);

+	if (dvb->flag == true) {
+		mutex_unlock(&dvb->lock);
+		return;
+	}
+
 	/* Stop transport */
 	stop_urb_transfer(dev);
 	au0828_write(dev, 0x608, 0x00);
@@ -304,6 +309,8 @@ static int dvb_register(struct au0828_dev *dev)

 	dprintk(1, "%s()\n", __func__);

+	dvb->flag = false;
+
 	INIT_WORK(&dev->restart_streaming, au0828_restart_dvb_streaming);

 	/* register adapter */
@@ -403,6 +410,10 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	if (dvb->frontend == NULL)
 		return;

+	mutex_lock(&dvb->lock);
+	dvb->flag = true;
+	mutex_unlock(&dvb->lock);
+
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
@@ -411,6 +422,8 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	dvb_unregister_frontend(dvb->frontend);
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
+
+	cancel_work_sync(&dev->restart_streaming);
 }

 /* All the DVB attach calls go here, this function get's modified
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
old mode 100644
new mode 100755
index ef1f57f..00255d5
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -102,6 +102,7 @@ struct au0828_dvb {
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
 	int feeding;
+	bool flag;
 };

 enum au0828_stream_state {
--
1.7.9.5

