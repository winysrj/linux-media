Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QKUkmJ006340
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:30:46 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4QKUYMu029420
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:30:34 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 26 May 2008 22:30:26 +0200
References: <200805072253.23219.tobias.lorenz@gmx.net>
	<20080526104146.7ef1bc91@gaivota>
In-Reply-To: <20080526104146.7ef1bc91@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805262230.26492.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 1/6] si470x: unplugging fixed
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Mauro,

> Please, don't send a patch with several different things on it. Instead, send me incremental patches. with just one change. So, you would send me:
> 	a patch for harware seek support;
> 	a patch for afc indication; 
> 	...

I splitted PATCH 2/2 into six separate parts.
Again this applies to vanilla 2.6.25.
For 5/6 and 6/6 also the previous general hw seek support PATCH 1/2 is necessary.

1/6: unplugging fixed
- problem fixed, when unplugging the device while still in use
- version bump to 1.0.7 finally made, was inconsistent in linux-2.6.25!

2/6: let si470x_get_freq return errno
- version bumped to 1.0.8 for all the following patches
- si470x_get_freq now returns errno

3/6: a lot of small code cleanups
- comment on how to listen to an usb audio device
  (i get so many questions about that...)
- code cleanup (error handling, more warnings, spacing, ...)

4/6: afc indication
- afc indication:
  device has no indication whether freq is too low or too high
  therefore afc always return 1, when freq is wrong

5/6: hardware frequency seek support
- this now finally adds hardware frequency seek support

6/6: private video controls
- private video controls
  - to control seek behaviour
  - to module parameters
  - corrected access rights of module parameters
  - separate header file to let the user space know about it

Best regards,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 0_vanilla/drivers/media/radio/radio-si470x.c 1_unplugging/drivers/media/radio/radio-si470x.c
--- 0_vanilla/drivers/media/radio/radio-si470x.c	2008-05-26 20:46:09.000000000 +0200
+++ 1_unplugging/drivers/media/radio/radio-si470x.c	2008-05-26 22:07:45.000000000 +0200
@@ -85,6 +85,7 @@
  *		Oliver Neukum <oliver@neukum.org>
  *		Version 1.0.7
  *		- usb autosuspend support
+ *		- unplugging fixed
  *
  * ToDo:
  * - add seeking support
@@ -97,10 +98,10 @@
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_NAME "radio-si470x"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 6)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 7)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.6"
+#define DRIVER_VERSION "1.0.7"
 
 
 /* kernel includes */
@@ -424,6 +425,8 @@ struct si470x_device {
 
 	/* driver management */
 	unsigned int users;
+	unsigned char disconnected;
+	struct mutex disconnect_lock;
 
 	/* Silabs internal registers (0..15) */
 	unsigned short registers[RADIO_REGISTER_NUM];
@@ -875,6 +878,8 @@ static void si470x_work(struct work_stru
 	struct si470x_device *radio = container_of(work, struct si470x_device,
 		work.work);
 
+	if (radio->disconnected)
+		return;
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		return;
 
@@ -1001,13 +1006,21 @@ static int si470x_fops_open(struct inode
 static int si470x_fops_release(struct inode *inode, struct file *file)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
 	if (!radio)
 		return -ENODEV;
 
+	mutex_lock(&radio->disconnect_lock);
 	radio->users--;
 	if (radio->users == 0) {
+		if (radio->disconnected) {
+			video_unregister_device(radio->videodev);
+			kfree(radio->buffer);
+			kfree(radio);
+			goto unlock;
+		}
+
 		/* stop rds reception */
 		cancel_delayed_work_sync(&radio->work);
 
@@ -1016,10 +1029,11 @@ static int si470x_fops_release(struct in
 
 		retval = si470x_stop(radio);
 		usb_autopm_put_interface(radio->intf);
-		return retval;
 	}
 
-	return 0;
+unlock:
+	mutex_unlock(&radio->disconnect_lock);
+	return retval;
 }
 
 
@@ -1157,6 +1171,9 @@ static int si470x_vidioc_g_ctrl(struct f
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 
+	if (radio->disconnected)
+		return -EIO;
+
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
 		ctrl->value = radio->registers[SYSCONFIG2] &
@@ -1181,6 +1198,9 @@ static int si470x_vidioc_s_ctrl(struct f
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
+	if (radio->disconnected)
+		return -EIO;
+
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
 		radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_VOLUME;
@@ -1243,6 +1263,8 @@ static int si470x_vidioc_g_tuner(struct 
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
+	if (radio->disconnected)
+		return -EIO;
 	if (tuner->index > 0)
 		return -EINVAL;
 
@@ -1299,6 +1321,8 @@ static int si470x_vidioc_s_tuner(struct 
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
+	if (radio->disconnected)
+		return -EIO;
 	if (tuner->index > 0)
 		return -EINVAL;
 
@@ -1324,6 +1348,9 @@ static int si470x_vidioc_g_frequency(str
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 
+	if (radio->disconnected)
+		return -EIO;
+
 	freq->type = V4L2_TUNER_RADIO;
 	freq->frequency = si470x_get_freq(radio);
 
@@ -1340,6 +1367,8 @@ static int si470x_vidioc_s_frequency(str
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
+	if (radio->disconnected)
+		return -EIO;
 	if (freq->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
 
@@ -1404,8 +1433,10 @@ static int si470x_usb_driver_probe(struc
 	memcpy(radio->videodev, &si470x_viddev_template,
 			sizeof(si470x_viddev_template));
 	radio->users = 0;
+	radio->disconnected = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
+	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);
 	video_set_drvdata(radio->videodev, radio);
 
@@ -1510,11 +1541,16 @@ static void si470x_usb_driver_disconnect
 {
 	struct si470x_device *radio = usb_get_intfdata(intf);
 
+	mutex_lock(&radio->disconnect_lock);
+	radio->disconnected = 1;
 	cancel_delayed_work_sync(&radio->work);
 	usb_set_intfdata(intf, NULL);
-	video_unregister_device(radio->videodev);
-	kfree(radio->buffer);
-	kfree(radio);
+	if (radio->users == 0) {
+		video_unregister_device(radio->videodev);
+		kfree(radio->buffer);
+		kfree(radio);
+	}
+	mutex_unlock(&radio->disconnect_lock);
 }
 
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
