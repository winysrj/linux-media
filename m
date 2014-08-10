Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaHJCOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 22:14:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] au0828: fix checks if dvb is initialized
Date: Sat,  9 Aug 2014 23:14:20 -0300
Message-Id: <1407636862-19394-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
References: <1407636862-19394-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev->dvb is always not null, as it is an area at the dev
memory. So, checking if (dev->dvb) is always true.

Instead of this stupid check, what the code wants to do is
to know if the DVB was successully registered.

Fix it by checking, instead, for dvb->frontend. It should
also be sure that this var will be NULL if the device was
not properly initialized.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index ee45990c0be1..bc4ea5397e92 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -267,7 +267,7 @@ static int au0828_dvb_start_feed(struct dvb_demux_feed *feed)
 	if (!demux->dmx.frontend)
 		return -EINVAL;
 
-	if (dvb) {
+	if (dvb->frontend) {
 		mutex_lock(&dvb->lock);
 		dvb->start_count++;
 		dprintk(1, "%s(), start_count: %d, stop_count: %d\n", __func__,
@@ -296,7 +296,7 @@ static int au0828_dvb_stop_feed(struct dvb_demux_feed *feed)
 
 	dprintk(1, "%s()\n", __func__);
 
-	if (dvb) {
+	if (dvb->frontend) {
 		cancel_work_sync(&dev->restart_streaming);
 
 		mutex_lock(&dvb->lock);
@@ -526,8 +526,7 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 		for (i = 0; i < URB_COUNT; i++)
 			kfree(dev->dig_transfer_buffer[i]);
 	}
-
-
+	dvb->frontend = NULL;
 }
 
 /* All the DVB attach calls go here, this function get's modified
@@ -608,6 +607,7 @@ int au0828_dvb_register(struct au0828_dev *dev)
 	if (ret < 0) {
 		if (dvb->frontend->ops.release)
 			dvb->frontend->ops.release(dvb->frontend);
+		dvb->frontend = NULL;
 		return ret;
 	}
 
@@ -618,7 +618,7 @@ void au0828_dvb_suspend(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
 
-	if (dvb && dev->urb_streaming) {
+	if (dvb->frontend && dev->urb_streaming) {
 		pr_info("stopping DVB\n");
 
 		cancel_work_sync(&dev->restart_streaming);
@@ -635,7 +635,7 @@ void au0828_dvb_resume(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
 
-	if (dvb && dev->urb_streaming) {
+	if (dvb->frontend && dev->urb_streaming) {
 		pr_info("resuming DVB\n");
 
 		au0828_set_frontend(dvb->frontend);
-- 
1.9.3

