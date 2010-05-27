Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41828
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab0E0Qkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:51 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC v2 5/8] dsbr100: cleanup return value of start/stop handlers
Date: Thu, 27 May 2010 12:39:13 -0400
Message-Id: <1274978356-25836-6-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The value returned from the device in radio->transfer_buffer[0]
isn't clearly defined, but is used as a return code. This value
is an unsigned 8-bit integer that is implicitly converted to an
int. Since this value can never be less than 0, return 0 instead.
This simplifies the verification of calling dsbr100_start and
dsbr100_stop.

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index c949ace..0e009b7 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -206,7 +206,7 @@ static int dsbr100_start(struct dsbr100_device *radio)
 	}
 
 	radio->status = STARTED;
-	return (radio->transfer_buffer)[0];
+	return 0;
 
 usb_control_msg_failed:
 	dev_err(&radio->usbdev->dev,
@@ -247,7 +247,7 @@ static int dsbr100_stop(struct dsbr100_device *radio)
 	}
 
 	radio->status = STOPPED;
-	return (radio->transfer_buffer)[0];
+	return 0;
 
 usb_control_msg_failed:
 	dev_err(&radio->usbdev->dev,
@@ -461,14 +461,14 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
 			retval = dsbr100_stop(radio);
-			if (retval < 0) {
+			if (retval) {
 				dev_warn(&radio->usbdev->dev,
 					 "Radio did not respond properly\n");
 				return -EBUSY;
 			}
 		} else {
 			retval = dsbr100_start(radio);
-			if (retval < 0) {
+			if (retval) {
 				dev_warn(&radio->usbdev->dev,
 					 "Radio did not respond properly\n");
 				return -EBUSY;
@@ -542,7 +542,7 @@ static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
 
 	if (radio->status == STARTED) {
 		retval = dsbr100_stop(radio);
-		if (retval < 0)
+		if (retval)
 			dev_warn(&intf->dev, "dsbr100_stop failed\n");
 
 		/* After dsbr100_stop() status set to STOPPED.
@@ -569,7 +569,7 @@ static int usb_dsbr100_resume(struct usb_interface *intf)
 
 	if (radio->status == STARTED) {
 		retval = dsbr100_start(radio);
-		if (retval < 0)
+		if (retval)
 			dev_warn(&intf->dev, "dsbr100_start failed\n");
 	}
 
-- 
1.7.1

