Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:32798 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbcCWEXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 00:23:43 -0400
Received: by mail-qg0-f50.google.com with SMTP id j35so3304322qge.0
        for <linux-media@vger.kernel.org>; Tue, 22 Mar 2016 21:23:43 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Kevin Fitch <kfitch42@gmail.com>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] i2c: saa7115: Support CJC7113 detection
Date: Wed, 23 Mar 2016 01:23:32 -0300
Message-Id: <1458707012-5063-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kevin Fitch <kfitch42@gmail.com>

It's been reported that CJC7113 devices are returning
all 1s when reading register 0:

  "1111111111111111" found @ 0x4a (stk1160)

This new device is apparently compatible with SA7113, so let's
add a quirk to allow its autodetection. Given there isn't
any known differences with SAA7113, this commit does not
introduces a new saa711x_model value.

Reported-by: Philippe Desrochers <desrochers.philippe@gmail.com>
Signed-off-by: Kevin Fitch <kfitch42@gmail.com>
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/i2c/saa7115.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 24d2b76dbe97..04f266d0a1ef 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1794,6 +1794,21 @@ static int saa711x_detect_chip(struct i2c_client *client,
 		return GM7113C;
 	}
 
+	/* Check if it is a CJC7113 */
+	if (!memcmp(name, "1111111111111111", CHIP_VER_SIZE)) {
+		strlcpy(name, "cjc7113", CHIP_VER_SIZE);
+
+		if (!autodetect && strcmp(name, id->name))
+			return -EINVAL;
+
+		v4l_dbg(1, debug, client,
+			"It seems to be a %s chip (%*ph) @ 0x%x.\n",
+			name, 16, chip_ver, client->addr << 1);
+
+		/* CJC7113 seems to be SAA7113-compatible */
+		return SAA7113;
+	}
+
 	/* Chip was not discovered. Return its ID and don't bind */
 	v4l_dbg(1, debug, client, "chip %*ph @ 0x%x is unknown.\n",
 		16, chip_ver, client->addr << 1);
-- 
2.7.0

