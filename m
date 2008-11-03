Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3Hpjwc016186
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:51:45 -0500
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA3HpYrY010208
	for <video4linux-list@redhat.com>; Mon, 3 Nov 2008 12:51:35 -0500
Received: by ug-out-1314.google.com with SMTP id j30so6295688ugc.13
	for <video4linux-list@redhat.com>; Mon, 03 Nov 2008 09:51:34 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
In-Reply-To: <30353c3d0811030936n744a55b2hb33b9300a4030106@mail.gmail.com>
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
	<30353c3d0810291008mc73e3ady3fdabc5adc0eacd5@mail.gmail.com>
	<30353c3d0810291012y5c9a4c54x480fdb0fa807dd0c@mail.gmail.com>
	<1225728173.20921.6.camel@tux.localhost>
	<30353c3d0811030819k4e6610d6u4188b940a40b02f5@mail.gmail.com>
	<1225733048.20921.11.camel@tux.localhost>
	<30353c3d0811030936n744a55b2hb33b9300a4030106@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 20:51:33 +0300
Message-Id: <1225734693.20921.15.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] radio-mr800: remove warn- and err- messages
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

And this version ? :)
Maybe it's good idea to remove KBUILD_MODNAME in pr_info and place
MR800_DRIVER_NAME there ?


Patch removes warn(), err() and info() statements in
media/radio/radio-mr800.c, and place dev_warn, dev_info in right places.
Printk changed on pr_info and pr_err macro. Also new macro
amradio_dev_warn defined.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--

diff -r db5374be1876 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Mon Nov 03 04:26:47 2008 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Nov 03 20:46:54 2008 +0300
@@ -72,6 +72,10 @@
 
 #define USB_AMRADIO_VENDOR 0x07ca
 #define USB_AMRADIO_PRODUCT 0xb800
+
+/* dev_warn macro with driver name */
+#define MR800_DRIVER_NAME "radio-mr800"
+#define amradio_dev_warn(dev, fmt, arg...) dev_warn(dev, MR800_DRIVER_NAME " - " fmt, ##arg)
 
 /* Probably USB_TIMEOUT should be modified in module parameter */
 #define BUFFER_LENGTH 8
@@ -155,7 +159,7 @@
 
 /* USB subsystem interface */
 static struct usb_driver usb_amradio_driver = {
-	.name			= "radio-mr800",
+	.name			= MR800_DRIVER_NAME,
 	.probe			= usb_amradio_probe,
 	.disconnect		= usb_amradio_disconnect,
 	.suspend		= usb_amradio_suspend,
@@ -362,7 +366,8 @@
 
 	radio->curfreq = f->frequency;
 	if (amradio_setfreq(radio, radio->curfreq) < 0)
-		warn("Set frequency failed");
+		amradio_dev_warn(&radio->videodev->dev,
+			"set frequency failed\n");
 	return 0;
 }
 
@@ -385,8 +390,7 @@
 
 	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
 		if (qc->id && qc->id == radio_qctrl[i].id) {
-			memcpy(qc, &(radio_qctrl[i]),
-						sizeof(*qc));
+			memcpy(qc, &(radio_qctrl[i]), sizeof(*qc));
 			return 0;
 		}
 	}
@@ -417,12 +421,14 @@
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
 			if (amradio_stop(radio) < 0) {
-				warn("amradio_stop() failed");
+				amradio_dev_warn(&radio->videodev->dev,
+					"amradio_stop failed\n");
 				return -1;
 			}
 		} else {
 			if (amradio_start(radio) < 0) {
-				warn("amradio_start() failed");
+				amradio_dev_warn(&radio->videodev->dev,
+					"amradio_start failed\n");
 				return -1;
 			}
 		}
@@ -478,13 +484,15 @@
 	radio->muted = 1;
 
 	if (amradio_start(radio) < 0) {
-		warn("Radio did not start up properly");
+		amradio_dev_warn(&radio->videodev->dev,
+			"radio did not start up properly\n");
 		radio->users = 0;
 		unlock_kernel();
 		return -EIO;
 	}
 	if (amradio_setfreq(radio, radio->curfreq) < 0)
-		warn("Set frequency failed");
+		amradio_dev_warn(&radio->videodev->dev,
+			"set frequency failed\n");
 
 	unlock_kernel();
 	return 0;
@@ -511,9 +519,9 @@
 	struct amradio_device *radio = usb_get_intfdata(intf);
 
 	if (amradio_stop(radio) < 0)
-		warn("amradio_stop() failed");
+		dev_warn(&intf->dev, "amradio_stop failed\n");
 
-	info("radio-mr800: Going into suspend..");
+	dev_info(&intf->dev, "going into suspend..\n");
 
 	return 0;
 }
@@ -524,9 +532,9 @@
 	struct amradio_device *radio = usb_get_intfdata(intf);
 
 	if (amradio_start(radio) < 0)
-		warn("amradio_start() failed");
+		dev_warn(&intf->dev, "amradio_start failed\n");
 
-	info("radio-mr800: Coming out of suspend..");
+	dev_info(&intf->dev, "coming out of suspend..\n");
 
 	return 0;
 }
@@ -605,7 +613,7 @@
 
 	video_set_drvdata(radio->videodev, radio);
 	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
-		warn("Could not register video device");
+		dev_warn(&intf->dev, "could not register video device\n");
 		video_device_release(radio->videodev);
 		kfree(radio->buffer);
 		kfree(radio);
@@ -620,9 +628,13 @@
 {
 	int retval = usb_register(&usb_amradio_driver);
 
-	info(DRIVER_VERSION " " DRIVER_DESC);
+	pr_info(KBUILD_MODNAME
+		": version " DRIVER_VERSION " " DRIVER_DESC "\n");
+
 	if (retval)
-		err("usb_register failed. Error number %d", retval);
+		pr_err(KBUILD_MODNAME
+			": usb_register failed. Error number %d\n", retval);
+
 	return retval;
 }
 


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
