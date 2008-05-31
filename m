Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VFFPff000662
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:25 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4VFFDnL015859
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:13 -0400
Content-Disposition: inline
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 31 May 2008 17:04:32 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805311704.32794.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 1/6] si470x: move global lock to device structure
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

this patch brings the following changes:
- move the global disconnect lock into the device structure
- code cleanup (spaces to tabs, long line splits, ...)

Best regards,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 0_mercurial/drivers/media/radio/radio-si470x.c 1_unplugging/drivers/media/radio/radio-si470x.c
--- 0_mercurial/drivers/media/radio/radio-si470x.c	2008-05-31 15:55:04.000000000 +0200
+++ 1_unplugging/drivers/media/radio/radio-si470x.c	2008-05-31 16:24:00.000000000 +0200
@@ -85,7 +85,7 @@
  *		Oliver Neukum <oliver@neukum.org>
  *		Version 1.0.7
  *		- usb autosuspend support
- *             - unplugging fixed
+ *		- unplugging fixed
  *
  * ToDo:
  * - add seeking support
@@ -428,7 +428,8 @@ struct si470x_device {
 
 	/* driver management */
 	unsigned int users;
-       unsigned char disconnected;
+	unsigned char disconnected;
+	struct mutex disconnect_lock;
 
 	/* Silabs internal registers (0..15) */
 	unsigned short registers[RADIO_REGISTER_NUM];
@@ -453,12 +454,6 @@ struct si470x_device {
 
 
 /*
- * Lock to prevent kfree of data before all users have releases the device.
- */
-static DEFINE_MUTEX(open_close_lock);
-
-
-/*
  * The frequency is set in units of 62.5 Hz when using V4L2_TUNER_CAP_LOW,
  * 62.5 kHz otherwise.
  * The tuner is able to have a channel spacing of 50, 100 or 200 kHz.
@@ -593,7 +588,7 @@ static int si470x_get_rds_registers(stru
 		usb_rcvintpipe(radio->usbdev, 1),
 		(void *) &buf, sizeof(buf), &size, usb_timeout);
 	if (size != sizeof(buf))
-	       printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
+		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
 			"return size differs: %d != %zu\n", size, sizeof(buf));
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
@@ -602,7 +597,8 @@ static int si470x_get_rds_registers(stru
 	if (retval >= 0)
 		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
 			radio->registers[STATUSRSSI + regnr] =
-				get_unaligned_be16(&buf[regnr * RADIO_REGISTER_SIZE + 1]);
+				get_unaligned_be16(
+				&buf[regnr * RADIO_REGISTER_SIZE + 1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -890,8 +886,8 @@ static void si470x_work(struct work_stru
 	struct si470x_device *radio = container_of(work, struct si470x_device,
 		work.work);
 
-       if (radio->disconnected)
-	       return;
+	if (radio->disconnected)
+		return;
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		return;
 
@@ -1018,20 +1014,20 @@ static int si470x_fops_open(struct inode
 static int si470x_fops_release(struct inode *inode, struct file *file)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-       int retval = 0;
+	int retval = 0;
 
 	if (!radio)
 		return -ENODEV;
 
-       mutex_lock(&open_close_lock);
+	mutex_lock(&radio->disconnect_lock);
 	radio->users--;
 	if (radio->users == 0) {
-	       if (radio->disconnected) {
-		       video_unregister_device(radio->videodev);
-		       kfree(radio->buffer);
-		       kfree(radio);
-		       goto done;
-	       }
+		if (radio->disconnected) {
+			video_unregister_device(radio->videodev);
+			kfree(radio->buffer);
+			kfree(radio);
+			goto unlock;
+		}
 
 		/* stop rds reception */
 		cancel_delayed_work_sync(&radio->work);
@@ -1043,9 +1039,9 @@ static int si470x_fops_release(struct in
 		usb_autopm_put_interface(radio->intf);
 	}
 
-done:
-       mutex_unlock(&open_close_lock);
-       return retval;
+unlock:
+	mutex_unlock(&radio->disconnect_lock);
+	return retval;
 }
 
 
@@ -1185,8 +1181,8 @@ static int si470x_vidioc_g_ctrl(struct f
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 
-       if (radio->disconnected)
-	       return -EIO;
+	if (radio->disconnected)
+		return -EIO;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1212,8 +1208,8 @@ static int si470x_vidioc_s_ctrl(struct f
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
-       if (radio->disconnected)
-	       return -EIO;
+	if (radio->disconnected)
+		return -EIO;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1277,8 +1273,8 @@ static int si470x_vidioc_g_tuner(struct 
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
-       if (radio->disconnected)
-	       return -EIO;
+	if (radio->disconnected)
+		return -EIO;
 	if (tuner->index > 0)
 		return -EINVAL;
 
@@ -1335,8 +1331,8 @@ static int si470x_vidioc_s_tuner(struct 
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
-       if (radio->disconnected)
-	       return -EIO;
+	if (radio->disconnected)
+		return -EIO;
 	if (tuner->index > 0)
 		return -EINVAL;
 
@@ -1362,8 +1358,8 @@ static int si470x_vidioc_g_frequency(str
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 
-       if (radio->disconnected)
-	       return -EIO;
+	if (radio->disconnected)
+		return -EIO;
 
 	freq->type = V4L2_TUNER_RADIO;
 	freq->frequency = si470x_get_freq(radio);
@@ -1381,8 +1377,8 @@ static int si470x_vidioc_s_frequency(str
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
-       if (radio->disconnected)
-	       return -EIO;
+	if (radio->disconnected)
+		return -EIO;
 	if (freq->type != V4L2_TUNER_RADIO)
 		return -EINVAL;
 
@@ -1447,8 +1443,10 @@ static int si470x_usb_driver_probe(struc
 	memcpy(radio->videodev, &si470x_viddev_template,
 			sizeof(si470x_viddev_template));
 	radio->users = 0;
+	radio->disconnected = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
+	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);
 	video_set_drvdata(radio->videodev, radio);
 
@@ -1553,16 +1551,16 @@ static void si470x_usb_driver_disconnect
 {
 	struct si470x_device *radio = usb_get_intfdata(intf);
 
-       mutex_lock(&open_close_lock);
-       radio->disconnected = 1;
+	mutex_lock(&radio->disconnect_lock);
+	radio->disconnected = 1;
 	cancel_delayed_work_sync(&radio->work);
 	usb_set_intfdata(intf, NULL);
-       if (radio->users == 0) {
-	       video_unregister_device(radio->videodev);
-	       kfree(radio->buffer);
-	       kfree(radio);
-       }
-       mutex_unlock(&open_close_lock);
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
