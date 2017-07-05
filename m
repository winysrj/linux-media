Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33203 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdGEKIE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Jul 2017 06:08:04 -0400
Received: by mail-lf0-f68.google.com with SMTP id t72so20333399lff.0
        for <linux-media@vger.kernel.org>; Wed, 05 Jul 2017 03:08:04 -0700 (PDT)
From: Ivan Menshykov <ivan.menshykov@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        Ivan Menshykov <ivan.menshykov@gmail.com>
Subject: [PATCH] staging: media: atomisp: i2c: ov5693: Fix style a coding style issue
Date: Wed,  5 Jul 2017 12:07:45 +0200
Message-Id: <20170705100745.17166-1-ivan.menshykov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix checkpath errors

Signed-off-by: Ivan Menshykov <ivan.menshykov@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 5e9dafe7cc32..0616ff044f1e 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -146,7 +146,7 @@ static int ov5693_read_reg(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	memset(msg, 0 , sizeof(msg));
+	memset(msg, 0, sizeof(msg));
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
@@ -702,7 +702,7 @@ static long ov5693_s_exposure(struct v4l2_subdev *sd,
 }
 
 static int ov5693_read_otp_reg_array(struct i2c_client *client, u16 size,
-				     u16 addr, u8 * buf)
+				     u16 addr, u8 *buf)
 {
 	u16 index;
 	int ret;
@@ -720,7 +720,7 @@ static int ov5693_read_otp_reg_array(struct i2c_client *client, u16 size,
 	return 0;
 }
 
-static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 * buf)
+static int __ov5693_otp_read(struct v4l2_subdev *sd, u8 *buf)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov5693_device *dev = to_ov5693_sensor(sd);
-- 
2.13.0
