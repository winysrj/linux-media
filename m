Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34348 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbeG0ESb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 00:18:31 -0400
From: Jia-Ju Bai <baijiaju1990@gmail.com>
To: hans.verkuil@cisco.com, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] media: i2c: adv7842: Replace mdelay() with msleep() and usleep_range() in adv7842_ddr_ram_test()
Date: Fri, 27 Jul 2018 10:58:43 +0800
Message-Id: <20180727025843.2378-1-baijiaju1990@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

adv7842_ddr_ram_test() is never called in atomic context.
It only calls from:
adv7842_ddr_ram_test() <- adv7842_command_ram_test() <- adv7842_ioctl()

adv7842_ddr_ram_test() calls mdelay() to busily wait, 
which is not necessary.
mdelay() can be replaced with msleep() and usleep_range().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/media/i2c/adv7842.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index fddac32e5051..74ed32f77d5f 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3102,7 +3102,7 @@ static int adv7842_ddr_ram_test(struct v4l2_subdev *sd)
 	sdp_write(sd, 0x12, 0x00); /* Disable 3D comb, Frame TBC & 3DNR */
 	io_write(sd, 0xFF, 0x04);  /* Reset memory controller */
 
-	mdelay(5);
+	usleep_range(5000, 6000);
 
 	sdp_write(sd, 0x12, 0x00);    /* Disable 3D Comb, Frame TBC & 3DNR */
 	sdp_io_write(sd, 0x2A, 0x01); /* Memory BIST Initialisation */
@@ -3116,12 +3116,12 @@ static int adv7842_ddr_ram_test(struct v4l2_subdev *sd)
 	sdp_io_write(sd, 0x7d, 0x00); /* Memory BIST Initialisation */
 	sdp_io_write(sd, 0x7e, 0x1a); /* Memory BIST Initialisation */
 
-	mdelay(5);
+	usleep_range(5000, 6000);
 
 	sdp_io_write(sd, 0xd9, 0xd5); /* Enable BIST Test */
 	sdp_write(sd, 0x12, 0x05); /* Enable FRAME TBC & 3D COMB */
 
-	mdelay(20);
+	msleep(20);
 
 	for (i = 0; i < 10; i++) {
 		u8 result = sdp_io_read(sd, 0xdb);
@@ -3132,7 +3132,7 @@ static int adv7842_ddr_ram_test(struct v4l2_subdev *sd)
 			else
 				pass++;
 		}
-		mdelay(20);
+		msleep(20);
 	}
 
 	v4l2_dbg(1, debug, sd,
-- 
2.17.0
