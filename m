Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39320 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIODx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 10:03:53 -0400
Received: by mail-pl1-f196.google.com with SMTP id w14-v6so319958plp.6
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 23:48:28 -0700 (PDT)
From: Sam Bobrowicz <sam@elite-embedded.com>
To: linux-media@vger.kernel.org
Cc: Sam Bobrowicz <sam@elite-embedded.com>
Subject: [PATCH 3/4] media: ov5640: Don't access ctrl regs when off
Date: Mon,  8 Oct 2018 23:48:01 -0700
Message-Id: <1539067682-60604-4-git-send-email-sam@elite-embedded.com>
In-Reply-To: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a check to g_volatile_ctrl to prevent trying to read
registers when the sensor is not powered.

Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
---
 drivers/media/i2c/ov5640.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index f183222..a50d884 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -2336,6 +2336,13 @@ static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 	/* v4l2_ctrl_lock() locks our own mutex */
 
+	/*
+	 * If the sensor is not powered up by the host driver, do
+	 * not try to access it to update the volatile controls.
+	 */
+	if (sensor->power_count == 0)
+		return 0;
+
 	switch (ctrl->id) {
 	case V4L2_CID_AUTOGAIN:
 		val = ov5640_get_gain(sensor);
-- 
2.7.4
