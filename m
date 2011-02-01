Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1BAWlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:41:02 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7348272fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:41:01 -0800 (PST)
Subject: [PATCH 3/9 v2] ds3000: loading firmware in bigger chunks
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:40:25 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020040.25705.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Decrease firmware loading time. Before it is ~4000 i2c calls,
now it is ~256 i2c calls to load ds3000 firmware.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index b20005c..02ba759 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -305,7 +305,7 @@ static int ds3000_writeFW(struct ds3000_state *state, int reg,
 	struct i2c_msg msg;
 	u8 *buf;
 
-	buf = kmalloc(3, GFP_KERNEL);
+	buf = kmalloc(33, GFP_KERNEL);
 	if (buf == NULL) {
 		printk(KERN_ERR "Unable to kmalloc\n");
 		ret = -ENOMEM;
@@ -317,10 +317,10 @@ static int ds3000_writeFW(struct ds3000_state *state, int reg,
 	msg.addr = state->config->demod_address;
 	msg.flags = 0;
 	msg.buf = buf;
-	msg.len = 3;
+	msg.len = 33;
 
-	for (i = 0; i < len; i += 2) {
-		memcpy(buf + 1, data + i, 2);
+	for (i = 0; i < len; i += 32) {
+		memcpy(buf + 1, data + i, 32);
 
 		dprintk("%s: write reg 0x%02x, len = %d\n", __func__, reg, len);
 
-- 
1.7.1

