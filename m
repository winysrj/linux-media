Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9SI7mAs005531
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:11:01 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9SI69g3031219
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 14:06:25 -0400
Received: by ug-out-1314.google.com with SMTP id j30so774441ugc.13
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 11:06:08 -0700 (PDT)
Date: Tue, 28 Oct 2008 21:05:53 +0300
From: Alexey Klimov <klimov.linux@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20081028180552.GA2677@tux>
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
Cc: 
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

Hello, all

Here is new patch, reformatted. Also KBUILD_MODNAME added.

radio-mr800: remove warn-, err- and info-messages

Patch removes warn(), err() and info() statements in radio/radio-mr800.c,
and place dev_warn, dev_info in right places.
Printk changed on pr_info and pr_err macro.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

---

diff -r 0b2679b688fe linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Tue Oct 28 14:15:21 2008 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Tue Oct 28 20:49:54 2008 +0300
@@ -362,7 +362,8 @@
 
 	radio->curfreq = f->frequency;
 	if (amradio_setfreq(radio, radio->curfreq) < 0)
-		warn("Set frequency failed");
+		dev_warn(&radio->videodev->dev,
+			KBUILD_MODNAME " - set frequency failed\n");
 	return 0;
 }
 
@@ -385,8 +386,7 @@
 
 	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
 		if (qc->id && qc->id == radio_qctrl[i].id) {
-			memcpy(qc, &(radio_qctrl[i]),
-						sizeof(*qc));
+			memcpy(qc, &(radio_qctrl[i]), sizeof(*qc));
 			return 0;
 		}
 	}
@@ -417,12 +417,16 @@
 	case V4L2_CID_AUDIO_MUTE:
 		if (ctrl->value) {
 			if (amradio_stop(radio) < 0) {
-				warn("amradio_stop() failed");
+				dev_warn(&radio->videodev->dev,
+					KBUILD_MODNAME
+						" - amradio_stop failed\n");
 				return -1;
 			}
 		} else {
 			if (amradio_start(radio) < 0) {
-				warn("amradio_start() failed");
+				dev_warn(&radio->videodev->dev,
+					KBUILD_MODNAME
+						" - amradio_start failed\n");
 				return -1;
 			}
 		}
@@ -478,13 +482,15 @@
 	radio->muted = 1;
 
 	if (amradio_start(radio) < 0) {
-		warn("Radio did not start up properly");
+		dev_warn(&radio->videodev->dev,
+			KBUILD_MODNAME " - radio did not start up properly\n");
 		radio->users = 0;
 		unlock_kernel();
 		return -EIO;
 	}
 	if (amradio_setfreq(radio, radio->curfreq) < 0)
-		warn("Set frequency failed");
+		dev_warn(&radio->videodev->dev,
+			KBUILD_MODNAME " - set frequency failed\n");
 
 	unlock_kernel();
 	return 0;
@@ -511,9 +517,9 @@
 	struct amradio_device *radio = usb_get_intfdata(intf);
 
 	if (amradio_stop(radio) < 0)
-		warn("amradio_stop() failed");
+		dev_warn(&intf->dev, "amradio_stop failed\n");
 
-	info("radio-mr800: Going into suspend..");
+	dev_info(&intf->dev, "going into suspend..\n");
 
 	return 0;
 }
@@ -524,9 +530,9 @@
 	struct amradio_device *radio = usb_get_intfdata(intf);
 
 	if (amradio_start(radio) < 0)
-		warn("amradio_start() failed");
+		dev_warn(&intf->dev, "amradio_start failed\n");
 
-	info("radio-mr800: Coming out of suspend..");
+	dev_info(&intf->dev, "coming out of suspend..\n");
 
 	return 0;
 }
@@ -605,7 +611,7 @@
 
 	video_set_drvdata(radio->videodev, radio);
 	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
-		warn("Could not register video device");
+		dev_warn(&intf->dev, "could not register video device\n");
 		video_device_release(radio->videodev);
 		kfree(radio->buffer);
 		kfree(radio);
@@ -620,9 +626,13 @@
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

-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
