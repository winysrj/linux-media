Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaIXW17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Antti Palosaari <crope@iki.fi>,
	Christoph Jaeger <christophjaeger@linux.com>,
	Dave Jones <davej@redhat.com>
Subject: [PATCH 11/18] [media] drxd: remove a dead code
Date: Wed, 24 Sep 2014 19:27:11 -0300
Message-Id: <72d5c25b8175ac7655c165339ad2d2880419dec7.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drxd_hard.c:2839 drxd_init() info: ignoring unreachable code.

Firmware request/release is not at drxd_init. So, we can remove
that dead code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 961641b67728..687e893d29fe 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2831,14 +2831,8 @@ static int drxd_read_status(struct dvb_frontend *fe, fe_status_t * status)
 static int drxd_init(struct dvb_frontend *fe)
 {
 	struct drxd_state *state = fe->demodulator_priv;
-	int err = 0;
 
-/*	if (request_firmware(&state->fw, "drxd.fw", state->dev)<0) */
 	return DRXD_init(state, NULL, 0);
-
-	err = DRXD_init(state, state->fw->data, state->fw->size);
-	release_firmware(state->fw);
-	return err;
 }
 
 static int drxd_config_i2c(struct dvb_frontend *fe, int onoff)
-- 
1.9.3

