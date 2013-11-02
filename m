Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3KBQdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:42 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jiri Kosina <jkosina@suse.cz>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCHv2 16/29] stv0367: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:24 -0200
Message-Id: <1383399097-11615-17-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/dvb-frontends/stv0367.c:791:1: warning: 'stv0367_writeregs.constprop.4' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 80, it seem safe to use 80 as the hard limit for all
those devices. On most cases, the limit is a way lower than that, but
80 is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/dvb-frontends/stv0367.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 7b6dba3ce55e..28294b3be319 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -767,7 +767,7 @@ static struct st_register def0367cab[STV0367CAB_NBREGS] = {
 static
 int stv0367_writeregs(struct stv0367_state *state, u16 reg, u8 *data, int len)
 {
-	u8 buf[len + 2];
+	u8 buf[80];
 	struct i2c_msg msg = {
 		.addr = state->config->demod_address,
 		.flags = 0,
@@ -776,6 +776,14 @@ int stv0367_writeregs(struct stv0367_state *state, u16 reg, u8 *data, int len)
 	};
 	int ret;
 
+	if (2 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		       KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
+
 	buf[0] = MSB(reg);
 	buf[1] = LSB(reg);
 	memcpy(buf + 2, data, len);
-- 
1.8.3.1

