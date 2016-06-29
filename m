Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43489 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbcF2Wng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 18:43:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	"David S. Miller" <davem@davemloft.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jiri Kosina <jkosina@suse.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 06/10] au8522: show signal strength in dBm, for devices with xc5000
Date: Wed, 29 Jun 2016 19:43:22 -0300
Message-Id: <6ec9fface21b8b5ddab4bce9ef237b69a84316e2.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
In-Reply-To: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devices with xc5000 provide the signal strength value in dBm.
So, provide it with the proper scale to userspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/au8522_dig.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/au8522_dig.c b/drivers/media/dvb-frontends/au8522_dig.c
index 22d837494cc7..518040228064 100644
--- a/drivers/media/dvb-frontends/au8522_dig.c
+++ b/drivers/media/dvb-frontends/au8522_dig.c
@@ -744,6 +744,15 @@ static void au8522_get_stats(struct dvb_frontend *fe, enum fe_status status)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 		if (ret < 0)
 			state->strength = 0;
+
+		/*
+		 * FIXME: As this frontend is used only with au0828, and,
+		 * currently, the tuner is eiter xc5000 or tda18271, and
+		 * only the first implements get_rf_strength(), we'll assume
+		 * that the strength will be returned in dB.
+		 */
+		c->strength.stat[0].svalue = 35000 - 1000 * (65535 - state->strength) / 256;
+		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
 	} else {
 		u32 tmp;
 		/*
@@ -769,9 +778,9 @@ static void au8522_get_stats(struct dvb_frontend *fe, enum fe_status status)
 			state->strength = 0xffff;
 		else
 			state->strength = tmp / 8960;
+		c->strength.stat[0].uvalue = state->strength;
+		c->strength.stat[0].scale = FE_SCALE_RELATIVE;
 	}
-	c->strength.stat[0].scale = FE_SCALE_RELATIVE;
-	c->strength.stat[0].uvalue = state->strength;
 
 	/* Read UCB blocks */
 	if (!(status & FE_HAS_LOCK)) {
-- 
2.7.4

