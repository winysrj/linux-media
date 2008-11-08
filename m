Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA80eqoV016157
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 19:40:52 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA80ed6A001683
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 19:40:39 -0500
Received: by ey-out-2122.google.com with SMTP id 4so592094eyf.39
	for <video4linux-list@redhat.com>; Fri, 07 Nov 2008 16:40:39 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 08 Nov 2008 03:40:46 +0300
Message-Id: <1226104846.3959.13.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH 2/2] dsbr100: add suspend and resume
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


This patch adds support for suspend and resume methods in driver.
Without this kradio and gnomeradio crashes during resume.
Also .supports_autosuspend in usb_driver struct set equal to 0 to avoid
suspending of module if usb_autosuspend enabled.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---

diff -r c716e749c7e5 linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Sat Nov 08 03:01:20 2008 +0300
+++ b/linux/drivers/media/radio/dsbr100.c	Sat Nov 08 03:11:38 2008 +0300
@@ -152,6 +152,9 @@
 static void usb_dsbr100_disconnect(struct usb_interface *intf);
 static int usb_dsbr100_open(struct inode *inode, struct file *file);
 static int usb_dsbr100_close(struct inode *inode, struct file *file);
+static int usb_dsbr100_suspend(struct usb_interface *intf,
+						pm_message_t message);
+static int usb_dsbr100_resume(struct usb_interface *intf);
 
 static int radio_nr = -1;
 module_param(radio_nr, int, 0);
@@ -178,10 +181,16 @@
 
 /* USB subsystem interface */
 static struct usb_driver usb_dsbr100_driver = {
-	.name =		"dsbr100",
-	.probe =	usb_dsbr100_probe,
-	.disconnect =	usb_dsbr100_disconnect,
-	.id_table =	usb_dsbr100_device_table,
+	.name			= "dsbr100",
+	.probe			= usb_dsbr100_probe,
+	.disconnect		= usb_dsbr100_disconnect,
+	.id_table		= usb_dsbr100_device_table,
+	.suspend		= usb_dsbr100_suspend,
+	.resume			= usb_dsbr100_resume,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 23)
+	.reset_resume		= usb_dsbr100_resume,
+#endif
+	.supports_autosuspend	= 0,
 };
 
 /* Low-level device interface begins here */
@@ -469,6 +478,36 @@
 	return 0;
 }
 
+/* Suspend device - stop device. */
+static int usb_dsbr100_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct dsbr100_device *radio = usb_get_intfdata(intf);
+	int retval;
+
+	retval = dsbr100_stop(radio);
+	if (retval == -1)
+		dev_warn(&intf->dev, "dsbr100_stop failed\n");
+
+	dev_info(&intf->dev, "going into suspend..\n");
+
+	return 0;
+}
+
+/* Resume device - start device. */
+static int usb_dsbr100_resume(struct usb_interface *intf)
+{
+	struct dsbr100_device *radio = usb_get_intfdata(intf);
+	int retval;
+
+	retval = dsbr100_start(radio);
+	if (retval == -1)
+		dev_warn(&intf->dev, "dsbr100_start failed\n");
+
+	dev_info(&intf->dev, "coming out of suspend..\n");
+
+	return 0;
+}
+
 /* File system interface */
 static const struct file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
