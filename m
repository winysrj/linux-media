Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35855 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbFXKwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:52:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2] [media] lmedm04: fix the range for relative measurements
Date: Wed, 24 Jun 2015 07:52:01 -0300
Message-Id: <620275d149c129d3464cb73dd00b17e54128340c.1435143112.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Relative measurements are typically between 0 and 0xffff. However,
for some tuners (TUNER_S7395 and TUNER_S0194), the range were from
0 to 0xff00, with means that 100% is never archived.
Also, TUNER_RS2000 uses a more complex math.

So, create a macro that does the conversion using bit operations
and use it for all conversions.

The code is also easier to read with is a bonus.

While here, remove a bogus comment.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index fcef2a33ef3d..4cc55b3a0558 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -257,6 +257,9 @@ static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
 	return ret;
 }
 
+/* Convert range from 0x00-0xff to 0x0000-0xffff */
+#define reg_to_16bits(x)	((x) | ((x) << 8))
+
 static void lme2510_update_stats(struct dvb_usb_adapter *adap)
 {
 	struct lme2510_state *st = adap_to_priv(adap);
@@ -288,23 +291,17 @@ static void lme2510_update_stats(struct dvb_usb_adapter *adap)
 
 	switch (st->tuner_config) {
 	case TUNER_LG:
-		s_tmp = 0xff - st->signal_level;
-		s_tmp |= s_tmp << 8;
-
-		c_tmp = 0xff - st->signal_sn;
-		c_tmp |= c_tmp << 8;
+		s_tmp = reg_to_16bits(0xff - st->signal_level);
+		c_tmp = reg_to_16bits(0xff - st->signal_sn);
 		break;
-	/* fall through */
 	case TUNER_S7395:
 	case TUNER_S0194:
 		s_tmp = 0xffff - (((st->signal_level * 2) << 8) * 5 / 4);
-
-		c_tmp = ((0xff - st->signal_sn - 0xa1) * 3) << 8;
+		c_tmp = reg_to_16bits((0xff - st->signal_sn - 0xa1) * 3);
 		break;
 	case TUNER_RS2000:
-		s_tmp = st->signal_level * 0xffff / 0xff;
-
-		c_tmp = st->signal_sn * 0xffff / 0x7f;
+		s_tmp = reg_to_16bits(st->signal_level);
+		c_tmp = reg_to_16bits(st->signal_sn);
 	}
 
 	c->strength.len = 1;
-- 
2.4.3

