Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49458 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaCCKIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:06 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 63/79] [media] drx-j: remove some unused data
Date: Mon,  3 Mar 2014 07:06:57 -0300
Message-Id: <1393841233-24840-64-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those struct data aren't used anymore. Get rid of them.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h | 2 --
 drivers/media/dvb-frontends/drx39xyj/drxj.c     | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index b9f642e5d98b..2e0c50f0a12a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -29,9 +29,7 @@
 struct drx39xxj_state {
 	struct i2c_adapter *i2c;
 	struct drx_demod_instance *demod;
-	enum drx_standard current_standard;
 	struct dvb_frontend frontend;
-	unsigned int powered_up:1;
 	unsigned int i2c_gate_open:1;
 	const struct firmware *fw;
 };
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index c843d8f4a96a..6fe65f4bd912 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -20015,7 +20015,6 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 		return 0;
 	}
 
-	state->powered_up = enable;
 	return 0;
 }
 
@@ -20222,8 +20221,6 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 			result);
 		return -EINVAL;
 	}
-	state->powered_up = 1;
-	state->current_standard = standard;
 
 	/* set channel parameters */
 	channel = def_channel;
-- 
1.8.5.3

