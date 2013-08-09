Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493Ab3HIMxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:53:43 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?q?Alfredo=20Jes=C3=BAs=20Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCHv2 2/3] mb86a20s: Fix TS parallel mode
Date: Fri,  9 Aug 2013 09:53:26 -0300
Message-Id: <1376052807-8215-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1376052807-8215-1-git-send-email-m.chehab@samsung.com>
References: <1376052807-8215-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset 768e6dadd74 caused a regression on using mb86a20s
in parallel mode, as the parallel mode selection got
overriden by mb86a20s_init2.

Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 856374b..2c7217f 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -157,7 +157,6 @@ static struct regdata mb86a20s_init2[] = {
 	{ 0x45, 0x04 },				/* CN symbol 4 */
 	{ 0x48, 0x04 },				/* CN manual mode */
 
-	{ 0x50, 0xd5 }, { 0x51, 0x01 },		/* Serial */
 	{ 0x50, 0xd6 }, { 0x51, 0x1f },
 	{ 0x50, 0xd2 }, { 0x51, 0x03 },
 	{ 0x50, 0xd7 }, { 0x51, 0xbf },
@@ -1860,16 +1859,15 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	dev_dbg(&state->i2c->dev, "%s: IF=%d, IF reg=0x%06llx\n",
 		__func__, state->if_freq, (long long)pll);
 
-	if (!state->config->is_serial) {
+	if (!state->config->is_serial)
 		regD5 &= ~1;
 
-		rc = mb86a20s_writereg(state, 0x50, 0xd5);
-		if (rc < 0)
-			goto err;
-		rc = mb86a20s_writereg(state, 0x51, regD5);
-		if (rc < 0)
-			goto err;
-	}
+	rc = mb86a20s_writereg(state, 0x50, 0xd5);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x51, regD5);
+	if (rc < 0)
+		goto err;
 
 	rc = mb86a20s_writeregdata(state, mb86a20s_init2);
 	if (rc < 0)
-- 
1.8.3.1

