Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab2FNNmz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 09:42:55 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/4] radio-si470x: Don't unnecesarily read registers on G_TUNER
Date: Thu, 14 Jun 2012 15:43:11 +0200
Message-Id: <1339681394-11348-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reading registers from the pcear USB dongles with the si470x causes a
loud pop (and an alsa buffer overrun). Since most radio apps periodically
call G_TUNER to update mono/stereo, signal and afc status this leads
to the music . pop . music . pop . music -> not good.

On the internet there is an howto for flashing the pcear with a newer
firmware from the silabs reference boardto fix this, but:
1) This howto relies on a special version of the driver which allows
   firmware flashing
2) We should try to avoid the answer to a bug report being upgrade your
   firmware, if at all possible
3) Windows does not suffer from the pop sounds

After a quick look at the driver I found at that the register reads are
not necessary at all, as the device gives us the necessary status through
usb interrupt packets, and the driver already uses these!

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |   10 ++++++----
 drivers/media/radio/si470x/radio-si470x-usb.c    |   12 +++++++++---
 drivers/media/radio/si470x/radio-si470x.h        |    1 +
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index d485b79..5dbb897 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -583,14 +583,16 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval;
+	int retval = 0;
 
 	if (tuner->index != 0)
 		return -EINVAL;
 
-	retval = si470x_get_register(radio, STATUSRSSI);
-	if (retval < 0)
-		return retval;
+	if (!radio->status_rssi_auto_update) {
+		retval = si470x_get_register(radio, STATUSRSSI);
+		if (retval < 0)
+			return retval;
+	}
 
 	/* driver constants */
 	strcpy(tuner->name, "FM");
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index f412f7a..0da5c98 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -399,12 +399,16 @@ static void si470x_int_in_callback(struct urb *urb)
 		}
 	}
 
-	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
+	/* Sometimes the device returns len 0 packets */
+	if (urb->actual_length != RDS_REPORT_SIZE)
 		goto resubmit;
 
-	if (urb->actual_length > 0) {
+	radio->registers[STATUSRSSI] =
+		get_unaligned_be16(&radio->int_in_buffer[1]);
+
+	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS)) {
 		/* Update RDS registers with URB data */
-		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
+		for (regnr = 1; regnr < RDS_REGISTER_NUM; regnr++)
 			radio->registers[STATUSRSSI + regnr] =
 			    get_unaligned_be16(&radio->int_in_buffer[
 				regnr * RADIO_REGISTER_SIZE + 1]);
@@ -480,6 +484,7 @@ resubmit:
 			radio->int_in_running = 0;
 		}
 	}
+	radio->status_rssi_auto_update = radio->int_in_running;
 }
 
 
@@ -560,6 +565,7 @@ static int si470x_start_usb(struct si470x_device *radio)
 				"submitting int urb failed (%d)\n", retval);
 		radio->int_in_running = 0;
 	}
+	radio->status_rssi_auto_update = radio->int_in_running;
 	return retval;
 }
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 4921cab..2a0a46f 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -161,6 +161,7 @@ struct si470x_device {
 
 	struct completion completion;
 	bool stci_enabled;		/* Seek/Tune Complete Interrupt */
+	bool status_rssi_auto_update;	/* Does RSSI get updated automatic? */
 
 #if defined(CONFIG_USB_SI470X) || defined(CONFIG_USB_SI470X_MODULE)
 	/* reference to USB and video device */
-- 
1.7.10.2

