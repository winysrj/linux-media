Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaHJCOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 22:14:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] au0828: Fix DVB resume when streaming
Date: Sat,  9 Aug 2014 23:14:21 -0300
Message-Id: <1407636862-19394-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
References: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When DVB is streaming and suspend is called, it will call
au0828_stop_transport(), with will clean the streaming flag.

Due to that, stop_urb_transfer() will be called twice,
causing an oops.

So, we need another flag to be used at resume, telling it
to restart DVB.

While here, add a logic at stop_urb_transfer() to prevent
it of being called twice, and convert the usb_streaming
flag into boolean.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c | 14 +++++++++-----
 drivers/media/usb/au0828/au0828.h     |  4 ++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index bc4ea5397e92..821f86e92cde 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -121,7 +121,7 @@ static void urb_completion(struct urb *purb)
 		return;
 	}
 
-	if (dev->urb_streaming == 0) {
+	if (!dev->urb_streaming) {
 		dprintk(2, "%s: not streaming!\n", __func__);
 		return;
 	}
@@ -159,7 +159,10 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 
 	dprintk(2, "%s()\n", __func__);
 
-	dev->urb_streaming = 0;
+	if (!dev->urb_streaming)
+		return 0;
+
+	dev->urb_streaming = false;
 	for (i = 0; i < URB_COUNT; i++) {
 		if (dev->urbs[i]) {
 			usb_kill_urb(dev->urbs[i]);
@@ -229,7 +232,7 @@ static int start_urb_transfer(struct au0828_dev *dev)
 		}
 	}
 
-	dev->urb_streaming = 1;
+	dev->urb_streaming = true;
 	ret = 0;
 
 err:
@@ -323,7 +326,7 @@ static void au0828_restart_dvb_streaming(struct work_struct *work)
 					      restart_streaming);
 	struct au0828_dvb *dvb = &dev->dvb;
 
-	if (dev->urb_streaming == 0)
+	if (!dev->urb_streaming)
 		return;
 
 	dprintk(1, "Restarting streaming...!\n");
@@ -628,6 +631,7 @@ void au0828_dvb_suspend(struct au0828_dev *dev)
 		stop_urb_transfer(dev);
 		au0828_stop_transport(dev, 1);
 		mutex_unlock(&dvb->lock);
+		dev->need_urb_start = 1;
 	}
 }
 
@@ -635,7 +639,7 @@ void au0828_dvb_resume(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
 
-	if (dvb->frontend && dev->urb_streaming) {
+	if (dvb->frontend && dev->need_urb_start) {
 		pr_info("resuming DVB\n");
 
 		au0828_set_frontend(dvb->frontend);
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index d187129b96b7..a7cc6e397fdd 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -267,8 +267,8 @@ struct au0828_dev {
 	char *transfer_buffer[AU0828_MAX_ISO_BUFS];/* transfer buffers for isoc
 						   transfer */
 
-	/* USB / URB Related */
-	int		urb_streaming;
+	/* DVB USB / URB Related */
+	bool		urb_streaming, need_urb_start;
 	struct urb	*urbs[URB_COUNT];
 
 	/* Preallocated transfer digital transfer buffers */
-- 
1.9.3

