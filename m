Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49727 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2BXPYv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:24:51 -0500
Received: by mail-yx0-f174.google.com with SMTP id m8so1156267yen.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:51 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 5/9] staging: easycap: Push video registration to easycap_register_video()
Date: Fri, 24 Feb 2012 12:24:18 -0300
Message-Id: <1330097062-31663-5-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |   58 +++++++++++++++-----------
 1 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 480164d..68af1a2 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3291,6 +3291,37 @@ static const struct v4l2_file_operations v4l2_fops = {
 	.mmap		= easycap_mmap,
 };
 
+static int easycap_register_video(struct easycap *peasycap)
+{
+	/*
+	 * FIXME: This is believed to be harmless,
+	 * but may well be unnecessary or wrong.
+	 */
+	peasycap->video_device.v4l2_dev = NULL;
+
+	strcpy(&peasycap->video_device.name[0], "easycapdc60");
+	peasycap->video_device.fops = &v4l2_fops;
+	peasycap->video_device.minor = -1;
+	peasycap->video_device.release = (void *)(&videodev_release);
+
+	video_set_drvdata(&(peasycap->video_device), (void *)peasycap);
+
+	if (0 != (video_register_device(&(peasycap->video_device),
+					VFL_TYPE_GRABBER, -1))) {
+		err("Not able to register with videodev");
+		videodev_release(&(peasycap->video_device));
+		return -ENODEV;
+	}
+
+	peasycap->registered_video++;
+
+	SAM("registered with videodev: %i=minor\n",
+	    peasycap->video_device.minor);
+	    peasycap->minor = peasycap->video_device.minor;
+
+	return 0;
+}
+
 /*
  * When the device is plugged, this function is called three times,
  * one for each interface.
@@ -3667,32 +3698,9 @@ static int easycap_usb_probe(struct usb_interface *intf,
 		JOM(4, "registered device instance: %s\n",
 			peasycap->v4l2_device.name);
 
-		/*
-		 * FIXME: This is believed to be harmless,
-		 * but may well be unnecessary or wrong.
-		 */
-		peasycap->video_device.v4l2_dev = NULL;
-
-
-		strcpy(&peasycap->video_device.name[0], "easycapdc60");
-		peasycap->video_device.fops = &v4l2_fops;
-		peasycap->video_device.minor = -1;
-		peasycap->video_device.release = (void *)(&videodev_release);
-
-		video_set_drvdata(&(peasycap->video_device), (void *)peasycap);
-
-		if (0 != (video_register_device(&(peasycap->video_device),
-							VFL_TYPE_GRABBER, -1))) {
-			err("Not able to register with videodev");
-			videodev_release(&(peasycap->video_device));
+		rc = easycap_register_video(peasycap);
+		if (rc < 0)
 			return -ENODEV;
-		}
-
-		peasycap->registered_video++;
-		SAM("registered with videodev: %i=minor\n",
-						peasycap->video_device.minor);
-		peasycap->minor = peasycap->video_device.minor;
-
 		break;
 	}
 	/* 1: Audio control */
-- 
1.7.3.4

