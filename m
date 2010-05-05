Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:48160
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0EERhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 May 2010 13:37:14 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC 5/7] dsbr100: properly initialize the radio
Date: Wed,  5 May 2010 13:05:28 -0400
Message-Id: <1273079130-21999-6-git-send-email-david@identd.dyndns.org>
In-Reply-To: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
References: <1273079130-21999-1-git-send-email-david@identd.dyndns.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a flag to indicate if the radio has been
initialized or not. If the flag has not been set upon open,
the radio initialized to a known state.

It combines the STARTED/STOPPED indicators into a single
MUTED flag and defines a couple of macros for determining
the status of the radio.

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |   54 +++++++++++++++++++++++++++++++---------
 1 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index c949ace..e2fed0b 100644
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
 	return (radio->transfer_buffer)[0];
 
 usb_control_msg_failed:
@@ -246,7 +249,7 @@ static int dsbr100_stop(struct dsbr100_device *radio)
 		goto usb_control_msg_failed;
 	}
 
-	radio->status = STOPPED;
+	radio->status |= MUTED;
 	return (radio->transfer_buffer)[0];
 
 usb_control_msg_failed:
@@ -532,6 +535,33 @@ unlock:
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
+		if (retval < 0)
+			goto unlock;
+
+		retval = 0;
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
@@ -540,17 +570,17 @@ static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
 
 	mutex_lock(&radio->lock);
 
-	if (radio->status == STARTED) {
+	if (!radio_muted(radio)) {
 		retval = dsbr100_stop(radio);
 		if (retval < 0)
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
@@ -567,7 +597,7 @@ static int usb_dsbr100_resume(struct usb_interface *intf)
 
 	mutex_lock(&radio->lock);
 
-	if (radio->status == STARTED) {
+	if (radio_initialized(radio) && !radio_muted(radio)) {
 		retval = dsbr100_start(radio);
 		if (retval < 0)
 			dev_warn(&intf->dev, "dsbr100_start failed\n");
@@ -593,6 +623,7 @@ static void usb_dsbr100_video_device_release(struct video_device *videodev)
 static const struct v4l2_file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= usb_dsbr100_ioctl,
+	.open		= usb_dsbr100_open,
 };
 
 static const struct v4l2_ioctl_ops usb_dsbr100_ioctl_ops = {
@@ -650,7 +681,6 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
-	radio->status = STOPPED;
 
 	video_set_drvdata(&radio->videodev, radio);
 
-- 
1.7.1

