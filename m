Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA80W0H9013507
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 19:32:00 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA80Vmeu030276
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 19:31:48 -0500
Received: by ey-out-2122.google.com with SMTP id 4so591607eyf.39
	for <video4linux-list@redhat.com>; Fri, 07 Nov 2008 16:31:47 -0800 (PST)
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Sat, 08 Nov 2008 03:31:50 +0300
Message-Id: <1226104310.3959.5.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: [PATCH 1/2] dsbr100: add disabled controls and fix version
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

Patch adds disabled controls in 
v4l2_queryctrl struct. Also version of driver corrected.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--

diff -r 55f8fcf70843 linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Thu Oct 30 08:07:44 2008 +0000
+++ b/linux/drivers/media/radio/dsbr100.c	Mon Nov 03 04:00:26 2008 +0300
@@ -94,8 +94,8 @@
  */
 #include <linux/version.h>	/* for KERNEL_VERSION MACRO	*/
 
-#define DRIVER_VERSION "v0.41"
-#define RADIO_VERSION KERNEL_VERSION(0,4,1)
+#define DRIVER_VERSION "v0.43"
+#define RADIO_VERSION KERNEL_VERSION(0, 4, 3)
 
 static struct v4l2_queryctrl radio_qctrl[] = {
 	{
@@ -105,7 +105,27 @@
 		.maximum       = 1,
 		.default_value = 1,
 		.type          = V4L2_CTRL_TYPE_BOOLEAN,
-	}
+	},
+/* HINT: the disabled controls are only here to satify kradio and such apps */
+	{       .id             = V4L2_CID_AUDIO_VOLUME,
+		.flags          = V4L2_CTRL_FLAG_DISABLED,
+	},
+	{
+		.id             = V4L2_CID_AUDIO_BALANCE,
+		.flags          = V4L2_CTRL_FLAG_DISABLED,
+	},
+	{
+		.id             = V4L2_CID_AUDIO_BASS,
+		.flags          = V4L2_CTRL_FLAG_DISABLED,
+	},
+	{
+		.id             = V4L2_CID_AUDIO_TREBLE,
+		.flags          = V4L2_CTRL_FLAG_DISABLED,
+	},
+	{
+		.id             = V4L2_CID_AUDIO_LOUDNESS,
+		.flags          = V4L2_CTRL_FLAG_DISABLED,
+	},
 };
 
 #define DRIVER_AUTHOR "Markus Demleitner <msdemlei@tucana.harvard.edu>"


-- 
Best regards, Klimov Alexey

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
