Return-path: <linux-media-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:46289 "EHLO m50-134.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1044380AbdDWJ0w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 05:26:52 -0400
From: Pan Bian <bianpan201602@163.com>
To: Erik Andren <erik.andren@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] m5602_s5k83a: check return value of kthread_create
Date: Sun, 23 Apr 2017 17:26:45 +0800
Message-Id: <1492939605-25977-1-git-send-email-bianpan201602@163.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pan Bian <bianpan2016@163.com>

Function kthread_create() returns an ERR_PTR on error. However, in
function s5k83a_start(), its return value is used without validation.
This may result in a bad memory access bug. This patch fixes the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
index be5e25d1..6ad8d48 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
@@ -345,6 +345,11 @@ int s5k83a_start(struct sd *sd)
 	   to assume that there is no better way of accomplishing this */
 	sd->rotation_thread = kthread_create(rotation_thread_function,
 					     sd, "rotation thread");
+	if (IS_ERR(sd->rotation_thread)) {
+		err = PTR_ERR(sd->rotation_thread);
+		sd->rotation_thread = NULL;
+		return err;
+	}
 	wake_up_process(sd->rotation_thread);
 
 	/* Preinit the sensor */
-- 
1.9.1
