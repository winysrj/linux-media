Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f196.google.com ([209.85.160.196]:34810 "EHLO
	mail-yk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbbKQUgH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2015 15:36:07 -0500
From: Insu Yun <wuninsu@gmail.com>
To: erik.andren@gmail.com, hdegoede@redhat.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] m5602: correctly check failed thread creation
Date: Tue, 17 Nov 2015 15:36:09 -0500
Message-Id: <1447792569-69734-1-git-send-email-wuninsu@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
index bf6b215..84b2961 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
@@ -221,6 +221,9 @@ int s5k83a_start(struct sd *sd)
 	   to assume that there is no better way of accomplishing this */
 	sd->rotation_thread = kthread_create(rotation_thread_function,
 					     sd, "rotation thread");
+	if (IS_ERR(sd->rotation_thread))
+		return PTR_ERR(sd->rotation_thread);
+
 	wake_up_process(sd->rotation_thread);
 
 	/* Preinit the sensor */
-- 
1.9.1

