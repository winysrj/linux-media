Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34798 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758132AbcH3Mbf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 08:31:35 -0400
Received: by mail-lf0-f66.google.com with SMTP id k135so891969lfb.1
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2016 05:31:34 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH 1/2] pulse8-cec: fixes
Date: Tue, 30 Aug 2016 14:31:28 +0200
Message-Id: <20160830123129.24306-1-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some small things:
    - clean up setup function
    - use MSGEND instead of 0xfe
    - don't assign "return value" from cec_phys_addr to err,
      it has return type void.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 33 ++++++++-------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index 193f4d1..1158ba9 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -266,7 +266,7 @@ static int pulse8_send(struct serio *serio, const u8 *command, u8 cmd_len)
 		}
 	}
 	if (!err)
-		err = serio_write(serio, 0xfe);
+		err = serio_write(serio, MSGEND);
 
 	return err;
 }
@@ -331,40 +331,29 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	u8 *data = pulse8->data + 1;
 	u8 cmd[2];
 	int err;
+	struct tm tm;
+	time_t date;
 
 	pulse8->vers = 0;
 
-	cmd[0] = MSGCODE_PING;
-	err = pulse8_send_and_wait(pulse8, cmd, 1,
-				   MSGCODE_COMMAND_ACCEPTED, 0);
 	cmd[0] = MSGCODE_FIRMWARE_VERSION;
-	if (!err)
-		err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 2);
+	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 2);
 	if (err)
 		return err;
-
 	pulse8->vers = (data[0] << 8) | data[1];
-
 	dev_info(pulse8->dev, "Firmware version %04x\n", pulse8->vers);
 	if (pulse8->vers < 2)
 		return 0;
 
 	cmd[0] = MSGCODE_GET_BUILDDATE;
-	if (!err)
-		err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 4);
-	if (!err) {
-		time_t date = (data[0] << 24) | (data[1] << 16) |
-			(data[2] << 8) | data[3];
-		struct tm tm;
-
-		time_to_tm(date, 0, &tm);
-
-		dev_info(pulse8->dev, "Firmware build date %04ld.%02d.%02d %02d:%02d:%02d\n",
-			 tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
-			 tm.tm_hour, tm.tm_min, tm.tm_sec);
-	}
+	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 4);
 	if (err)
 		return err;
+	date = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
+	time_to_tm(date, 0, &tm);
+	dev_info(pulse8->dev, "Firmware build date %04ld.%02d.%02d %02d:%02d:%02d\n",
+		 tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+		 tm.tm_hour, tm.tm_min, tm.tm_sec);
 
 	dev_dbg(pulse8->dev, "Persistent config:\n");
 	cmd[0] = MSGCODE_GET_AUTO_ENABLED;
@@ -456,8 +445,6 @@ static int pulse8_apply_persistent_config(struct pulse8 *pulse8,
 		return err;
 
 	cec_s_phys_addr(pulse8->adap, pa, false);
-	if (err)
-		return err;
 
 	return 0;
 }
-- 
2.9.3

