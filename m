Return-path: <mchehab@pedra>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13345 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab1DGTeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 15:34:13 -0400
Date: Thu, 7 Apr 2011 21:34:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <error27@gmail.com>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>
Subject: [PATCH][media] DVB, DiB9000: Fix leak in dib9000_attach()
Message-ID: <alpine.LNX.2.00.1104072131050.1538@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If the second memory allocation in dib9000_attach() fails, we'll leak the 
memory allocated by the first.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dib9000.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

   compile tested only...

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 9151876..b25ef2b 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -2255,8 +2255,10 @@ struct dvb_frontend *dib9000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, c
 	if (st == NULL)
 		return NULL;
 	fe = kzalloc(sizeof(struct dvb_frontend), GFP_KERNEL);
-	if (fe == NULL)
+	if (fe == NULL) {
+		kfree(st);
 		return NULL;
+	}
 
 	memcpy(&st->chip.d9.cfg, cfg, sizeof(struct dib9000_config));
 	st->i2c.i2c_adap = i2c_adap;


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

