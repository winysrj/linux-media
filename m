Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VFFU86000687
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:30 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4VFFIw2015883
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:15:18 -0400
Content-Disposition: inline
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 31 May 2008 17:11:32 +0200
MIME-Version: 1.0
Message-Id: <200805311711.32489.tobias.lorenz@gmx.net>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 5/6] si470x: hardware frequency seek support
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
- this now finally adds hardware frequency seek support

Best regards,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 4_afc/drivers/media/radio/radio-si470x.c 5_hw_seek/drivers/media/radio/radio-si470x.c
--- 4_afc/drivers/media/radio/radio-si470x.c	2008-05-31 16:30:02.000000000 +0200
+++ 5_hw_seek/drivers/media/radio/radio-si470x.c	2008-05-31 16:31:15.000000000 +0200
@@ -101,11 +101,11 @@
  *		- unplugging fixed
  * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
  *		Version 1.0.8
+ *		- hardware frequency seek support
  *		- afc indication
  *		- more safety checks, let si470x_get_freq return errno
  *
  * ToDo:
- * - add seeking support
  * - add firmware download/update support
  * - RDS support: interrupt mode, instead of polling
  * - add LED status output (check if that's not already done in firmware)
@@ -195,6 +195,11 @@ static unsigned int tune_timeout = 3000;
 module_param(tune_timeout, uint, 0);
 MODULE_PARM_DESC(tune_timeout, "Tune timeout: *3000*");
 
+/* Seek timeout */
+static unsigned int seek_timeout = 5000;
+module_param(seek_timeout, uint, 0);
+MODULE_PARM_DESC(seek_timeout, "Seek timeout: *5000*");
+
 /* RDS buffer blocks */
 static unsigned int rds_buf = 100;
 module_param(rds_buf, uint, 0);
@@ -738,6 +743,62 @@ static int si470x_set_freq(struct si470x
 
 
 /*
+ * si470x_set_seek - set seek
+ */
+static int si470x_set_seek(struct si470x_device *radio,
+		unsigned int wrap_around, unsigned int seek_upward)
+{
+	int retval = 0;
+	unsigned long timeout;
+	bool timed_out = 0;
+
+	/* start seeking */
+	radio->registers[POWERCFG] |= POWERCFG_SEEK;
+	if (wrap_around == 1)
+		radio->registers[POWERCFG] &= ~POWERCFG_SKMODE;
+	else
+		radio->registers[POWERCFG] |= POWERCFG_SKMODE;
+	if (seek_upward == 1)
+		radio->registers[POWERCFG] |= POWERCFG_SEEKUP;
+	else
+		radio->registers[POWERCFG] &= ~POWERCFG_SEEKUP;
+	retval = si470x_set_register(radio, POWERCFG);
+	if (retval < 0)
+		goto done;
+
+	/* wait till seek operation has completed */
+	timeout = jiffies + msecs_to_jiffies(seek_timeout);
+	do {
+		retval = si470x_get_register(radio, STATUSRSSI);
+		if (retval < 0)
+			goto stop;
+		timed_out = time_after(jiffies, timeout);
+	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
+		(!timed_out));
+	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
+		printk(KERN_WARNING DRIVER_NAME ": seek does not complete\n");
+	if (radio->registers[STATUSRSSI] & STATUSRSSI_SF)
+		printk(KERN_WARNING DRIVER_NAME
+			": seek failed / band limit reached\n");
+	if (timed_out)
+		printk(KERN_WARNING DRIVER_NAME
+			": seek timed out after %u ms\n", seek_timeout);
+
+stop:
+	/* stop seeking */
+	radio->registers[POWERCFG] &= ~POWERCFG_SEEK;
+	retval = si470x_set_register(radio, POWERCFG);
+
+done:
+	/* try again, if timed out */
+	if ((retval == 0) && timed_out)
+		retval = -EAGAIN;
+
+	return retval;
+}
+
+
+/*
  * si470x_start - switch on radio
  */
 static int si470x_start(struct si470x_device *radio)
@@ -1159,7 +1220,8 @@ static int si470x_vidioc_querycap(struct
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
 	sprintf(capability->bus_info, "USB");
 	capability->version = DRIVER_KERNEL_VERSION;
-	capability->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
+		V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 
 	return 0;
 }
@@ -1506,6 +1568,36 @@ done:
 
 
 /*
+ * si470x_vidioc_s_hw_freq_seek - set hardware frequency seek
+ */
+static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
+		struct v4l2_hw_freq_seek *seek)
+{
+	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
+
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((seek->tuner != 0) && (seek->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
+
+	retval = si470x_set_seek(radio, seek->wrap_around, seek->seek_upward);
+
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": set hardware frequency seek failed with %d\n",
+			retval);
+	return retval;
+}
+
+
+/*
  * si470x_viddev_tamples - video device interface
  */
 static struct video_device si470x_viddev_template = {
@@ -1525,6 +1617,7 @@ static struct video_device si470x_viddev
 	.vidioc_s_tuner		= si470x_vidioc_s_tuner,
 	.vidioc_g_frequency	= si470x_vidioc_g_frequency,
 	.vidioc_s_frequency	= si470x_vidioc_s_frequency,
+	.vidioc_s_hw_freq_seek	= si470x_vidioc_s_hw_freq_seek,
 	.owner			= THIS_MODULE,
 };
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
