Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QKaE37007891
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:36:14 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4QKZwLQ032382
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 16:35:58 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 26 May 2008 22:35:51 +0200
References: <200805072253.23219.tobias.lorenz@gmx.net>
	<20080526104146.7ef1bc91@gaivota>
In-Reply-To: <20080526104146.7ef1bc91@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200805262235.51865.tobias.lorenz@gmx.net>
Content-Transfer-Encoding: 8bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 5/6] si470x: hardware frequency seek support
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
>       a patch for harware seek support;
>       a patch for afc indication; 
>       ...

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
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 4_afc/drivers/media/radio/radio-si470x.c 5_hw_seek/drivers/media/radio/radio-si470x.c
--- 4_afc/drivers/media/radio/radio-si470x.c	2008-05-26 22:06:41.000000000 +0200
+++ 5_hw_seek/drivers/media/radio/radio-si470x.c	2008-05-26 22:15:19.000000000 +0200
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
@@ -134,6 +134,7 @@
 #include <linux/mutex.h>
 #include <media/v4l2-common.h>
 #include <media/rds.h>
+
 #include <asm/unaligned.h>
 
 
@@ -192,6 +193,11 @@ static unsigned int tune_timeout = 3000;
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
@@ -730,6 +736,62 @@ static int si470x_set_freq(struct si470x
 
 
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
@@ -1149,7 +1211,8 @@ static int si470x_vidioc_querycap(struct
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
 	sprintf(capability->bus_info, "USB");
 	capability->version = DRIVER_KERNEL_VERSION;
-	capability->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
+		V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 
 	return 0;
 }
@@ -1496,6 +1559,36 @@ done:
 
 
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
@@ -1515,6 +1608,7 @@ static struct video_device si470x_viddev
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
