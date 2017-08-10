Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33180 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbdHJOcL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 10:32:11 -0400
Date: Thu, 10 Aug 2017 20:02:05 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging:media:atomisp:Fix trivial codingstyle issues
Message-ID: <20170810143204.GA4107@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

change comment style to match codingstyle. Issue found by checkpatch
change four comments.

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 38 ++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index 3e229ba..68e0b83 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -321,12 +321,15 @@ static int ap1302_request_firmware(struct v4l2_subdev *sd)
 	return ret;
 }
 
-/* When loading firmware, host writes firmware data from address 0x8000.
-   When the address reaches 0x9FFF, the next address should return to 0x8000.
-   This function handles this address window and load firmware data to AP1302.
-   win_pos indicates the offset within this window. Firmware loading procedure
-   may call this function several times. win_pos records the current position
-   that has been written to.*/
+/*
+ * When loading firmware, host writes firmware data from address 0x8000.
+ * When the address reaches 0x9FFF, the next address should return to 0x8000.
+ * This function handles this address window and load firmware data to AP1302.
+ * win_pos indicates the offset within this window. Firmware loading procedure
+ * may call this function several times. win_pos records the current position
+ * that has been written to.
+ *
+ */
 static int ap1302_write_fw_window(struct v4l2_subdev *sd,
 				  u16 *win_pos, const u8 *buf, u32 len)
 {
@@ -371,9 +374,12 @@ static int ap1302_load_firmware(struct v4l2_subdev *sd)
 		dev_err(&client->dev, "firmware size does not match.\n");
 		return -EINVAL;
 	}
-	/* The fw binary contains a header of struct ap1302_firmware.
-	   Following the header is the bootdata of AP1302.
-	   The bootdata pointer can be referenced as &fw[1]. */
+	/*
+	 * The fw binary contains a header of struct ap1302_firmware.
+	 * Following the header is the bootdata of AP1302.
+	 * The bootdata pointer can be referenced as &fw[1].
+	 *
+	 */
 	fw_data = (u8 *)&fw[1];
 
 	/* Clear crc register. */
@@ -386,8 +392,11 @@ static int ap1302_load_firmware(struct v4l2_subdev *sd)
 	if (ret)
 		return ret;
 
-	/* Write 2 to bootdata_stage register to apply basic_init_hp
-	   settings and enable PLL. */
+	/*
+	 * Write 2 to bootdata_stage register to apply basic_init_hp
+	 * settings and enable PLL.
+	 *
+	 */
 	ret = ap1302_i2c_write_reg(sd, REG_BOOTDATA_STAGE,
 				   AP1302_REG16, 0x0002);
 	if (ret)
@@ -413,8 +422,11 @@ static int ap1302_load_firmware(struct v4l2_subdev *sd)
 		return -EAGAIN;
 	}
 
-	/* Write 0xFFFF to bootdata_stage register to indicate AP1302 that
-	   the whole bootdata content has been loaded. */
+	/*
+	 * Write 0xFFFF to bootdata_stage register to indicate AP1302 that
+	 * the whole bootdata content has been loaded.
+	 *
+	 */
 	ret = ap1302_i2c_write_reg(sd, REG_BOOTDATA_STAGE,
 				   AP1302_REG16, 0xFFFF);
 	if (ret)
-- 
2.1.4
