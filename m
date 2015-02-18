Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53976 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbBRRN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 12:13:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Antti Palosaari <crope@iki.fi>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
	linux-kbuild@vger.kernel.org,
	"Yann E. MORIN" <yann.morin.1998@free.fr>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] [kbuild] Add and use IS_REACHABLE macro
Date: Wed, 18 Feb 2015 18:12:42 +0100
Message-ID: <6116702.rrbrOqQ26P@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the media drivers, the v4l2 core knows about all submodules
and calls into them from a common function. However this cannot
work if the modules that get called are loadable and the
core is built-in. In that case we get

drivers/built-in.o: In function `set_type':
drivers/media/v4l2-core/tuner-core.c:301: undefined reference to `tea5767_attach'
drivers/media/v4l2-core/tuner-core.c:307: undefined reference to `tea5761_attach'
drivers/media/v4l2-core/tuner-core.c:349: undefined reference to `tda9887_attach'
drivers/media/v4l2-core/tuner-core.c:405: undefined reference to `xc4000_attach'

This was working previously, until the IS_ENABLED() macro was used
to replace the construct like

 #if defined(CONFIG_DVB_CX24110) || (defined(CONFIG_DVB_CX24110_MODULE) && defined(MODULE))

with the difference that the new code no longer checks whether it is being
built as a loadable module itself.

To fix this, this new patch adds an 'IS_REACHABLE' macro, which evaluates
true in exactly the condition that was used previously. The downside
of this is that this trades an obvious link error for a more subtle
runtime failure, but it is clear that the change that introduced the
link error was unintentional and it seems better to revert it for
now. Also, a similar change was originally created by Trent Piepho
and then reverted by teh change to the IS_ENABLED macro.

Ideally Kconfig would be used to avoid the case of a broken dependency,
or the code restructured in a way to turn around the dependency, but either
way would require much larger changes here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 7b34be71db53 ("[media] use IS_ENABLED() macro")
See-also: c5dec9fb248e ("V4L/DVB (4751): Fix DBV_FE_CUSTOMISE for card drivers compiled into kernel")
---

dirstat:
  69.2% drivers/media/dvb-frontends/
   0.8% drivers/media/pci/cx23885/
  25.5% drivers/media/tuners/
   4.2% include/linux/
 116 files changed, 125 insertions(+), 116 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
index b6ef6427cfa5..5f0411939ffc 100644
--- a/drivers/media/dvb-frontends/a8293.h
+++ b/drivers/media/dvb-frontends/a8293.h
@@ -27,7 +27,7 @@ struct a8293_config {
 	u8 i2c_addr;
 };
 
-#if IS_ENABLED(CONFIG_DVB_A8293)
+#if IS_REACHABLE(CONFIG_DVB_A8293)
 extern struct dvb_frontend *a8293_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, const struct a8293_config *cfg);
 #else
diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index 09273b2cd310..1dcc936e1661 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -103,7 +103,7 @@ struct af9013_config {
 	u8 gpio[4];
 };
 
-#if IS_ENABLED(CONFIG_DVB_AF9013)
+#if IS_REACHABLE(CONFIG_DVB_AF9013)
 extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/atbm8830.h b/drivers/media/dvb-frontends/atbm8830.h
index 8e0ac98f8d08..5446d13fdfe8 100644
--- a/drivers/media/dvb-frontends/atbm8830.h
+++ b/drivers/media/dvb-frontends/atbm8830.h
@@ -61,7 +61,7 @@ struct atbm8830_config {
 	u8 agc_hold_loop;
 };
 
-#if IS_ENABLED(CONFIG_DVB_ATBM8830)
+#if IS_REACHABLE(CONFIG_DVB_ATBM8830)
 extern struct dvb_frontend *atbm8830_attach(const struct atbm8830_config *config,
 		struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/au8522.h b/drivers/media/dvb-frontends/au8522.h
index 612251958855..dde61582c158 100644
--- a/drivers/media/dvb-frontends/au8522.h
+++ b/drivers/media/dvb-frontends/au8522.h
@@ -61,7 +61,7 @@ struct au8522_config {
 	enum au8522_if_freq qam_if;
 };
 
-#if IS_ENABLED(CONFIG_DVB_AU8522_DTV)
+#if IS_REACHABLE(CONFIG_DVB_AU8522_DTV)
 extern struct dvb_frontend *au8522_attach(const struct au8522_config *config,
 					  struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/bcm3510.h b/drivers/media/dvb-frontends/bcm3510.h
index 5bd56b1623bf..ff66492fb940 100644
--- a/drivers/media/dvb-frontends/bcm3510.h
+++ b/drivers/media/dvb-frontends/bcm3510.h
@@ -34,7 +34,7 @@ struct bcm3510_config
 	int (*request_firmware)(struct dvb_frontend* fe, const struct firmware **fw, char* name);
 };
 
-#if IS_ENABLED(CONFIG_DVB_BCM3510)
+#if IS_REACHABLE(CONFIG_DVB_BCM3510)
 extern struct dvb_frontend* bcm3510_attach(const struct bcm3510_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/cx22700.h b/drivers/media/dvb-frontends/cx22700.h
index 382a7b1f3618..e0a764868e6f 100644
--- a/drivers/media/dvb-frontends/cx22700.h
+++ b/drivers/media/dvb-frontends/cx22700.h
@@ -31,7 +31,7 @@ struct cx22700_config
 	u8 demod_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_CX22700)
+#if IS_REACHABLE(CONFIG_DVB_CX22700)
 extern struct dvb_frontend* cx22700_attach(const struct cx22700_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/cx22702.h b/drivers/media/dvb-frontends/cx22702.h
index 0b1a6c2f9d5f..68b69a7660d2 100644
--- a/drivers/media/dvb-frontends/cx22702.h
+++ b/drivers/media/dvb-frontends/cx22702.h
@@ -41,7 +41,7 @@ struct cx22702_config {
 	u8 output_mode;
 };
 
-#if IS_ENABLED(CONFIG_DVB_CX22702)
+#if IS_REACHABLE(CONFIG_DVB_CX22702)
 extern struct dvb_frontend *cx22702_attach(
 	const struct cx22702_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cx24110.h b/drivers/media/dvb-frontends/cx24110.h
index 527aff1f2723..d5453ed20b28 100644
--- a/drivers/media/dvb-frontends/cx24110.h
+++ b/drivers/media/dvb-frontends/cx24110.h
@@ -46,7 +46,7 @@ static inline int cx24110_pll_write(struct dvb_frontend *fe, u32 val)
 	return 0;
 }
 
-#if IS_ENABLED(CONFIG_DVB_CX24110)
+#if IS_REACHABLE(CONFIG_DVB_CX24110)
 extern struct dvb_frontend* cx24110_attach(const struct cx24110_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/cx24113.h b/drivers/media/dvb-frontends/cx24113.h
index 782711ba1a32..962919b9b6e6 100644
--- a/drivers/media/dvb-frontends/cx24113.h
+++ b/drivers/media/dvb-frontends/cx24113.h
@@ -32,7 +32,7 @@ struct cx24113_config {
 	u32 xtal_khz;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TUNER_CX24113)
+#if IS_REACHABLE(CONFIG_DVB_TUNER_CX24113)
 extern struct dvb_frontend *cx24113_attach(struct dvb_frontend *,
 	const struct cx24113_config *config, struct i2c_adapter *i2c);
 
diff --git a/drivers/media/dvb-frontends/cx24116.h b/drivers/media/dvb-frontends/cx24116.h
index 2ec84fae3f9f..f6dbabc1d62b 100644
--- a/drivers/media/dvb-frontends/cx24116.h
+++ b/drivers/media/dvb-frontends/cx24116.h
@@ -41,7 +41,7 @@ struct cx24116_config {
 	u16 i2c_wr_max;
 };
 
-#if IS_ENABLED(CONFIG_DVB_CX24116)
+#if IS_REACHABLE(CONFIG_DVB_CX24116)
 extern struct dvb_frontend *cx24116_attach(
 	const struct cx24116_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cx24117.h b/drivers/media/dvb-frontends/cx24117.h
index 4e59e9574fa7..1648ab432168 100644
--- a/drivers/media/dvb-frontends/cx24117.h
+++ b/drivers/media/dvb-frontends/cx24117.h
@@ -30,7 +30,7 @@ struct cx24117_config {
 	u8 demod_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_CX24117)
+#if IS_REACHABLE(CONFIG_DVB_CX24117)
 extern struct dvb_frontend *cx24117_attach(
 	const struct cx24117_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cx24123.h b/drivers/media/dvb-frontends/cx24123.h
index 102e70d17c43..758aee5a072f 100644
--- a/drivers/media/dvb-frontends/cx24123.h
+++ b/drivers/media/dvb-frontends/cx24123.h
@@ -39,7 +39,7 @@ struct cx24123_config {
 	void (*agc_callback) (struct dvb_frontend *);
 };
 
-#if IS_ENABLED(CONFIG_DVB_CX24123)
+#if IS_REACHABLE(CONFIG_DVB_CX24123)
 extern struct dvb_frontend *cx24123_attach(const struct cx24123_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *cx24123_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
index 6095dbcf7850..56d42760263d 100644
--- a/drivers/media/dvb-frontends/cxd2820r.h
+++ b/drivers/media/dvb-frontends/cxd2820r.h
@@ -72,7 +72,7 @@ struct cxd2820r_config {
 };
 
 
-#if IS_ENABLED(CONFIG_DVB_CXD2820R)
+#if IS_REACHABLE(CONFIG_DVB_CXD2820R)
 extern struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
 	struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/dib0070.h b/drivers/media/dvb-frontends/dib0070.h
index 0c6befcc9143..6c0b6672b1d9 100644
--- a/drivers/media/dvb-frontends/dib0070.h
+++ b/drivers/media/dvb-frontends/dib0070.h
@@ -48,7 +48,7 @@ struct dib0070_config {
 	u8 vga_filter;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TUNER_DIB0070)
+#if IS_REACHABLE(CONFIG_DVB_TUNER_DIB0070)
 extern struct dvb_frontend *dib0070_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct dib0070_config *cfg);
 extern u16 dib0070_wbd_offset(struct dvb_frontend *);
 extern void dib0070_ctrl_agc_filter(struct dvb_frontend *, u8 open);
diff --git a/drivers/media/dvb-frontends/dib0090.h b/drivers/media/dvb-frontends/dib0090.h
index 6a090954fa10..ad74bc823f08 100644
--- a/drivers/media/dvb-frontends/dib0090.h
+++ b/drivers/media/dvb-frontends/dib0090.h
@@ -75,7 +75,7 @@ struct dib0090_config {
 	u8 force_crystal_mode;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TUNER_DIB0090)
+#if IS_REACHABLE(CONFIG_DVB_TUNER_DIB0090)
 extern struct dvb_frontend *dib0090_register(struct dvb_frontend *fe, struct i2c_adapter *i2c, const struct dib0090_config *config);
 extern struct dvb_frontend *dib0090_fw_register(struct dvb_frontend *fe, struct i2c_adapter *i2c, const struct dib0090_config *config);
 extern void dib0090_dcc_freq(struct dvb_frontend *fe, u8 fast);
diff --git a/drivers/media/dvb-frontends/dib3000.h b/drivers/media/dvb-frontends/dib3000.h
index 9b6c3bbc983a..6ae9899b5b45 100644
--- a/drivers/media/dvb-frontends/dib3000.h
+++ b/drivers/media/dvb-frontends/dib3000.h
@@ -41,7 +41,7 @@ struct dib_fe_xfer_ops
 	int (*tuner_pass_ctrl)(struct dvb_frontend *fe, int onoff, u8 pll_ctrl);
 };
 
-#if IS_ENABLED(CONFIG_DVB_DIB3000MB)
+#if IS_REACHABLE(CONFIG_DVB_DIB3000MB)
 extern struct dvb_frontend* dib3000mb_attach(const struct dib3000_config* config,
 					     struct i2c_adapter* i2c, struct dib_fe_xfer_ops *xfer_ops);
 #else
diff --git a/drivers/media/dvb-frontends/dib3000mc.h b/drivers/media/dvb-frontends/dib3000mc.h
index 129d1425516a..74816f793611 100644
--- a/drivers/media/dvb-frontends/dib3000mc.h
+++ b/drivers/media/dvb-frontends/dib3000mc.h
@@ -41,7 +41,7 @@ struct dib3000mc_config {
 #define DEFAULT_DIB3000MC_I2C_ADDRESS 16
 #define DEFAULT_DIB3000P_I2C_ADDRESS  24
 
-#if IS_ENABLED(CONFIG_DVB_DIB3000MC)
+#if IS_REACHABLE(CONFIG_DVB_DIB3000MC)
 extern struct dvb_frontend *dib3000mc_attach(struct i2c_adapter *i2c_adap,
 					     u8 i2c_addr,
 					     struct dib3000mc_config *cfg);
diff --git a/drivers/media/dvb-frontends/dib7000m.h b/drivers/media/dvb-frontends/dib7000m.h
index b585413f9a29..6468c278cc4d 100644
--- a/drivers/media/dvb-frontends/dib7000m.h
+++ b/drivers/media/dvb-frontends/dib7000m.h
@@ -40,7 +40,7 @@ struct dib7000m_config {
 
 #define DEFAULT_DIB7000M_I2C_ADDRESS 18
 
-#if IS_ENABLED(CONFIG_DVB_DIB7000M)
+#if IS_REACHABLE(CONFIG_DVB_DIB7000M)
 extern struct dvb_frontend *dib7000m_attach(struct i2c_adapter *i2c_adap,
 					    u8 i2c_addr,
 					    struct dib7000m_config *cfg);
diff --git a/drivers/media/dvb-frontends/dib7000p.h b/drivers/media/dvb-frontends/dib7000p.h
index 1fea0e972654..baa278928cf3 100644
--- a/drivers/media/dvb-frontends/dib7000p.h
+++ b/drivers/media/dvb-frontends/dib7000p.h
@@ -66,7 +66,7 @@ struct dib7000p_ops {
 	struct dvb_frontend *(*init)(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
 };
 
-#if IS_ENABLED(CONFIG_DVB_DIB7000P)
+#if IS_REACHABLE(CONFIG_DVB_DIB7000P)
 void *dib7000p_attach(struct dib7000p_ops *ops);
 #else
 static inline void *dib7000p_attach(struct dib7000p_ops *ops)
diff --git a/drivers/media/dvb-frontends/dib8000.h b/drivers/media/dvb-frontends/dib8000.h
index 84cc10383dcd..780c37bdcb72 100644
--- a/drivers/media/dvb-frontends/dib8000.h
+++ b/drivers/media/dvb-frontends/dib8000.h
@@ -63,7 +63,7 @@ struct dib8000_ops {
 	struct dvb_frontend *(*init)(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg);
 };
 
-#if IS_ENABLED(CONFIG_DVB_DIB8000)
+#if IS_REACHABLE(CONFIG_DVB_DIB8000)
 void *dib8000_attach(struct dib8000_ops *ops);
 #else
 static inline int dib8000_attach(struct dib8000_ops *ops)
diff --git a/drivers/media/dvb-frontends/dib9000.h b/drivers/media/dvb-frontends/dib9000.h
index f3639f045ff0..b10a70aa7c9f 100644
--- a/drivers/media/dvb-frontends/dib9000.h
+++ b/drivers/media/dvb-frontends/dib9000.h
@@ -27,7 +27,7 @@ struct dib9000_config {
 
 #define DEFAULT_DIB9000_I2C_ADDRESS 18
 
-#if IS_ENABLED(CONFIG_DVB_DIB9000)
+#if IS_REACHABLE(CONFIG_DVB_DIB9000)
 extern struct dvb_frontend *dib9000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, const struct dib9000_config *cfg);
 extern int dib9000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods, u8 default_addr, u8 first_addr);
 extern struct i2c_adapter *dib9000_get_tuner_interface(struct dvb_frontend *fe);
diff --git a/drivers/media/dvb-frontends/drxd.h b/drivers/media/dvb-frontends/drxd.h
index d998e4d5a7fc..a47c22d6667e 100644
--- a/drivers/media/dvb-frontends/drxd.h
+++ b/drivers/media/dvb-frontends/drxd.h
@@ -52,7 +52,7 @@ struct drxd_config {
 	 s16(*osc_deviation) (void *priv, s16 dev, int flag);
 };
 
-#if IS_ENABLED(CONFIG_DVB_DRXD)
+#if IS_REACHABLE(CONFIG_DVB_DRXD)
 extern
 struct dvb_frontend *drxd_attach(const struct drxd_config *config,
 				 void *priv, struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index f6cb34660327..8f0b9eec528f 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -51,7 +51,7 @@ struct drxk_config {
 	int		 qam_demod_parameter_count;
 };
 
-#if IS_ENABLED(CONFIG_DVB_DRXK)
+#if IS_REACHABLE(CONFIG_DVB_DRXK)
 extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/ds3000.h b/drivers/media/dvb-frontends/ds3000.h
index f9c21fb7af13..153169da9017 100644
--- a/drivers/media/dvb-frontends/ds3000.h
+++ b/drivers/media/dvb-frontends/ds3000.h
@@ -35,7 +35,7 @@ struct ds3000_config {
 	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
-#if IS_ENABLED(CONFIG_DVB_DS3000)
+#if IS_REACHABLE(CONFIG_DVB_DS3000)
 extern struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index f4b5a0601c3a..bf9602a88b6c 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -38,7 +38,7 @@
  * @param pll_desc_id dvb_pll_desc to use.
  * @return Frontend pointer on success, NULL on failure
  */
-#if IS_ENABLED(CONFIG_DVB_PLL)
+#if IS_REACHABLE(CONFIG_DVB_PLL)
 extern struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe,
 					   int pll_addr,
 					   struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/dvb_dummy_fe.h b/drivers/media/dvb-frontends/dvb_dummy_fe.h
index 0cbf96105631..15e4ceab869a 100644
--- a/drivers/media/dvb-frontends/dvb_dummy_fe.h
+++ b/drivers/media/dvb-frontends/dvb_dummy_fe.h
@@ -26,7 +26,7 @@
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
 
-#if IS_ENABLED(CONFIG_DVB_DUMMY_FE)
+#if IS_REACHABLE(CONFIG_DVB_DUMMY_FE)
 extern struct dvb_frontend* dvb_dummy_fe_ofdm_attach(void);
 extern struct dvb_frontend* dvb_dummy_fe_qpsk_attach(void);
 extern struct dvb_frontend* dvb_dummy_fe_qam_attach(void);
diff --git a/drivers/media/dvb-frontends/ec100.h b/drivers/media/dvb-frontends/ec100.h
index 37558403068d..9544bab5cd1d 100644
--- a/drivers/media/dvb-frontends/ec100.h
+++ b/drivers/media/dvb-frontends/ec100.h
@@ -31,7 +31,7 @@ struct ec100_config {
 };
 
 
-#if IS_ENABLED(CONFIG_DVB_EC100)
+#if IS_REACHABLE(CONFIG_DVB_EC100)
 extern struct dvb_frontend *ec100_attach(const struct ec100_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/hd29l2.h b/drivers/media/dvb-frontends/hd29l2.h
index 05cd13028a91..48e9ab74c883 100644
--- a/drivers/media/dvb-frontends/hd29l2.h
+++ b/drivers/media/dvb-frontends/hd29l2.h
@@ -51,7 +51,7 @@ struct hd29l2_config {
 };
 
 
-#if IS_ENABLED(CONFIG_DVB_HD29L2)
+#if IS_REACHABLE(CONFIG_DVB_HD29L2)
 extern struct dvb_frontend *hd29l2_attach(const struct hd29l2_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/isl6405.h b/drivers/media/dvb-frontends/isl6405.h
index 8abb70c26fd9..3c148b830bd1 100644
--- a/drivers/media/dvb-frontends/isl6405.h
+++ b/drivers/media/dvb-frontends/isl6405.h
@@ -55,7 +55,7 @@
 #define ISL6405_ENT2	0x20
 #define ISL6405_ISEL2	0x40
 
-#if IS_ENABLED(CONFIG_DVB_ISL6405)
+#if IS_REACHABLE(CONFIG_DVB_ISL6405)
 /* override_set and override_clear control which system register bits (above)
  * to always set & clear
  */
diff --git a/drivers/media/dvb-frontends/isl6421.h b/drivers/media/dvb-frontends/isl6421.h
index 630e7f8a150e..3273597833fd 100644
--- a/drivers/media/dvb-frontends/isl6421.h
+++ b/drivers/media/dvb-frontends/isl6421.h
@@ -39,7 +39,7 @@
 #define ISL6421_ISEL1	0x20
 #define ISL6421_DCL	0x40
 
-#if IS_ENABLED(CONFIG_DVB_ISL6421)
+#if IS_REACHABLE(CONFIG_DVB_ISL6421)
 /* override_set and override_clear control which system register bits (above) to always set & clear */
 extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
 			  u8 override_set, u8 override_clear, bool override_tone);
diff --git a/drivers/media/dvb-frontends/isl6423.h b/drivers/media/dvb-frontends/isl6423.h
index 80dfd9cc4f41..a64df0ee256b 100644
--- a/drivers/media/dvb-frontends/isl6423.h
+++ b/drivers/media/dvb-frontends/isl6423.h
@@ -42,7 +42,7 @@ struct isl6423_config {
 	u8 mod_extern;
 };
 
-#if IS_ENABLED(CONFIG_DVB_ISL6423)
+#if IS_REACHABLE(CONFIG_DVB_ISL6423)
 
 
 extern struct dvb_frontend *isl6423_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/itd1000.h b/drivers/media/dvb-frontends/itd1000.h
index edae0902f4fd..a691bb6f26de 100644
--- a/drivers/media/dvb-frontends/itd1000.h
+++ b/drivers/media/dvb-frontends/itd1000.h
@@ -29,7 +29,7 @@ struct itd1000_config {
 	u8 i2c_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TUNER_ITD1000)
+#if IS_REACHABLE(CONFIG_DVB_TUNER_ITD1000)
 extern struct dvb_frontend *itd1000_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct itd1000_config *cfg);
 #else
 static inline struct dvb_frontend *itd1000_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct itd1000_config *cfg)
diff --git a/drivers/media/dvb-frontends/ix2505v.h b/drivers/media/dvb-frontends/ix2505v.h
index 1a735a75aa98..af107a2dd357 100644
--- a/drivers/media/dvb-frontends/ix2505v.h
+++ b/drivers/media/dvb-frontends/ix2505v.h
@@ -49,7 +49,7 @@ struct ix2505v_config {
 
 };
 
-#if IS_ENABLED(CONFIG_DVB_IX2505V)
+#if IS_REACHABLE(CONFIG_DVB_IX2505V)
 extern struct dvb_frontend *ix2505v_attach(struct dvb_frontend *fe,
 	const struct ix2505v_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/l64781.h b/drivers/media/dvb-frontends/l64781.h
index 6813b08a774d..8697e2c2ba36 100644
--- a/drivers/media/dvb-frontends/l64781.h
+++ b/drivers/media/dvb-frontends/l64781.h
@@ -31,7 +31,7 @@ struct l64781_config
 	u8 demod_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_L64781)
+#if IS_REACHABLE(CONFIG_DVB_L64781)
 extern struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 					  struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lg2160.h b/drivers/media/dvb-frontends/lg2160.h
index 194a07a78dc1..d20bd909de39 100644
--- a/drivers/media/dvb-frontends/lg2160.h
+++ b/drivers/media/dvb-frontends/lg2160.h
@@ -67,7 +67,7 @@ struct lg2160_config {
 	enum lg_chip_type lg_chip;
 };
 
-#if IS_ENABLED(CONFIG_DVB_LG2160)
+#if IS_REACHABLE(CONFIG_DVB_LG2160)
 extern
 struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
 				     struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/lgdt3305.h b/drivers/media/dvb-frontends/lgdt3305.h
index 9c03e530e01b..f91a1b49ce2f 100644
--- a/drivers/media/dvb-frontends/lgdt3305.h
+++ b/drivers/media/dvb-frontends/lgdt3305.h
@@ -80,7 +80,7 @@ struct lgdt3305_config {
 	enum lgdt_demod_chip_type demod_chip;
 };
 
-#if IS_ENABLED(CONFIG_DVB_LGDT3305)
+#if IS_REACHABLE(CONFIG_DVB_LGDT3305)
 extern
 struct dvb_frontend *lgdt3305_attach(const struct lgdt3305_config *config,
 				     struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/lgdt330x.h b/drivers/media/dvb-frontends/lgdt330x.h
index 8bb332219fc4..c73eeb45e330 100644
--- a/drivers/media/dvb-frontends/lgdt330x.h
+++ b/drivers/media/dvb-frontends/lgdt330x.h
@@ -52,7 +52,7 @@ struct lgdt330x_config
 	int clock_polarity_flip;
 };
 
-#if IS_ENABLED(CONFIG_DVB_LGDT330X)
+#if IS_REACHABLE(CONFIG_DVB_LGDT330X)
 extern struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 					    struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lgs8gl5.h b/drivers/media/dvb-frontends/lgs8gl5.h
index c2da59614727..a5b3faf121f0 100644
--- a/drivers/media/dvb-frontends/lgs8gl5.h
+++ b/drivers/media/dvb-frontends/lgs8gl5.h
@@ -31,7 +31,7 @@ struct lgs8gl5_config {
 	u8 demod_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_LGS8GL5)
+#if IS_REACHABLE(CONFIG_DVB_LGS8GL5)
 extern struct dvb_frontend *lgs8gl5_attach(
 	const struct lgs8gl5_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lgs8gxx.h b/drivers/media/dvb-frontends/lgs8gxx.h
index dadb78bf61a9..368c9928ef7f 100644
--- a/drivers/media/dvb-frontends/lgs8gxx.h
+++ b/drivers/media/dvb-frontends/lgs8gxx.h
@@ -80,7 +80,7 @@ struct lgs8gxx_config {
 	u8 tuner_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_LGS8GXX)
+#if IS_REACHABLE(CONFIG_DVB_LGS8GXX)
 extern struct dvb_frontend *lgs8gxx_attach(const struct lgs8gxx_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lnbh24.h b/drivers/media/dvb-frontends/lnbh24.h
index b327a4f31d16..a088b8ec1e53 100644
--- a/drivers/media/dvb-frontends/lnbh24.h
+++ b/drivers/media/dvb-frontends/lnbh24.h
@@ -37,7 +37,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if IS_ENABLED(CONFIG_DVB_LNBP21)
+#if IS_REACHABLE(CONFIG_DVB_LNBP21)
 /* override_set and override_clear control which
    system register bits (above) to always set & clear */
 extern struct dvb_frontend *lnbh24_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/lnbp21.h b/drivers/media/dvb-frontends/lnbp21.h
index dbcbcc2f20a3..a9b530de62a6 100644
--- a/drivers/media/dvb-frontends/lnbp21.h
+++ b/drivers/media/dvb-frontends/lnbp21.h
@@ -57,7 +57,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if IS_ENABLED(CONFIG_DVB_LNBP21)
+#if IS_REACHABLE(CONFIG_DVB_LNBP21)
 /* override_set and override_clear control which
  system register bits (above) to always set & clear */
 extern struct dvb_frontend *lnbp21_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/lnbp22.h b/drivers/media/dvb-frontends/lnbp22.h
index 63861b311dd8..628148385182 100644
--- a/drivers/media/dvb-frontends/lnbp22.h
+++ b/drivers/media/dvb-frontends/lnbp22.h
@@ -39,7 +39,7 @@
 
 #include <linux/dvb/frontend.h>
 
-#if IS_ENABLED(CONFIG_DVB_LNBP22)
+#if IS_REACHABLE(CONFIG_DVB_LNBP22)
 /*
  * override_set and override_clear control which system register bits (above)
  * to always set & clear
diff --git a/drivers/media/dvb-frontends/m88rs2000.h b/drivers/media/dvb-frontends/m88rs2000.h
index 0a50ea90736b..de7430178e9e 100644
--- a/drivers/media/dvb-frontends/m88rs2000.h
+++ b/drivers/media/dvb-frontends/m88rs2000.h
@@ -41,7 +41,7 @@ enum {
 	CALL_IS_READ,
 };
 
-#if IS_ENABLED(CONFIG_DVB_M88RS2000)
+#if IS_REACHABLE(CONFIG_DVB_M88RS2000)
 extern struct dvb_frontend *m88rs2000_attach(
 	const struct m88rs2000_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/mb86a16.h b/drivers/media/dvb-frontends/mb86a16.h
index 277ce061acf9..e486dc0d8e60 100644
--- a/drivers/media/dvb-frontends/mb86a16.h
+++ b/drivers/media/dvb-frontends/mb86a16.h
@@ -33,7 +33,7 @@ struct mb86a16_config {
 
 
 
-#if IS_ENABLED(CONFIG_DVB_MB86A16)
+#if IS_REACHABLE(CONFIG_DVB_MB86A16)
 
 extern struct dvb_frontend *mb86a16_attach(const struct mb86a16_config *config,
 					   struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index cbeb941fba7c..f749c8ac5f39 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -34,7 +34,7 @@ struct mb86a20s_config {
 	bool	is_serial;
 };
 
-#if IS_ENABLED(CONFIG_DVB_MB86A20S)
+#if IS_REACHABLE(CONFIG_DVB_MB86A20S)
 extern struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/mt312.h b/drivers/media/dvb-frontends/mt312.h
index 5706621ad79d..386939a90555 100644
--- a/drivers/media/dvb-frontends/mt312.h
+++ b/drivers/media/dvb-frontends/mt312.h
@@ -36,7 +36,7 @@ struct mt312_config {
 	unsigned int voltage_inverted:1;
 };
 
-#if IS_ENABLED(CONFIG_DVB_MT312)
+#if IS_REACHABLE(CONFIG_DVB_MT312)
 struct dvb_frontend *mt312_attach(const struct mt312_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/mt352.h b/drivers/media/dvb-frontends/mt352.h
index 451d904e1500..5873263bd1af 100644
--- a/drivers/media/dvb-frontends/mt352.h
+++ b/drivers/media/dvb-frontends/mt352.h
@@ -51,7 +51,7 @@ struct mt352_config
 	int (*demod_init)(struct dvb_frontend* fe);
 };
 
-#if IS_ENABLED(CONFIG_DVB_MT352)
+#if IS_REACHABLE(CONFIG_DVB_MT352)
 extern struct dvb_frontend* mt352_attach(const struct mt352_config* config,
 					 struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/nxt200x.h b/drivers/media/dvb-frontends/nxt200x.h
index e38d01fb6c2b..825b928ef542 100644
--- a/drivers/media/dvb-frontends/nxt200x.h
+++ b/drivers/media/dvb-frontends/nxt200x.h
@@ -42,7 +42,7 @@ struct nxt200x_config
 	int (*set_ts_params)(struct dvb_frontend* fe, int is_punctured);
 };
 
-#if IS_ENABLED(CONFIG_DVB_NXT200X)
+#if IS_REACHABLE(CONFIG_DVB_NXT200X)
 extern struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/nxt6000.h b/drivers/media/dvb-frontends/nxt6000.h
index b5867c2ae681..a94cefcc6dfd 100644
--- a/drivers/media/dvb-frontends/nxt6000.h
+++ b/drivers/media/dvb-frontends/nxt6000.h
@@ -33,7 +33,7 @@ struct nxt6000_config
 	u8 clock_inversion:1;
 };
 
-#if IS_ENABLED(CONFIG_DVB_NXT6000)
+#if IS_REACHABLE(CONFIG_DVB_NXT6000)
 extern struct dvb_frontend* nxt6000_attach(const struct nxt6000_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/or51132.h b/drivers/media/dvb-frontends/or51132.h
index cdb5be3c65d6..9acf8dc87413 100644
--- a/drivers/media/dvb-frontends/or51132.h
+++ b/drivers/media/dvb-frontends/or51132.h
@@ -34,7 +34,7 @@ struct or51132_config
 	int (*set_ts_params)(struct dvb_frontend* fe, int is_punctured);
 };
 
-#if IS_ENABLED(CONFIG_DVB_OR51132)
+#if IS_REACHABLE(CONFIG_DVB_OR51132)
 extern struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/or51211.h b/drivers/media/dvb-frontends/or51211.h
index 9a8ae936b62d..cc6adab63249 100644
--- a/drivers/media/dvb-frontends/or51211.h
+++ b/drivers/media/dvb-frontends/or51211.h
@@ -37,7 +37,7 @@ struct or51211_config
 	void (*sleep)(struct dvb_frontend * fe);
 };
 
-#if IS_ENABLED(CONFIG_DVB_OR51211)
+#if IS_REACHABLE(CONFIG_DVB_OR51211)
 extern struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1409.h b/drivers/media/dvb-frontends/s5h1409.h
index 9e143f5c8107..f58b9ca5557a 100644
--- a/drivers/media/dvb-frontends/s5h1409.h
+++ b/drivers/media/dvb-frontends/s5h1409.h
@@ -67,7 +67,7 @@ struct s5h1409_config {
 	u8 hvr1600_opt;
 };
 
-#if IS_ENABLED(CONFIG_DVB_S5H1409)
+#if IS_REACHABLE(CONFIG_DVB_S5H1409)
 extern struct dvb_frontend *s5h1409_attach(const struct s5h1409_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1411.h b/drivers/media/dvb-frontends/s5h1411.h
index 1d7deb615674..f3a87f7ec360 100644
--- a/drivers/media/dvb-frontends/s5h1411.h
+++ b/drivers/media/dvb-frontends/s5h1411.h
@@ -69,7 +69,7 @@ struct s5h1411_config {
 	u8 status_mode;
 };
 
-#if IS_ENABLED(CONFIG_DVB_S5H1411)
+#if IS_REACHABLE(CONFIG_DVB_S5H1411)
 extern struct dvb_frontend *s5h1411_attach(const struct s5h1411_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1420.h b/drivers/media/dvb-frontends/s5h1420.h
index 210049b5cf30..142d93e7d02b 100644
--- a/drivers/media/dvb-frontends/s5h1420.h
+++ b/drivers/media/dvb-frontends/s5h1420.h
@@ -40,7 +40,7 @@ struct s5h1420_config
 	u8 serial_mpeg:1;
 };
 
-#if IS_ENABLED(CONFIG_DVB_S5H1420)
+#if IS_REACHABLE(CONFIG_DVB_S5H1420)
 extern struct dvb_frontend *s5h1420_attach(const struct s5h1420_config *config,
 	     struct i2c_adapter *i2c);
 extern struct i2c_adapter *s5h1420_get_tuner_i2c_adapter(struct dvb_frontend *fe);
diff --git a/drivers/media/dvb-frontends/s5h1432.h b/drivers/media/dvb-frontends/s5h1432.h
index 70917dd2533a..f490c5ee5801 100644
--- a/drivers/media/dvb-frontends/s5h1432.h
+++ b/drivers/media/dvb-frontends/s5h1432.h
@@ -75,7 +75,7 @@ struct s5h1432_config {
 	u8 status_mode;
 };
 
-#if IS_ENABLED(CONFIG_DVB_S5H1432)
+#if IS_REACHABLE(CONFIG_DVB_S5H1432)
 extern struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s921.h b/drivers/media/dvb-frontends/s921.h
index 9b20c9e0eb88..7d3999a4e974 100644
--- a/drivers/media/dvb-frontends/s921.h
+++ b/drivers/media/dvb-frontends/s921.h
@@ -25,7 +25,7 @@ struct s921_config {
 	u8 demod_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_S921)
+#if IS_REACHABLE(CONFIG_DVB_S921)
 extern struct dvb_frontend *s921_attach(const struct s921_config *config,
 					   struct i2c_adapter *i2c);
 extern struct i2c_adapter *s921_get_tuner_i2c_adapter(struct dvb_frontend *);
diff --git a/drivers/media/dvb-frontends/si21xx.h b/drivers/media/dvb-frontends/si21xx.h
index 1509fed44a3a..ef5f351ca68e 100644
--- a/drivers/media/dvb-frontends/si21xx.h
+++ b/drivers/media/dvb-frontends/si21xx.h
@@ -13,7 +13,7 @@ struct si21xx_config {
 	int min_delay_ms;
 };
 
-#if IS_ENABLED(CONFIG_DVB_SI21XX)
+#if IS_REACHABLE(CONFIG_DVB_SI21XX)
 extern struct dvb_frontend *si21xx_attach(const struct si21xx_config *config,
 						struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/sp8870.h b/drivers/media/dvb-frontends/sp8870.h
index 065ec67d4e30..f507b9fd707b 100644
--- a/drivers/media/dvb-frontends/sp8870.h
+++ b/drivers/media/dvb-frontends/sp8870.h
@@ -35,7 +35,7 @@ struct sp8870_config
 	int (*request_firmware)(struct dvb_frontend* fe, const struct firmware **fw, char* name);
 };
 
-#if IS_ENABLED(CONFIG_DVB_SP8870)
+#if IS_REACHABLE(CONFIG_DVB_SP8870)
 extern struct dvb_frontend* sp8870_attach(const struct sp8870_config* config,
 					  struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/sp887x.h b/drivers/media/dvb-frontends/sp887x.h
index 2cdc4e8bc9cd..412f011e6dfd 100644
--- a/drivers/media/dvb-frontends/sp887x.h
+++ b/drivers/media/dvb-frontends/sp887x.h
@@ -17,7 +17,7 @@ struct sp887x_config
 	int (*request_firmware)(struct dvb_frontend* fe, const struct firmware **fw, char* name);
 };
 
-#if IS_ENABLED(CONFIG_DVB_SP887X)
+#if IS_REACHABLE(CONFIG_DVB_SP887X)
 extern struct dvb_frontend* sp887x_attach(const struct sp887x_config* config,
 					  struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stb0899_drv.h b/drivers/media/dvb-frontends/stb0899_drv.h
index 139264d19263..0a72131a57db 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.h
+++ b/drivers/media/dvb-frontends/stb0899_drv.h
@@ -141,7 +141,7 @@ struct stb0899_config {
 	int (*tuner_set_rfsiggain)(struct dvb_frontend *fe, u32 rf_gain);
 };
 
-#if IS_ENABLED(CONFIG_DVB_STB0899)
+#if IS_REACHABLE(CONFIG_DVB_STB0899)
 
 extern struct dvb_frontend *stb0899_attach(struct stb0899_config *config,
 					   struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/stb6000.h b/drivers/media/dvb-frontends/stb6000.h
index a768189bfaad..da581b652cb9 100644
--- a/drivers/media/dvb-frontends/stb6000.h
+++ b/drivers/media/dvb-frontends/stb6000.h
@@ -35,7 +35,7 @@
  * @param i2c i2c adapter to use.
  * @return FE pointer on success, NULL on failure.
  */
-#if IS_ENABLED(CONFIG_DVB_STB6000)
+#if IS_REACHABLE(CONFIG_DVB_STB6000)
 extern struct dvb_frontend *stb6000_attach(struct dvb_frontend *fe, int addr,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stb6100.h b/drivers/media/dvb-frontends/stb6100.h
index 3a1e40f3b8be..218c8188865d 100644
--- a/drivers/media/dvb-frontends/stb6100.h
+++ b/drivers/media/dvb-frontends/stb6100.h
@@ -94,7 +94,7 @@ struct stb6100_state {
 	u32 reference;
 };
 
-#if IS_ENABLED(CONFIG_DVB_STB6100)
+#if IS_REACHABLE(CONFIG_DVB_STB6100)
 
 extern struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
 					   const struct stb6100_config *config,
diff --git a/drivers/media/dvb-frontends/stv0288.h b/drivers/media/dvb-frontends/stv0288.h
index a0bd93107154..b58603c00c80 100644
--- a/drivers/media/dvb-frontends/stv0288.h
+++ b/drivers/media/dvb-frontends/stv0288.h
@@ -43,7 +43,7 @@ struct stv0288_config {
 	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
 };
 
-#if IS_ENABLED(CONFIG_DVB_STV0288)
+#if IS_REACHABLE(CONFIG_DVB_STV0288)
 extern struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv0297.h b/drivers/media/dvb-frontends/stv0297.h
index c8ff3639ce00..b30632a67333 100644
--- a/drivers/media/dvb-frontends/stv0297.h
+++ b/drivers/media/dvb-frontends/stv0297.h
@@ -42,7 +42,7 @@ struct stv0297_config
 	u8 stop_during_read:1;
 };
 
-#if IS_ENABLED(CONFIG_DVB_STV0297)
+#if IS_REACHABLE(CONFIG_DVB_STV0297)
 extern struct dvb_frontend* stv0297_attach(const struct stv0297_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv0299.h b/drivers/media/dvb-frontends/stv0299.h
index 06f70fc8327b..0aca30a8ec25 100644
--- a/drivers/media/dvb-frontends/stv0299.h
+++ b/drivers/media/dvb-frontends/stv0299.h
@@ -95,7 +95,7 @@ struct stv0299_config
 	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
 };
 
-#if IS_ENABLED(CONFIG_DVB_STV0299)
+#if IS_REACHABLE(CONFIG_DVB_STV0299)
 extern struct dvb_frontend *stv0299_attach(const struct stv0299_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv0367.h b/drivers/media/dvb-frontends/stv0367.h
index ea80b341f094..92b3e85fb818 100644
--- a/drivers/media/dvb-frontends/stv0367.h
+++ b/drivers/media/dvb-frontends/stv0367.h
@@ -39,7 +39,7 @@ struct stv0367_config {
 	int clk_pol;
 };
 
-#if IS_ENABLED(CONFIG_DVB_STV0367)
+#if IS_REACHABLE(CONFIG_DVB_STV0367)
 extern struct
 dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/stv0900.h b/drivers/media/dvb-frontends/stv0900.h
index e2a6dc69ecb4..c90bf00ea9ce 100644
--- a/drivers/media/dvb-frontends/stv0900.h
+++ b/drivers/media/dvb-frontends/stv0900.h
@@ -58,7 +58,7 @@ struct stv0900_config {
 	void (*set_lock_led)(struct dvb_frontend *fe, int offon);
 };
 
-#if IS_ENABLED(CONFIG_DVB_STV0900)
+#if IS_REACHABLE(CONFIG_DVB_STV0900)
 extern struct dvb_frontend *stv0900_attach(const struct stv0900_config *config,
 					struct i2c_adapter *i2c, int demod);
 #else
diff --git a/drivers/media/dvb-frontends/stv090x.h b/drivers/media/dvb-frontends/stv090x.h
index 742eeda99000..012e55e5032e 100644
--- a/drivers/media/dvb-frontends/stv090x.h
+++ b/drivers/media/dvb-frontends/stv090x.h
@@ -107,7 +107,7 @@ struct stv090x_config {
 			u8 xor_value);
 };
 
-#if IS_ENABLED(CONFIG_DVB_STV090x)
+#if IS_REACHABLE(CONFIG_DVB_STV090x)
 
 struct dvb_frontend *stv090x_attach(struct stv090x_config *config,
 				    struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/stv6110.h b/drivers/media/dvb-frontends/stv6110.h
index 8fa07e6a6745..f3c8a5c6b77d 100644
--- a/drivers/media/dvb-frontends/stv6110.h
+++ b/drivers/media/dvb-frontends/stv6110.h
@@ -46,7 +46,7 @@ struct stv6110_config {
 	u8 clk_div;	/* divisor value for the output clock */
 };
 
-#if IS_ENABLED(CONFIG_DVB_STV6110)
+#if IS_REACHABLE(CONFIG_DVB_STV6110)
 extern struct dvb_frontend *stv6110_attach(struct dvb_frontend *fe,
 					const struct stv6110_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/stv6110x.h b/drivers/media/dvb-frontends/stv6110x.h
index bc4766db29c5..9f7eb251aec3 100644
--- a/drivers/media/dvb-frontends/stv6110x.h
+++ b/drivers/media/dvb-frontends/stv6110x.h
@@ -53,7 +53,7 @@ struct stv6110x_devctl {
 };
 
 
-#if IS_ENABLED(CONFIG_DVB_STV6110x)
+#if IS_REACHABLE(CONFIG_DVB_STV6110x)
 
 extern struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
 					       const struct stv6110x_config *config,
diff --git a/drivers/media/dvb-frontends/tda1002x.h b/drivers/media/dvb-frontends/tda1002x.h
index e404b6e44802..0d334613de1b 100644
--- a/drivers/media/dvb-frontends/tda1002x.h
+++ b/drivers/media/dvb-frontends/tda1002x.h
@@ -57,7 +57,7 @@ struct tda10023_config {
 	u16 deltaf;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TDA10021)
+#if IS_REACHABLE(CONFIG_DVB_TDA10021)
 extern struct dvb_frontend* tda10021_attach(const struct tda1002x_config* config,
 					    struct i2c_adapter* i2c, u8 pwm);
 #else
@@ -69,7 +69,7 @@ static inline struct dvb_frontend* tda10021_attach(const struct tda1002x_config*
 }
 #endif // CONFIG_DVB_TDA10021
 
-#if IS_ENABLED(CONFIG_DVB_TDA10023)
+#if IS_REACHABLE(CONFIG_DVB_TDA10023)
 extern struct dvb_frontend *tda10023_attach(
 	const struct tda10023_config *config,
 	struct i2c_adapter *i2c, u8 pwm);
diff --git a/drivers/media/dvb-frontends/tda10048.h b/drivers/media/dvb-frontends/tda10048.h
index 5e7bf4e47cb3..bc77a7311de1 100644
--- a/drivers/media/dvb-frontends/tda10048.h
+++ b/drivers/media/dvb-frontends/tda10048.h
@@ -73,7 +73,7 @@ struct tda10048_config {
 	u8 pll_n;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TDA10048)
+#if IS_REACHABLE(CONFIG_DVB_TDA10048)
 extern struct dvb_frontend *tda10048_attach(
 	const struct tda10048_config *config,
 	struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/tda1004x.h b/drivers/media/dvb-frontends/tda1004x.h
index dd283fbb61c0..efd7659dace9 100644
--- a/drivers/media/dvb-frontends/tda1004x.h
+++ b/drivers/media/dvb-frontends/tda1004x.h
@@ -117,7 +117,7 @@ struct tda1004x_state {
 	enum tda1004x_demod demod_type;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TDA1004X)
+#if IS_REACHABLE(CONFIG_DVB_TDA1004X)
 extern struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 					    struct i2c_adapter* i2c);
 
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index 331b5a819383..da89f4249846 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -72,7 +72,7 @@ struct tda10071_config {
 };
 
 
-#if IS_ENABLED(CONFIG_DVB_TDA10071)
+#if IS_REACHABLE(CONFIG_DVB_TDA10071)
 extern struct dvb_frontend *tda10071_attach(
 	const struct tda10071_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda10086.h b/drivers/media/dvb-frontends/tda10086.h
index 458fe91c1b88..690e469995b6 100644
--- a/drivers/media/dvb-frontends/tda10086.h
+++ b/drivers/media/dvb-frontends/tda10086.h
@@ -46,7 +46,7 @@ struct tda10086_config
 	enum tda10086_xtal xtal_freq;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TDA10086)
+#if IS_REACHABLE(CONFIG_DVB_TDA10086)
 extern struct dvb_frontend* tda10086_attach(const struct tda10086_config* config,
 					    struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.h b/drivers/media/dvb-frontends/tda18271c2dd.h
index dd84f7b69bec..7ebd8eaff4eb 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.h
+++ b/drivers/media/dvb-frontends/tda18271c2dd.h
@@ -3,7 +3,7 @@
 
 #include <linux/kconfig.h>
 
-#if IS_ENABLED(CONFIG_DVB_TDA18271C2DD)
+#if IS_REACHABLE(CONFIG_DVB_TDA18271C2DD)
 struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
 					 struct i2c_adapter *i2c, u8 adr);
 #else
diff --git a/drivers/media/dvb-frontends/tda665x.h b/drivers/media/dvb-frontends/tda665x.h
index 03a0da6d5cf2..baf520baa42e 100644
--- a/drivers/media/dvb-frontends/tda665x.h
+++ b/drivers/media/dvb-frontends/tda665x.h
@@ -31,7 +31,7 @@ struct tda665x_config {
 	u32	ref_divider;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TDA665x)
+#if IS_REACHABLE(CONFIG_DVB_TDA665x)
 
 extern struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
 					   const struct tda665x_config *config,
diff --git a/drivers/media/dvb-frontends/tda8083.h b/drivers/media/dvb-frontends/tda8083.h
index de6b1860dfdd..46be06fa7e0d 100644
--- a/drivers/media/dvb-frontends/tda8083.h
+++ b/drivers/media/dvb-frontends/tda8083.h
@@ -35,7 +35,7 @@ struct tda8083_config
 	u8 demod_address;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TDA8083)
+#if IS_REACHABLE(CONFIG_DVB_TDA8083)
 extern struct dvb_frontend* tda8083_attach(const struct tda8083_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda8261.h b/drivers/media/dvb-frontends/tda8261.h
index 55cf4ffcbfdf..9fa5b3076d5b 100644
--- a/drivers/media/dvb-frontends/tda8261.h
+++ b/drivers/media/dvb-frontends/tda8261.h
@@ -34,7 +34,7 @@ struct tda8261_config {
 	enum tda8261_step	step_size;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TDA8261)
+#if IS_REACHABLE(CONFIG_DVB_TDA8261)
 
 extern struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
 					   const struct tda8261_config *config,
diff --git a/drivers/media/dvb-frontends/tda826x.h b/drivers/media/dvb-frontends/tda826x.h
index 5f0f20e7e4f8..81abe1aebe9f 100644
--- a/drivers/media/dvb-frontends/tda826x.h
+++ b/drivers/media/dvb-frontends/tda826x.h
@@ -35,7 +35,7 @@
  * @param has_loopthrough Set to 1 if the card has a loopthrough RF connector.
  * @return FE pointer on success, NULL on failure.
  */
-#if IS_ENABLED(CONFIG_DVB_TDA826X)
+#if IS_REACHABLE(CONFIG_DVB_TDA826X)
 extern struct dvb_frontend* tda826x_attach(struct dvb_frontend *fe, int addr,
 					   struct i2c_adapter *i2c,
 					   int has_loopthrough);
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index b2fe6bb3a38b..595841def66d 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -31,7 +31,7 @@ struct ts2020_config {
 	u32 frequency_div;
 };
 
-#if IS_ENABLED(CONFIG_DVB_TS2020)
+#if IS_REACHABLE(CONFIG_DVB_TS2020)
 
 extern struct dvb_frontend *ts2020_attach(
 	struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/tua6100.h b/drivers/media/dvb-frontends/tua6100.h
index 83a9c30e67ca..52919e04e258 100644
--- a/drivers/media/dvb-frontends/tua6100.h
+++ b/drivers/media/dvb-frontends/tua6100.h
@@ -34,7 +34,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if IS_ENABLED(CONFIG_DVB_TUA6100)
+#if IS_REACHABLE(CONFIG_DVB_TUA6100)
 extern struct dvb_frontend *tua6100_attach(struct dvb_frontend *fe, int addr, struct i2c_adapter *i2c);
 #else
 static inline struct dvb_frontend* tua6100_attach(struct dvb_frontend *fe, int addr, struct i2c_adapter *i2c)
diff --git a/drivers/media/dvb-frontends/ves1820.h b/drivers/media/dvb-frontends/ves1820.h
index c073f353ac38..ece46fdcd714 100644
--- a/drivers/media/dvb-frontends/ves1820.h
+++ b/drivers/media/dvb-frontends/ves1820.h
@@ -41,7 +41,7 @@ struct ves1820_config
 	u8 selagc:1;
 };
 
-#if IS_ENABLED(CONFIG_DVB_VES1820)
+#if IS_REACHABLE(CONFIG_DVB_VES1820)
 extern struct dvb_frontend* ves1820_attach(const struct ves1820_config* config,
 					   struct i2c_adapter* i2c, u8 pwm);
 #else
diff --git a/drivers/media/dvb-frontends/ves1x93.h b/drivers/media/dvb-frontends/ves1x93.h
index 2307caea6aec..4510fe2f6676 100644
--- a/drivers/media/dvb-frontends/ves1x93.h
+++ b/drivers/media/dvb-frontends/ves1x93.h
@@ -40,7 +40,7 @@ struct ves1x93_config
 	u8 invert_pwm:1;
 };
 
-#if IS_ENABLED(CONFIG_DVB_VES1X93)
+#if IS_REACHABLE(CONFIG_DVB_VES1X93)
 extern struct dvb_frontend* ves1x93_attach(const struct ves1x93_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/zl10036.h b/drivers/media/dvb-frontends/zl10036.h
index 5f1e8217eeb6..670e76a654ee 100644
--- a/drivers/media/dvb-frontends/zl10036.h
+++ b/drivers/media/dvb-frontends/zl10036.h
@@ -38,7 +38,7 @@ struct zl10036_config {
 	int rf_loop_enable;
 };
 
-#if IS_ENABLED(CONFIG_DVB_ZL10036)
+#if IS_REACHABLE(CONFIG_DVB_ZL10036)
 extern struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
 	const struct zl10036_config *config, struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/zl10039.h b/drivers/media/dvb-frontends/zl10039.h
index 750b9bca9d02..070929444e71 100644
--- a/drivers/media/dvb-frontends/zl10039.h
+++ b/drivers/media/dvb-frontends/zl10039.h
@@ -24,7 +24,7 @@
 
 #include <linux/kconfig.h>
 
-#if IS_ENABLED(CONFIG_DVB_ZL10039)
+#if IS_REACHABLE(CONFIG_DVB_ZL10039)
 struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
 					u8 i2c_addr,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/zl10353.h b/drivers/media/dvb-frontends/zl10353.h
index 50c1004aef36..37aa6e8f454a 100644
--- a/drivers/media/dvb-frontends/zl10353.h
+++ b/drivers/media/dvb-frontends/zl10353.h
@@ -47,7 +47,7 @@ struct zl10353_config
 	u8 pll_0;        /* default: 0x15 */
 };
 
-#if IS_ENABLED(CONFIG_DVB_ZL10353)
+#if IS_REACHABLE(CONFIG_DVB_ZL10353)
 extern struct dvb_frontend* zl10353_attach(const struct zl10353_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/pci/cx23885/altera-ci.h b/drivers/media/pci/cx23885/altera-ci.h
index 5028f0cf83f4..6c511723fd1b 100644
--- a/drivers/media/pci/cx23885/altera-ci.h
+++ b/drivers/media/pci/cx23885/altera-ci.h
@@ -39,7 +39,7 @@ struct altera_ci_config {
 	int (*fpga_rw) (void *dev, int ad_rg, int val, int rw);
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_ALTERA_CI)
+#if IS_REACHABLE(CONFIG_MEDIA_ALTERA_CI)
 
 extern int altera_ci_init(struct altera_ci_config *config, int ci_nr);
 extern void altera_ci_release(void *dev, int ci_nr);
diff --git a/drivers/media/tuners/fc0011.h b/drivers/media/tuners/fc0011.h
index 43ec893a6877..81bb568d6943 100644
--- a/drivers/media/tuners/fc0011.h
+++ b/drivers/media/tuners/fc0011.h
@@ -23,7 +23,7 @@ enum fc0011_fe_callback_commands {
 	FC0011_FE_CALLBACK_RESET,
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0011)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_FC0011)
 struct dvb_frontend *fc0011_attach(struct dvb_frontend *fe,
 				   struct i2c_adapter *i2c,
 				   const struct fc0011_config *config);
diff --git a/drivers/media/tuners/fc0012.h b/drivers/media/tuners/fc0012.h
index 1d08057e3275..9ad32859bab0 100644
--- a/drivers/media/tuners/fc0012.h
+++ b/drivers/media/tuners/fc0012.h
@@ -49,7 +49,7 @@ struct fc0012_config {
 	bool clock_out;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0012)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_FC0012)
 extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
 					struct i2c_adapter *i2c,
 					const struct fc0012_config *cfg);
diff --git a/drivers/media/tuners/fc0013.h b/drivers/media/tuners/fc0013.h
index d65d5b37f56e..e130bd7a3230 100644
--- a/drivers/media/tuners/fc0013.h
+++ b/drivers/media/tuners/fc0013.h
@@ -26,7 +26,7 @@
 #include "dvb_frontend.h"
 #include "fc001x-common.h"
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC0013)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_FC0013)
 extern struct dvb_frontend *fc0013_attach(struct dvb_frontend *fe,
 					struct i2c_adapter *i2c,
 					u8 i2c_address, int dual_master,
diff --git a/drivers/media/tuners/fc2580.h b/drivers/media/tuners/fc2580.h
index 9c43c1cc82d9..b1ce6770f88e 100644
--- a/drivers/media/tuners/fc2580.h
+++ b/drivers/media/tuners/fc2580.h
@@ -37,7 +37,7 @@ struct fc2580_config {
 	u32 clock;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_FC2580)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_FC2580)
 extern struct dvb_frontend *fc2580_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, const struct fc2580_config *cfg);
 #else
diff --git a/drivers/media/tuners/max2165.h b/drivers/media/tuners/max2165.h
index 26e1dc64bb67..5054f01a78fb 100644
--- a/drivers/media/tuners/max2165.h
+++ b/drivers/media/tuners/max2165.h
@@ -32,7 +32,7 @@ struct max2165_config {
 	u8 osc_clk; /* in MHz, selectable values: 4,16,18,20,22,24,26,28 */
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MAX2165)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MAX2165)
 extern struct dvb_frontend *max2165_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c,
 	struct max2165_config *cfg);
diff --git a/drivers/media/tuners/mc44s803.h b/drivers/media/tuners/mc44s803.h
index 9aae50aca2b7..b3e614be657d 100644
--- a/drivers/media/tuners/mc44s803.h
+++ b/drivers/media/tuners/mc44s803.h
@@ -32,7 +32,7 @@ struct mc44s803_config {
 	u8 dig_out;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MC44S803)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MC44S803)
 extern struct dvb_frontend *mc44s803_attach(struct dvb_frontend *fe,
 	 struct i2c_adapter *i2c, struct mc44s803_config *cfg);
 #else
diff --git a/drivers/media/tuners/mt2060.h b/drivers/media/tuners/mt2060.h
index c64fc19cb278..6efed359a24f 100644
--- a/drivers/media/tuners/mt2060.h
+++ b/drivers/media/tuners/mt2060.h
@@ -30,7 +30,7 @@ struct mt2060_config {
 	u8 clock_out; /* 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1 */
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2060)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MT2060)
 extern struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2060_config *cfg, u16 if1);
 #else
 static inline struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2060_config *cfg, u16 if1)
diff --git a/drivers/media/tuners/mt2063.h b/drivers/media/tuners/mt2063.h
index e1acfc8e7ae3..e55e0a6dd1be 100644
--- a/drivers/media/tuners/mt2063.h
+++ b/drivers/media/tuners/mt2063.h
@@ -8,7 +8,7 @@ struct mt2063_config {
 	u32 refclock;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2063)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MT2063)
 struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 				   struct mt2063_config *config,
 				   struct i2c_adapter *i2c);
diff --git a/drivers/media/tuners/mt20xx.h b/drivers/media/tuners/mt20xx.h
index f56241ccaa00..9912362b415e 100644
--- a/drivers/media/tuners/mt20xx.h
+++ b/drivers/media/tuners/mt20xx.h
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT20XX)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MT20XX)
 extern struct dvb_frontend *microtune_attach(struct dvb_frontend *fe,
 					     struct i2c_adapter* i2c_adap,
 					     u8 i2c_addr);
diff --git a/drivers/media/tuners/mt2131.h b/drivers/media/tuners/mt2131.h
index 837c854b9c65..8267a6ae5d84 100644
--- a/drivers/media/tuners/mt2131.h
+++ b/drivers/media/tuners/mt2131.h
@@ -30,7 +30,7 @@ struct mt2131_config {
 	u8 clock_out; /* 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1 */
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2131)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MT2131)
 extern struct dvb_frontend* mt2131_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct mt2131_config *cfg,
diff --git a/drivers/media/tuners/mt2266.h b/drivers/media/tuners/mt2266.h
index fad6dd657d77..69abefa18c37 100644
--- a/drivers/media/tuners/mt2266.h
+++ b/drivers/media/tuners/mt2266.h
@@ -24,7 +24,7 @@ struct mt2266_config {
 	u8 i2c_address;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2266)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MT2266)
 extern struct dvb_frontend * mt2266_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2266_config *cfg);
 #else
 static inline struct dvb_frontend * mt2266_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2266_config *cfg)
diff --git a/drivers/media/tuners/mxl5005s.h b/drivers/media/tuners/mxl5005s.h
index ae8db885ad87..5764b12c5c7c 100644
--- a/drivers/media/tuners/mxl5005s.h
+++ b/drivers/media/tuners/mxl5005s.h
@@ -118,7 +118,7 @@ struct mxl5005s_config {
 	u8 AgcMasterByte;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL5005S)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MXL5005S)
 extern struct dvb_frontend *mxl5005s_attach(struct dvb_frontend *fe,
 					    struct i2c_adapter *i2c,
 					    struct mxl5005s_config *config);
diff --git a/drivers/media/tuners/mxl5007t.h b/drivers/media/tuners/mxl5007t.h
index ae7037d681c5..e786d1f23ff1 100644
--- a/drivers/media/tuners/mxl5007t.h
+++ b/drivers/media/tuners/mxl5007t.h
@@ -77,7 +77,7 @@ struct mxl5007t_config {
 	unsigned int clk_out_enable:1;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL5007T)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_MXL5007T)
 extern struct dvb_frontend *mxl5007t_attach(struct dvb_frontend *fe,
 					    struct i2c_adapter *i2c, u8 addr,
 					    struct mxl5007t_config *cfg);
diff --git a/drivers/media/tuners/qt1010.h b/drivers/media/tuners/qt1010.h
index 8ab5d479749f..e3198f23437c 100644
--- a/drivers/media/tuners/qt1010.h
+++ b/drivers/media/tuners/qt1010.h
@@ -36,7 +36,7 @@ struct qt1010_config {
  * @param cfg  tuner hw based configuration
  * @return fe  pointer on success, NULL on failure
  */
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_QT1010)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_QT1010)
 extern struct dvb_frontend *qt1010_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct qt1010_config *cfg);
diff --git a/drivers/media/tuners/r820t.h b/drivers/media/tuners/r820t.h
index 48af3548027d..b1e5661af1c7 100644
--- a/drivers/media/tuners/r820t.h
+++ b/drivers/media/tuners/r820t.h
@@ -42,7 +42,7 @@ struct r820t_config {
 	bool use_predetect;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_R820T)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_R820T)
 struct dvb_frontend *r820t_attach(struct dvb_frontend *fe,
 				  struct i2c_adapter *i2c,
 				  const struct r820t_config *cfg);
diff --git a/drivers/media/tuners/tda18218.h b/drivers/media/tuners/tda18218.h
index 366410e0cc9a..1eacb4f84e93 100644
--- a/drivers/media/tuners/tda18218.h
+++ b/drivers/media/tuners/tda18218.h
@@ -30,7 +30,7 @@ struct tda18218_config {
 	u8 loop_through:1;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18218)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TDA18218)
 extern struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, struct tda18218_config *cfg);
 #else
diff --git a/drivers/media/tuners/tda18271.h b/drivers/media/tuners/tda18271.h
index 4c418d63f540..0a846333ce57 100644
--- a/drivers/media/tuners/tda18271.h
+++ b/drivers/media/tuners/tda18271.h
@@ -121,7 +121,7 @@ enum tda18271_mode {
 	TDA18271_DIGITAL,
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18271)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TDA18271)
 extern struct dvb_frontend *tda18271_attach(struct dvb_frontend *fe, u8 addr,
 					    struct i2c_adapter *i2c,
 					    struct tda18271_config *cfg);
diff --git a/drivers/media/tuners/tda827x.h b/drivers/media/tuners/tda827x.h
index b64292152baf..abf2e2fe5350 100644
--- a/drivers/media/tuners/tda827x.h
+++ b/drivers/media/tuners/tda827x.h
@@ -51,7 +51,7 @@ struct tda827x_config
  * @param cfg optional callback function pointers.
  * @return FE pointer on success, NULL on failure.
  */
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA827X)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TDA827X)
 extern struct dvb_frontend* tda827x_attach(struct dvb_frontend *fe, int addr,
 					   struct i2c_adapter *i2c,
 					   struct tda827x_config *cfg);
diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
index cf96e585785e..901b8cac7105 100644
--- a/drivers/media/tuners/tda8290.h
+++ b/drivers/media/tuners/tda8290.h
@@ -38,7 +38,7 @@ struct tda829x_config {
 	struct tda18271_std_map *tda18271_std_map;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA8290)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TDA8290)
 extern int tda829x_probe(struct i2c_adapter *i2c_adap, u8 i2c_addr);
 
 extern struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/tuners/tda9887.h b/drivers/media/tuners/tda9887.h
index 37a4a1123e0c..95070eca02ca 100644
--- a/drivers/media/tuners/tda9887.h
+++ b/drivers/media/tuners/tda9887.h
@@ -21,7 +21,7 @@
 #include "dvb_frontend.h"
 
 /* ------------------------------------------------------------------------ */
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA9887)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TDA9887)
 extern struct dvb_frontend *tda9887_attach(struct dvb_frontend *fe,
 					   struct i2c_adapter *i2c_adap,
 					   u8 i2c_addr);
diff --git a/drivers/media/tuners/tea5761.h b/drivers/media/tuners/tea5761.h
index 933228ffb509..2d624d9919e3 100644
--- a/drivers/media/tuners/tea5761.h
+++ b/drivers/media/tuners/tea5761.h
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TEA5761)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TEA5761)
 extern int tea5761_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr);
 
 extern struct dvb_frontend *tea5761_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/tuners/tea5767.h b/drivers/media/tuners/tea5767.h
index c39101199383..4f6f6c92db78 100644
--- a/drivers/media/tuners/tea5767.h
+++ b/drivers/media/tuners/tea5767.h
@@ -39,7 +39,7 @@ struct tea5767_ctrl {
 	enum tea5767_xtal	xtal_freq;
 };
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TEA5767)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TEA5767)
 extern int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr);
 
 extern struct dvb_frontend *tea5767_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/tuners/tua9001.h b/drivers/media/tuners/tua9001.h
index 26358da1c100..2c3375c7aeb9 100644
--- a/drivers/media/tuners/tua9001.h
+++ b/drivers/media/tuners/tua9001.h
@@ -51,7 +51,7 @@ struct tua9001_config {
 #define TUA9001_CMD_RESETN  1
 #define TUA9001_CMD_RXEN    2
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_TUA9001)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_TUA9001)
 extern struct dvb_frontend *tua9001_attach(struct dvb_frontend *fe,
 		struct i2c_adapter *i2c, struct tua9001_config *cfg);
 #else
diff --git a/drivers/media/tuners/tuner-simple.h b/drivers/media/tuners/tuner-simple.h
index ffd12cfe650b..6399b45b0590 100644
--- a/drivers/media/tuners/tuner-simple.h
+++ b/drivers/media/tuners/tuner-simple.h
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_SIMPLE)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_SIMPLE)
 extern struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
 						struct i2c_adapter *i2c_adap,
 						u8 i2c_addr,
diff --git a/drivers/media/tuners/tuner-xc2028.h b/drivers/media/tuners/tuner-xc2028.h
index 181d087faec4..98e4effca896 100644
--- a/drivers/media/tuners/tuner-xc2028.h
+++ b/drivers/media/tuners/tuner-xc2028.h
@@ -56,7 +56,7 @@ struct xc2028_config {
 #define XC2028_RESET_CLK	1
 #define XC2028_I2C_FLUSH	2
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_XC2028)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_XC2028)
 extern struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
 					  struct xc2028_config *cfg);
 #else
diff --git a/drivers/media/tuners/xc4000.h b/drivers/media/tuners/xc4000.h
index 97c23de5296c..40517860cf67 100644
--- a/drivers/media/tuners/xc4000.h
+++ b/drivers/media/tuners/xc4000.h
@@ -50,7 +50,7 @@ struct xc4000_config {
  * it's passed back to a bridge during tuner_callback().
  */
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_XC4000)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_XC4000)
 extern struct dvb_frontend *xc4000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct xc4000_config *cfg);
diff --git a/drivers/media/tuners/xc5000.h b/drivers/media/tuners/xc5000.h
index 6aa534f17a30..00ba29e21fb9 100644
--- a/drivers/media/tuners/xc5000.h
+++ b/drivers/media/tuners/xc5000.h
@@ -58,7 +58,7 @@ struct xc5000_config {
  * it's passed back to a bridge during tuner_callback().
  */
 
-#if IS_ENABLED(CONFIG_MEDIA_TUNER_XC5000)
+#if IS_REACHABLE(CONFIG_MEDIA_TUNER_XC5000)
 extern struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  const struct xc5000_config *cfg);
diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
index be342b94c640..16cfb3448568 100644
--- a/include/linux/kconfig.h
+++ b/include/linux/kconfig.h
@@ -43,4 +43,13 @@
  */
 #define IS_MODULE(option) config_enabled(option##_MODULE)
 
+/*
+ * IS_REACHABLE(CONFIG_FOO) evaluates to 1 if the currently compiled
+ * code can call a function defined in code compiled based on CONFIG_FOO.
+ * This is similar to IS_ENABLED(), but returns false when invoked from
+ * built-in code when CONFIG_FOO is set to 'm'.
+ */
+#define IS_REACHABLE(option) (config_enabled(option) || \
+		 (config_enabled(option##_MODULE) && config_enabled(MODULE)))
+
 #endif /* __LINUX_KCONFIG_H */

