Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:56105 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaIKUBx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 16:01:53 -0400
Received: by mail-la0-f52.google.com with SMTP id b8so12211598lan.25
        for <linux-media@vger.kernel.org>; Thu, 11 Sep 2014 13:01:49 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] si2157: Add support for Si2147-A30 tuner
Date: Thu, 11 Sep 2014 23:01:38 +0300
Message-Id: <1410465698-12873-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for Si2147-A30 tuner. Fairly trivial, no firmware needed for this tuner. However, command 14 00 02 07 01 00 seems to be mandatory. On Si2157 and Si2158 the value 0x0100 is the default value, so this patch does not impact the existing tuners/devices. On Si2147 the default is 0x0000 and I can't get a lock with that value.

While here, fix the return length of the previous set command to 4 bytes.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c      | 13 +++++++++++--
 drivers/media/tuners/si2157.h      |  2 +-
 drivers/media/tuners/si2157_priv.h |  2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 5901484..cf97142 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -1,5 +1,5 @@
 /*
- * Silicon Labs Si2157/2158 silicon tuner driver
+ * Silicon Labs Si2147/2157/2158 silicon tuner driver
  *
  * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
  *
@@ -113,12 +113,14 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	#define SI2158_A20 ('A' << 24 | 58 << 16 | '2' << 8 | '0' << 0)
 	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
+	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
 
 	switch (chip_id) {
 	case SI2158_A20:
 		fw_file = SI2158_A20_FIRMWARE;
 		break;
 	case SI2157_A30:
+	case SI2147_A30:
 		goto skip_fw_download;
 		break;
 	default:
@@ -265,7 +267,14 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	if (s->inversion)
 		cmd.args[5] = 0x01;
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	memcpy(cmd.args, "\x14\x00\x02\x07\x01\x00", 6);
+	cmd.wlen = 6;
+	cmd.rlen = 4;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
index 6da4d5d..d3b19ca 100644
--- a/drivers/media/tuners/si2157.h
+++ b/drivers/media/tuners/si2157.h
@@ -1,5 +1,5 @@
 /*
- * Silicon Labs Si2157/2158 silicon tuner driver
+ * Silicon Labs Si2147/2157/2158 silicon tuner driver
  *
  * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
  *
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index 4080a57..e71ffaf 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -1,5 +1,5 @@
 /*
- * Silicon Labs Si2157/2158 silicon tuner driver
+ * Silicon Labs Si2147/2157/2158 silicon tuner driver
  *
  * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
  *
-- 
1.9.1

