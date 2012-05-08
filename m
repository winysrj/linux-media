Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51506 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2EHIZR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 04:25:17 -0400
Received: by bkcji2 with SMTP id ji2so4354434bkc.19
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 01:25:15 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: m88rs2000: LNB voltage control implemented
Date: Tue, 08 May 2012 11:25:24 +0300
Message-ID: <4246147.n44n5i5ILa@useri>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart13781395.88fiTAev5W"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart13781395.88fiTAev5W
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Trival patch to get it working with my cards stuff.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
--nextPart13781395.88fiTAev5W
Content-Disposition: inline; filename="rs2000volt.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="rs2000volt.patch"

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index 547230d..f6d6e39 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -416,9 +416,25 @@ static int m88rs2000_tab_set(struct m88rs2000_state *state,
 
 static int m88rs2000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
 {
-	deb_info("%s: %s\n", __func__,
-		volt == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" :
-		volt == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" : "??");
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	u8 data;
+
+	data = m88rs2000_demod_read(state, 0xb2);
+	data |= 0x03; /* bit0 V/H, bit1 off/on */
+
+	switch (volt) {
+	case SEC_VOLTAGE_18:
+		data &= ~0x03;
+		break;
+	case SEC_VOLTAGE_13:
+		data &= ~0x03;
+		data |= 0x01;
+		break;
+	case SEC_VOLTAGE_OFF:
+		break;
+	}
+
+	m88rs2000_demod_write(state, 0xb2, data);
 
 	return 0;
 }

--nextPart13781395.88fiTAev5W--

