Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:49954 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdK3Q5g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 11:57:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        Daniel Scheller <d.scheller@gmx.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dvb-frontends: fix i2c access helpers for KASAN
Date: Thu, 30 Nov 2017 17:55:46 +0100
Message-Id: <20171130165656.2405881-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A typical code fragment was copied across many dvb-frontend drivers and
causes large stack frames when built with with CONFIG_KASAN on gcc-5/6/7:

drivers/media/dvb-frontends/cxd2841er.c:3225:1: error: the frame size of 3992 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
drivers/media/dvb-frontends/cxd2841er.c:3404:1: error: the frame size of 3136 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
drivers/media/dvb-frontends/stv0367.c:3143:1: error: the frame size of 4016 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
drivers/media/dvb-frontends/stv090x.c:3430:1: error: the frame size of 5312 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
drivers/media/dvb-frontends/stv090x.c:4248:1: error: the frame size of 4872 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]

gcc-8 now solves this by consolidating the stack slots for the argument
variables, but on older compilers we can get the same behavior by taking
the pointer of a local variable rather than the inline function argument.

Cc: stable@vger.kernel.org
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: add a comment for each instance of the problem, linking
to the gcc bugzilla (I left out the http:// so it would fit
in one line)
---
 drivers/media/dvb-frontends/ascot2e.c     | 4 +++-
 drivers/media/dvb-frontends/cxd2841er.c   | 4 +++-
 drivers/media/dvb-frontends/helene.c      | 4 +++-
 drivers/media/dvb-frontends/horus3a.c     | 4 +++-
 drivers/media/dvb-frontends/itd1000.c     | 5 +++--
 drivers/media/dvb-frontends/mt312.c       | 5 ++++-
 drivers/media/dvb-frontends/stb0899_drv.c | 3 ++-
 drivers/media/dvb-frontends/stb6100.c     | 6 ++++--
 drivers/media/dvb-frontends/stv0367.c     | 4 +++-
 drivers/media/dvb-frontends/stv090x.c     | 4 +++-
 drivers/media/dvb-frontends/stv6110x.c    | 4 +++-
 drivers/media/dvb-frontends/zl10039.c     | 4 +++-
 12 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
index 0ee0df53b91b..79d5d89bc95e 100644
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -155,7 +155,9 @@ static int ascot2e_write_regs(struct ascot2e_priv *priv,
 
 static int ascot2e_write_reg(struct ascot2e_priv *priv, u8 reg, u8 val)
 {
-	return ascot2e_write_regs(priv, reg, &val, 1);
+	u8 tmp = val; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return ascot2e_write_regs(priv, reg, &tmp, 1);
 }
 
 static int ascot2e_read_regs(struct ascot2e_priv *priv,
diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 48ee9bc00c06..ccbd84fd6428 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -257,7 +257,9 @@ static int cxd2841er_write_regs(struct cxd2841er_priv *priv,
 static int cxd2841er_write_reg(struct cxd2841er_priv *priv,
 			       u8 addr, u8 reg, u8 val)
 {
-	return cxd2841er_write_regs(priv, addr, reg, &val, 1);
+	u8 tmp = val; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return cxd2841er_write_regs(priv, addr, reg, &tmp, 1);
 }
 
 static int cxd2841er_read_regs(struct cxd2841er_priv *priv,
diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index 4bf5a551ba40..2ab8d83e5576 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -331,7 +331,9 @@ static int helene_write_regs(struct helene_priv *priv,
 
 static int helene_write_reg(struct helene_priv *priv, u8 reg, u8 val)
 {
-	return helene_write_regs(priv, reg, &val, 1);
+	u8 tmp = val; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return helene_write_regs(priv, reg, &tmp, 1);
 }
 
 static int helene_read_regs(struct helene_priv *priv,
diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
index 68d759c4c52e..5c8b405f2ddc 100644
--- a/drivers/media/dvb-frontends/horus3a.c
+++ b/drivers/media/dvb-frontends/horus3a.c
@@ -89,7 +89,9 @@ static int horus3a_write_regs(struct horus3a_priv *priv,
 
 static int horus3a_write_reg(struct horus3a_priv *priv, u8 reg, u8 val)
 {
-	return horus3a_write_regs(priv, reg, &val, 1);
+	u8 tmp = val; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return horus3a_write_regs(priv, reg, &tmp, 1);
 }
 
 static int horus3a_enter_power_save(struct horus3a_priv *priv)
diff --git a/drivers/media/dvb-frontends/itd1000.c b/drivers/media/dvb-frontends/itd1000.c
index 5bb1e73a10b4..ce7c443d3eac 100644
--- a/drivers/media/dvb-frontends/itd1000.c
+++ b/drivers/media/dvb-frontends/itd1000.c
@@ -95,8 +95,9 @@ static int itd1000_read_reg(struct itd1000_state *state, u8 reg)
 
 static inline int itd1000_write_reg(struct itd1000_state *state, u8 r, u8 v)
 {
-	int ret = itd1000_write_regs(state, r, &v, 1);
-	state->shadow[r] = v;
+	u8 tmp = v; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+	int ret = itd1000_write_regs(state, r, &tmp, 1);
+	state->shadow[r] = tmp;
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index 961b9a2508e0..0b23cbc021b8 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -142,7 +142,10 @@ static inline int mt312_readreg(struct mt312_state *state,
 static inline int mt312_writereg(struct mt312_state *state,
 				 const enum mt312_reg_addr reg, const u8 val)
 {
-	return mt312_write(state, reg, &val, 1);
+	u8 tmp = val; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+
+	return mt312_write(state, reg, &tmp, 1);
 }
 
 static inline u32 mt312_div(u32 a, u32 b)
diff --git a/drivers/media/dvb-frontends/stb0899_drv.c b/drivers/media/dvb-frontends/stb0899_drv.c
index 02347598277a..db5dde3215f0 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.c
+++ b/drivers/media/dvb-frontends/stb0899_drv.c
@@ -539,7 +539,8 @@ int stb0899_write_regs(struct stb0899_state *state, unsigned int reg, u8 *data,
 
 int stb0899_write_reg(struct stb0899_state *state, unsigned int reg, u8 data)
 {
-	return stb0899_write_regs(state, reg, &data, 1);
+	u8 tmp = data;
+	return stb0899_write_regs(state, reg, &tmp, 1);
 }
 
 /*
diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index 17a955d0031b..75509bec66e4 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -226,12 +226,14 @@ static int stb6100_write_reg_range(struct stb6100_state *state, u8 buf[], int st
 
 static int stb6100_write_reg(struct stb6100_state *state, u8 reg, u8 data)
 {
+	u8 tmp = data; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
 	if (unlikely(reg >= STB6100_NUMREGS)) {
 		dprintk(verbose, FE_ERROR, 1, "Invalid register offset 0x%x", reg);
 		return -EREMOTEIO;
 	}
-	data = (data & stb6100_template[reg].mask) | stb6100_template[reg].set;
-	return stb6100_write_reg_range(state, &data, reg, 1);
+	tmp = (tmp & stb6100_template[reg].mask) | stb6100_template[reg].set;
+	return stb6100_write_reg_range(state, &tmp, reg, 1);
 }
 
 
diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index f3529df8211d..1a726196c126 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -166,7 +166,9 @@ int stv0367_writeregs(struct stv0367_state *state, u16 reg, u8 *data, int len)
 
 static int stv0367_writereg(struct stv0367_state *state, u16 reg, u8 data)
 {
-	return stv0367_writeregs(state, reg, &data, 1);
+	u8 tmp = data; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return stv0367_writeregs(state, reg, &tmp, 1);
 }
 
 static u8 stv0367_readreg(struct stv0367_state *state, u16 reg)
diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 7ef469c0c866..2695e1eb6d9c 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -755,7 +755,9 @@ static int stv090x_write_regs(struct stv090x_state *state, unsigned int reg, u8
 
 static int stv090x_write_reg(struct stv090x_state *state, unsigned int reg, u8 data)
 {
-	return stv090x_write_regs(state, reg, &data, 1);
+	u8 tmp = data; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return stv090x_write_regs(state, reg, &tmp, 1);
 }
 
 static int stv090x_i2c_gate_ctrl(struct stv090x_state *state, int enable)
diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index 66eba38f1014..7e8e01389c55 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -97,7 +97,9 @@ static int stv6110x_write_regs(struct stv6110x_state *stv6110x, int start, u8 da
 
 static int stv6110x_write_reg(struct stv6110x_state *stv6110x, u8 reg, u8 data)
 {
-	return stv6110x_write_regs(stv6110x, reg, &data, 1);
+	u8 tmp = data; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return stv6110x_write_regs(stv6110x, reg, &tmp, 1);
 }
 
 static int stv6110x_init(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index 623355fc2666..3208b866d1cb 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -134,7 +134,9 @@ static inline int zl10039_writereg(struct zl10039_state *state,
 				const enum zl10039_reg_addr reg,
 				const u8 val)
 {
-	return zl10039_write(state, reg, &val, 1);
+	const u8 tmp = val; /* see gcc.gnu.org/bugzilla/show_bug.cgi?id=81715 */
+
+	return zl10039_write(state, reg, &tmp, 1);
 }
 
 static int zl10039_init(struct dvb_frontend *fe)
-- 
2.9.0
