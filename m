Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.mail.tnz.yahoo.co.jp ([203.216.246.68]:35617 "HELO
	smtp05.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750885AbZKLHCN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 02:02:13 -0500
Message-ID: <4AFBB2F8.2070904@yahoo.co.jp>
Date: Thu, 12 Nov 2009 16:02:16 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] dvb-usb-friio: accept center-shifted frequency
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd2@yahoo.co.jp>

This patch adds a fix to accept frequency with its center shifted.

The driver used to accept center frequencies of the normal UHF band channels,
but in ISDB-T, center frequency is shifted with 1/7MHz.
It was shifted internally in the driver,
but this patch enables to accept both types of frequency.

Priority: normal

Signed-off-by: Akihiro Tsukada <tskd2@yahoo.co.jp>
---
 friio-fe.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/linux/drivers/media/dvb/dvb-usb/friio-fe.c b/linux/drivers/media/dvb/dvb-usb/friio-fe.c
--- a/linux/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/linux/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -134,11 +134,13 @@ static int jdvbt90502_pll_set_freq(struc
 	deb_fe("%s: freq=%d, step=%d\n", __func__, freq,
 	       state->frontend.ops.info.frequency_stepsize);
 	/* freq -> oscilator frequency conversion. */
-	/* freq: 473,000,000 + n*6,000,000 (no 1/7MHz shift to center freq) */
-	/* add 400[1/7 MHZ] = 57.142857MHz.   57MHz for the IF,  */
-	/*                                   1/7MHz for center freq shift */
+	/* freq: 473,000,000 + n*6,000,000 [+ 142857 (center freq. shift)] */
 	f = freq / state->frontend.ops.info.frequency_stepsize;
-	f += 400;
+	/* add 399[1/7 MHZ] = 57MHz for the IF  */
+	f += 399;
+	/* add center frequency shift if necessary */
+	if (f % 7 == 0)
+		f++;
 	pll_freq_cmd[DEMOD_REDIRECT_REG] = JDVBT90502_2ND_I2C_REG; /* 0xFE */
 	pll_freq_cmd[ADDRESS_BYTE] = state->config.pll_address << 1;
 	pll_freq_cmd[DIVIDER_BYTE1] = (f >> 8) & 0x7F;

--------------------------------------
GyaO! - Anime, Dramas, Movies, and Music videos [FREE]
http://pr.mail.yahoo.co.jp/gyao/
