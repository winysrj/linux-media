Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:52966 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaLMASz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 19:18:55 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] mn88472: implement dvb-t signal lock
Date: Sat, 13 Dec 2014 01:18:42 +0100
Message-Id: <1418429925-16342-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 107552a..4d80046 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -238,6 +238,7 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	unsigned int utmp;
+	int lock = 0;
 
 	*status = 0;
 
@@ -248,6 +249,12 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
+		ret = regmap_read(dev->regmap[0], 0x7F, &utmp);
+		if (ret)
+			goto err;
+		if ((utmp&0xF) > 8)
+			lock = 1;
+		break;
 	case SYS_DVBT2:
 		/* FIXME: implement me */
 		utmp = 0x08; /* DVB-C lock value */
@@ -262,7 +269,7 @@ static int mn88472_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	if (utmp == 0x08)
+	if (lock)
 		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
 				FE_HAS_SYNC | FE_HAS_LOCK;
 
-- 
1.9.1

