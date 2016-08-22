Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35473 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754795AbcHVJFN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:05:13 -0400
Received: by mail-wm0-f65.google.com with SMTP id i5so12450682wmg.2
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 02:05:12 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCHv2 2/4] pulse8-cec: serialize communication with adapter
Date: Mon, 22 Aug 2016 11:04:52 +0200
Message-Id: <1471856694-14182-3-git-send-email-jaffe1@gmail.com>
In-Reply-To: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
References: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sending messages to the adapter serialized within the driver.

send_and_wait is split into send_and_wait_once, which only sends once
and checks for the result, and the higher level send_and_wait, which
performs locking and retries.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 drivers/staging/media/pulse8-cec/pulse8-cec.c | 52 ++++++++++++++++-----------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
index ed8bd95..37c8418 100644
--- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
+++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
@@ -99,6 +99,7 @@ struct pulse8 {
 	unsigned int idx;
 	bool escape;
 	bool started;
+	struct mutex write_lock;
 };
 
 static void pulse8_irq_work_handler(struct work_struct *work)
@@ -233,8 +234,9 @@ static int pulse8_send(struct serio *serio, const u8 *command, u8 cmd_len)
 	return err;
 }
 
-static int pulse8_send_and_wait(struct pulse8 *pulse8,
-				const u8 *cmd, u8 cmd_len, u8 response, u8 size)
+static int pulse8_send_and_wait_once(struct pulse8 *pulse8,
+				     const u8 *cmd, u8 cmd_len,
+				     u8 response, u8 size)
 {
 	int err;
 
@@ -250,24 +252,8 @@ static int pulse8_send_and_wait(struct pulse8 *pulse8,
 	if ((pulse8->data[0] & 0x3f) == MSGCODE_COMMAND_REJECTED &&
 	    cmd[0] != MSGCODE_SET_CONTROLLED &&
 	    cmd[0] != MSGCODE_SET_AUTO_ENABLED &&
-	    cmd[0] != MSGCODE_GET_BUILDDATE) {
-		u8 cmd_sc[2];
-
-		cmd_sc[0] = MSGCODE_SET_CONTROLLED;
-		cmd_sc[1] = 1;
-		err = pulse8_send_and_wait(pulse8, cmd_sc, 2,
-					   MSGCODE_COMMAND_ACCEPTED, 1);
-		if (err)
-			return err;
-		init_completion(&pulse8->cmd_done);
-
-		err = pulse8_send(pulse8->serio, cmd, cmd_len);
-		if (err)
-			return err;
-
-		if (!wait_for_completion_timeout(&pulse8->cmd_done, HZ))
-			return -ETIMEDOUT;
-	}
+	    cmd[0] != MSGCODE_GET_BUILDDATE)
+		return -ENOTTY;
 	if (response &&
 	    ((pulse8->data[0] & 0x3f) != response || pulse8->len < size + 1)) {
 		dev_info(pulse8->dev, "transmit: failed %02x\n",
@@ -277,6 +263,31 @@ static int pulse8_send_and_wait(struct pulse8 *pulse8,
 	return 0;
 }
 
+static int pulse8_send_and_wait(struct pulse8 *pulse8,
+				const u8 *cmd, u8 cmd_len, u8 response, u8 size)
+{
+	u8 cmd_sc[2];
+	int err;
+
+	mutex_lock(&pulse8->write_lock);
+	err = pulse8_send_and_wait_once(pulse8, cmd, cmd_len, response, size);
+
+	if (err == -ENOTTY) {
+		cmd_sc[0] = MSGCODE_SET_CONTROLLED;
+		cmd_sc[1] = 1;
+		err = pulse8_send_and_wait_once(pulse8, cmd_sc, 2,
+						MSGCODE_COMMAND_ACCEPTED, 1);
+		if (err)
+			goto unlock;
+		err = pulse8_send_and_wait_once(pulse8, cmd, cmd_len,
+						response, size);
+	}
+
+unlock:
+	mutex_unlock(&pulse8->write_lock);
+	return err == -ENOTTY ? -EIO : err;
+}
+
 static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio)
 {
 	u8 *data = pulse8->data + 1;
@@ -453,6 +464,7 @@ static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
 	pulse8->dev = &serio->dev;
 	serio_set_drvdata(serio, pulse8);
 	INIT_WORK(&pulse8->work, pulse8_irq_work_handler);
+	mutex_init(&pulse8->write_lock);
 
 	err = serio_open(serio, drv);
 	if (err)
-- 
2.7.4

