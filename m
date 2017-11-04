Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:47395 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbdKDVxP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Nov 2017 17:53:15 -0400
From: Himanshu Jha <himanshujha199640@gmail.com>
To: hverkuil@xs4all.nl
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] [media] pulse8-cec: Eliminate use of time_t and time_to_tm
Date: Sun,  5 Nov 2017 03:23:01 +0530
Message-Id: <1509832381-1243-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eliminate the use of time_t type and time_to_tm functions as they are
deprecated due to y2038 problem.
Use the 64-Bit type interface instead.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/media/usb/pulse8-cec/pulse8-cec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 50146f2..3506358 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -329,7 +329,7 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	u8 cmd[2];
 	int err;
 	struct tm tm;
-	time_t date;
+	time64_t date;
 
 	pulse8->vers = 0;
 
@@ -349,7 +349,7 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	if (err)
 		return err;
 	date = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
-	time_to_tm(date, 0, &tm);
+	time64_to_tm(date, 0, &tm);
 	dev_info(pulse8->dev, "Firmware build date %04ld.%02d.%02d %02d:%02d:%02d\n",
 		 tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
 		 tm.tm_hour, tm.tm_min, tm.tm_sec);
-- 
2.7.4
