Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43277 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab3KENDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 12/29] [media] dvb-frontends: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:25 -0200
Message-Id: <1383645702-30636-13-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
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
max data length of 64 bytes for the control URBs.

So, it seem safe to use 64 bytes as the hard limit for all those devices.

 On most cases, the limit is a way lower than that, but this limit
is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/bcm3510.c      | 15 ++++++++++++++-
 drivers/media/dvb-frontends/itd1000.c      | 13 ++++++++++++-
 drivers/media/dvb-frontends/mt312.c        | 10 +++++++++-
 drivers/media/dvb-frontends/nxt200x.c      | 11 ++++++++++-
 drivers/media/dvb-frontends/stb6100.c      | 11 ++++++++++-
 drivers/media/dvb-frontends/stv6110.c      | 12 +++++++++++-
 drivers/media/dvb-frontends/stv6110x.c     | 13 ++++++++++++-
 drivers/media/dvb-frontends/tda18271c2dd.c | 14 ++++++++++++--
 drivers/media/dvb-frontends/zl10039.c      | 12 +++++++++++-
 9 files changed, 101 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 1b77909c0c71..39a29dd29519 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -44,6 +44,9 @@
 #include "bcm3510.h"
 #include "bcm3510_priv.h"
 
+/* Max transfer size done by bcm3510_do_hab_cmd() function */
+#define MAX_XFER_SIZE	128
+
 struct bcm3510_state {
 
 	struct i2c_adapter* i2c;
@@ -201,9 +204,19 @@ static int bcm3510_hab_send_request(struct bcm3510_state *st, u8 *buf, int len)
 
 static int bcm3510_do_hab_cmd(struct bcm3510_state *st, u8 cmd, u8 msgid, u8 *obuf, u8 olen, u8 *ibuf, u8 ilen)
 {
-	u8 ob[olen+2],ib[ilen+2];
+	u8 ob[MAX_XFER_SIZE], ib[MAX_XFER_SIZE];
 	int ret = 0;
 
+	if (ilen + 2 > sizeof(ib)) {
+		deb_hab("do_hab_cmd: ilen=%d is too big!\n", ilen);
+		return -EINVAL;
+	}
+
+	if (olen + 2 > sizeof(ob)) {
+		deb_hab("do_hab_cmd: olen=%d is too big!\n", olen);
+		return -EINVAL;
+	}
+
 	ob[0] = cmd;
 	ob[1] = msgid;
 	memcpy(&ob[2],obuf,olen);
diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
index c1c3400b2173..cadcae4cff89 100644
--- a/drivers/media/dvb-frontends/itd1000.c
+++ b/drivers/media/dvb-frontends/itd1000.c
@@ -31,6 +31,9 @@
 #include "itd1000.h"
 #include "itd1000_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
@@ -52,10 +55,18 @@ MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
 /* don't write more than one byte with flexcop behind */
 static int itd1000_write_regs(struct itd1000_state *state, u8 reg, u8 v[], u8 len)
 {
-	u8 buf[1+len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg = {
 		.addr = state->cfg->i2c_address, .flags = 0, .buf = buf, .len = len+1
 	};
+
+	if (1 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "itd1000: i2c wr reg=%04x: len=%d is too big!\n",
+		       reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], v, len);
 
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index ec388c1d6913..a74ac0ddb833 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -36,6 +36,8 @@
 #include "mt312_priv.h"
 #include "mt312.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
 
 struct mt312_state {
 	struct i2c_adapter *i2c;
@@ -96,9 +98,15 @@ static int mt312_write(struct mt312_state *state, const enum mt312_reg_addr reg,
 		       const u8 *src, const size_t count)
 {
 	int ret;
-	u8 buf[count + 1];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg;
 
+	if (1 + count > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "mt312: write: len=%zd is too big!\n", count);
+		return -EINVAL;
+	}
+
 	if (debug) {
 		int i;
 		dprintk("W(%d):", reg & 0x7f);
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 8e288940a61f..fbca9856313a 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -39,6 +39,9 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 #define NXT2002_DEFAULT_FIRMWARE "dvb-fe-nxt2002.fw"
 #define NXT2004_DEFAULT_FIRMWARE "dvb-fe-nxt2004.fw"
 #define CRC_CCIT_MASK 0x1021
@@ -95,10 +98,16 @@ static int i2c_readbytes(struct nxt200x_state *state, u8 addr, u8 *buf, u8 len)
 static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg,
 			       const u8 *buf, u8 len)
 {
-	u8 buf2 [len+1];
+	u8 buf2[MAX_XFER_SIZE];
 	int err;
 	struct i2c_msg msg = { .addr = state->config->demod_address, .flags = 0, .buf = buf2, .len = len + 1 };
 
+	if (1 + len > sizeof(buf2)) {
+		pr_warn("%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 __func__, reg, len);
+		return -EINVAL;
+	}
+
 	buf2[0] = reg;
 	memcpy(&buf2[1], buf, len);
 
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index 45f9523f968f..cea175d19890 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -31,6 +31,8 @@
 static unsigned int verbose;
 module_param(verbose, int, 0644);
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
 
 #define FE_ERROR		0
 #define FE_NOTICE		1
@@ -183,7 +185,7 @@ static int stb6100_read_reg(struct stb6100_state *state, u8 reg)
 static int stb6100_write_reg_range(struct stb6100_state *state, u8 buf[], int start, int len)
 {
 	int rc;
-	u8 cmdbuf[len + 1];
+	u8 cmdbuf[MAX_XFER_SIZE];
 	struct i2c_msg msg = {
 		.addr	= state->config->tuner_address,
 		.flags	= 0,
@@ -191,6 +193,13 @@ static int stb6100_write_reg_range(struct stb6100_state *state, u8 buf[], int st
 		.len	= len + 1
 	};
 
+	if (1 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, len);
+		return -EINVAL;
+	}
+
 	if (unlikely(start < 1 || start + len > STB6100_NUMREGS)) {
 		dprintk(verbose, FE_ERROR, 1, "Invalid register range %d:%d",
 			start, len);
diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 20b5fa92c53e..b1425830a24e 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -30,6 +30,9 @@
 
 #include "stv6110.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static int debug;
 
 struct stv6110_priv {
@@ -68,7 +71,7 @@ static int stv6110_write_regs(struct dvb_frontend *fe, u8 buf[],
 {
 	struct stv6110_priv *priv = fe->tuner_priv;
 	int rc;
-	u8 cmdbuf[len + 1];
+	u8 cmdbuf[MAX_XFER_SIZE];
 	struct i2c_msg msg = {
 		.addr	= priv->i2c_address,
 		.flags	= 0,
@@ -78,6 +81,13 @@ static int stv6110_write_regs(struct dvb_frontend *fe, u8 buf[],
 
 	dprintk("%s\n", __func__);
 
+	if (1 + len > sizeof(cmdbuf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, len);
+		return -EINVAL;
+	}
+
 	if (start + len > 8)
 		return -EINVAL;
 
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index f36cab12bdc7..e66154e5c1d7 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -32,6 +32,9 @@
 #include "stv6110x.h"
 #include "stv6110x_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static unsigned int verbose;
 module_param(verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "Set Verbosity level");
@@ -61,7 +64,8 @@ static int stv6110x_write_regs(struct stv6110x_state *stv6110x, int start, u8 da
 {
 	int ret;
 	const struct stv6110x_config *config = stv6110x->config;
-	u8 buf[len + 1];
+	u8 buf[MAX_XFER_SIZE];
+
 	struct i2c_msg msg = {
 		.addr = config->addr,
 		.flags = 0,
@@ -69,6 +73,13 @@ static int stv6110x_write_regs(struct stv6110x_state *stv6110x, int start, u8 da
 		.len = len + 1
 	};
 
+	if (1 + len > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, len);
+		return -EINVAL;
+	}
+
 	if (start + len > 8)
 		return -EINVAL;
 
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
index d281f77d5c28..2c54586ac07f 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.c
+++ b/drivers/media/dvb-frontends/tda18271c2dd.c
@@ -34,6 +34,9 @@
 #include "dvb_frontend.h"
 #include "tda18271c2dd.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct SStandardParam {
 	s32   m_IFFrequency;
 	u32   m_BandWidth;
@@ -139,11 +142,18 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 static int WriteRegs(struct tda_state *state,
 		     u8 SubAddr, u8 *Regs, u16 nRegs)
 {
-	u8 data[nRegs+1];
+	u8 data[MAX_XFER_SIZE];
+
+	if (1 + nRegs > sizeof(data)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr: len=%d is too big!\n",
+		       KBUILD_MODNAME, nRegs);
+		return -EINVAL;
+	}
 
 	data[0] = SubAddr;
 	memcpy(data + 1, Regs, nRegs);
-	return i2c_write(state->i2c, state->adr, data, nRegs+1);
+	return i2c_write(state->i2c, state->adr, data, nRegs + 1);
 }
 
 static int WriteReg(struct tda_state *state, u8 SubAddr, u8 Reg)
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index eff9c5fde50a..91b6b2e9b792 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -30,6 +30,9 @@
 
 static int debug;
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 #define dprintk(args...) \
 	do { \
 		if (debug) \
@@ -98,7 +101,7 @@ static int zl10039_write(struct zl10039_state *state,
 			const enum zl10039_reg_addr reg, const u8 *src,
 			const size_t count)
 {
-	u8 buf[count + 1];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg = {
 		.addr = state->i2c_addr,
 		.flags = 0,
@@ -106,6 +109,13 @@ static int zl10039_write(struct zl10039_state *state,
 		.len = count + 1,
 	};
 
+	if (1 + count > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: i2c wr reg=%04x: len=%zd is too big!\n",
+		       KBUILD_MODNAME, reg, count);
+		return -EINVAL;
+	}
+
 	dprintk("%s\n", __func__);
 	/* Write register address and data in one go */
 	buf[0] = reg;
-- 
1.8.3.1

