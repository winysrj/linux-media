Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60753 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3KBQdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:42 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <pb@linuxtv.org>
Subject: [PATCHv2 12/29] s5h1420: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:20 -0200
Message-Id: <1383399097-11615-13-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/dvb-frontends/s5h1420.c:851:1: warning: 's5h1420_tuner_i2c_tuner_xfer' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer.

In the specific case of this frontend, only ttpci uses it. The maximum
number of messages there is two, on I2C read operations. As the logic
can add an extra operation, change the size to 3.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Patrick Boettcher <pb@linuxtv.org>
---
 drivers/media/dvb-frontends/s5h1420.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index e2fec9ebf947..e0b0366ccfa5 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -836,9 +836,16 @@ static u32 s5h1420_tuner_i2c_func(struct i2c_adapter *adapter)
 static int s5h1420_tuner_i2c_tuner_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msg[], int num)
 {
 	struct s5h1420_state *state = i2c_get_adapdata(i2c_adap);
-	struct i2c_msg m[1 + num];
+	struct i2c_msg m[3];
 	u8 tx_open[2] = { CON_1, state->CON_1_val | 1 }; /* repeater stops once there was a stop condition */
 
+	if (1 + num > ARRAY_SIZE(m)) {
+		printk(KERN_WARNING
+		       "%s: i2c xfer: num=%d is too big!\n",
+		       KBUILD_MODNAME, num);
+		return  -EREMOTEIO;
+	}
+
 	memset(m, 0, sizeof(struct i2c_msg) * (1 + num));
 
 	m[0].addr = state->config->demod_address;
-- 
1.8.3.1

