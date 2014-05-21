Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaEUSUP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 14:20:15 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/8] [media] Reset au0828 streaming when a new frequency is set
Date: Wed, 21 May 2014 15:19:57 -0300
Message-Id: <1400696402-1805-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Trevor, doing several opening/streaming/closing
operations to the demux causes it to fail.

I was able to simulate this bug too. I also noticed that,
sometimes, changing channels with au0828, the same thing
happens.

Most of the issues seem to be due to some hardware bug, that
causes the device to not fill all the URBs allocated. When
the bug happens, the only known fix is to either replug the
device, or to send an USB reset to it.

There's also a hack a the au0828 driver that starts a thread
that tries to reset the device when a package doesn't start
with a sync.

One of the culpits for this bad hardware behavior seem to be
caused by the lack of stopping and restarting the stream every
time a new channel is set.

This patch warrants that the stream will be properly reset
every time the set_frontend callback is called, partially
solving the problem.

A complete fix, however, would also need to check the PM
conditions for the tuner and demux.

Reported-by: Trevor Graffa <tlgraffa@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c | 43 +++++++++++++++++++++++++++++++++--
 drivers/media/usb/au0828/au0828.h     |  2 ++
 2 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index ab5f93643021..d8b5d9480279 100755
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -256,8 +256,6 @@ static void au0828_stop_transport(struct au0828_dev *dev, int full_stop)
 	au0828_write(dev, 0x60b, 0x00);
 }
 
-
-
 static int au0828_dvb_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
@@ -300,6 +298,8 @@ static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
 	dprintk(1, "%s()\n", __func__);
 
 	if (dvb) {
+		cancel_work_sync(&dev->restart_streaming);
+
 		mutex_lock(&dvb->lock);
 		dvb->stop_count++;
 		dprintk(1, "%s(), start_count: %d, stop_count: %d\n", __func__,
@@ -342,6 +342,41 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 	mutex_unlock(&dvb->lock);
 }
 
+static int au0828_set_frontend(struct dvb_frontend *fe)
+{
+	struct au0828_dev *dev = fe->dvb->priv;
+	struct au0828_dvb *dvb = &dev->dvb;
+	int ret, was_streaming;
+
+	mutex_lock(&dvb->lock);
+	was_streaming = dev->urb_streaming;
+	if (was_streaming) {
+		au0828_stop_transport(dev, 1);
+
+		/*
+		 * We can't hold a mutex here, as the restart_streaming
+		 * kthread may also hold it.
+		 */
+		mutex_unlock(&dvb->lock);
+		cancel_work_sync(&dev->restart_streaming);
+		mutex_lock(&dvb->lock);
+
+		stop_urb_transfer(dev);
+	}
+	mutex_unlock(&dvb->lock);
+
+	ret = dvb->set_frontend(fe);
+
+	if (was_streaming) {
+		mutex_lock(&dvb->lock);
+		au0828_start_transport(dev);
+		start_urb_transfer(dev);
+		mutex_unlock(&dvb->lock);
+	}
+
+	return ret;
+}
+
 static int dvb_register(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
@@ -386,6 +421,10 @@ static int dvb_register(struct au0828_dev *dev)
 		goto fail_frontend;
 	}
 
+	/* Hook dvb frontend */
+	dvb->set_frontend = dvb->frontend->ops.set_frontend;
+	dvb->frontend->ops.set_frontend = au0828_set_frontend;
+
 	/* register demux stuff */
 	dvb->demux.dmx.capabilities =
 		DMX_TS_FILTERING | DMX_SECTION_FILTERING |
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index 5439772c1551..7112b9d956fa 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -104,6 +104,8 @@ struct au0828_dvb {
 	int feeding;
 	int start_count;
 	int stop_count;
+
+	int (*set_frontend)(struct dvb_frontend *fe);
 };
 
 enum au0828_stream_state {
-- 
1.9.0

