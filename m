Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49727 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2BXPYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:24:46 -0500
Received: by yenm8 with SMTP id m8so1156267yen.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:45 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 3/9] staging: easycap: Push bInterfaceNumber saving to config_easycap()
Date: Fri, 24 Feb 2012 12:24:16 -0300
Message-Id: <1330097062-31663-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |   72 +++++++++++++++-----------
 1 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 6d7cdef..9d6dc09 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3242,6 +3242,44 @@ static int create_video_urbs(struct easycap *peasycap)
 	return 0;
 }
 
+static void config_easycap(struct easycap *peasycap,
+			   u8 bInterfaceNumber,
+			   u8 bInterfaceClass,
+			   u8 bInterfaceSubClass)
+{
+	if ((USB_CLASS_VIDEO == bInterfaceClass) ||
+	    (USB_CLASS_VENDOR_SPEC == bInterfaceClass)) {
+		if (-1 == peasycap->video_interface) {
+			peasycap->video_interface = bInterfaceNumber;
+			JOM(4, "setting peasycap->video_interface=%i\n",
+				peasycap->video_interface);
+		} else {
+			if (peasycap->video_interface != bInterfaceNumber) {
+				SAM("ERROR: attempting to reset "
+				    "peasycap->video_interface\n");
+				SAM("...... continuing with "
+				    "%i=peasycap->video_interface\n",
+				    peasycap->video_interface);
+			}
+		}
+	} else if ((USB_CLASS_AUDIO == bInterfaceClass) &&
+		   (USB_SUBCLASS_AUDIOSTREAMING == bInterfaceSubClass)) {
+		if (-1 == peasycap->audio_interface) {
+			peasycap->audio_interface = bInterfaceNumber;
+			JOM(4, "setting peasycap->audio_interface=%i\n",
+				peasycap->audio_interface);
+		} else {
+			if (peasycap->audio_interface != bInterfaceNumber) {
+				SAM("ERROR: attempting to reset "
+				    "peasycap->audio_interface\n");
+				SAM("...... continuing with "
+				    "%i=peasycap->audio_interface\n",
+				    peasycap->audio_interface);
+			}
+		}
+	}
+}
+
 static const struct v4l2_file_operations v4l2_fops = {
 	.owner		= THIS_MODULE,
 	.open		= easycap_open_noinode,
@@ -3340,37 +3378,9 @@ static int easycap_usb_probe(struct usb_interface *intf,
 			return -ENODEV;
 	}
 
-	if ((USB_CLASS_VIDEO == bInterfaceClass) ||
-	    (USB_CLASS_VENDOR_SPEC == bInterfaceClass)) {
-		if (-1 == peasycap->video_interface) {
-			peasycap->video_interface = bInterfaceNumber;
-			JOM(4, "setting peasycap->video_interface=%i\n",
-							peasycap->video_interface);
-		} else {
-			if (peasycap->video_interface != bInterfaceNumber) {
-				SAM("ERROR: attempting to reset "
-						"peasycap->video_interface\n");
-				SAM("...... continuing with "
-						"%i=peasycap->video_interface\n",
-						peasycap->video_interface);
-			}
-		}
-	} else if ((USB_CLASS_AUDIO == bInterfaceClass) &&
-		   (USB_SUBCLASS_AUDIOSTREAMING == bInterfaceSubClass)) {
-		if (-1 == peasycap->audio_interface) {
-			peasycap->audio_interface = bInterfaceNumber;
-			JOM(4, "setting peasycap->audio_interface=%i\n",
-							 peasycap->audio_interface);
-		} else {
-			if (peasycap->audio_interface != bInterfaceNumber) {
-				SAM("ERROR: attempting to reset "
-						"peasycap->audio_interface\n");
-				SAM("...... continuing with "
-						"%i=peasycap->audio_interface\n",
-						peasycap->audio_interface);
-			}
-		}
-	}
+	config_easycap(peasycap, bInterfaceNumber,
+				 bInterfaceClass,
+				 bInterfaceSubClass);
 
 	/*
 	 * Investigate all altsettings. This is done in detail
-- 
1.7.3.4

