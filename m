Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1346 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1AHNhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:06 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Dalk7015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:04 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 10/16] radio-mr800: remove autopm support.
Date: Sat,  8 Jan 2011 14:36:35 +0100
Message-Id: <10726fc7153b52f7eb2e4c15dbc1ab9c18eaf15f.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

autopm is a bad idea for radio usb sticks: it means that when the last user
closes the file handle the radio stops working which is not what you want.

Removing this simplifies the code as well.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-mr800.c |   67 ++++--------------------------------
 1 files changed, 8 insertions(+), 59 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 492cfca..3e2b3ae 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -122,8 +122,6 @@ MODULE_PARM_DESC(radio_nr, "Radio Nr");
 static int usb_amradio_probe(struct usb_interface *intf,
 			     const struct usb_device_id *id);
 static void usb_amradio_disconnect(struct usb_interface *intf);
-static int usb_amradio_open(struct file *file);
-static int usb_amradio_close(struct file *file);
 static int usb_amradio_suspend(struct usb_interface *intf,
 				pm_message_t message);
 static int usb_amradio_resume(struct usb_interface *intf);
@@ -141,7 +139,6 @@ struct amradio_device {
 	int curfreq;
 	int stereo;
 	int muted;
-	int initialized;
 };
 
 static inline struct amradio_device *to_amradio_dev(struct v4l2_device *v4l2_dev)
@@ -167,7 +164,6 @@ static struct usb_driver usb_amradio_driver = {
 	.resume			= usb_amradio_resume,
 	.reset_resume		= usb_amradio_resume,
 	.id_table		= usb_amradio_device_table,
-	.supports_autosuspend	= 1,
 };
 
 /* switch on/off the radio. Send 8 bytes to device */
@@ -474,62 +470,13 @@ static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 	return 0;
 }
 
-static int usb_amradio_init(struct amradio_device *radio)
-{
-	int retval;
-
-	retval = amradio_set_mute(radio, AMRADIO_STOP);
-	if (retval)
-		goto out_err;
-
-	retval = amradio_set_stereo(radio, WANT_STEREO);
-	if (retval)
-		goto out_err;
-
-	radio->initialized = 1;
-	goto out;
-
-out_err:
-	amradio_dev_err(&radio->videodev.dev, "initialization failed\n");
-out:
-	return retval;
-}
-
-/* open device - amradio_start() and amradio_setfreq() */
-static int usb_amradio_open(struct file *file)
-{
-	struct amradio_device *radio = video_drvdata(file);
-	int retval;
-
-	retval = usb_autopm_get_interface(radio->intf);
-	if (retval)
-		return retval;
-
-	if (unlikely(!radio->initialized)) {
-		retval = usb_amradio_init(radio);
-		if (retval)
-			usb_autopm_put_interface(radio->intf);
-	}
-	return retval;
-}
-
-/*close device */
-static int usb_amradio_close(struct file *file)
-{
-	struct amradio_device *radio = video_drvdata(file);
-
-	if (video_is_registered(&radio->videodev))
-		usb_autopm_put_interface(radio->intf);
-	return 0;
-}
-
 /* Suspend device - stop device. Need to be checked and fixed */
 static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
 
 	mutex_lock(&radio->lock);
-	if (!radio->muted && radio->initialized) {
+	if (!radio->muted) {
 		amradio_set_mute(radio, AMRADIO_STOP);
 		radio->muted = 0;
 	}
@@ -545,8 +492,6 @@ static int usb_amradio_resume(struct usb_interface *intf)
 	struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
 
 	mutex_lock(&radio->lock);
-	if (unlikely(!radio->initialized))
-		goto unlock;
 
 	if (radio->stereo)
 		amradio_set_stereo(radio, WANT_STEREO);
@@ -558,7 +503,6 @@ static int usb_amradio_resume(struct usb_interface *intf)
 	if (!radio->muted)
 		amradio_set_mute(radio, AMRADIO_START);
 
-unlock:
 	mutex_unlock(&radio->lock);
 
 	dev_info(&intf->dev, "coming out of suspend..\n");
@@ -568,8 +512,6 @@ unlock:
 /* File system interface */
 static const struct v4l2_file_operations usb_amradio_fops = {
 	.owner		= THIS_MODULE,
-	.open		= usb_amradio_open,
-	.release	= usb_amradio_close,
 	.unlocked_ioctl	= video_ioctl2,
 };
 
@@ -641,6 +583,13 @@ static int usb_amradio_probe(struct usb_interface *intf,
 	radio->curfreq = 95.16 * FREQ_MUL;
 
 	video_set_drvdata(&radio->videodev, radio);
+	retval = amradio_set_mute(radio, AMRADIO_STOP);
+	if (!retval)
+		retval = amradio_set_stereo(radio, WANT_STEREO);
+	if (retval) {
+		dev_err(&intf->dev, "initialization failed\n");
+		goto err_vdev;
+	}
 
 	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
 					radio_nr);
-- 
1.7.0.4

