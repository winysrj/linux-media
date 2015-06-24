Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38408 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbbFXPLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 11:11:34 -0400
Received: by wibdq8 with SMTP id dq8so49719643wib.1
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 08:11:32 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 03/12] [media] stv0367: Refine i2c error trace to include i2c address
Date: Wed, 24 Jun 2015 16:11:01 +0100
Message-Id: <1435158670-7195-4-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using stv0367 demodulator with STi STB platforms,
we can have easily have four or more stv0367 demods running
in the system at one time.

As typically the b2120 reference design ships with a b2004a daughter
board, which can accept two dvb NIM cards, and each b2100A NIM
has 2x stv0367 demods and 2x NXPs tuner on it.

In such circumstances it is useful to print the i2c address
on error messages to know which one is failing due to I2C issues.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/dvb-frontends/stv0367.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index b31ff26..c3b7e6c 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -791,11 +791,13 @@ int stv0367_writeregs(struct stv0367_state *state, u16 reg, u8 *data, int len)
 	memcpy(buf + 2, data, len);
 
 	if (i2cdebug)
-		printk(KERN_DEBUG "%s: %02x: %02x\n", __func__, reg, buf[2]);
+		printk(KERN_DEBUG "%s: [%02x] %02x: %02x\n", __func__,
+			state->config->demod_address, reg, buf[2]);
 
 	ret = i2c_transfer(state->i2c, &msg, 1);
 	if (ret != 1)
-		printk(KERN_ERR "%s: i2c write error!\n", __func__);
+		printk(KERN_ERR "%s: i2c write error! ([%02x] %02x: %02x)\n",
+			__func__, state->config->demod_address, reg, buf[2]);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -829,10 +831,12 @@ static u8 stv0367_readreg(struct stv0367_state *state, u16 reg)
 
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2)
-		printk(KERN_ERR "%s: i2c read error\n", __func__);
+		printk(KERN_ERR "%s: i2c read error ([%02x] %02x: %02x)\n",
+			__func__, state->config->demod_address, reg, b1[0]);
 
 	if (i2cdebug)
-		printk(KERN_DEBUG "%s: %02x: %02x\n", __func__, reg, b1[0]);
+		printk(KERN_DEBUG "%s: [%02x] %02x: %02x\n", __func__,
+			state->config->demod_address, reg, b1[0]);
 
 	return b1[0];
 }
-- 
1.9.1

