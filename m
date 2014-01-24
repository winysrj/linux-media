Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:57436 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaAXUy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 15:54:26 -0500
Received: by mail-we0-f181.google.com with SMTP id u56so3090927wes.26
        for <linux-media@vger.kernel.org>; Fri, 24 Jan 2014 12:54:25 -0800 (PST)
Message-ID: <1390596853.3346.38.camel@canaries32-MCP7A>
Subject: [PATCH TEST] ts2020.c : correct divider settings
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Joakim Hernberg <jbh@alchemy.lu>
Cc: linux-media@vger.kernel.org
Date: Fri, 24 Jan 2014 20:54:13 +0000
In-Reply-To: <20140124164309.778dcfbd@tor.valhalla.alchemy.lu>
References: <20140122200408.3d0fc1cf@tor.valhalla.alchemy.lu>
	 <20140124164309.778dcfbd@tor.valhalla.alchemy.lu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2014-01-24 at 16:43 +0100, Joakim Hernberg wrote:
> On Wed, 22 Jan 2014 20:04:08 +0100
> Joakim Hernberg <jbh@alchemy.lu> wrote:
> 
> > I recently discovered a regression in the S471 driver.  When trying to
> > tune to 10818V on Astra 28E2, the system would tune to 11343V instead.
> > After browsing the code it appears that a divider was changed when the
> > tuning code was moved from ds3000.c to ts2020.c.
Use 10818V daily BBC News no problems. I also use 11353v
 
>     
> 
> I decided to test this a bit more thoroughly.  I scanned 28E2 with
> w_scan, compared the listings for 28E2 on King Of Sat with the
> resulting channels.conf, and came up with the following anomalies. I've
> also verified the non/existence of the transponders with my VU+ STB.
> 
> Some anomalies are common to all tests:
> No channels found on 11307H (11307V is OK)
> No channels found on 11344H (11344V is OK)
> No channels found on 11390V (11389H is OK)
> Finds 2 channels on 11097V that aren't in KOS nor found on the STB
> Transponder on 12000H duplicate of 11992H
> 
> 
> With linux v3.8.1 (old tuning code in ds3000.c):
> 
> No channels found on 11224V (11222H is OK)
> 
> 
> With linux v3.13.0 (new tuning code in ts2020.c):
> 
> Shows the channels from 11344V as found on 10818V
> No channels found on 11224V (11222H is OK)
> 
> Transponder on 12560H duplicate of 12545H
> Transponder on 12607H duplicate of 12603H
> Transponder on 12643H duplicate of 12633H
> 
> With linux 3.13.0 (+ my proposed patch):
> 
> Shows the channels from 11222H as found on 11224V
> No channels found on 11224V
Yes I can tune this channel using current ts2020 kernel code.

> 
> Transponder on 12524V duplicate of 12522V
> Transponder on 12560H duplicate of 12545H
> Transponder on 12607H duplicate of 12603H
> Transponder on 12643H duplicate of 12633H
> 
Problems here could be the carrier offset or error occurred during tuning.

The carrier offset can be as much as +/- 30 MHz and accidentally slip onto
the next channel carrier.

The ds3000 does not return carrier offset adjusted frequency.

> 
> Unless some one can directly spot what is wrong in the ts2020.c code, I
> guess the next step will be to sprinkle printk statements in the tuning
> code and try to tune to the problematic channels.  Then try to see if I
> can figure out how the code that programs the pll oscilliator functions
> and if I can come up with better dividers for it.
I am using the ts2020 with the m88r2000. It think the problem is in ds3000.

Here is alternative ndiv code, it is based on vendors code.

It uses the ndiv value not frequency to change the divider.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb-frontends/ts2020.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 9aba044..9e051efb 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -186,22 +186,27 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	struct ts2020_priv *priv = fe->tuner_priv;
 	int ret;
 	u32 frequency = c->frequency;
-	s32 offset_khz;
+	u32 offset_khz, ndiv_mul;
 	u32 symbol_rate = (c->symbol_rate / 1000);
 	u32 f3db, gdiv28;
 	u16 value, ndiv, lpf_coeff;
 	u8 lpf_mxdiv, mlpf_max, mlpf_min, nlpf;
 	u8 lo = 0x01, div4 = 0x0;
 
+	ndiv = (u16)((frequency * 14 * 2 + TS2020_XTAL_FREQ / 2)
+			/ TS2020_XTAL_FREQ);
+
 	/* Calculate frequency divider */
-	if (frequency < priv->frequency_div) {
+	if (ndiv < 1100) {
 		lo |= 0x10;
 		div4 = 0x1;
-		ndiv = (frequency * 14 * 4) / TS2020_XTAL_FREQ;
-	} else
-		ndiv = (frequency * 14 * 2) / TS2020_XTAL_FREQ;
-	ndiv = ndiv + ndiv % 2;
-	ndiv = ndiv - 1024;
+		ndiv = (u16)((frequency * 14 * 4 + TS2020_XTAL_FREQ / 2)
+					/ TS2020_XTAL_FREQ) - 1024;
+		ndiv_mul = ndiv + 1024;
+	} else {
+		ndiv -= 1024;
+		ndiv_mul = ndiv - ndiv % 2 + 1024;
+	}
 
 	ret = ts2020_writereg(fe, 0x10, 0x80 | lo);
 
@@ -272,9 +277,8 @@ static int ts2020_set_params(struct dvb_frontend *fe)
 	ret |= ts2020_tuner_gate_ctrl(fe, 0x01);
 
 	msleep(80);
-	/* calculate offset assuming 96000kHz*/
-	offset_khz = (ndiv - ndiv % 2 + 1024) * TS2020_XTAL_FREQ
-		/ (6 + 8) / (div4 + 1) / 2;
+
+	offset_khz = ndiv_mul * TS2020_XTAL_FREQ / 14 / (div4 + 1) / 2;
 
 	priv->frequency = offset_khz;
 
-- 
1.8.5.3

