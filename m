Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61807 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375Ab2CNUbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 16:31:36 -0400
Received: by wejx9 with SMTP id x9so2129641wej.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 13:31:35 -0700 (PDT)
Message-ID: <1331757086.5029.2.camel@tvbox>
Subject: [PATCH] m88rs2000 ver 1.13 Correct deseqc and tuner gain functions
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 14 Mar 2012 20:31:26 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove incorrect SEC_MINI_B settings-TODO complete this section.

Correct break and remove return -EINVAL within set tone. It appears
there is a bug that occasionally something other than ON/OFF is
sent stalling the driver. Just continue and write back registers.

Set register b2 in setup. This is the set voltage pin which
isn't used in lmedm04 driver but it is always set to 0x1.

Correct the if statements in set_tuner_rf.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/m88rs2000.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index c9a3435..a8573db 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -228,8 +228,7 @@ static int m88rs2000_send_diseqc_burst(struct dvb_frontend *fe,
 	msleep(50);
 	reg0 = m88rs2000_demod_read(state, 0xb1);
 	reg1 = m88rs2000_demod_read(state, 0xb2);
-	if (burst == SEC_MINI_B)
-		reg1 |= 0x1;
+	/* TODO complete this section */
 	m88rs2000_demod_write(state, 0xb2, reg1);
 	m88rs2000_demod_write(state, 0xb1, reg0);
 	m88rs2000_demod_write(state, 0x9a, 0xb0);
@@ -251,13 +250,12 @@ static int m88rs2000_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
 	case SEC_TONE_ON:
 		reg0 |= 0x4;
 		reg0 &= 0xbc;
-	break;
+		break;
 	case SEC_TONE_OFF:
 		reg1 |= 0x80;
-	break;
-
+		break;
 	default:
-		return -EINVAL;
+		break;
 	}
 	m88rs2000_demod_write(state, 0xb2, reg1);
 	m88rs2000_demod_write(state, 0xb1, reg0);
@@ -292,6 +290,7 @@ struct inittab m88rs2000_setup[] = {
 	{DEMOD_WRITE, 0xf0, 0x22},
 	{DEMOD_WRITE, 0xf1, 0xbf},
 	{DEMOD_WRITE, 0xb0, 0x45},
+	{DEMOD_WRITE, 0xb2, 0x01}, /* set voltage pin always set 1*/
 	{DEMOD_WRITE, 0x9a, 0xb0},
 	{0xff, 0xaa, 0xff}
 };
@@ -520,9 +519,9 @@ static int m88rs2000_set_tuner_rf(struct dvb_frontend *fe)
 	int reg;
 	reg = m88rs2000_tuner_read(state, 0x3d);
 	reg &= 0x7f;
-	if (reg < 0x17)
+	if (reg < 0x16)
 		reg = 0xa1;
-	else if (reg < 0x16)
+	else if (reg == 0x16)
 		reg = 0x99;
 	else
 		reg = 0xf9;
@@ -902,5 +901,5 @@ EXPORT_SYMBOL(m88rs2000_attach);
 MODULE_DESCRIPTION("M88RS2000 DVB-S Demodulator driver");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("1.12");
+MODULE_VERSION("1.13");
 
-- 
1.7.9.1




