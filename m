Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m19G936P001955
	for <video4linux-list@redhat.com>; Sat, 9 Feb 2008 11:09:03 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m19G8WSD027364
	for <video4linux-list@redhat.com>; Sat, 9 Feb 2008 11:08:32 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 9 Feb 2008 17:08:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802091708.25126.tobias.lorenz@gmx.net>
Cc: video4linux-list@redhat.com, Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 1.0.7] autosuspend support
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

this is hopefully the latest patch for the radio-si470x driver now.
Together with Oliver Neukum from Novell, USB autosuspend support was added.

The patch is against version 1.0.6 of the driver, which I send on 2008-01-31.
Can you please upload the patch to the Mercurial Repository?

Hopefully Linus is using the new version for the upcoming kernel release.
The version 1.0.4, which is currently in linux git, had some flaws...

Bye,
  Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- 1.0.6/drivers/media/radio/radio-si470x.c	2008-02-04 22:58:55.000000000 +0100
+++ 1.0.7/drivers/media/radio/radio-si470x.c	2008-02-09 16:51:48.000000000 +0100
@@ -81,6 +81,10 @@
  *		- racy interruptible_sleep_on(),
  *		  replaced with wait_event_interruptible()
  *		- handle signals in read()
+ * 2008-02-08	Tobias Lorenz <tobias.lorenz@gmx.net>
+ *		Oliver Neukum <oliver@neukum.org>
+ *		Version 1.0.7
+ *		- usb autosuspend support
  *
  * ToDo:
  * - add seeking support
@@ -416,6 +420,7 @@ MODULE_PARM_DESC(rds_poll_time, "RDS pol
 struct si470x_device {
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
+	struct usb_interface *intf;
 	struct video_device *videodev;
 
 	/* driver management */
@@ -763,9 +768,17 @@ static int si470x_stop(struct si470x_dev
  */
 static int si470x_rds_on(struct si470x_device *radio)
 {
+	int retval;
+
 	/* sysconfig 1 */
+	mutex_lock(&radio->lock);
 	radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDS;
-	return si470x_set_register(radio, SYSCONFIG1);
+	retval = si470x_set_register(radio, SYSCONFIG1);
+	if (retval < 0)
+		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_RDS;
+	mutex_unlock(&radio->lock);
+
+	return retval;
 }
 
 
@@ -962,10 +975,22 @@ static unsigned int si470x_fops_poll(str
 static int si470x_fops_open(struct inode *inode, struct file *file)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval;
 
 	radio->users++;
-	if (radio->users == 1)
-		return si470x_start(radio);
+
+	retval = usb_autopm_get_interface(radio->intf);
+	if (retval < 0) {
+		radio->users--;
+		return -EIO;
+	}
+
+	if (radio->users == 1) {
+		retval = si470x_start(radio);
+		if (retval < 0)
+			usb_autopm_put_interface(radio->intf);
+		return retval;
+	}
 
 	return 0;
 }
@@ -977,6 +1002,7 @@ static int si470x_fops_open(struct inode
 static int si470x_fops_release(struct inode *inode, struct file *file)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval;
 
 	if (!radio)
 		return -ENODEV;
@@ -989,7 +1015,9 @@ static int si470x_fops_release(struct in
 		/* cancel read processes */
 		wake_up_interruptible(&radio->read_queue);
 
-		return si470x_stop(radio);
+		retval = si470x_stop(radio);
+		usb_autopm_put_interface(radio->intf);
+		return retval;
 	}
 
 	return 0;
@@ -1378,6 +1406,7 @@ static int si470x_usb_driver_probe(struc
 			sizeof(si470x_viddev_template));
 	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
+	radio->intf = intf;
 	mutex_init(&radio->lock);
 	video_set_drvdata(radio->videodev, radio);
 
@@ -1441,6 +1470,41 @@ err_initial:
 
 
 /*
+ * si470x_usb_driver_suspend - suspend the device
+ */
+static int si470x_usb_driver_suspend(struct usb_interface *intf,
+		pm_message_t message)
+{
+	struct si470x_device *radio = usb_get_intfdata(intf);
+
+	printk(KERN_INFO DRIVER_NAME ": suspending now...\n");
+
+	cancel_delayed_work_sync(&radio->work);
+
+	return 0;
+}
+
+
+/*
+ * si470x_usb_driver_resume - resume the device
+ */
+static int si470x_usb_driver_resume(struct usb_interface *intf)
+{
+	struct si470x_device *radio = usb_get_intfdata(intf);
+
+	printk(KERN_INFO DRIVER_NAME ": resuming now...\n");
+
+	mutex_lock(&radio->lock);
+	if (radio->users && radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS)
+		schedule_delayed_work(&radio->work,
+			msecs_to_jiffies(rds_poll_time));
+	mutex_unlock(&radio->lock);
+
+	return 0;
+}
+
+
+/*
  * si470x_usb_driver_disconnect - disconnect the device
  */
 static void si470x_usb_driver_disconnect(struct usb_interface *intf)
@@ -1459,10 +1523,13 @@ static void si470x_usb_driver_disconnect
  * si470x_usb_driver - usb driver interface
  */
 static struct usb_driver si470x_usb_driver = {
-	.name		= DRIVER_NAME,
-	.probe		= si470x_usb_driver_probe,
-	.disconnect	= si470x_usb_driver_disconnect,
-	.id_table	= si470x_usb_driver_id_table,
+	.name			= DRIVER_NAME,
+	.probe			= si470x_usb_driver_probe,
+	.disconnect		= si470x_usb_driver_disconnect,
+	.suspend		= si470x_usb_driver_suspend,
+	.resume			= si470x_usb_driver_resume,
+	.id_table		= si470x_usb_driver_id_table,
+	.supports_autosuspend	= 1,
 };
 
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
