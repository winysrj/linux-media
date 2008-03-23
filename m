Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NEbRt0032352
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 10:37:27 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2NEasGV030985
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 10:36:55 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Keith Mok <ek9852@gmail.com>
Date: Sun, 23 Mar 2008 15:36:45 +0100
References: <47C14336.9030903@gmail.com>
	<200803072105.08054.tobias.lorenz@gmx.net>
	<47D67AB4.3000008@gmail.com>
In-Reply-To: <47D67AB4.3000008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803231536.46713.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] v4l2: add hardware frequency seek
	ioctl interface
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

Hi Keith,

> I have already submit the patch to the group but we need an example 
> patch/code also for the patch to be applied. I attached the previous 
> submit patch here again.
Sorry, I have not found it on the v4l mailing list.

> Such as different chipset vendor may have different seek tuning 
> parameters and limits.
Therefore I would not implement this as ioctls, but using VIDIOC_[G/S/ENUM]_CTRL.
#define V4L2_CID_SEEKTH (V4L2_CID_BASE+24) /* RSSI Seek Threshold */
#define V4L2_CID_SKSNR (V4L2_CID_BASE+25) /* Seek SNR Threshold */
#define V4L2_CID_SKCNT (V4L2_CID_BASE+26) /* Seek FM Impulse Detection Threshold */
But this is not done in the current implementation of the driver radio-si470x.
The device is currently just initialized using the default/recommended parameters.

> Signed-off-by: Keith Mok <ek9852@gmail.com>
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
I guess that there is also a patch to linux/include/media/v4l2-dev.h containing at least:
--- linux-2.6.23/include/media/v4l2-dev.h       2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23.new/include/media/v4l2-dev.h   2008-03-23 14:39:16.000000000 +0100
@@ -301,6 +301,8 @@
                                        struct v4l2_frequency *a);
        int (*vidioc_s_frequency)      (struct file *file, void *fh,
                                        struct v4l2_frequency *a);
+       int (*vidioc_s_hw_freq_seek)   (struct file *file, void *fh,
+                                       struct v4l2_hw_freq_seek *a);

        /* Sliced VBI cap */
        int (*vidioc_g_sliced_vbi_cap) (struct file *file, void *fh,
Is there also a function, that indicated if seek is in progress, completed or failed, propably named vidioc_g_hw_freq_seek?

Okay, I made a patch to my driver radio-si470x to implement the functionality as your patch currently needs it.
Implementing it, I found some remaining questions/issues:

1. When does seeking finish? Should the ioctl wait and return after a timeout, as currently implemented?
Where and how is it indicated else?
=> I would suggest to have a vidioc_g_hw_freq_seek to indicate that seek is in progress, completed or failed.

2. At least my device does not support wrap around at the end of the frequency band.
=> I suggest to remove that parameter. The application has to handle seek failures anyway.

3. Do we need a start_freq parameter? The usual case for the application is to start seeking at the current frequency.
And we have a vidioc_s_frequency for it, that applications can use, if they want to start seeking somewhere else.
=> I suggest to remove that parameter too.

Here is my patch. I have not modified any application yet to test the functionality. But the driver compiles cleanly.
May I update your patch using my three suggestions above?

So for my ToDo list, I have:
- modify the seek patch and the radio-si470x driver.
- add code to change the seek parameters using VIDIOC_[G/S/ENUM]_CTRL.
- patch an application to test everything.

Bye,
  Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- 1.0.7c_unplug_patch/radio-si470x.c  2008-03-23 11:12:07.000000000 +0100
+++ 1.0.8_hw_seek/radio-si470x.c        2008-03-23 14:40:53.000000000 +0100
@@ -86,9 +86,11 @@
  *             Version 1.0.7
  *             - usb autosuspend support
  *             - unplugging fixed
+ * 2008-03-17  Tobias Lorenz <tobias.lorenz@gmx.net
+ *             Version 1.0.8
+ *             - hardware frequency seek
  *
  * ToDo:
- * - add seeking support
  * - add firmware download/update support
  * - RDS support: interrupt mode, instead of polling
  * - add LED status output (check if that's not already done in firmware)
@@ -98,10 +100,10 @@
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_NAME "radio-si470x"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 7)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 8)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.7"
+#define DRIVER_VERSION "1.0.8"


 /* kernel includes */
@@ -178,6 +180,11 @@ static unsigned int tune_timeout = 3000;
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
@@ -726,6 +733,71 @@ static int si470x_set_freq(struct si470x


 /*
+ * si470x_set_seek - set seek
+ */
+static int si470x_set_seek(struct si470x_device *radio,
+               unsigned int wrap_around, unsigned int seek_upward)
+{
+       int retval;
+       unsigned long timeout;
+       bool timed_out = 0;
+
+       /* start seeking */
+       radio->registers[POWERCFG] |= POWERCFG_SEEK;
+       if (seek_upward)
+               radio->registers[POWERCFG] |= POWERCFG_SEEKUP;
+       retval = si470x_set_register(radio, POWERCFG);
+       if (retval < 0)
+               return retval;
+
+       /* wait till seek operation has completed */
+       timeout = jiffies + msecs_to_jiffies(seek_timeout);
+       do {
+               /* check for success */
+               do {
+                       retval = si470x_get_register(radio, STATUSRSSI);
+                       if (retval < 0)
+                               return retval;
+                       timed_out = time_after(jiffies, timeout);
+               } while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
+                       && (!timed_out));
+
+               /* wrap around operation */
+               if ((radio->registers[STATUSRSSI] & STATUSRSSI_SF) &&
+                       wrap_around) {
+                       unsigned int freq;
+                       /* Frequency Wrap Around (MHz) */
+                       switch (band) {
+                       /* 0: 87.5 - 108 MHz (USA, Europe) */
+                       case 0 : freq = seek_upward ?  87.5 * FREQ_MUL
+                                                   : 108   * FREQ_MUL; break;
+                       /* 1: 76   - 108 MHz (Japan wide band) */
+                       default: freq = seek_upward ?  76   * FREQ_MUL
+                                                   : 108   * FREQ_MUL; break;
+                       /* 2: 76   -  90 MHz (Japan) */
+                       case 2 : freq = seek_upward ?  76   * FREQ_MUL
+                                                   :  90   * FREQ_MUL; break;
+                       };
+                       si470x_set_freq(radio, freq);
+
+                       /* restart seek */
+                       retval = si470x_set_register(radio, POWERCFG);
+                       if (retval < 0)
+                               return retval;
+               }
+       } while (((radio->registers[STATUSRSSI] & STATUSRSSI_SF) == 1) &&
+               (!timed_out));
+       if (timed_out)
+               printk(KERN_WARNING DRIVER_NAME
+                       ": seek does not finish after %u ms\n", seek_timeout);
+
+       /* stop seeking */
+       radio->registers[POWERCFG] &= ~POWERCFG_SEEK;
+       return si470x_set_register(radio, POWERCFG);
+}
+
+
+/*
  * si470x_start - switch on radio
  */
 static int si470x_start(struct si470x_device *radio)
@@ -1126,7 +1198,8 @@ static int si470x_vidioc_querycap(struct
        strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
        sprintf(capability->bus_info, "USB");
        capability->version = DRIVER_KERNEL_VERSION;
-       capability->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+       capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
+               V4L2_CAP_TUNER | V4L2_CAP_RADIO;

        return 0;
 }
@@ -1399,6 +1472,32 @@ static int si470x_vidioc_s_frequency(str


 /*
+ * si470x_vidioc_s_hw_freq_seek - set hardware frequency seek
+ */
+static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
+               struct v4l2_hw_freq_seek *seek)
+{
+       struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+       int retval;
+
+       if (seek->type != V4L2_TUNER_RADIO)
+               return -EINVAL;
+
+       retval = si470x_set_freq(radio, seek->start_freq);
+       if (retval < 0)
+               printk(KERN_WARNING DRIVER_NAME
+                       ": set frequency failed with %d\n", retval);
+
+       retval = si470x_set_seek(radio, seek->wrap_around, seek->seek_upward);
+       if (retval < 0)
+               printk(KERN_WARNING DRIVER_NAME
+                       ": set seek failed with %d\n", retval);
+
+       return 0;
+}
+
+
+/*
  * si470x_viddev_tamples - video device interface
  */
 static struct video_device si470x_viddev_template = {
@@ -1418,6 +1517,7 @@ static struct video_device si470x_viddev
        .vidioc_s_tuner         = si470x_vidioc_s_tuner,
        .vidioc_g_frequency     = si470x_vidioc_g_frequency,
        .vidioc_s_frequency     = si470x_vidioc_s_frequency,
+       .vidioc_s_hw_freq_seek  = si470x_vidioc_s_hw_freq_seek,
        .owner                  = THIS_MODULE,
 };

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
