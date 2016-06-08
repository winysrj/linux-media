Return-path: <linux-media-owner@vger.kernel.org>
Received: from [216.47.245.140] ([216.47.245.140]:43874 "HELO
	your.mail.server.name.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754017AbcFHDhM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 23:37:12 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media] Fix DVB-T tuning
Date: Tue,  7 Jun 2016 23:30:16 -0400
Message-Id: <1465356616-21333-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

can't tune to DVB-T because 10 bytes can't be written to tuner

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/ascot2e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
index f770f6a..8cc8c45 100644
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -132,7 +132,7 @@ static int ascot2e_write_regs(struct ascot2e_priv *priv,
 		}
 	};
 
-	if (len + 1 >= sizeof(buf)) {
+	if (len + 1 > sizeof(buf)) {
 		dev_warn(&priv->i2c->dev,"wr reg=%04x: len=%d is too big!\n",
 			 reg, len + 1);
 		return -E2BIG;
-- 
2.7.4

