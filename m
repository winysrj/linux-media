Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab3KBQdp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:45 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Manu Abraham <manu@linuxtv.org>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andreas Regel <andreas.regel@gmx.de>
Subject: [PATCHv2 17/29] stv090x: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:25 -0200
Message-Id: <1383399097-11615-18-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

       drivers/media/dvb-frontends/stv090x.c:750:1: warning: 'stv090x_write_regs.constprop.6' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 80, it seem safe to use 80 as the hard limit for all
those devices. On most cases, the limit is a way lower than that, but
80 is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Manu Abraham <manu@linuxtv.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Andreas Regel <andreas.regel@gmx.de>
---
 drivers/media/dvb-frontends/stv090x.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 56d470ad5a82..7484b01a9f13 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -722,9 +722,16 @@ static int stv090x_write_regs(struct stv090x_state *state, unsigned int reg, u8
 {
 	const struct stv090x_config *config = state->config;
 	int ret;
-	u8 buf[2 + count];
+	u8 buf[80];
 	struct i2c_msg i2c_msg = { .addr = config->address, .flags = 0, .buf = buf, .len = 2 + count };
 
+	if (2 + count > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		       KBUILD_MODNAME, reg, count);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = reg >> 8;
 	buf[1] = reg & 0xff;
 	memcpy(&buf[2], data, count);
-- 
1.8.3.1

