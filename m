Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39713 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752286AbcJKKfO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>
Subject: [PATCH v2 12/31] dtt200u-fe: don't keep waiting for lock at set_frontend()
Date: Tue, 11 Oct 2016 07:09:27 -0300
Message-Id: <e1289c9f18fe374be092c74ae0cc96966219bff8.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is up to the frontend kthread to wait for lock.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dtt200u-fe.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dtt200u-fe.c b/drivers/media/usb/dvb-usb/dtt200u-fe.c
index c09332bd99cb..9bb15f7b48db 100644
--- a/drivers/media/usb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/usb/dvb-usb/dtt200u-fe.c
@@ -105,8 +105,6 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	int i;
-	enum fe_status st;
 	u16 freq = fep->frequency / 250000;
 	u8 bwbuf[2] = { SET_BANDWIDTH, 0 },freqbuf[3] = { SET_RF_FREQ, 0, 0 };
 
@@ -130,13 +128,6 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend *fe)
 	freqbuf[2] = (freq >> 8) & 0xff;
 	dvb_usb_generic_write(state->d,freqbuf,3);
 
-	for (i = 0; i < 30; i++) {
-		msleep(20);
-		dtt200u_fe_read_status(fe, &st);
-		if (st & FE_TIMEDOUT)
-			continue;
-	}
-
 	return 0;
 }
 
-- 
2.7.4


