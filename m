Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61563 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1K0WOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Nov 2011 17:14:16 -0500
Received: by wwp14 with SMTP id 14so7707555wwp.1
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2011 14:14:14 -0800 (PST)
Message-ID: <1322432045.29202.2.camel@tvbox>
Subject: [PATCH] for 3_3 it913x-fe more user and debugging info.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 27 Nov 2011 22:14:05 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More debugging and user info from it913x-fe.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/it913x-fe.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 07c1b46..e0cf881 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -46,6 +46,8 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able)).");
 	  dprintk(level, name" (%02x%02x%02x%02x%02x%02x%02x%02x)", \
 		*p, *(p+1), *(p+2), *(p+3), *(p+4), \
 			*(p+5), *(p+6), *(p+7));
+#define info(format, arg...) \
+	printk(KERN_INFO "it913x-fe: " format "\n" , ## arg)
 
 struct it913x_fe_state {
 	struct dvb_frontend frontend;
@@ -739,6 +741,8 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	if (state->config->chip_ver == 1)
 		ret = it913x_init_tuner(state);
 
+	info("ADF table value	:%02x", adf);
+
 	if (adf < 10) {
 		state->crystalFrequency = fe_clockTable[adf].xtal ;
 		state->table = fe_clockTable[adf].table;
@@ -750,9 +754,6 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	} else
 		return -EINVAL;
 
-	deb_info("Xtal Freq :%d Adc Freq :%d Adc %08x Xtal %08x",
-		state->crystalFrequency, state->adcFrequency, adc, xtal);
-
 	/* Set LED indicator on GPIOH3 */
 	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_EN, 0x1);
 	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_ON, 0x1);
@@ -772,6 +773,11 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	b[1] = (adc >> 8) & 0xff;
 	b[2] = (adc >> 16) & 0xff;
 	ret |= it913x_write(state, PRO_DMOD, ADC_FREQ, b, 3);
+
+	info("Crystal Frequency :%d Adc Frequency :%d",
+		state->crystalFrequency, state->adcFrequency);
+	deb_info("Xtal value :%04x Adc value :%04x", xtal, adc);
+
 	if (ret < 0)
 		return -ENODEV;
 
@@ -804,6 +810,8 @@ static int it913x_fe_start(struct it913x_fe_state *state)
 	default:
 		set_lna = it9135_38;
 	}
+	info("Tuner LNA type :%02x", state->tuner_type);
+
 	ret = it913x_fe_script_loader(state, set_lna);
 	if (ret < 0)
 		return ret;
-- 
1.7.7.1


