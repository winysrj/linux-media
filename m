Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17607 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaEHG0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 02:26:23 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5800JVISJYZM60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 May 2014 15:26:22 +0900 (KST)
From: Changbing Xiong <cb.xiong@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, dheitmueller@kernellabs.com
Subject: [PATCH 1/2] au0828: Fix disconnection bug of tuner
Date: Thu, 08 May 2014 14:25:51 +0800
Message-id: <1399530351-6755-1-git-send-email-cb.xiong@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
 drivers/media/usb/au0828/au0828-dvb.c |   11 +++++++++++
 drivers/media/usb/au0828/au0828.h     |    1 +
 2 files changed, 12 insertions(+)
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828.h

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
old mode 100644
new mode 100755
index 9a6f156..878f66f
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -280,6 +280,11 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)

 	mutex_lock(&dvb->lock);

+	if (dvb->fe_disconnected == true) {
+		mutex_unlock(&dvb->lock);
+		return;
+	}
+
 	/* Stop transport */
 	stop_urb_transfer(dev);
 	au0828_write(dev, 0x608, 0x00);
@@ -304,6 +309,8 @@ static int dvb_register(struct au0828_dev *dev)

 	dprintk(1, "%s()\n", __func__);

+	dvb->fe_disconnected = false;
+
 	INIT_WORK(&dev->restart_streaming, au0828_restart_dvb_streaming);

 	/* register adapter */
@@ -403,6 +410,10 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	if (dvb->frontend == NULL)
 		return;

+	mutex_lock(&dvb->lock);
+	dvb->fe_disconnected = true;
+	mutex_unlock(&dvb->lock);
+
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
old mode 100644
new mode 100755
index ef1f57f..9f9623a
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -102,6 +102,7 @@ struct au0828_dvb {
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
 	int feeding;
+	bool fe_disconnected;
 };

 enum au0828_stream_state {
--
1.7.9.5

