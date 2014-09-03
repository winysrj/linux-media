Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbaICUd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:28 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/46] [media] af9013: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:43 -0300
Message-Id: <79024650ad541cb15910fad5cda3bc4ff0b16ade.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index ecf6388d2200..8001690d7576 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -683,7 +683,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 
 	switch (c->transmission_mode) {
 	case TRANSMISSION_MODE_AUTO:
-		auto_mode = 1;
+		auto_mode = true;
 		break;
 	case TRANSMISSION_MODE_2K:
 		break;
@@ -693,12 +693,12 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	default:
 		dev_dbg(&state->i2c->dev, "%s: invalid transmission_mode\n",
 				__func__);
-		auto_mode = 1;
+		auto_mode = true;
 	}
 
 	switch (c->guard_interval) {
 	case GUARD_INTERVAL_AUTO:
-		auto_mode = 1;
+		auto_mode = true;
 		break;
 	case GUARD_INTERVAL_1_32:
 		break;
@@ -714,12 +714,12 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	default:
 		dev_dbg(&state->i2c->dev, "%s: invalid guard_interval\n",
 				__func__);
-		auto_mode = 1;
+		auto_mode = true;
 	}
 
 	switch (c->hierarchy) {
 	case HIERARCHY_AUTO:
-		auto_mode = 1;
+		auto_mode = true;
 		break;
 	case HIERARCHY_NONE:
 		break;
@@ -734,12 +734,12 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		break;
 	default:
 		dev_dbg(&state->i2c->dev, "%s: invalid hierarchy\n", __func__);
-		auto_mode = 1;
+		auto_mode = true;
 	}
 
 	switch (c->modulation) {
 	case QAM_AUTO:
-		auto_mode = 1;
+		auto_mode = true;
 		break;
 	case QPSK:
 		break;
@@ -751,7 +751,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 		break;
 	default:
 		dev_dbg(&state->i2c->dev, "%s: invalid modulation\n", __func__);
-		auto_mode = 1;
+		auto_mode = true;
 	}
 
 	/* Use HP. How and which case we can switch to LP? */
@@ -759,7 +759,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 
 	switch (c->code_rate_HP) {
 	case FEC_AUTO:
-		auto_mode = 1;
+		auto_mode = true;
 		break;
 	case FEC_1_2:
 		break;
@@ -778,12 +778,12 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	default:
 		dev_dbg(&state->i2c->dev, "%s: invalid code_rate_HP\n",
 				__func__);
-		auto_mode = 1;
+		auto_mode = true;
 	}
 
 	switch (c->code_rate_LP) {
 	case FEC_AUTO:
-		auto_mode = 1;
+		auto_mode = true;
 		break;
 	case FEC_1_2:
 		break;
@@ -804,7 +804,7 @@ static int af9013_set_frontend(struct dvb_frontend *fe)
 	default:
 		dev_dbg(&state->i2c->dev, "%s: invalid code_rate_LP\n",
 				__func__);
-		auto_mode = 1;
+		auto_mode = true;
 	}
 
 	switch (c->bandwidth_hz) {
-- 
1.9.3

