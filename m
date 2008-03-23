Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2NAddh9008838
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 06:39:39 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2NAd5Ar011390
	for <video4linux-list@redhat.com>; Sun, 23 Mar 2008 06:39:06 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sun, 23 Mar 2008 11:38:56 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803231138.57707.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH] radio-si470x: unplugging fixed
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

this patch fixes several kernel oops, when unplugging device while it is in use:
kernel: EIP is at __video_do_ioctl+0x40/0x3810 [videodev]
kernel: EIP is at si470x_fops_release+0x11/0xd0 [radio_si470x]
kernel: EIP is at si470x_fops_poll+0x17/0x80 [radio_si470x]

Basically the patch delays freeing of the internal variables in si470x_usb_driver_disconnect,
until the the last user closed the device in si470x_fops_release.
This was implemented a while ago with the help of Oliver Neukum.

I tested the patch five times (unplugging while in use) without oops coming from the radio-si470x driver anymore.
A remaining oops was coming from the usbaudio driver, but this is someone else task.
Hopefully this fixed all unplugging issues.

Please consider to let Linus apply this for the upcoming linux kernel release.

Bye the way, current work is done to support an additional device "Lart FM radio"
and to support hardware frequency seek support.
But this is something not for the next kernel.

Bye,
  Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- 20080216_mercurial/radio-si470x.c   2008-02-16 23:46:46.000000000 +0100
+++ 1.0.7c_unplug_patch/radio-si470x.c  2008-03-23 11:12:07.000000000 +0100
@@ -85,6 +85,7 @@
  *             Oliver Neukum <oliver@neukum.org>
  *             Version 1.0.7
  *             - usb autosuspend support
+ *             - unplugging fixed
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
@@ -427,12 +428,13 @@ struct si470x_device {

        /* driver management */
        unsigned int users;
+       unsigned char disconnected;

        /* Silabs internal registers (0..15) */
        unsigned short registers[RADIO_REGISTER_NUM];

        /* RDS receive buffer */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
        struct work_struct work;
 #else
        struct delayed_work work;
@@ -452,6 +454,12 @@ struct si470x_device {


 /*
+ * Lock to prevent kfree of data before all users have releases the device.
+ */
+static DEFINE_MUTEX(open_close_lock);
+
+
+/*
  * The frequency is set in units of 62.5 Hz when using V4L2_TUNER_CAP_LOW,
  * 62.5 kHz otherwise.
  * The tuner is able to have a channel spacing of 50, 100 or 200 kHz.
@@ -589,7 +597,7 @@ static int si470x_get_rds_registers(stru
                usb_rcvintpipe(radio->usbdev, 1),
                (void *) &buf, sizeof(buf), &size, usb_timeout);
        if (size != sizeof(buf))
-               printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_register: "
+               printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
                        "return size differs: %d != %zu\n", size, sizeof(buf));
        if (retval < 0)
                printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
@@ -887,6 +895,8 @@ static void si470x_work(struct work_stru
        struct si470x_device *radio = container_of(work, struct si470x_device,
                work.work);

+       if (radio->disconnected)
+               return;
        if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
                return;

@@ -1013,13 +1023,21 @@ static int si470x_fops_open(struct inode
 static int si470x_fops_release(struct inode *inode, struct file *file)
 {
        struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-       int retval;
+       int retval = 0;

        if (!radio)
                return -ENODEV;

+       mutex_lock(&open_close_lock);
        radio->users--;
        if (radio->users == 0) {
+               if (radio->disconnected) {
+                       video_unregister_device(radio->videodev);
+                       kfree(radio->buffer);
+                       kfree(radio);
+                       goto done;
+               }
+
                /* stop rds reception */
                cancel_delayed_work_sync(&radio->work);

@@ -1028,10 +1046,11 @@ static int si470x_fops_release(struct in

                retval = si470x_stop(radio);
                usb_autopm_put_interface(radio->intf);
-               return retval;
        }

-       return 0;
+done:
+       mutex_unlock(&open_close_lock);
+       return retval;
 }


@@ -1169,6 +1188,9 @@ static int si470x_vidioc_g_ctrl(struct f
 {
        struct si470x_device *radio = video_get_drvdata(video_devdata(file));

+       if (radio->disconnected)
+               return -EIO;
+
        switch (ctrl->id) {
        case V4L2_CID_AUDIO_VOLUME:
                ctrl->value = radio->registers[SYSCONFIG2] &
@@ -1193,6 +1215,9 @@ static int si470x_vidioc_s_ctrl(struct f
        struct si470x_device *radio = video_get_drvdata(video_devdata(file));
        int retval;

+       if (radio->disconnected)
+               return -EIO;
+
        switch (ctrl->id) {
        case V4L2_CID_AUDIO_VOLUME:
                radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_VOLUME;
@@ -1255,6 +1280,8 @@ static int si470x_vidioc_g_tuner(struct
        struct si470x_device *radio = video_get_drvdata(video_devdata(file));
        int retval;

+       if (radio->disconnected)
+               return -EIO;
        if (tuner->index > 0)
                return -EINVAL;

@@ -1311,6 +1338,8 @@ static int si470x_vidioc_s_tuner(struct
        struct si470x_device *radio = video_get_drvdata(video_devdata(file));
        int retval;

+       if (radio->disconnected)
+               return -EIO;
        if (tuner->index > 0)
                return -EINVAL;

@@ -1336,6 +1365,9 @@ static int si470x_vidioc_g_frequency(str
 {
        struct si470x_device *radio = video_get_drvdata(video_devdata(file));

+       if (radio->disconnected)
+               return -EIO;
+
        freq->type = V4L2_TUNER_RADIO;
        freq->frequency = si470x_get_freq(radio);

@@ -1352,6 +1384,8 @@ static int si470x_vidioc_s_frequency(str
        struct si470x_device *radio = video_get_drvdata(video_devdata(file));
        int retval;

+       if (radio->disconnected)
+               return -EIO;
        if (freq->type != V4L2_TUNER_RADIO)
                return -EINVAL;

@@ -1522,11 +1556,16 @@ static void si470x_usb_driver_disconnect
 {
        struct si470x_device *radio = usb_get_intfdata(intf);

+       mutex_lock(&open_close_lock);
+       radio->disconnected = 1;
        cancel_delayed_work_sync(&radio->work);
        usb_set_intfdata(intf, NULL);
-       video_unregister_device(radio->videodev);
-       kfree(radio->buffer);
-       kfree(radio);
+       if (radio->users == 0) {
+               video_unregister_device(radio->videodev);
+               kfree(radio->buffer);
+               kfree(radio);
+       }
+       mutex_unlock(&open_close_lock);
 }


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
