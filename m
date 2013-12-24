Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39578 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3LXQSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 11:18:53 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq4so11621076wib.3
        for <linux-media@vger.kernel.org>; Tue, 24 Dec 2013 08:18:52 -0800 (PST)
Received: from [192.168.1.100] (94.196.117.167.threembb.co.uk. [94.196.117.167])
        by mx.google.com with ESMTPSA id at5sm24025359wic.1.2013.12.24.08.18.51
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 24 Dec 2013 08:18:51 -0800 (PST)
Message-ID: <1387901926.24033.41.camel@canaries32-MCP7A>
Subject: [PATCH 2/2] m88rs2000: set symbol rate accurately.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 24 Dec 2013 16:18:46 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current setting of symbol rate is not very actuate causing
loss of lock.

Covert temp to u64 and use mclk to calculate from big number.

Calculate symbol rate by dividing symbol rate by 1000 times
1 << 24 and dividing sum by mclk.

Add other symbol rate settings to function registers 0xa0-0xa3.

In set_frontend add changes to register 0xf1 this must be done
prior call to fe_reset. Register 0x00 doesn't need a second
write of 0x1

Applied after patch
m88rs2000: add m88rs2000_set_carrieroffset

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # v3.9+
---
 drivers/media/dvb-frontends/m88rs2000.c | 42 ++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 8091653..02699c1 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -160,24 +160,44 @@ static int m88rs2000_set_symbolrate(struct dvb_frontend *fe, u32 srate)
 {
 	struct m88rs2000_state *state = fe->demodulator_priv;
 	int ret;
-	u32 temp;
+	u64 temp;
+	u32 mclk;
 	u8 b[3];
 
 	if ((srate < 1000000) || (srate > 45000000))
 		return -EINVAL;
 
+	mclk = m88rs2000_get_mclk(fe);
+	if (!mclk)
+		return -EINVAL;
+
 	temp = srate / 1000;
-	temp *= 11831;
-	temp /= 68;
-	temp -= 3;
+	temp *= 1 << 24;
+
+	do_div(temp, mclk);
 
 	b[0] = (u8) (temp >> 16) & 0xff;
 	b[1] = (u8) (temp >> 8) & 0xff;
 	b[2] = (u8) temp & 0xff;
+
 	ret = m88rs2000_writereg(state, 0x93, b[2]);
 	ret |= m88rs2000_writereg(state, 0x94, b[1]);
 	ret |= m88rs2000_writereg(state, 0x95, b[0]);
 
+	if (srate > 10000000)
+		ret |= m88rs2000_writereg(state, 0xa0, 0x20);
+	else
+		ret |= m88rs2000_writereg(state, 0xa0, 0x60);
+
+	ret |= m88rs2000_writereg(state, 0xa1, 0xe0);
+
+	if (srate > 12000000)
+		ret |= m88rs2000_writereg(state, 0xa3, 0x20);
+	else if (srate > 2800000)
+		ret |= m88rs2000_writereg(state, 0xa3, 0x98);
+	else
+		ret |= m88rs2000_writereg(state, 0xa3, 0x90);
+
 	deb_info("m88rs2000: m88rs2000_set_symbolrate\n");
 	return ret;
 }
@@ -307,8 +327,6 @@ struct inittab m88rs2000_shutdown[] = {
 
 struct inittab fe_reset[] = {
 	{DEMOD_WRITE, 0x00, 0x01},
-	{DEMOD_WRITE, 0xf1, 0xbf},
-	{DEMOD_WRITE, 0x00, 0x01},
 	{DEMOD_WRITE, 0x20, 0x81},
 	{DEMOD_WRITE, 0x21, 0x80},
 	{DEMOD_WRITE, 0x10, 0x33},
@@ -351,9 +369,6 @@ struct inittab fe_trigger[] = {
 	{DEMOD_WRITE, 0x9b, 0x64},
 	{DEMOD_WRITE, 0x9e, 0x00},
 	{DEMOD_WRITE, 0x9f, 0xf8},
-	{DEMOD_WRITE, 0xa0, 0x20},
-	{DEMOD_WRITE, 0xa1, 0xe0},
-	{DEMOD_WRITE, 0xa3, 0x38},
 	{DEMOD_WRITE, 0x98, 0xff},
 	{DEMOD_WRITE, 0xc0, 0x0f},
 	{DEMOD_WRITE, 0x89, 0x01},
@@ -625,8 +640,13 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return -ENODEV;
 
-	/* Reset Demod */
-	ret = m88rs2000_tab_set(state, fe_reset);
+	/* Reset demod by symbol rate */
+	if (c->symbol_rate > 27500000)
+		ret = m88rs2000_writereg(state, 0xf1, 0xa4);
+	else
+		ret = m88rs2000_writereg(state, 0xf1, 0xbf);
+
+	ret |= m88rs2000_tab_set(state, fe_reset);
 	if (ret < 0)
 		return -ENODEV;
 
-- 
1.8.5.2

