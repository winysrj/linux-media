Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34639 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaI2Hox (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 03:44:53 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so606570lbi.37
        for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 00:44:51 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 3/5] sp2: improve debug logging
Date: Mon, 29 Sep 2014 10:44:18 +0300
Message-Id: <1411976660-19329-3-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
References: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Improve debugging output.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/sp2.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
index 1f4f250..320cbe9 100644
--- a/drivers/media/dvb-frontends/sp2.c
+++ b/drivers/media/dvb-frontends/sp2.c
@@ -92,6 +92,9 @@ static int sp2_write_i2c(struct sp2 *s, u8 reg, u8 *buf, int len)
 			return -EIO;
 	}
 
+	dev_dbg(&s->client->dev, "addr=0x%04x, reg = 0x%02x, data = %*ph\n",
+				client->addr, reg, len, buf);
+
 	return 0;
 }
 
@@ -103,9 +106,6 @@ static int sp2_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot, u8 acs,
 	int mem, ret;
 	int (*ci_op_cam)(void*, u8, int, u8, int*) = s->ci_control;
 
-	dev_dbg(&s->client->dev, "slot=%d, acs=0x%02x, addr=0x%04x, data = 0x%02x",
-			slot, acs, addr, data);
-
 	if (slot != 0)
 		return -EINVAL;
 
@@ -140,13 +140,16 @@ static int sp2_ci_op_cam(struct dvb_ca_en50221 *en50221, int slot, u8 acs,
 	if (ret)
 		return ret;
 
-	if (read) {
-		dev_dbg(&s->client->dev, "cam read, addr=0x%04x, data = 0x%04x",
-				addr, mem);
+	dev_dbg(&s->client->dev, "%s: slot=%d, addr=0x%04x, %s, data=%x",
+			(read) ? "read" : "write", slot, addr,
+			(acs == SP2_CI_ATTR_ACS) ? "attr" : "io",
+			(read) ? mem : data);
+
+	if (read)
 		return mem;
-	} else {
+	else
 		return 0;
-	}
+
 }
 
 int sp2_ci_read_attribute_mem(struct dvb_ca_en50221 *en50221,
-- 
1.9.1

