Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:36274 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbbJSPXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2015 11:23:00 -0400
From: Insu Yun <wuninsu@gmail.com>
To: erik.andren@gmail.com, hdegoede@redhat.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] m5602: correctly check failed thread creation
Date: Mon, 19 Oct 2015 15:24:13 +0000
Message-Id: <1445268253-23157-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since thread creation can be failed, check return value of
kthread_create and handle an error.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
index bf6b215..76b40d1 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
@@ -221,6 +221,10 @@ int s5k83a_start(struct sd *sd)
 	   to assume that there is no better way of accomplishing this */
 	sd->rotation_thread = kthread_create(rotation_thread_function,
 					     sd, "rotation thread");
+	if (IS_ERR(sd->rotation_thread)) {
+		err = PTR_ERR(sd->rotation_thread);
+		goto fail;
+	}
 	wake_up_process(sd->rotation_thread);
 
 	/* Preinit the sensor */
@@ -234,9 +238,11 @@ int s5k83a_start(struct sd *sd)
 				data[0]);
 	}
 	if (err < 0)
-		return err;
+		goto fail;
 
 	return s5k83a_set_led_indication(sd, 1);
+fail:
+	return err;
 }
 
 int s5k83a_stop(struct sd *sd)
-- 
1.9.1

