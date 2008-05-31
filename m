Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VFFRAG000675
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:27 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4VFFF0i015869
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:15 -0400
Content-Disposition: inline
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 31 May 2008 17:07:52 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200805311707.52448.tobias.lorenz@gmx.net>
Content-Transfer-Encoding: 8bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 3/6] si470x: a lot of small code cleanups
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
- comment on how to listen to an usb audio device
  (i get so many questions about that...)
- code cleanup (error handling, more warnings, spacing, ...)

Best regards,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 2_ret_get_freq/drivers/media/radio/radio-si470x.c 3_code_style/drivers/media/radio/radio-si470x.c
--- 2_ret_get_freq/drivers/media/radio/radio-si470x.c	2008-05-31 16:27:03.000000000 +0200
+++ 3_code_style/drivers/media/radio/radio-si470x.c	2008-05-31 16:29:01.000000000 +0200
@@ -101,7 +101,7 @@
  *		- unplugging fixed
  * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
  *		Version 1.0.8
- *		- let si470x_get_freq return errno
+ *		- more safety checks, let si470x_get_freq return errno
  *
  * ToDo:
  * - add seeking support
@@ -498,11 +498,11 @@ static int si470x_get_report(struct si47
 		USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
 		report[0], 2,
 		buf, size, usb_timeout);
+
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": si470x_get_report: usb_control_msg returned %d\n",
 			retval);
-
 	return retval;
 }
 
@@ -521,11 +521,11 @@ static int si470x_set_report(struct si47
 		USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
 		report[0], 2,
 		buf, size, usb_timeout);
+
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": si470x_set_report: usb_control_msg returned %d\n",
 			retval);
-
 	return retval;
 }
 
@@ -634,24 +634,30 @@ static int si470x_set_chan(struct si470x
 	radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
 	retval = si470x_set_register(radio, CHANNEL);
 	if (retval < 0)
-		return retval;
+		goto done;
 
-	/* wait till seek operation has completed */
+	/* wait till tune operation has completed */
 	timeout = jiffies + msecs_to_jiffies(tune_timeout);
 	do {
 		retval = si470x_get_register(radio, STATUSRSSI);
 		if (retval < 0)
-			return retval;
+			goto stop;
 		timed_out = time_after(jiffies, timeout);
 	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
 		(!timed_out));
+	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
+		printk(KERN_WARNING DRIVER_NAME ": tune does not complete\n");
 	if (timed_out)
 		printk(KERN_WARNING DRIVER_NAME
-			": seek does not finish after %u ms\n", tune_timeout);
+			": tune timed out after %u ms\n", tune_timeout);
 
+stop:
 	/* stop tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
-	return si470x_set_register(radio, CHANNEL);
+	retval = si470x_set_register(radio, CHANNEL);
+
+done:
+	return retval;
 }
 
 
@@ -742,27 +748,30 @@ static int si470x_start(struct si470x_de
 		POWERCFG_DMUTE | POWERCFG_ENABLE | POWERCFG_RDSM;
 	retval = si470x_set_register(radio, POWERCFG);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* sysconfig 1 */
 	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* sysconfig 2 */
 	radio->registers[SYSCONFIG2] =
-		(0x3f  << 8) |	/* SEEKTH */
-		(band  << 6) |	/* BAND */
-		(space << 4) |	/* SPACE */
-		15;		/* VOLUME (max) */
+		(0x3f  << 8) |				/* SEEKTH */
+		((band  << 6) & SYSCONFIG2_BAND)  |	/* BAND */
+		((space << 4) & SYSCONFIG2_SPACE) |	/* SPACE */
+		15;					/* VOLUME (max) */
 	retval = si470x_set_register(radio, SYSCONFIG2);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* reset last channel */
-	return si470x_set_chan(radio,
+	retval = si470x_set_chan(radio,
 		radio->registers[CHANNEL] & CHANNEL_CHAN);
+
+done:
+	return retval;
 }
 
 
@@ -777,13 +786,16 @@ static int si470x_stop(struct si470x_dev
 	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_RDS;
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* powercfg */
 	radio->registers[POWERCFG] &= ~POWERCFG_DMUTE;
 	/* POWERCFG_ENABLE has to automatically go low */
 	radio->registers[POWERCFG] |= POWERCFG_ENABLE |	POWERCFG_DISABLE;
-	return si470x_set_register(radio, POWERCFG);
+	retval = si470x_set_register(radio, POWERCFG);
+
+done:
+	return retval;
 }
 
 
@@ -900,6 +912,7 @@ static void si470x_work(struct work_stru
 	struct si470x_device *radio = container_of(work, struct si470x_device,
 		work.work);
 
+	/* safety checks */
 	if (radio->disconnected)
 		return;
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
@@ -934,11 +947,15 @@ static ssize_t si470x_fops_read(struct f
 
 	/* block if no new data available */
 	while (radio->wr_index == radio->rd_index) {
-		if (file->f_flags & O_NONBLOCK)
-			return -EWOULDBLOCK;
+		if (file->f_flags & O_NONBLOCK) {
+			retval = -EWOULDBLOCK;
+			goto done;
+		}
 		if (wait_event_interruptible(radio->read_queue,
-			radio->wr_index != radio->rd_index) < 0)
-			return -EINTR;
+			radio->wr_index != radio->rd_index) < 0) {
+			retval = -EINTR;
+			goto done;
+		}
 	}
 
 	/* calculate block count from byte count */
@@ -967,6 +984,7 @@ static ssize_t si470x_fops_read(struct f
 	}
 	mutex_unlock(&radio->lock);
 
+done:
 	return retval;
 }
 
@@ -978,6 +996,7 @@ static unsigned int si470x_fops_poll(str
 		struct poll_table_struct *pts)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
 
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
@@ -989,9 +1008,9 @@ static unsigned int si470x_fops_poll(str
 	poll_wait(file, &radio->read_queue, pts);
 
 	if (radio->rd_index != radio->wr_index)
-		return POLLIN | POLLRDNORM;
+		retval = POLLIN | POLLRDNORM;
 
-	return 0;
+	return retval;
 }
 
 
@@ -1008,17 +1027,18 @@ static int si470x_fops_open(struct inode
 	retval = usb_autopm_get_interface(radio->intf);
 	if (retval < 0) {
 		radio->users--;
-		return -EIO;
+		retval = -EIO;
+		goto done;
 	}
 
 	if (radio->users == 1) {
 		retval = si470x_start(radio);
 		if (retval < 0)
 			usb_autopm_put_interface(radio->intf);
-		return retval;
 	}
 
-	return 0;
+done:
+	return retval;
 }
 
 
@@ -1030,8 +1050,11 @@ static int si470x_fops_release(struct in
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
 	int retval = 0;
 
-	if (!radio)
-		return -ENODEV;
+	/* safety check */
+	if (!radio) {
+		retval = -ENODEV;
+		goto done;
+	}
 
 	mutex_lock(&radio->disconnect_lock);
 	radio->users--;
@@ -1055,6 +1078,8 @@ static int si470x_fops_release(struct in
 
 unlock:
 	mutex_unlock(&radio->disconnect_lock);
+
+done:
 	return retval;
 }
 
@@ -1142,7 +1167,7 @@ static int si470x_vidioc_querycap(struct
 /*
  * si470x_vidioc_g_input - get input
  */
-static int si470x_vidioc_g_input(struct file *filp, void *priv,
+static int si470x_vidioc_g_input(struct file *file, void *priv,
 		unsigned int *i)
 {
 	*i = 0;
@@ -1154,12 +1179,18 @@ static int si470x_vidioc_g_input(struct 
 /*
  * si470x_vidioc_s_input - set input
  */
-static int si470x_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
+static int si470x_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
+	int retval = 0;
+
+	/* safety checks */
 	if (i != 0)
-		return -EINVAL;
+		retval = -EINVAL;
 
-	return 0;
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": set input failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1172,17 +1203,22 @@ static int si470x_vidioc_queryctrl(struc
 	unsigned char i;
 	int retval = -EINVAL;
 
+	/* safety checks */
+	if (!qc->id)
+		goto done;
+
 	for (i = 0; i < ARRAY_SIZE(si470x_v4l2_queryctrl); i++) {
-		if (qc->id && qc->id == si470x_v4l2_queryctrl[i].id) {
+		if (qc->id == si470x_v4l2_queryctrl[i].id) {
 			memcpy(qc, &(si470x_v4l2_queryctrl[i]), sizeof(*qc));
 			retval = 0;
 			break;
 		}
 	}
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
-			": query control failed with %d\n", retval);
-
+			": query controls failed with %d\n", retval);
 	return retval;
 }
 
@@ -1194,9 +1230,13 @@ static int si470x_vidioc_g_ctrl(struct f
 		struct v4l2_control *ctrl)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
 
-	if (radio->disconnected)
-		return -EIO;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1207,9 +1247,15 @@ static int si470x_vidioc_g_ctrl(struct f
 		ctrl->value = ((radio->registers[POWERCFG] &
 				POWERCFG_DMUTE) == 0) ? 1 : 0;
 		break;
+	default:
+		retval = -EINVAL;
 	}
 
-	return 0;
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get control failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1220,10 +1266,13 @@ static int si470x_vidioc_s_ctrl(struct f
 		struct v4l2_control *ctrl)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (radio->disconnected)
-		return -EIO;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1241,10 +1290,11 @@ static int si470x_vidioc_s_ctrl(struct f
 	default:
 		retval = -EINVAL;
 	}
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": set control failed with %d\n", retval);
-
 	return retval;
 }
 
@@ -1255,13 +1305,22 @@ static int si470x_vidioc_s_ctrl(struct f
 static int si470x_vidioc_g_audio(struct file *file, void *priv,
 		struct v4l2_audio *audio)
 {
-	if (audio->index > 1)
-		return -EINVAL;
+	int retval = 0;
+
+	/* safety checks */
+	if (audio->index != 0) {
+		retval = -EINVAL;
+		goto done;
+	}
 
 	strcpy(audio->name, "Radio");
 	audio->capability = V4L2_AUDCAP_STEREO;
 
-	return 0;
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get audio failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1271,10 +1330,19 @@ static int si470x_vidioc_g_audio(struct 
 static int si470x_vidioc_s_audio(struct file *file, void *priv,
 		struct v4l2_audio *audio)
 {
-	if (audio->index != 0)
-		return -EINVAL;
+	int retval = 0;
 
-	return 0;
+	/* safety checks */
+	if (audio->index != 0) {
+		retval = -EINVAL;
+		goto done;
+	}
+
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": set audio failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1285,20 +1353,23 @@ static int si470x_vidioc_g_tuner(struct 
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (radio->disconnected)
-		return -EIO;
-	if (tuner->index > 0)
-		return -EINVAL;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((tuner->index != 0) && (tuner->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
 
-	/* read status rssi */
 	retval = si470x_get_register(radio, STATUSRSSI);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	strcpy(tuner->name, "FM");
-	tuner->type = V4L2_TUNER_RADIO;
 	switch (band) {
 	/* 0: 87.5 - 108 MHz (USA, Europe, default) */
 	default:
@@ -1332,7 +1403,11 @@ static int si470x_vidioc_g_tuner(struct 
 	/* automatic frequency control: -1: freq to low, 1 freq to high */
 	tuner->afc = 0;
 
-	return 0;
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get tuner failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1343,12 +1418,17 @@ static int si470x_vidioc_s_tuner(struct 
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (radio->disconnected)
-		return -EIO;
-	if (tuner->index > 0)
-		return -EINVAL;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((tuner->index != 0) && (tuner->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
 
 	if (tuner->audmode == V4L2_TUNER_MODE_MONO)
 		radio->registers[POWERCFG] |= POWERCFG_MONO;  /* force mono */
@@ -1356,10 +1436,11 @@ static int si470x_vidioc_s_tuner(struct 
 		radio->registers[POWERCFG] &= ~POWERCFG_MONO; /* try stereo */
 
 	retval = si470x_set_register(radio, POWERCFG);
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": set tuner failed with %d\n", retval);
-
 	return retval;
 }
 
@@ -1371,12 +1452,25 @@ static int si470x_vidioc_g_frequency(str
 		struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
 
-	if (radio->disconnected)
-		return -EIO;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((freq->tuner != 0) && (freq->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
+
+	retval = si470x_get_freq(radio, &freq->frequency);
 
-	freq->type = V4L2_TUNER_RADIO;
-	return si470x_get_freq(radio, &radio->frequency);
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get frequency failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1387,19 +1481,25 @@ static int si470x_vidioc_s_frequency(str
 		struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (radio->disconnected)
-		return -EIO;
-	if (freq->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((freq->tuner != 0) && (freq->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
 
 	retval = si470x_set_freq(radio, freq->frequency);
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": set frequency failed with %d\n", retval);
-
-	return 0;
+	return retval;
 }
 
 
@@ -1439,33 +1539,36 @@ static int si470x_usb_driver_probe(struc
 		const struct usb_device_id *id)
 {
 	struct si470x_device *radio;
-	int retval = -ENOMEM;
+	int retval = 0;
 
-	/* private data allocation */
+	/* private data allocation and initialization */
 	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
-	if (!radio)
+	if (!radio) {
+		retval = -ENOMEM;
 		goto err_initial;
-
-	/* video device allocation */
-	radio->videodev = video_device_alloc();
-	if (!radio->videodev)
-		goto err_radio;
-
-	/* initial configuration */
-	memcpy(radio->videodev, &si470x_viddev_template,
-			sizeof(si470x_viddev_template));
+	}
 	radio->users = 0;
 	radio->disconnected = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
 	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);
+
+	/* video device allocation and initialization */
+	radio->videodev = video_device_alloc();
+	if (!radio->videodev) {
+		retval = -ENOMEM;
+		goto err_radio;
+	}
+	memcpy(radio->videodev, &si470x_viddev_template,
+			sizeof(si470x_viddev_template));
 	video_set_drvdata(radio->videodev, radio);
 
 	/* show some infos about the specific device */
-	retval = -EIO;
-	if (si470x_get_all_registers(radio) < 0)
+	if (si470x_get_all_registers(radio) < 0) {
+		retval = -EIO;
 		goto err_all;
+	}
 	printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
 			radio->registers[DEVICEID], radio->registers[CHIPID]);
 
@@ -1491,8 +1594,10 @@ static int si470x_usb_driver_probe(struc
 	/* rds buffer allocation */
 	radio->buf_size = rds_buf * 3;
 	radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
-	if (!radio->buffer)
+	if (!radio->buffer) {
+		retval = -EIO;
 		goto err_all;
+	}
 
 	/* rds buffer configuration */
 	radio->wr_index = 0;
@@ -1504,6 +1609,7 @@ static int si470x_usb_driver_probe(struc
 
 	/* register video device */
 	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
+		retval = -EIO;
 		printk(KERN_WARNING DRIVER_NAME
 				": Could not register video device\n");
 		goto err_all;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
