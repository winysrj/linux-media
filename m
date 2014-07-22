Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39359 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaGVTOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 15:14:23 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] si2168: Fix unknown chip version message
Date: Tue, 22 Jul 2014 16:14:10 -0300
Message-Id: <1406056450-16031-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At least here with my PCTV 292e, it is printing this error:

	si2168 10-0064: si2168: unkown chip version Si21170-

without a \n at the end. Probably because it is doing something
weird or firmware didn't load well. Anyway, better to print it
in hex, instead of using %c.

While here, fix the typo.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/si2168.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 41bdbc4d9f6c..842c4a555d01 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -414,9 +414,8 @@ static int si2168_init(struct dvb_frontend *fe)
 		break;
 	default:
 		dev_err(&s->client->dev,
-				"%s: unkown chip version Si21%d-%c%c%c\n",
-				KBUILD_MODNAME, cmd.args[2], cmd.args[1],
-				cmd.args[3], cmd.args[4]);
+				"%s: unknown chip version: 0x%04x\n",
+				KBUILD_MODNAME, chip_id);
 		ret = -EINVAL;
 		goto err;
 	}
-- 
1.9.3

