Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:43130 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3ATFd1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jan 2013 00:33:27 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: mkrufky@linuxtv.org, crope@iki.fi, peter.senna@gmail.com,
	patricechotard@free.fr, kosio.dimitrov@gmail.com, liplianin@me.by,
	danny.kukawka@bisect.de, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] use IS_ENABLED() macro
Date: Sun, 20 Jan 2013 03:32:56 -0200
Message-Id: <1358659976-8767-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces the use of IS_ENABLED() macro. For example,
replacing:
 #if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))

with:
 #if IS_ENABLED(CONFIG_I2C)

All changes made by this patch respect the same replacement pattern.

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/dvb-frontends/bcm3510.h     | 2 +-
 drivers/media/dvb-frontends/cx22700.h     | 2 +-
 drivers/media/dvb-frontends/cx24110.h     | 2 +-
 drivers/media/dvb-frontends/dib0070.h     | 2 +-
 drivers/media/dvb-frontends/dib0090.h     | 2 +-
 drivers/media/dvb-frontends/dib3000.h     | 2 +-
 drivers/media/dvb-frontends/dib8000.h     | 2 +-
 drivers/media/dvb-frontends/dib9000.h     | 2 +-
 drivers/media/dvb-frontends/dvb-pll.h     | 2 +-
 drivers/media/dvb-frontends/isl6405.h     | 2 +-
 drivers/media/dvb-frontends/isl6421.h     | 2 +-
 drivers/media/dvb-frontends/isl6423.h     | 2 +-
 drivers/media/dvb-frontends/itd1000.h     | 2 +-
 drivers/media/dvb-frontends/l64781.h      | 2 +-
 drivers/media/dvb-frontends/lgdt330x.h    | 2 +-
 drivers/media/dvb-frontends/mb86a16.h     | 2 +-
 drivers/media/dvb-frontends/mt312.h       | 2 +-
 drivers/media/dvb-frontends/mt352.h       | 2 +-
 drivers/media/dvb-frontends/nxt200x.h     | 2 +-
 drivers/media/dvb-frontends/nxt6000.h     | 2 +-
 drivers/media/dvb-frontends/or51132.h     | 2 +-
 drivers/media/dvb-frontends/or51211.h     | 2 +-
 drivers/media/dvb-frontends/s5h1420.h     | 2 +-
 drivers/media/dvb-frontends/sp8870.h      | 2 +-
 drivers/media/dvb-frontends/sp887x.h      | 2 +-
 drivers/media/dvb-frontends/stb0899_drv.h | 2 +-
 drivers/media/dvb-frontends/stb6100.h     | 2 +-
 drivers/media/dvb-frontends/stv0297.h     | 2 +-
 drivers/media/dvb-frontends/stv0299.h     | 2 +-
 drivers/media/dvb-frontends/stv090x.h     | 2 +-
 drivers/media/dvb-frontends/stv6110x.h    | 2 +-
 drivers/media/dvb-frontends/tda1002x.h    | 5 ++---
 drivers/media/dvb-frontends/tda1004x.h    | 2 +-
 drivers/media/dvb-frontends/tda10086.h    | 2 +-
 drivers/media/dvb-frontends/tda665x.h     | 2 +-
 drivers/media/dvb-frontends/tda8083.h     | 2 +-
 drivers/media/dvb-frontends/tda8261.h     | 2 +-
 drivers/media/dvb-frontends/tda826x.h     | 2 +-
 drivers/media/dvb-frontends/tua6100.h     | 2 +-
 drivers/media/dvb-frontends/ves1820.h     | 2 +-
 drivers/media/dvb-frontends/ves1x93.h     | 2 +-
 drivers/media/dvb-frontends/zl10353.h     | 2 +-
 drivers/media/pci/cx88/cx88-dvb.c         | 4 ++--
 drivers/media/pci/cx88/cx88-vp3054-i2c.h  | 2 +-
 drivers/media/tuners/mt2060.h             | 2 +-
 drivers/media/tuners/mt2063.h             | 2 +-
 drivers/media/tuners/mt20xx.h             | 2 +-
 drivers/media/tuners/mt2131.h             | 2 +-
 drivers/media/tuners/mt2266.h             | 2 +-
 drivers/media/tuners/mxl5007t.h           | 2 +-
 drivers/media/tuners/qt1010.h             | 2 +-
 drivers/media/tuners/tda18271.h           | 2 +-
 drivers/media/tuners/tda827x.h            | 2 +-
 drivers/media/tuners/tda8290.h            | 2 +-
 drivers/media/tuners/tda9887.h            | 2 +-
 drivers/media/tuners/tea5761.h            | 2 +-
 drivers/media/tuners/tea5767.h            | 2 +-
 drivers/media/tuners/tuner-simple.h       | 2 +-
 drivers/media/tuners/tuner-xc2028.h       | 2 +-
 drivers/media/tuners/xc4000.h             | 2 +-
 drivers/media/v4l2-core/v4l2-device.c     | 2 +-
 61 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/drivers/media/dvb-frontends/bcm3510.h b/drivers/media/dvb-frontends/bcm3510.h
index f4575c0..5bd56b1 100644
--- a/drivers/media/dvb-frontends/bcm3510.h
+++ b/drivers/media/dvb-frontends/bcm3510.h
@@ -34,7 +34,7 @@ struct bcm3510_config
 	int (*request_firmware)(struct dvb_frontend* fe, const struct firmware **fw, char* name);
 };
 
-#if defined(CONFIG_DVB_BCM3510) || (defined(CONFIG_DVB_BCM3510_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_BCM3510)
 extern struct dvb_frontend* bcm3510_attach(const struct bcm3510_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/cx22700.h b/drivers/media/dvb-frontends/cx22700.h
index 4757a93..382a7b1 100644
--- a/drivers/media/dvb-frontends/cx22700.h
+++ b/drivers/media/dvb-frontends/cx22700.h
@@ -31,7 +31,7 @@ struct cx22700_config
 	u8 demod_address;
 };
 
-#if defined(CONFIG_DVB_CX22700) || (defined(CONFIG_DVB_CX22700_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX22700)
 extern struct dvb_frontend* cx22700_attach(const struct cx22700_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/cx24110.h b/drivers/media/dvb-frontends/cx24110.h
index fdcceee..527aff1 100644
--- a/drivers/media/dvb-frontends/cx24110.h
+++ b/drivers/media/dvb-frontends/cx24110.h
@@ -46,7 +46,7 @@ static inline int cx24110_pll_write(struct dvb_frontend *fe, u32 val)
 	return 0;
 }
 
-#if defined(CONFIG_DVB_CX24110) || (defined(CONFIG_DVB_CX24110_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_CX24110)
 extern struct dvb_frontend* cx24110_attach(const struct cx24110_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/dib0070.h b/drivers/media/dvb-frontends/dib0070.h
index 45c31fa..0c6befc 100644
--- a/drivers/media/dvb-frontends/dib0070.h
+++ b/drivers/media/dvb-frontends/dib0070.h
@@ -48,7 +48,7 @@ struct dib0070_config {
 	u8 vga_filter;
 };
 
-#if defined(CONFIG_DVB_TUNER_DIB0070) || (defined(CONFIG_DVB_TUNER_DIB0070_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TUNER_DIB0070)
 extern struct dvb_frontend *dib0070_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct dib0070_config *cfg);
 extern u16 dib0070_wbd_offset(struct dvb_frontend *);
 extern void dib0070_ctrl_agc_filter(struct dvb_frontend *, u8 open);
diff --git a/drivers/media/dvb-frontends/dib0090.h b/drivers/media/dvb-frontends/dib0090.h
index 781dc49..6a09095 100644
--- a/drivers/media/dvb-frontends/dib0090.h
+++ b/drivers/media/dvb-frontends/dib0090.h
@@ -75,7 +75,7 @@ struct dib0090_config {
 	u8 force_crystal_mode;
 };
 
-#if defined(CONFIG_DVB_TUNER_DIB0090) || (defined(CONFIG_DVB_TUNER_DIB0090_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TUNER_DIB0090)
 extern struct dvb_frontend *dib0090_register(struct dvb_frontend *fe, struct i2c_adapter *i2c, const struct dib0090_config *config);
 extern struct dvb_frontend *dib0090_fw_register(struct dvb_frontend *fe, struct i2c_adapter *i2c, const struct dib0090_config *config);
 extern void dib0090_dcc_freq(struct dvb_frontend *fe, u8 fast);
diff --git a/drivers/media/dvb-frontends/dib3000.h b/drivers/media/dvb-frontends/dib3000.h
index 404f63a..9b6c3bb 100644
--- a/drivers/media/dvb-frontends/dib3000.h
+++ b/drivers/media/dvb-frontends/dib3000.h
@@ -41,7 +41,7 @@ struct dib_fe_xfer_ops
 	int (*tuner_pass_ctrl)(struct dvb_frontend *fe, int onoff, u8 pll_ctrl);
 };
 
-#if defined(CONFIG_DVB_DIB3000MB) || (defined(CONFIG_DVB_DIB3000MB_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB3000MB)
 extern struct dvb_frontend* dib3000mb_attach(const struct dib3000_config* config,
 					     struct i2c_adapter* i2c, struct dib_fe_xfer_ops *xfer_ops);
 #else
diff --git a/drivers/media/dvb-frontends/dib8000.h b/drivers/media/dvb-frontends/dib8000.h
index 39591bb..9e7a2b1 100644
--- a/drivers/media/dvb-frontends/dib8000.h
+++ b/drivers/media/dvb-frontends/dib8000.h
@@ -37,7 +37,7 @@ struct dib8000_config {
 
 #define DEFAULT_DIB8000_I2C_ADDRESS 18
 
-#if defined(CONFIG_DVB_DIB8000) || (defined(CONFIG_DVB_DIB8000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB8000)
 extern struct dvb_frontend *dib8000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg);
 extern struct i2c_adapter *dib8000_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);
 
diff --git a/drivers/media/dvb-frontends/dib9000.h b/drivers/media/dvb-frontends/dib9000.h
index de1cc91..f3639f0 100644
--- a/drivers/media/dvb-frontends/dib9000.h
+++ b/drivers/media/dvb-frontends/dib9000.h
@@ -27,7 +27,7 @@ struct dib9000_config {
 
 #define DEFAULT_DIB9000_I2C_ADDRESS 18
 
-#if defined(CONFIG_DVB_DIB9000) || (defined(CONFIG_DVB_DIB9000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_DIB9000)
 extern struct dvb_frontend *dib9000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, const struct dib9000_config *cfg);
 extern int dib9000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods, u8 default_addr, u8 first_addr);
 extern struct i2c_adapter *dib9000_get_tuner_interface(struct dvb_frontend *fe);
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index 4de754f..f4b5a06 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -38,7 +38,7 @@
  * @param pll_desc_id dvb_pll_desc to use.
  * @return Frontend pointer on success, NULL on failure
  */
-#if defined(CONFIG_DVB_PLL) || (defined(CONFIG_DVB_PLL_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_PLL)
 extern struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe,
 					   int pll_addr,
 					   struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/isl6405.h b/drivers/media/dvb-frontends/isl6405.h
index 1c793d3..8abb70c 100644
--- a/drivers/media/dvb-frontends/isl6405.h
+++ b/drivers/media/dvb-frontends/isl6405.h
@@ -55,7 +55,7 @@
 #define ISL6405_ENT2	0x20
 #define ISL6405_ISEL2	0x40
 
-#if defined(CONFIG_DVB_ISL6405) || (defined(CONFIG_DVB_ISL6405_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ISL6405)
 /* override_set and override_clear control which system register bits (above)
  * to always set & clear
  */
diff --git a/drivers/media/dvb-frontends/isl6421.h b/drivers/media/dvb-frontends/isl6421.h
index 47e4518..e7ca7d1 100644
--- a/drivers/media/dvb-frontends/isl6421.h
+++ b/drivers/media/dvb-frontends/isl6421.h
@@ -39,7 +39,7 @@
 #define ISL6421_ISEL1	0x20
 #define ISL6421_DCL	0x40
 
-#if defined(CONFIG_DVB_ISL6421) || (defined(CONFIG_DVB_ISL6421_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ISL6421)
 /* override_set and override_clear control which system register bits (above) to always set & clear */
 extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
 			  u8 override_set, u8 override_clear);
diff --git a/drivers/media/dvb-frontends/isl6423.h b/drivers/media/dvb-frontends/isl6423.h
index e1a37fb..80dfd9c 100644
--- a/drivers/media/dvb-frontends/isl6423.h
+++ b/drivers/media/dvb-frontends/isl6423.h
@@ -42,7 +42,7 @@ struct isl6423_config {
 	u8 mod_extern;
 };
 
-#if defined(CONFIG_DVB_ISL6423) || (defined(CONFIG_DVB_ISL6423_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ISL6423)
 
 
 extern struct dvb_frontend *isl6423_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/dvb-frontends/itd1000.h b/drivers/media/dvb-frontends/itd1000.h
index 5e18df0..edae090 100644
--- a/drivers/media/dvb-frontends/itd1000.h
+++ b/drivers/media/dvb-frontends/itd1000.h
@@ -29,7 +29,7 @@ struct itd1000_config {
 	u8 i2c_address;
 };
 
-#if defined(CONFIG_DVB_TUNER_ITD1000) || (defined(CONFIG_DVB_TUNER_ITD1000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TUNER_ITD1000)
 extern struct dvb_frontend *itd1000_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct itd1000_config *cfg);
 #else
 static inline struct dvb_frontend *itd1000_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct itd1000_config *cfg)
diff --git a/drivers/media/dvb-frontends/l64781.h b/drivers/media/dvb-frontends/l64781.h
index 1305a9e..6813b08 100644
--- a/drivers/media/dvb-frontends/l64781.h
+++ b/drivers/media/dvb-frontends/l64781.h
@@ -31,7 +31,7 @@ struct l64781_config
 	u8 demod_address;
 };
 
-#if defined(CONFIG_DVB_L64781) || (defined(CONFIG_DVB_L64781_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_L64781)
 extern struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 					  struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/lgdt330x.h b/drivers/media/dvb-frontends/lgdt330x.h
index 9012504..ca0eab5 100644
--- a/drivers/media/dvb-frontends/lgdt330x.h
+++ b/drivers/media/dvb-frontends/lgdt330x.h
@@ -52,7 +52,7 @@ struct lgdt330x_config
 	int clock_polarity_flip;
 };
 
-#if defined(CONFIG_DVB_LGDT330X) || (defined(CONFIG_DVB_LGDT330X_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_LGDT330X)
 extern struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 					    struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/mb86a16.h b/drivers/media/dvb-frontends/mb86a16.h
index 6ea8c37..277ce06 100644
--- a/drivers/media/dvb-frontends/mb86a16.h
+++ b/drivers/media/dvb-frontends/mb86a16.h
@@ -33,7 +33,7 @@ struct mb86a16_config {
 
 
 
-#if defined(CONFIG_DVB_MB86A16) || (defined(CONFIG_DVB_MB86A16_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_MB86A16)
 
 extern struct dvb_frontend *mb86a16_attach(const struct mb86a16_config *config,
 					   struct i2c_adapter *i2c_adap);
diff --git a/drivers/media/dvb-frontends/mt312.h b/drivers/media/dvb-frontends/mt312.h
index 29e3bb5..5706621 100644
--- a/drivers/media/dvb-frontends/mt312.h
+++ b/drivers/media/dvb-frontends/mt312.h
@@ -36,7 +36,7 @@ struct mt312_config {
 	unsigned int voltage_inverted:1;
 };
 
-#if defined(CONFIG_DVB_MT312) || (defined(CONFIG_DVB_MT312_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_MT312)
 struct dvb_frontend *mt312_attach(const struct mt312_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/mt352.h b/drivers/media/dvb-frontends/mt352.h
index ca2562d..451d904 100644
--- a/drivers/media/dvb-frontends/mt352.h
+++ b/drivers/media/dvb-frontends/mt352.h
@@ -51,7 +51,7 @@ struct mt352_config
 	int (*demod_init)(struct dvb_frontend* fe);
 };
 
-#if defined(CONFIG_DVB_MT352) || (defined(CONFIG_DVB_MT352_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_MT352)
 extern struct dvb_frontend* mt352_attach(const struct mt352_config* config,
 					 struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/nxt200x.h b/drivers/media/dvb-frontends/nxt200x.h
index f3c8458..b518d54 100644
--- a/drivers/media/dvb-frontends/nxt200x.h
+++ b/drivers/media/dvb-frontends/nxt200x.h
@@ -42,7 +42,7 @@ struct nxt200x_config
 	int (*set_ts_params)(struct dvb_frontend* fe, int is_punctured);
 };
 
-#if defined(CONFIG_DVB_NXT200X) || (defined(CONFIG_DVB_NXT200X_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_NXT200X)
 extern struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/nxt6000.h b/drivers/media/dvb-frontends/nxt6000.h
index 878eb38..b5867c2 100644
--- a/drivers/media/dvb-frontends/nxt6000.h
+++ b/drivers/media/dvb-frontends/nxt6000.h
@@ -33,7 +33,7 @@ struct nxt6000_config
 	u8 clock_inversion:1;
 };
 
-#if defined(CONFIG_DVB_NXT6000) || (defined(CONFIG_DVB_NXT6000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_NXT6000)
 extern struct dvb_frontend* nxt6000_attach(const struct nxt6000_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/or51132.h b/drivers/media/dvb-frontends/or51132.h
index 1b8e04d..9389583 100644
--- a/drivers/media/dvb-frontends/or51132.h
+++ b/drivers/media/dvb-frontends/or51132.h
@@ -34,7 +34,7 @@ struct or51132_config
 	int (*set_ts_params)(struct dvb_frontend* fe, int is_punctured);
 };
 
-#if defined(CONFIG_DVB_OR51132) || (defined(CONFIG_DVB_OR51132_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_OR51132)
 extern struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/or51211.h b/drivers/media/dvb-frontends/or51211.h
index 3ce0508..9a8ae93 100644
--- a/drivers/media/dvb-frontends/or51211.h
+++ b/drivers/media/dvb-frontends/or51211.h
@@ -37,7 +37,7 @@ struct or51211_config
 	void (*sleep)(struct dvb_frontend * fe);
 };
 
-#if defined(CONFIG_DVB_OR51211) || (defined(CONFIG_DVB_OR51211_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_OR51211)
 extern struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/s5h1420.h b/drivers/media/dvb-frontends/s5h1420.h
index ff30813..210049b 100644
--- a/drivers/media/dvb-frontends/s5h1420.h
+++ b/drivers/media/dvb-frontends/s5h1420.h
@@ -40,7 +40,7 @@ struct s5h1420_config
 	u8 serial_mpeg:1;
 };
 
-#if defined(CONFIG_DVB_S5H1420) || (defined(CONFIG_DVB_S5H1420_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_S5H1420)
 extern struct dvb_frontend *s5h1420_attach(const struct s5h1420_config *config,
 	     struct i2c_adapter *i2c);
 extern struct i2c_adapter *s5h1420_get_tuner_i2c_adapter(struct dvb_frontend *fe);
diff --git a/drivers/media/dvb-frontends/sp8870.h b/drivers/media/dvb-frontends/sp8870.h
index a764a79..065ec67 100644
--- a/drivers/media/dvb-frontends/sp8870.h
+++ b/drivers/media/dvb-frontends/sp8870.h
@@ -35,7 +35,7 @@ struct sp8870_config
 	int (*request_firmware)(struct dvb_frontend* fe, const struct firmware **fw, char* name);
 };
 
-#if defined(CONFIG_DVB_SP8870) || (defined(CONFIG_DVB_SP8870_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_SP8870)
 extern struct dvb_frontend* sp8870_attach(const struct sp8870_config* config,
 					  struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/sp887x.h b/drivers/media/dvb-frontends/sp887x.h
index 04eff6e..2cdc4e8 100644
--- a/drivers/media/dvb-frontends/sp887x.h
+++ b/drivers/media/dvb-frontends/sp887x.h
@@ -17,7 +17,7 @@ struct sp887x_config
 	int (*request_firmware)(struct dvb_frontend* fe, const struct firmware **fw, char* name);
 };
 
-#if defined(CONFIG_DVB_SP887X) || (defined(CONFIG_DVB_SP887X_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_SP887X)
 extern struct dvb_frontend* sp887x_attach(const struct sp887x_config* config,
 					  struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stb0899_drv.h b/drivers/media/dvb-frontends/stb0899_drv.h
index 98b200c..8d26ff6 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.h
+++ b/drivers/media/dvb-frontends/stb0899_drv.h
@@ -142,7 +142,7 @@ struct stb0899_config {
 	int (*tuner_set_rfsiggain)(struct dvb_frontend *fe, u32 rf_gain);
 };
 
-#if defined(CONFIG_DVB_STB0899) || (defined(CONFIG_DVB_STB0899_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STB0899)
 
 extern struct dvb_frontend *stb0899_attach(struct stb0899_config *config,
 					   struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/stb6100.h b/drivers/media/dvb-frontends/stb6100.h
index 2ab0966..3a1e40f 100644
--- a/drivers/media/dvb-frontends/stb6100.h
+++ b/drivers/media/dvb-frontends/stb6100.h
@@ -94,7 +94,7 @@ struct stb6100_state {
 	u32 reference;
 };
 
-#if defined(CONFIG_DVB_STB6100) || (defined(CONFIG_DVB_STB6100_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STB6100)
 
 extern struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
 					   const struct stb6100_config *config,
diff --git a/drivers/media/dvb-frontends/stv0297.h b/drivers/media/dvb-frontends/stv0297.h
index 3f8f946..c8ff363 100644
--- a/drivers/media/dvb-frontends/stv0297.h
+++ b/drivers/media/dvb-frontends/stv0297.h
@@ -42,7 +42,7 @@ struct stv0297_config
 	u8 stop_during_read:1;
 };
 
-#if defined(CONFIG_DVB_STV0297) || (defined(CONFIG_DVB_STV0297_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0297)
 extern struct dvb_frontend* stv0297_attach(const struct stv0297_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv0299.h b/drivers/media/dvb-frontends/stv0299.h
index ba219b7..06f70fc8 100644
--- a/drivers/media/dvb-frontends/stv0299.h
+++ b/drivers/media/dvb-frontends/stv0299.h
@@ -95,7 +95,7 @@ struct stv0299_config
 	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
 };
 
-#if defined(CONFIG_DVB_STV0299) || (defined(CONFIG_DVB_STV0299_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV0299)
 extern struct dvb_frontend *stv0299_attach(const struct stv0299_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/stv090x.h b/drivers/media/dvb-frontends/stv090x.h
index 29cdc2b..0bd6adc 100644
--- a/drivers/media/dvb-frontends/stv090x.h
+++ b/drivers/media/dvb-frontends/stv090x.h
@@ -103,7 +103,7 @@ struct stv090x_config {
 	void (*tuner_i2c_lock) (struct dvb_frontend *fe, int lock);
 };
 
-#if defined(CONFIG_DVB_STV090x) || (defined(CONFIG_DVB_STV090x_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV090x)
 
 extern struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
 					   struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/stv6110x.h b/drivers/media/dvb-frontends/stv6110x.h
index 47516753..bc4766d 100644
--- a/drivers/media/dvb-frontends/stv6110x.h
+++ b/drivers/media/dvb-frontends/stv6110x.h
@@ -53,7 +53,7 @@ struct stv6110x_devctl {
 };
 
 
-#if defined(CONFIG_DVB_STV6110x) || (defined(CONFIG_DVB_STV6110x_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_STV6110x)
 
 extern struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
 					       const struct stv6110x_config *config,
diff --git a/drivers/media/dvb-frontends/tda1002x.h b/drivers/media/dvb-frontends/tda1002x.h
index 04d1941..e404b6e 100644
--- a/drivers/media/dvb-frontends/tda1002x.h
+++ b/drivers/media/dvb-frontends/tda1002x.h
@@ -57,7 +57,7 @@ struct tda10023_config {
 	u16 deltaf;
 };
 
-#if defined(CONFIG_DVB_TDA10021) || (defined(CONFIG_DVB_TDA10021_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA10021)
 extern struct dvb_frontend* tda10021_attach(const struct tda1002x_config* config,
 					    struct i2c_adapter* i2c, u8 pwm);
 #else
@@ -69,8 +69,7 @@ static inline struct dvb_frontend* tda10021_attach(const struct tda1002x_config*
 }
 #endif // CONFIG_DVB_TDA10021
 
-#if defined(CONFIG_DVB_TDA10023) || \
-	(defined(CONFIG_DVB_TDA10023_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA10023)
 extern struct dvb_frontend *tda10023_attach(
 	const struct tda10023_config *config,
 	struct i2c_adapter *i2c, u8 pwm);
diff --git a/drivers/media/dvb-frontends/tda1004x.h b/drivers/media/dvb-frontends/tda1004x.h
index 4e27ffb..dd283fb 100644
--- a/drivers/media/dvb-frontends/tda1004x.h
+++ b/drivers/media/dvb-frontends/tda1004x.h
@@ -117,7 +117,7 @@ struct tda1004x_state {
 	enum tda1004x_demod demod_type;
 };
 
-#if defined(CONFIG_DVB_TDA1004X) || (defined(CONFIG_DVB_TDA1004X_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA1004X)
 extern struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 					    struct i2c_adapter* i2c);
 
diff --git a/drivers/media/dvb-frontends/tda10086.h b/drivers/media/dvb-frontends/tda10086.h
index 61148c5..458fe91 100644
--- a/drivers/media/dvb-frontends/tda10086.h
+++ b/drivers/media/dvb-frontends/tda10086.h
@@ -46,7 +46,7 @@ struct tda10086_config
 	enum tda10086_xtal xtal_freq;
 };
 
-#if defined(CONFIG_DVB_TDA10086) || (defined(CONFIG_DVB_TDA10086_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA10086)
 extern struct dvb_frontend* tda10086_attach(const struct tda10086_config* config,
 					    struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda665x.h b/drivers/media/dvb-frontends/tda665x.h
index ec7927a..03a0da6 100644
--- a/drivers/media/dvb-frontends/tda665x.h
+++ b/drivers/media/dvb-frontends/tda665x.h
@@ -31,7 +31,7 @@ struct tda665x_config {
 	u32	ref_divider;
 };
 
-#if defined(CONFIG_DVB_TDA665x) || (defined(CONFIG_DVB_TDA665x_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA665x)
 
 extern struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
 					   const struct tda665x_config *config,
diff --git a/drivers/media/dvb-frontends/tda8083.h b/drivers/media/dvb-frontends/tda8083.h
index 5a03c14..de6b186 100644
--- a/drivers/media/dvb-frontends/tda8083.h
+++ b/drivers/media/dvb-frontends/tda8083.h
@@ -35,7 +35,7 @@ struct tda8083_config
 	u8 demod_address;
 };
 
-#if defined(CONFIG_DVB_TDA8083) || (defined(CONFIG_DVB_TDA8083_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA8083)
 extern struct dvb_frontend* tda8083_attach(const struct tda8083_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda8261.h b/drivers/media/dvb-frontends/tda8261.h
index 006e453..55cf4ff 100644
--- a/drivers/media/dvb-frontends/tda8261.h
+++ b/drivers/media/dvb-frontends/tda8261.h
@@ -34,7 +34,7 @@ struct tda8261_config {
 	enum tda8261_step	step_size;
 };
 
-#if defined(CONFIG_DVB_TDA8261) || (defined(CONFIG_DVB_TDA8261_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA8261)
 
 extern struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
 					   const struct tda8261_config *config,
diff --git a/drivers/media/dvb-frontends/tda826x.h b/drivers/media/dvb-frontends/tda826x.h
index 89e9792..5f0f20e 100644
--- a/drivers/media/dvb-frontends/tda826x.h
+++ b/drivers/media/dvb-frontends/tda826x.h
@@ -35,7 +35,7 @@
  * @param has_loopthrough Set to 1 if the card has a loopthrough RF connector.
  * @return FE pointer on success, NULL on failure.
  */
-#if defined(CONFIG_DVB_TDA826X) || (defined(CONFIG_DVB_TDA826X_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TDA826X)
 extern struct dvb_frontend* tda826x_attach(struct dvb_frontend *fe, int addr,
 					   struct i2c_adapter *i2c,
 					   int has_loopthrough);
diff --git a/drivers/media/dvb-frontends/tua6100.h b/drivers/media/dvb-frontends/tua6100.h
index f83dbd5..83a9c30 100644
--- a/drivers/media/dvb-frontends/tua6100.h
+++ b/drivers/media/dvb-frontends/tua6100.h
@@ -34,7 +34,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if defined(CONFIG_DVB_TUA6100) || (defined(CONFIG_DVB_TUA6100_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_TUA6100)
 extern struct dvb_frontend *tua6100_attach(struct dvb_frontend *fe, int addr, struct i2c_adapter *i2c);
 #else
 static inline struct dvb_frontend* tua6100_attach(struct dvb_frontend *fe, int addr, struct i2c_adapter *i2c)
diff --git a/drivers/media/dvb-frontends/ves1820.h b/drivers/media/dvb-frontends/ves1820.h
index e902ed6..c073f35 100644
--- a/drivers/media/dvb-frontends/ves1820.h
+++ b/drivers/media/dvb-frontends/ves1820.h
@@ -41,7 +41,7 @@ struct ves1820_config
 	u8 selagc:1;
 };
 
-#if defined(CONFIG_DVB_VES1820) || (defined(CONFIG_DVB_VES1820_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_VES1820)
 extern struct dvb_frontend* ves1820_attach(const struct ves1820_config* config,
 					   struct i2c_adapter* i2c, u8 pwm);
 #else
diff --git a/drivers/media/dvb-frontends/ves1x93.h b/drivers/media/dvb-frontends/ves1x93.h
index 8a5a49e..2307cae 100644
--- a/drivers/media/dvb-frontends/ves1x93.h
+++ b/drivers/media/dvb-frontends/ves1x93.h
@@ -40,7 +40,7 @@ struct ves1x93_config
 	u8 invert_pwm:1;
 };
 
-#if defined(CONFIG_DVB_VES1X93) || (defined(CONFIG_DVB_VES1X93_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_VES1X93)
 extern struct dvb_frontend* ves1x93_attach(const struct ves1x93_config* config,
 					   struct i2c_adapter* i2c);
 #else
diff --git a/drivers/media/dvb-frontends/zl10353.h b/drivers/media/dvb-frontends/zl10353.h
index 6e3ca9e..50c1004 100644
--- a/drivers/media/dvb-frontends/zl10353.h
+++ b/drivers/media/dvb-frontends/zl10353.h
@@ -47,7 +47,7 @@ struct zl10353_config
 	u8 pll_0;        /* default: 0x15 */
 };
 
-#if defined(CONFIG_DVB_ZL10353) || (defined(CONFIG_DVB_ZL10353_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_DVB_ZL10353)
 extern struct dvb_frontend* zl10353_attach(const struct zl10353_config *config,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 50b5ac5..672b267 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -265,7 +265,7 @@ static struct mb86a16_config twinhan_vp1027 = {
 	.demod_address  = 0x08,
 };
 
-#if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
 static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
 {
 	static const u8 clock_config []  = { 0x89, 0x38, 0x38 };
@@ -1127,7 +1127,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		}
 		break;
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
-#if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
 		/* MT352 is on a secondary I2C bus made from some GPIO lines */
 		fe0->dvb.frontend = dvb_attach(mt352_attach, &dntv_live_dvbt_pro_config,
 					       &dev->vp3054->adap);
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.h b/drivers/media/pci/cx88/cx88-vp3054-i2c.h
index be99c93..95d0c60 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.h
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.h
@@ -30,7 +30,7 @@ struct vp3054_i2c_state {
 };
 
 /* ----------------------------------------------------------------------- */
-#if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_VIDEO_CX88_VP3054)
 int  vp3054_i2c_probe(struct cx8802_dev *dev);
 void vp3054_i2c_remove(struct cx8802_dev *dev);
 #else
diff --git a/drivers/media/tuners/mt2060.h b/drivers/media/tuners/mt2060.h
index cb60caf..c64fc19 100644
--- a/drivers/media/tuners/mt2060.h
+++ b/drivers/media/tuners/mt2060.h
@@ -30,7 +30,7 @@ struct mt2060_config {
 	u8 clock_out; /* 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1 */
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MT2060) || (defined(CONFIG_MEDIA_TUNER_MT2060_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2060)
 extern struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2060_config *cfg, u16 if1);
 #else
 static inline struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2060_config *cfg, u16 if1)
diff --git a/drivers/media/tuners/mt2063.h b/drivers/media/tuners/mt2063.h
index ab24170..e1acfc8 100644
--- a/drivers/media/tuners/mt2063.h
+++ b/drivers/media/tuners/mt2063.h
@@ -8,7 +8,7 @@ struct mt2063_config {
 	u32 refclock;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MT2063) || (defined(CONFIG_MEDIA_TUNER_MT2063_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2063)
 struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 				   struct mt2063_config *config,
 				   struct i2c_adapter *i2c);
diff --git a/drivers/media/tuners/mt20xx.h b/drivers/media/tuners/mt20xx.h
index 259553a..f56241c 100644
--- a/drivers/media/tuners/mt20xx.h
+++ b/drivers/media/tuners/mt20xx.h
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if defined(CONFIG_MEDIA_TUNER_MT20XX) || (defined(CONFIG_MEDIA_TUNER_MT20XX_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT20XX)
 extern struct dvb_frontend *microtune_attach(struct dvb_frontend *fe,
 					     struct i2c_adapter* i2c_adap,
 					     u8 i2c_addr);
diff --git a/drivers/media/tuners/mt2131.h b/drivers/media/tuners/mt2131.h
index 6632de6..09ceaf6 100644
--- a/drivers/media/tuners/mt2131.h
+++ b/drivers/media/tuners/mt2131.h
@@ -30,7 +30,7 @@ struct mt2131_config {
 	u8 clock_out; /* 0 = off, 1 = CLK/4, 2 = CLK/2, 3 = CLK/1 */
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MT2131) || (defined(CONFIG_MEDIA_TUNER_MT2131_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2131)
 extern struct dvb_frontend* mt2131_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct mt2131_config *cfg,
diff --git a/drivers/media/tuners/mt2266.h b/drivers/media/tuners/mt2266.h
index 4d08388..fad6dd6 100644
--- a/drivers/media/tuners/mt2266.h
+++ b/drivers/media/tuners/mt2266.h
@@ -24,7 +24,7 @@ struct mt2266_config {
 	u8 i2c_address;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MT2266) || (defined(CONFIG_MEDIA_TUNER_MT2266_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MT2266)
 extern struct dvb_frontend * mt2266_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2266_config *cfg);
 #else
 static inline struct dvb_frontend * mt2266_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2266_config *cfg)
diff --git a/drivers/media/tuners/mxl5007t.h b/drivers/media/tuners/mxl5007t.h
index aa3eea0..37b0942 100644
--- a/drivers/media/tuners/mxl5007t.h
+++ b/drivers/media/tuners/mxl5007t.h
@@ -77,7 +77,7 @@ struct mxl5007t_config {
 	unsigned int clk_out_enable:1;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_MXL5007T) || (defined(CONFIG_MEDIA_TUNER_MXL5007T_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL5007T)
 extern struct dvb_frontend *mxl5007t_attach(struct dvb_frontend *fe,
 					    struct i2c_adapter *i2c, u8 addr,
 					    struct mxl5007t_config *cfg);
diff --git a/drivers/media/tuners/qt1010.h b/drivers/media/tuners/qt1010.h
index 807fb7b..8ab5d47 100644
--- a/drivers/media/tuners/qt1010.h
+++ b/drivers/media/tuners/qt1010.h
@@ -36,7 +36,7 @@ struct qt1010_config {
  * @param cfg  tuner hw based configuration
  * @return fe  pointer on success, NULL on failure
  */
-#if defined(CONFIG_MEDIA_TUNER_QT1010) || (defined(CONFIG_MEDIA_TUNER_QT1010_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_QT1010)
 extern struct dvb_frontend *qt1010_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct qt1010_config *cfg);
diff --git a/drivers/media/tuners/tda18271.h b/drivers/media/tuners/tda18271.h
index 89b6c6d..4c418d6 100644
--- a/drivers/media/tuners/tda18271.h
+++ b/drivers/media/tuners/tda18271.h
@@ -121,7 +121,7 @@ enum tda18271_mode {
 	TDA18271_DIGITAL,
 };
 
-#if defined(CONFIG_MEDIA_TUNER_TDA18271) || (defined(CONFIG_MEDIA_TUNER_TDA18271_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA18271)
 extern struct dvb_frontend *tda18271_attach(struct dvb_frontend *fe, u8 addr,
 					    struct i2c_adapter *i2c,
 					    struct tda18271_config *cfg);
diff --git a/drivers/media/tuners/tda827x.h b/drivers/media/tuners/tda827x.h
index 7d72ce0..9432b5b 100644
--- a/drivers/media/tuners/tda827x.h
+++ b/drivers/media/tuners/tda827x.h
@@ -50,7 +50,7 @@ struct tda827x_config
  * @param cfg optional callback function pointers.
  * @return FE pointer on success, NULL on failure.
  */
-#if defined(CONFIG_MEDIA_TUNER_TDA827X) || (defined(CONFIG_MEDIA_TUNER_TDA827X_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA827X)
 extern struct dvb_frontend* tda827x_attach(struct dvb_frontend *fe, int addr,
 					   struct i2c_adapter *i2c,
 					   struct tda827x_config *cfg);
diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
index 7e288b2..e12ecba 100644
--- a/drivers/media/tuners/tda8290.h
+++ b/drivers/media/tuners/tda8290.h
@@ -28,7 +28,7 @@ struct tda829x_config {
 #define TDA829X_DONT_PROBE  1
 };
 
-#if defined(CONFIG_MEDIA_TUNER_TDA8290) || (defined(CONFIG_MEDIA_TUNER_TDA8290_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA8290)
 extern int tda829x_probe(struct i2c_adapter *i2c_adap, u8 i2c_addr);
 
 extern struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/tuners/tda9887.h b/drivers/media/tuners/tda9887.h
index acc419e..37a4a11 100644
--- a/drivers/media/tuners/tda9887.h
+++ b/drivers/media/tuners/tda9887.h
@@ -21,7 +21,7 @@
 #include "dvb_frontend.h"
 
 /* ------------------------------------------------------------------------ */
-#if defined(CONFIG_MEDIA_TUNER_TDA9887) || (defined(CONFIG_MEDIA_TUNER_TDA9887_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TDA9887)
 extern struct dvb_frontend *tda9887_attach(struct dvb_frontend *fe,
 					   struct i2c_adapter *i2c_adap,
 					   u8 i2c_addr);
diff --git a/drivers/media/tuners/tea5761.h b/drivers/media/tuners/tea5761.h
index 2e2ff82..933228f 100644
--- a/drivers/media/tuners/tea5761.h
+++ b/drivers/media/tuners/tea5761.h
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if defined(CONFIG_MEDIA_TUNER_TEA5761) || (defined(CONFIG_MEDIA_TUNER_TEA5761_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TEA5761)
 extern int tea5761_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr);
 
 extern struct dvb_frontend *tea5761_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/tuners/tea5767.h b/drivers/media/tuners/tea5767.h
index d30ab1b..c391011 100644
--- a/drivers/media/tuners/tea5767.h
+++ b/drivers/media/tuners/tea5767.h
@@ -39,7 +39,7 @@ struct tea5767_ctrl {
 	enum tea5767_xtal	xtal_freq;
 };
 
-#if defined(CONFIG_MEDIA_TUNER_TEA5767) || (defined(CONFIG_MEDIA_TUNER_TEA5767_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_TEA5767)
 extern int tea5767_autodetection(struct i2c_adapter* i2c_adap, u8 i2c_addr);
 
 extern struct dvb_frontend *tea5767_attach(struct dvb_frontend *fe,
diff --git a/drivers/media/tuners/tuner-simple.h b/drivers/media/tuners/tuner-simple.h
index 381fa5d..ffd12cf 100644
--- a/drivers/media/tuners/tuner-simple.h
+++ b/drivers/media/tuners/tuner-simple.h
@@ -20,7 +20,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
-#if defined(CONFIG_MEDIA_TUNER_SIMPLE) || (defined(CONFIG_MEDIA_TUNER_SIMPLE_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_SIMPLE)
 extern struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
 						struct i2c_adapter *i2c_adap,
 						u8 i2c_addr,
diff --git a/drivers/media/tuners/tuner-xc2028.h b/drivers/media/tuners/tuner-xc2028.h
index 9ebfb2d..181d087 100644
--- a/drivers/media/tuners/tuner-xc2028.h
+++ b/drivers/media/tuners/tuner-xc2028.h
@@ -56,7 +56,7 @@ struct xc2028_config {
 #define XC2028_RESET_CLK	1
 #define XC2028_I2C_FLUSH	2
 
-#if defined(CONFIG_MEDIA_TUNER_XC2028) || (defined(CONFIG_MEDIA_TUNER_XC2028_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_XC2028)
 extern struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
 					  struct xc2028_config *cfg);
 #else
diff --git a/drivers/media/tuners/xc4000.h b/drivers/media/tuners/xc4000.h
index e6a44d1..97c23de 100644
--- a/drivers/media/tuners/xc4000.h
+++ b/drivers/media/tuners/xc4000.h
@@ -50,7 +50,7 @@ struct xc4000_config {
  * it's passed back to a bridge during tuner_callback().
  */
 
-#if defined(CONFIG_MEDIA_TUNER_XC4000) || (defined(CONFIG_MEDIA_TUNER_XC4000_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_XC4000)
 extern struct dvb_frontend *xc4000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
 					  struct xc4000_config *cfg);
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 98a7f5e..8ed5da2 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -112,7 +112,7 @@ void v4l2_device_unregister(struct v4l2_device *v4l2_dev)
 	/* Unregister subdevs */
 	list_for_each_entry_safe(sd, next, &v4l2_dev->subdevs, list) {
 		v4l2_device_unregister_subdev(sd);
-#if defined(CONFIG_I2C) || (defined(CONFIG_I2C_MODULE) && defined(MODULE))
+#if IS_ENABLED(CONFIG_I2C)
 		if (sd->flags & V4L2_SUBDEV_FL_IS_I2C) {
 			struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-- 
1.7.11.7

