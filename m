Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 12/18] [media] au0828: add pr_info to track au0828 suspend/resume code
Date: Sat,  9 Aug 2014 21:47:18 -0300
Message-Id: <1407631644-11990-13-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Suspend/resume conditions can be very tricky. Add some info
printk's to help tracking what's happening there.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c  | 4 ++++
 drivers/media/usb/au0828/au0828-dvb.c   | 4 ++++
 drivers/media/usb/au0828/au0828-input.c | 4 ++++
 drivers/media/usb/au0828/au0828-video.c | 5 +++++
 4 files changed, 17 insertions(+)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 452d14249348..bc064803b6c7 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -288,6 +288,8 @@ static int au0828_suspend(struct usb_interface *interface,
 	if (!dev)
 		return 0;
 
+	pr_info("Suspend\n");
+
 	au0828_rc_suspend(dev);
 	au0828_v4l2_suspend(dev);
 	au0828_dvb_suspend(dev);
@@ -303,6 +305,8 @@ static int au0828_resume(struct usb_interface *interface)
 	if (!dev)
 		return 0;
 
+	pr_info("Resume\n");
+
 	/* Power Up the bridge */
 	au0828_write(dev, REG_600, 1 << 4);
 
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 99cf83bca033..ee45990c0be1 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -619,6 +619,8 @@ void au0828_dvb_suspend(struct au0828_dev *dev)
 	struct au0828_dvb *dvb = &dev->dvb;
 
 	if (dvb && dev->urb_streaming) {
+		pr_info("stopping DVB\n");
+
 		cancel_work_sync(&dev->restart_streaming);
 
 		/* Stop transport */
@@ -634,6 +636,8 @@ void au0828_dvb_resume(struct au0828_dev *dev)
 	struct au0828_dvb *dvb = &dev->dvb;
 
 	if (dvb && dev->urb_streaming) {
+		pr_info("resuming DVB\n");
+
 		au0828_set_frontend(dvb->frontend);
 
 		/* Start transport */
diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 6db1ce8e09e1..63995f97dc65 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -378,6 +378,8 @@ int au0828_rc_suspend(struct au0828_dev *dev)
 	if (!ir)
 		return 0;
 
+	pr_info("Stopping RC\n");
+
 	cancel_delayed_work_sync(&ir->work);
 
 	/* Disable IR */
@@ -393,6 +395,8 @@ int au0828_rc_resume(struct au0828_dev *dev)
 	if (!ir)
 		return 0;
 
+	pr_info("Restarting RC\n");
+
 	/* Enable IR */
 	au8522_rc_set(ir, 0xe0, 1 << 4);
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 193b2e364266..5f337b118bff 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1876,7 +1876,10 @@ void au0828_v4l2_suspend(struct au0828_dev *dev)
 	struct urb *urb;
 	int i;
 
+	pr_info("stopping V4L2\n");
+
 	if (dev->stream_state == STREAM_ON) {
+		pr_info("stopping V4L2 active URBs\n");
 		au0828_analog_stream_disable(dev);
 		/* stop urbs */
 		for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
@@ -1900,6 +1903,8 @@ void au0828_v4l2_resume(struct au0828_dev *dev)
 {
 	int i, rc;
 
+	pr_info("restarting V4L2\n");
+
 	if (dev->stream_state == STREAM_ON) {
 		au0828_stream_interrupt(dev);
 		au0828_init_tuner(dev);
-- 
1.9.3

