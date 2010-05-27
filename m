Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41826
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab0E0Qku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:50 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC v2 6/8] dsbr100: properly initialize the radio
Date: Thu, 27 May 2010 12:39:14 -0400
Message-Id: <1274978356-25836-7-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a flag to indicate if the radio has been
initialized or not. If the flag has not been set upon open,
the radio is initialized to a known state.

It combines the STARTED/STOPPED indicators into a single
MUTED flag adn defines a couple of macros for determining
the status of the radio.

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |   53 +++++++++++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 0e009b7..96e6128 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -125,10 +125,13 @@ devices, that would be 76 and 91.  */
 #define FREQ_MAX 108.0
 #define FREQ_MUL 16000
 
-/* defines for radio->status */
-#define STARTED	0
-#define STOPPED	1
+enum dsbr100_status {
+	INITIALIZED	= 1 << 0,
+	MUTED		= 1 << 1
+};
 
+#define radio_initialized(r) (r->status & INITIALIZED)
+#define radio_muted(r) (r->status & MUTED)
 #define videodev_to_radio(d) container_of(d, struct dsbr100_device, videodev)
 
 static int usb_dsbr100_probe(struct usb_interface *intf,
@@ -151,7 +154,7 @@ struct dsbr100_device {
 	struct mutex lock;	/* buffer locking */
 	int curfreq;
 	int stereo;
-	int status;
+	enum dsbr100_status status;
 };
 
 static struct usb_device_id usb_dsbr100_device_table [] = {
@@ -205,7 +208,7 @@ static int dsbr100_start(struct dsbr100_device *radio)
 		goto usb_control_msg_failed;
 	}
 
-	radio->status = STARTED;
+	radio->status &= ~MUTED;
 	return 0;
 
 usb_control_msg_failed:
@@ -246,7 +249,7 @@ static int dsbr100_stop(struct dsbr100_device *radio)
 		goto usb_control_msg_failed;
 	}
 
-	radio->status = STOPPED;
+	radio->status |= MUTED;
 	return 0;
 
 usb_control_msg_failed:
@@ -532,6 +535,32 @@ unlock:
 	return retval;
 }
 
+static int usb_dsbr100_open(struct file *file)
+{
+	struct dsbr100_device *radio = video_drvdata(file);
+	int retval = 0;
+
+	mutex_lock(&radio->lock);
+
+	if (!radio->usbdev) {
+		retval = -EIO;
+		goto unlock;
+	}
+
+	if (unlikely(!radio_initialized(radio))) {
+		retval = dsbr100_stop(radio);
+
+		if (retval)
+			goto unlock;
+
+		radio->status |= INITIALIZED;
+	}
+
+unlock:
+	mutex_unlock(&radio->lock);
+	return retval;
+}
+
 /* Suspend device - stop device. */
 static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
 {
@@ -540,17 +569,17 @@ static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
 
 	mutex_lock(&radio->lock);
 
-	if (radio->status == STARTED) {
+	if (!radio_muted(radio)) {
 		retval = dsbr100_stop(radio);
 		if (retval)
 			dev_warn(&intf->dev, "dsbr100_stop failed\n");
 
-		/* After dsbr100_stop() status set to STOPPED.
+		/* After dsbr100_stop() status set to MUTED.
 		 * If we want driver to start radio on resume
-		 * we set status equal to STARTED.
+		 * we set status equal to not MUTED
 		 * On resume we will check status and run radio if needed.
 		 */
-		radio->status = STARTED;
+		radio->status &= ~MUTED;
 	}
 
 	mutex_unlock(&radio->lock);
@@ -567,7 +596,7 @@ static int usb_dsbr100_resume(struct usb_interface *intf)
 
 	mutex_lock(&radio->lock);
 
-	if (radio->status == STARTED) {
+	if (radio_initialized(radio) && !radio_muted(radio)) {
 		retval = dsbr100_start(radio);
 		if (retval)
 			dev_warn(&intf->dev, "dsbr100_start failed\n");
@@ -593,6 +622,7 @@ static void usb_dsbr100_video_device_release(struct video_device *videodev)
 static const struct v4l2_file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= usb_dsbr100_ioctl,
+	.open		= usb_dsbr100_open,
 };
 
 static const struct v4l2_ioctl_ops usb_dsbr100_ioctl_ops = {
@@ -650,7 +680,6 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
-	radio->status = STOPPED;
 
 	video_set_drvdata(&radio->videodev, radio);
 
-- 
1.7.1

