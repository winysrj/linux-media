Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3578 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0JQM03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 08:26:29 -0400
Message-Id: <49e7400bcbcc4412b77216bb061db1b57cb3b882.1287318143.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 17 Oct 2010 14:26:18 +0200
Subject: [RFC PATCH] radio-mr800: locking fixes
To: linux-media@vger.kernel.org
Cc: David Ellingsworth <david@identd.dyndns.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

- serialize the suspend and resume functions using the global lock.
- do not call usb_autopm_put_interface after a disconnect.
- fix a race when disconnecting the device.

Reported-by: David Ellingsworth <david@identd.dyndns.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-mr800.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 2f56b26..b540e80 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -284,9 +284,13 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
 	struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
 
 	mutex_lock(&radio->lock);
+	/* increase the device node's refcount */
+	get_device(&radio->videodev.dev);
 	v4l2_device_disconnect(&radio->v4l2_dev);
-	mutex_unlock(&radio->lock);
 	video_unregister_device(&radio->videodev);
+	mutex_unlock(&radio->lock);
+	/* decrease the device node's refcount, allowing it to be released */
+	put_device(&radio->videodev.dev);
 }
 
 /* vidioc_querycap - query device capabilities */
@@ -515,7 +519,8 @@ static int usb_amradio_close(struct file *file)
 {
 	struct amradio_device *radio = file->private_data;
 
-	usb_autopm_put_interface(radio->intf);
+	if (video_is_registered(&radio->videodev))
+		usb_autopm_put_interface(radio->intf);
 	return 0;
 }
 
@@ -524,10 +529,12 @@ static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
 
+	mutex_lock(&radio->lock);
 	if (!radio->muted && radio->initialized) {
 		amradio_set_mute(radio, AMRADIO_STOP);
 		radio->muted = 0;
 	}
+	mutex_unlock(&radio->lock);
 
 	dev_info(&intf->dev, "going into suspend..\n");
 	return 0;
@@ -538,8 +545,9 @@ static int usb_amradio_resume(struct usb_interface *intf)
 {
 	struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
 
+	mutex_lock(&radio->lock);
 	if (unlikely(!radio->initialized))
-		return 0;
+		goto unlock;
 
 	if (radio->stereo)
 		amradio_set_stereo(radio, WANT_STEREO);
@@ -551,6 +559,9 @@ static int usb_amradio_resume(struct usb_interface *intf)
 	if (!radio->muted)
 		amradio_set_mute(radio, AMRADIO_START);
 
+unlock:
+	mutex_unlock(&radio->lock);
+
 	dev_info(&intf->dev, "coming out of suspend..\n");
 	return 0;
 }
-- 
1.7.0.4

