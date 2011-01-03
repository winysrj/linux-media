Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2716 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab1ACSbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jan 2011 13:31:31 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr18.xs4all.nl (8.13.8/8.13.8) with ESMTP id p03IVMuY006180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 3 Jan 2011 19:31:30 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv2 PATCH 07/10] radio-mr800: remove autopm support.
Date: Mon,  3 Jan 2011 19:31:12 +0100
Message-Id: <910fe6472dfab87e56c5fa6245c233ff4f0d7ea9.1294078230.git.hverkuil@xs4all.nl>
In-Reply-To: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
References: <1294079475-13259-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
References: <6515cfbdde63364fd12bca1219870f38ff371145.1294078230.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

autopm is a bad idea for radio usb sticks: it means that when the last user
closes the file handle the radio stops working which is not what you want.

Removing this simplifies the code as well.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-mr800.c |   87 ++-----------------------------------
 1 files changed, 4 insertions(+), 83 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 492cfca..fcf3a9c 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -122,11 +122,6 @@ MODULE_PARM_DESC(radio_nr, "Radio Nr");
 static int usb_amradio_probe(struct usb_interface *intf,
 			     const struct usb_device_id *id);
 static void usb_amradio_disconnect(struct usb_interface *intf);
-static int usb_amradio_open(struct file *file);
-static int usb_amradio_close(struct file *file);
-static int usb_amradio_suspend(struct usb_interface *intf,
-				pm_message_t message);
-static int usb_amradio_resume(struct usb_interface *intf);
 
 /* Data for one (physical) device */
 struct amradio_device {
@@ -141,7 +136,6 @@ struct amradio_device {
 	int curfreq;
 	int stereo;
 	int muted;
-	int initialized;
 };
 
 static inline struct amradio_device *to_amradio_dev(struct v4l2_device *v4l2_dev)
@@ -163,11 +157,7 @@ static struct usb_driver usb_amradio_driver = {
 	.name			= MR800_DRIVER_NAME,
 	.probe			= usb_amradio_probe,
 	.disconnect		= usb_amradio_disconnect,
-	.suspend		= usb_amradio_suspend,
-	.resume			= usb_amradio_resume,
-	.reset_resume		= usb_amradio_resume,
 	.id_table		= usb_amradio_device_table,
-	.supports_autosuspend	= 1,
 };
 
 /* switch on/off the radio. Send 8 bytes to device */
@@ -486,7 +476,6 @@ static int usb_amradio_init(struct amradio_device *radio)
 	if (retval)
 		goto out_err;
 
-	radio->initialized = 1;
 	goto out;
 
 out_err:
@@ -495,81 +484,9 @@ out:
 	return retval;
 }
 
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
-/* Suspend device - stop device. Need to be checked and fixed */
-static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
-{
-	struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
-
-	mutex_lock(&radio->lock);
-	if (!radio->muted && radio->initialized) {
-		amradio_set_mute(radio, AMRADIO_STOP);
-		radio->muted = 0;
-	}
-	mutex_unlock(&radio->lock);
-
-	dev_info(&intf->dev, "going into suspend..\n");
-	return 0;
-}
-
-/* Resume device - start device. Need to be checked and fixed */
-static int usb_amradio_resume(struct usb_interface *intf)
-{
-	struct amradio_device *radio = to_amradio_dev(usb_get_intfdata(intf));
-
-	mutex_lock(&radio->lock);
-	if (unlikely(!radio->initialized))
-		goto unlock;
-
-	if (radio->stereo)
-		amradio_set_stereo(radio, WANT_STEREO);
-	else
-		amradio_set_stereo(radio, WANT_MONO);
-
-	amradio_setfreq(radio, radio->curfreq);
-
-	if (!radio->muted)
-		amradio_set_mute(radio, AMRADIO_START);
-
-unlock:
-	mutex_unlock(&radio->lock);
-
-	dev_info(&intf->dev, "coming out of suspend..\n");
-	return 0;
-}
-
 /* File system interface */
 static const struct v4l2_file_operations usb_amradio_fops = {
 	.owner		= THIS_MODULE,
-	.open		= usb_amradio_open,
-	.release	= usb_amradio_close,
 	.unlocked_ioctl	= video_ioctl2,
 };
 
@@ -642,6 +559,10 @@ static int usb_amradio_probe(struct usb_interface *intf,
 
 	video_set_drvdata(&radio->videodev, radio);
 
+	retval = usb_amradio_init(radio);
+	if (retval < 0)
+		goto err_vdev;
+
 	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
 					radio_nr);
 	if (retval < 0) {
-- 
1.7.0.4

