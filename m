Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaGVTZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 15:25:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] si2168: Fix a badly solved merge conflict
Date: Tue, 22 Jul 2014 16:25:33 -0300
Message-Id: <1406057133-7657-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset a733291d6934 didn't merge the fixes well. It ended by
restoring some bad logic removed there.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/si2168.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 842c4a555d01..02127613eeff 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -381,20 +381,6 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	cmd.args[0] = 0x05;
-	cmd.args[1] = 0x00;
-	cmd.args[2] = 0xaa;
-	cmd.args[3] = 0x4d;
-	cmd.args[4] = 0x56;
-	cmd.args[5] = 0x40;
-	cmd.args[6] = 0x00;
-	cmd.args[7] = 0x00;
-	cmd.wlen = 8;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8 |
 			cmd.args[4] << 0;
 
-- 
1.9.3

