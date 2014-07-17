Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:63226 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaGQRbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 13:31:36 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so3460789wes.0
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 10:31:34 -0700 (PDT)
From: Luis Alves <ljalvs@gmail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, Luis Alves <ljalvs@gmail.com>
Subject: [PATCH 1/1] si2168: Set symbol_rate in set_frontend for DVB-C delivery system.
Date: Thu, 17 Jul 2014 18:31:28 +0100
Message-Id: <1405618288-28317-1-git-send-email-ljalvs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds symbol rate setting to the driver.

Signed-off-by: Luis Alves <ljalvs@gmail.com>
---
 drivers/media/dvb-frontends/si2168.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 0422925..7980741 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -278,6 +278,18 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	/* set DVB-C symbol rate */
+	if (c->delivery_system == SYS_DVBC_ANNEX_A) {
+		memcpy(cmd.args, "\x14\x00\x02\x11", 4);
+		cmd.args[4] = (c->symbol_rate / 1000) & 0xff;
+		cmd.args[5] = ((c->symbol_rate / 1000) >> 8) & 0xff;
+		cmd.wlen = 6;
+		cmd.rlen = 4;
+		ret = si2168_cmd_execute(s, &cmd);
+		if (ret)
+			goto err;
+	}
+
 	memcpy(cmd.args, "\x14\x00\x0f\x10\x10\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 4;
-- 
1.9.1

