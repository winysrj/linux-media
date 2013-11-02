Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3KBQdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:38 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 13/29] dvb-frontends: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:21 -0200
Message-Id: <1383399097-11615-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/dvb-frontends/bcm3510.c:230:1: warning: 'bcm3510_do_hab_cmd' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/itd1000.c:69:1: warning: 'itd1000_write_regs.constprop.0' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/mt312.c:126:1: warning: 'mt312_write' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/nxt200x.c:111:1: warning: 'nxt200x_writebytes' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/stb6100.c:216:1: warning: 'stb6100_write_reg_range.constprop.3' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/stv6110.c:98:1: warning: 'stv6110_write_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/stv6110x.c:85:1: warning: 'stv6110x_write_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/tda18271c2dd.c:147:1: warning: 'WriteRegs' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/zl10039.c:119:1: warning: 'zl10039_write' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 80, it seem safe to use 80 as the hard limit for all
those devices. On most cases, the limit is a way lower than that, but
80 is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/bcm3510.c      | 12 +++++++++++-
 drivers/media/dvb-frontends/itd1000.c      | 10 +++++++++-
 drivers/media/dvb-frontends/mt312.c        |  8 +++++++-
 drivers/media/dvb-frontends/nxt200x.c      |  8 +++++++-
 drivers/media/dvb-frontends/stb6100.c      |  9 ++++++++-
 drivers/media/dvb-frontends/stv6110.c      |  9 ++++++++-
 drivers/media/dvb-frontends/stv6110x.c     |  9 ++++++++-
 drivers/media/dvb-frontends/tda18271c2dd.c | 11 +++++++++--
 drivers/media/dvb-frontends/zl10039.c      |  9 ++++++++-
 9 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 1b77909c0c71..efd8ce671caf 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -201,9 +201,19 @@ static int bcm3510_hab_send_request(struct bcm3510_state *st, u8 *buf, int len)
 
 static int bcm3510_do_hab_cmd(struct bcm3510_state *st, u8 cmd, u8 msgid, u8 *obuf, u8 olen, u8 *ibuf, u8 ilen)
 {
-	u8 ob[olen+2],ib[ilen+2];
+	u8 ob[128], ib[128];
 	int ret = 0;
 
+	if (ilen + 2 > sizeof(ib)) {
+		deb_hab("do_hab_cmd: ilen=%d is too big!\n", ilen);
+		return -EREMOTEIO;
+	}
+
+	if (olen + 2 > sizeof(ob)) {
+		deb_hab("do_hab_cmd: olen=%d is too big!\n", olen);
+		return -EREMOTEIO;
+	}
+
 	ob[0] = cmd;
 	ob[1] = msgid;
 	memcpy(&ob[2],obuf,olen);
diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
index c1c3400b2173..1a8e9f83a002 100644
--- a/drivers/media/dvb-frontends/itd1000.c
+++ b/drivers/media/dvb-frontends/itd1000.c
@@ -52,10 +52,18 @@ MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
 /* don't write more than one byte with flexcop behind */
 static int itd1000_write_regs(struct itd1000_state *state, u8 reg, u8 v[], u8 len)
 {
-	u8 buf[1+len];
+	u8 buf[80];
 	struct i2c_msg msg = {
 		.addr = state->cfg->i2c_address, .flags = 0, .buf = buf, .len = len+1
 	};
+
+	if (1 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "itd1000: i2c wr reg=%04x: len=%d is too big!\n",
+		       reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], v, len);
 
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index ec388c1d6913..fee0e7938f48 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -96,9 +96,15 @@ static int mt312_write(struct mt312_state *state, const enum mt312_reg_addr reg,
 		       const u8 *src, const size_t count)
 {
 	int ret;
-	u8 buf[count + 1];
+	u8 buf[80];
 	struct i2c_msg msg;
 
+	if (1 + count > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "mt312: write: len=%zd is too big!\n", count);
+		return -EREMOTEIO;
+	}
+
 	if (debug) {
 		int i;
 		dprintk("W(%d):", reg & 0x7f);
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 8e288940a61f..335b35ce60c8 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -95,10 +95,16 @@ static int i2c_readbytes(struct nxt200x_state *state, u8 addr, u8 *buf, u8 len)
 static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg,
 			       const u8 *buf, u8 len)
 {
-	u8 buf2 [len+1];
+	u8 buf2[80];
 	int err;
 	struct i2c_msg msg = { .addr = state->config->demod_address, .flags = 0, .buf = buf2, .len = len + 1 };
 
+	if (1 + len > sizeof(buf2)) {
+		pr_warn("%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 __func__, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf2[0] = reg;
 	memcpy(&buf2[1], buf, len);
 
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index 45f9523f968f..5623af5fcdd4 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -183,7 +183,7 @@ static int stb6100_read_reg(struct stb6100_state *state, u8 reg)
 static int stb6100_write_reg_range(struct stb6100_state *state, u8 buf[], int start, int len)
 {
 	int rc;
-	u8 cmdbuf[len + 1];
+	u8 cmdbuf[80];
 	struct i2c_msg msg = {
 		.addr	= state->config->tuner_address,
 		.flags	= 0,
@@ -191,6 +191,13 @@ static int stb6100_write_reg_range(struct stb6100_state *state, u8 buf[], int st
 		.len	= len + 1
 	};
 
+	if (1 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, len);
+		return -EREMOTEIO;
+	}
+
 	if (unlikely(start < 1 || start + len > STB6100_NUMREGS)) {
 		dprintk(verbose, FE_ERROR, 1, "Invalid register range %d:%d",
 			start, len);
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 20b5fa92c53e..4bb3f9a1cf2a 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -68,7 +68,7 @@ static int stv6110_write_regs(struct dvb_frontend *fe, u8 buf[],
 {
 	struct stv6110_priv *priv = fe->tuner_priv;
 	int rc;
-	u8 cmdbuf[len + 1];
+	u8 cmdbuf[80];
 	struct i2c_msg msg = {
 		.addr	= priv->i2c_address,
 		.flags	= 0,
@@ -78,6 +78,13 @@ static int stv6110_write_regs(struct dvb_frontend *fe, u8 buf[],
 
 	dprintk("%s\n", __func__);
 
+	if (1 + len > sizeof(cmdbuf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, len);
+		return -EREMOTEIO;
+	}
+
 	if (start + len > 8)
 		return -EINVAL;
 
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index f36cab12bdc7..41f1d34f64ac 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -61,7 +61,7 @@ static int stv6110x_write_regs(struct stv6110x_state *stv6110x, int start, u8 da
 {
 	int ret;
 	const struct stv6110x_config *config = stv6110x->config;
-	u8 buf[len + 1];
+	u8 buf[80];
 	struct i2c_msg msg = {
 		.addr = config->addr,
 		.flags = 0,
@@ -69,6 +69,13 @@ static int stv6110x_write_regs(struct stv6110x_state *stv6110x, int start, u8 da
 		.len = len + 1
 	};
 
+	if (1 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, len);
+		return -EREMOTEIO;
+	}
+
 	if (start + len > 8)
 		return -EINVAL;
 
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index d281f77d5c28..d3aa82cd4eb7 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -139,11 +139,18 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 static int WriteRegs(struct tda_state *state,
 		     u8 SubAddr, u8 *Regs, u16 nRegs)
 {
-	u8 data[nRegs+1];
+	u8 data[80];
+
+	if (1 + nRegs > sizeof(data)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, nRegs);
+		return -EREMOTEIO;
+	}
 
 	data[0] = SubAddr;
 	memcpy(data + 1, Regs, nRegs);
-	return i2c_write(state->i2c, state->adr, data, nRegs+1);
+	return i2c_write(state->i2c, state->adr, data, nRegs + 1);
 }
 
 static int WriteReg(struct tda_state *state, u8 SubAddr, u8 Reg)
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index eff9c5fde50a..1e2d99b47bc3 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -98,7 +98,7 @@ static int zl10039_write(struct zl10039_state *state,
 			const enum zl10039_reg_addr reg, const u8 *src,
 			const size_t count)
 {
-	u8 buf[count + 1];
+	u8 buf[80];
 	struct i2c_msg msg = {
 		.addr = state->i2c_addr,
 		.flags = 0,
@@ -106,6 +106,13 @@ static int zl10039_write(struct zl10039_state *state,
 		.len = count + 1,
 	};
 
+	if (1 + count > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%zd is too big!\n",
+		       KBUILD_MODNAME, reg, count);
+		return -EREMOTEIO;
+	}
+
 	dprintk("%s\n", __func__);
 	/* Write register address and data in one go */
 	buf[0] = reg;
-- 
1.8.3.1

