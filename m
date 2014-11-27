Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:45226 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaK0Tmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 14:42:37 -0500
Received: by mail-la0-f48.google.com with SMTP id s18so4574400lam.7
        for <linux-media@vger.kernel.org>; Thu, 27 Nov 2014 11:42:36 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/2] si2168: add support for firmware files in new format
Date: Thu, 27 Nov 2014 21:42:23 +0200
Message-Id: <1417117343-1793-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1417117343-1793-1-git-send-email-olli.salonen@iki.fi>
References: <1417117343-1793-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for new type of firmware versions of Si2168 chip. 

Old type: n x 8 bytes (all data, first byte seems to be 04 or 05)
New type: n x 17 bytes (1 byte indicates len and max 16 bytes data)

New version of TechnoTrend CT2-4400 drivers 
(http://www.tt-downloads.de/bda-treiber_4.3.0.0.zip) contains newer
firmware for Si2168-B40 that is in the new format. It can be extracted
with the following command:

dd if=ttTVStick4400_64.sys ibs=1 skip=323872 count=6919 of=dvb-demod-si2168-b40-01.fw

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 46 +++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 6da38e8..ce9ab44 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -462,20 +462,38 @@ static int si2168_init(struct dvb_frontend *fe)
 	dev_info(&s->client->dev, "downloading firmware from file '%s'\n",
 			fw_file);
 
-	for (remaining = fw->size; remaining > 0; remaining -= i2c_wr_max) {
-		len = remaining;
-		if (len > i2c_wr_max)
-			len = i2c_wr_max;
-
-		memcpy(cmd.args, &fw->data[fw->size - remaining], len);
-		cmd.wlen = len;
-		cmd.rlen = 1;
-		ret = si2168_cmd_execute(s, &cmd);
-		if (ret) {
-			dev_err(&s->client->dev,
-					"firmware download failed=%d\n",
-					ret);
-			goto error_fw_release;
+	if ((fw->size % 17 == 0) && (fw->data[0] > 5)) {
+		/* firmware is in the new format */
+		for (remaining = fw->size; remaining > 0; remaining -= 17) {
+			len = fw->data[fw->size - remaining];
+			memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
+			cmd.wlen = len;
+			cmd.rlen = 1;
+			ret = si2168_cmd_execute(s, &cmd);
+			if (ret) {
+				dev_err(&s->client->dev,
+						"firmware download failed=%d\n",
+						ret);
+				goto error_fw_release;
+			}
+		}
+	} else {
+		/* firmware is in the old format */
+		for (remaining = fw->size; remaining > 0; remaining -= i2c_wr_max) {
+			len = remaining;
+			if (len > i2c_wr_max)
+				len = i2c_wr_max;
+
+			memcpy(cmd.args, &fw->data[fw->size - remaining], len);
+			cmd.wlen = len;
+			cmd.rlen = 1;
+			ret = si2168_cmd_execute(s, &cmd);
+			if (ret) {
+				dev_err(&s->client->dev,
+						"firmware download failed=%d\n",
+						ret);
+				goto error_fw_release;
+			}
 		}
 	}
 
-- 
1.9.1

