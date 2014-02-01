Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37777 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417AbaBAUog (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 15:44:36 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Robert Schlabbach <Robert.Schlabbach@gmx.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] m88ds3103: fix bug on .set_tone()
Date: Sat,  1 Feb 2014 22:44:18 +0200
Message-Id: <1391287458-11939-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391287458-11939-1-git-send-email-crope@iki.fi>
References: <1391287458-11939-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Band switching didn't worked always reliably as there was one
register bit set wrong.

Thanks to Robert Schlabbach for pointing this bug and solution.

Reported-by: Robert Schlabbach <Robert.Schlabbach@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index b8f8df0..2ef8ce1 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -944,7 +944,7 @@ static int m88ds3103_set_tone(struct dvb_frontend *fe,
 	switch (fe_sec_tone_mode) {
 	case SEC_TONE_ON:
 		tone = 0;
-		reg_a1_mask = 0x87;
+		reg_a1_mask = 0x47;
 		break;
 	case SEC_TONE_OFF:
 		tone = 1;
-- 
1.8.5.3

