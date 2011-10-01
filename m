Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62730 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1JANYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Oct 2011 09:24:24 -0400
Received: by wyg34 with SMTP id 34so1846664wyg.19
        for <linux-media@vger.kernel.org>; Sat, 01 Oct 2011 06:24:22 -0700 (PDT)
Message-ID: <4e871485.9a67e30a.0411.2265@mx.google.com>
Subject: [PATCH] [ver 1.07] it913x-fe changes to power up and down of tuner.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 01 Oct 2011 14:24:16 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the tuner is constantly powered causing these effects.
1. Remembering last tune channel causing corruptions of changing channel.
2. Causing corruption on other frontend.
3. Higher current in standby of demodulator with clock running.

Power sequence now follows;
Power Up
Tuner on -> Frontend suspend off -> Tuner clk on
Power Down
Frontend suspend on -> Tuner clk off -> Tuner off

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/it913x-fe-priv.h |   10 ++++++++-
 drivers/media/dvb/frontends/it913x-fe.c      |   27 ++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb/frontends/it913x-fe-priv.h
index 40e1d9b..1c6fb4b 100644
--- a/drivers/media/dvb/frontends/it913x-fe-priv.h
+++ b/drivers/media/dvb/frontends/it913x-fe-priv.h
@@ -312,7 +312,15 @@ static struct it913xset it9137_set[] = {
 	{PRO_LINK, GPIOH5_EN, {0x01}, 0x01},
 	{PRO_LINK, GPIOH5_ON, {0x01}, 0x01},
 	{PRO_LINK, GPIOH5_O, {0x00}, 0x01},
-	{PRO_LINK, GPIOH5_O, {0x01}, 0x01},/* ?, but enable */
+	{PRO_LINK, GPIOH5_O, {0x01}, 0x01},
+	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+};
+
+static struct it913xset it9137_tuner_off[] = {
+	{PRO_DMOD, 0xfba8, {0x01}, 0x01}, /* Tuner Clock Off  */
+	{PRO_DMOD, 0xec40, {0x00}, 0x01}, /* Power Down Tuner */
+	{PRO_DMOD, 0xec02, {0x3f, 0x1f, 0x3f, 0x3f}, 0x04},
+	{PRO_DMOD, 0xec3f, {0x01}, 0x01},
 	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
 };
 
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
index 02839a8b7..d4bd24e 100644
--- a/drivers/media/dvb/frontends/it913x-fe.c
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -626,7 +626,7 @@ static int it913x_fe_suspend(struct it913x_fe_state *state)
 	for (i = 0; i < 128; i++) {
 		ret = it913x_read_reg(state, SUSPEND_FLAG, &b, 1);
 		if (ret < 0)
-			return -EINVAL;
+			return -ENODEV;
 		if (b == 0)
 			break;
 
@@ -634,18 +634,23 @@ static int it913x_fe_suspend(struct it913x_fe_state *state)
 
 	ret |= it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x8);
 	/* Turn LED off */
-	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x0);
+	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x0);
 
-	return 0;
+	ret |= it913x_fe_script_loader(state, it9137_tuner_off);
+
+	return (ret < 0) ? -ENODEV : 0;
 }
 
+/* Power sequence */
+/* Power Up	Tuner on -> Frontend suspend off -> Tuner clk on */
+/* Power Down	Frontend suspend on -> Tuner clk off -> Tuner off */
+
 static int it913x_fe_sleep(struct dvb_frontend *fe)
 {
 	struct it913x_fe_state *state = fe->demodulator_priv;
 	return it913x_fe_suspend(state);
 }
 
-
 static u32 compute_div(u32 a, u32 b, u32 x)
 {
 	u32 res = 0;
@@ -738,11 +743,21 @@ static int it913x_fe_init(struct dvb_frontend *fe)
 {
 	struct it913x_fe_state *state = fe->demodulator_priv;
 	int ret = 0;
+	/* Power Up Tuner - common all versions */
+	ret = it913x_write_reg(state, PRO_DMOD, 0xec40, 0x1);
 
-	it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x0);
+	ret |= it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x0);
 
 	ret |= it913x_fe_script_loader(state, init_1);
 
+	switch (state->tuner_type) {
+	case IT9137:
+		ret |= it913x_write_reg(state, PRO_DMOD, 0xfba8, 0x0);
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return (ret < 0) ? -ENODEV : 0;
 }
 
@@ -820,5 +835,5 @@ static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
 
 MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
 MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
-MODULE_VERSION("1.06");
+MODULE_VERSION("1.07");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4


