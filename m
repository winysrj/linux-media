Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60749 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab3KBQdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:40 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Zoran Turalija <zoran.turalija@gmail.com>,
	=?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCHv2 15/29] stb0899_drv: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:23 -0200
Message-Id: <1383399097-11615-16-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/dvb-frontends/stb0899_drv.c:540:1: warning: 'stb0899_write_regs' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 80, it seem safe to use 80 as the hard limit for all
those devices. On most cases, the limit is a way lower than that, but
80 is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>
Cc: Zoran Turalija <zoran.turalija@gmail.com>
Cc: "Reinhard Nißl" <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_drv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 3dd5714eadba..9df77899b219 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -499,7 +499,7 @@ err:
 int stb0899_write_regs(struct stb0899_state *state, unsigned int reg, u8 *data, u32 count)
 {
 	int ret;
-	u8 buf[2 + count];
+	u8 buf[80];
 	struct i2c_msg i2c_msg = {
 		.addr	= state->config->demod_address,
 		.flags	= 0,
@@ -507,6 +507,13 @@ int stb0899_write_regs(struct stb0899_state *state, unsigned int reg, u8 *data,
 		.len	= 2 + count
 	};
 
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

