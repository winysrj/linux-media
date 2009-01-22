Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:36666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZAVOO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 09:14:29 -0500
Message-ID: <49787F42.8080908@gmail.com>
Date: Thu, 22 Jan 2009 15:14:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L/DVB: fix v4l2_device_call_all/v4l2_device_call_until_err
 macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When these macros aren't called with 'grp_id' this will result in a
build failure.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 9bf4ccc..ad86caa 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -94,16 +94,16 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev *sd);
 /* Call the specified callback for all subdevs matching grp_id (if 0, then
    match them all). Ignore any errors. Note that you cannot add or delete
    a subdev while walking the subdevs list. */
-#define v4l2_device_call_all(dev, grp_id, o, f, args...) 		\
+#define v4l2_device_call_all(dev, _grp_id, o, f, args...) 		\
 	__v4l2_device_call_subdevs(dev, 				\
-			!(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
+			!(_grp_id) || sd->grp_id == (_grp_id), o, f , ##args)
 
 /* Call the specified callback for all subdevs matching grp_id (if 0, then
    match them all). If the callback returns an error other than 0 or
    -ENOIOCTLCMD, then return with that error code. Note that you cannot
    add or delete a subdev while walking the subdevs list. */
-#define v4l2_device_call_until_err(dev, grp_id, o, f, args...) 		\
+#define v4l2_device_call_until_err(dev, _grp_id, o, f, args...) 		\
 	__v4l2_device_call_subdevs_until_err(dev,			\
-		       !(grp_id) || sd->grp_id == (grp_id), o, f , ##args)
+		       !(_grp_id) || sd->grp_id == (_grp_id), o, f , ##args)
 
 #endif

