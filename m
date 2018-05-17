Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43820 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbeEQIyI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:54:08 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 02/12] media: ov5640: Adjust the clock based on the expected rate
Date: Thu, 17 May 2018 10:53:55 +0200
Message-Id: <20180517085405.10104-3-maxime.ripard@bootlin.com>
In-Reply-To: <20180517085405.10104-1-maxime.ripard@bootlin.com>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clock structure for the PCLK is quite obscure in the documentation, and
was hardcoded through the bytes array of each and every mode.

This is troublesome, since we cannot adjust it at runtime based on other
parameters (such as the number of bytes per pixel), and we can't support
either framerates that have not been used by the various vendors, since we
don't have the needed initialization sequence.

We can however understand how the clock tree works, and then implement some
functions to derive the various parameters from a given rate. And now that
those parameters are calculated at runtime, we can remove them from the
initialization sequence.

The modes also gained a new parameter which is the clock that they are
running at, from the register writes they were doing, so for now the switch
to the new algorithm should be transparent.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 289 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 288 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 4bd968b478db..63923d85a31f 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -174,6 +174,7 @@ struct ov5640_mode_info {
 	u32 htot;
 	u32 vact;
 	u32 vtot;
+	u32 pixel_clock;
 	const struct reg_value *reg_data;
 	u32 reg_data_size;
 };
@@ -695,6 +696,7 @@ static const struct reg_value ov5640_setting_15fps_QSXGA_2592_1944[] = {
 /* power-on sensor init reg table */
 static const struct ov5640_mode_info ov5640_mode_init_data = {
 	0, SUBSAMPLING, 640, 1896, 480, 984,
+	56000000,
 	ov5640_init_setting_30fps_VGA,
 	ARRAY_SIZE(ov5640_init_setting_30fps_VGA),
 };
@@ -704,74 +706,91 @@ ov5640_mode_data[OV5640_NUM_FRAMERATES][OV5640_NUM_MODES] = {
 	{
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
+		 28000000,
 		 ov5640_setting_15fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_15fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
+		 28000000,
 		 ov5640_setting_15fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_15fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
+		 28000000,
 		 ov5640_setting_15fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
+		 28000000,
 		 ov5640_setting_15fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_15fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
+		 28000000,
 		 ov5640_setting_15fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_15fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
+		 28000000,
 		 ov5640_setting_15fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_15fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
+		 21000000,
 		 ov5640_setting_15fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_15fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
+		 42000000,
 		 ov5640_setting_15fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_15fps_1080P_1920_1080)},
 		{OV5640_MODE_QSXGA_2592_1944, SCALING,
 		 2592, 2844, 1944, 1968,
+		 84000000,
 		 ov5640_setting_15fps_QSXGA_2592_1944,
 		 ARRAY_SIZE(ov5640_setting_15fps_QSXGA_2592_1944)},
 	}, {
 		{OV5640_MODE_QCIF_176_144, SUBSAMPLING,
 		 176, 1896, 144, 984,
+		 56000000,
 		 ov5640_setting_30fps_QCIF_176_144,
 		 ARRAY_SIZE(ov5640_setting_30fps_QCIF_176_144)},
 		{OV5640_MODE_QVGA_320_240, SUBSAMPLING,
 		 320, 1896, 240, 984,
+		 56000000,
 		 ov5640_setting_30fps_QVGA_320_240,
 		 ARRAY_SIZE(ov5640_setting_30fps_QVGA_320_240)},
 		{OV5640_MODE_VGA_640_480, SUBSAMPLING,
 		 640, 1896, 480, 1080,
+		 56000000,
 		 ov5640_setting_30fps_VGA_640_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_VGA_640_480)},
 		{OV5640_MODE_NTSC_720_480, SUBSAMPLING,
 		 720, 1896, 480, 984,
+		 56000000,
 		 ov5640_setting_30fps_NTSC_720_480,
 		 ARRAY_SIZE(ov5640_setting_30fps_NTSC_720_480)},
 		{OV5640_MODE_PAL_720_576, SUBSAMPLING,
 		 720, 1896, 576, 984,
+		 56000000,
 		 ov5640_setting_30fps_PAL_720_576,
 		 ARRAY_SIZE(ov5640_setting_30fps_PAL_720_576)},
 		{OV5640_MODE_XGA_1024_768, SUBSAMPLING,
 		 1024, 1896, 768, 1080,
+		 56000000,
 		 ov5640_setting_30fps_XGA_1024_768,
 		 ARRAY_SIZE(ov5640_setting_30fps_XGA_1024_768)},
 		{OV5640_MODE_720P_1280_720, SUBSAMPLING,
 		 1280, 1892, 720, 740,
+		 42000000,
 		 ov5640_setting_30fps_720P_1280_720,
 		 ARRAY_SIZE(ov5640_setting_30fps_720P_1280_720)},
 		{OV5640_MODE_1080P_1920_1080, SCALING,
 		 1920, 2500, 1080, 1120,
+		 84000000,
 		 ov5640_setting_30fps_1080P_1920_1080,
 		 ARRAY_SIZE(ov5640_setting_30fps_1080P_1920_1080)},
-		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, NULL, 0},
+		{OV5640_MODE_QSXGA_2592_1944, -1, 0, 0, 0, 0, 0, NULL, 0},
 	},
 };
 
@@ -904,6 +923,255 @@ static int ov5640_mod_reg(struct ov5640_dev *sensor, u16 reg,
 	return ov5640_write_reg(sensor, reg, val);
 }
 
+/*
+ * After trying the various combinations, reading various
+ * documentations spreaded around the net, and from the various
+ * feedback, the clock tree is probably as follows:
+ *
+ *   +--------------+
+ *   |  Ext. Clock  |
+ *   +-+------------+
+ *     |  +----------+
+ *     +->|   PLL1   | - reg 0x3036, for the multiplier
+ *        +-+--------+ - reg 0x3037, bits 0-3 for the pre-divider
+ *          |  +--------------+
+ *          +->| System Clock |  - reg 0x3035, bits 4-7
+ *             +-+------------+
+ *               |  +--------------+
+ *               +->| MIPI Divider | - reg 0x3035, bits 0-3
+ *               |  +-+------------+
+ *               |    +----------------> MIPI SCLK
+ *               |  +--------------+
+ *               +->| PLL Root Div | - reg 0x3037, bit 4
+ *                  +-+------------+
+ *                    |  +---------+
+ *                    +->| Bit Div | - reg 0x3035, bits 0-3
+ *                       +-+-------+
+ *                         |  +-------------+
+ *                         +->| SCLK Div    | - reg 0x3108, bits 0-1
+ *                         |  +-+-----------+
+ *                         |    +---------------> SCLK
+ *                         |  +-------------+
+ *                         +->| SCLK 2X Div | - reg 0x3108, bits 2-3
+ *                         |  +-+-----------+
+ *                         |    +---------------> SCLK 2X
+ *                         |  +-------------+
+ *                         +->| PCLK Div    | - reg 0x3108, bits 4-5
+ *                            +-+-----------+
+ *                              +---------------> PCLK
+ *
+ * This is deviating from the datasheet at least for the register
+ * 0x3108, since it's said here that the PCLK would be clocked from
+ * the PLL.
+ *
+ * There seems to be also (unverified) constraints:
+ *  - the PLL pre-divider output rate should be in the 4-27MHz range
+ *  - the PLL multiplier output rate should be in the 500-1000MHz range
+ *  - PCLK >= SCLK * 2 in YUV, >= SCLK in Raw or JPEG
+ *  - MIPI SCLK = (bpp / lanes) / PCLK
+ *
+ * In the two latter cases, these constraints are met since our
+ * factors are hardcoded. If we were to change that, we would need to
+ * take this into account. The only varying parts are the PLL
+ * multiplier and the system clock divider, which are shared between
+ * all these clocks so won't cause any issue.
+ */
+
+/*
+ * This is supposed to be ranging from 1 to 8, but the value is always
+ * set to 3 in the vendor kernels.
+ */
+#define OV5640_PLL_PREDIV	3
+
+#define OV5640_PLL_MULT_MIN	4
+#define OV5640_PLL_MULT_MAX	252
+
+/*
+ * This is supposed to be ranging from 1 to 16, but the value is
+ * always set to either 1 or 2 in the vendor kernels.
+ */
+#define OV5640_SYSDIV_MIN	1
+#define OV5640_SYSDIV_MAX	2
+
+/*
+ * This is supposed to be ranging from 1 to 16, but the value is always
+ * set to 2 in the vendor kernels.
+ */
+#define OV5640_MIPI_DIV		2
+
+/*
+ * This is supposed to be ranging from 1 to 2, but the value is always
+ * set to 2 in the vendor kernels.
+ */
+#define OV5640_PLL_ROOT_DIV	2
+
+/*
+ * This is supposed to be either 1, 2 or 2.5, but the value is always
+ * set to 2 in the vendor kernels.
+ */
+#define OV5640_BIT_DIV		2
+
+/*
+ * This is supposed to be ranging from 1 to 8, but the value is always
+ * set to 2 in the vendor kernels.
+ */
+#define OV5640_SCLK_ROOT_DIV	2
+
+/*
+ * This is hardcoded so that the consistency is maintained between SCLK and
+ * SCLK 2x.
+ */
+#define OV5640_SCLK2X_ROOT_DIV (OV5640_SCLK_ROOT_DIV / 2)
+
+/*
+ * This is supposed to be ranging from 1 to 8, but the value is always
+ * set to 1 in the vendor kernels.
+ */
+#define OV5640_PCLK_ROOT_DIV	1
+
+static unsigned long ov5640_compute_sys_clk(struct ov5640_dev *sensor,
+					    u8 pll_prediv, u8 pll_mult,
+					    u8 sysdiv)
+{
+	unsigned long rate = clk_get_rate(sensor->xclk);
+
+	return rate / pll_prediv * pll_mult / sysdiv;
+}
+
+static unsigned long ov5640_calc_sys_clk(struct ov5640_dev *sensor,
+					 unsigned long rate,
+					 u8 *pll_prediv, u8 *pll_mult,
+					 u8 *sysdiv)
+{
+	unsigned long best = ~0;
+	u8 best_sysdiv = 1, best_mult = 1;
+	u8 _sysdiv, _pll_mult;
+
+	for (_sysdiv = OV5640_SYSDIV_MIN;
+	     _sysdiv <= OV5640_SYSDIV_MAX;
+	     _sysdiv++) {
+		for (_pll_mult = OV5640_PLL_MULT_MIN;
+		     _pll_mult <= OV5640_PLL_MULT_MAX;
+		     _pll_mult++) {
+			unsigned long _rate;
+
+			/*
+			 * The PLL multiplier cannot be odd if above
+			 * 127.
+			 */
+			if (_pll_mult > 127 && (_pll_mult % 2))
+				continue;
+
+			_rate = ov5640_compute_sys_clk(sensor,
+						       OV5640_PLL_PREDIV,
+						       _pll_mult, _sysdiv);
+			if (abs(rate - _rate) < abs(rate - best)) {
+				best = _rate;
+				best_sysdiv = _sysdiv;
+				best_mult = _pll_mult;
+			}
+
+			if (_rate == rate)
+				goto out;
+		}
+	}
+
+out:
+	*sysdiv = best_sysdiv;
+	*pll_prediv = OV5640_PLL_PREDIV;
+	*pll_mult = best_mult;
+	return best;
+}
+
+static unsigned long ov5640_calc_mipi_clk(struct ov5640_dev *sensor,
+					  unsigned long rate,
+					  u8 *pll_prediv, u8 *pll_mult,
+					  u8 *sysdiv, u8 *mipi_div)
+{
+	unsigned long _rate = rate * OV5640_MIPI_DIV;
+
+	_rate = ov5640_calc_sys_clk(sensor, _rate, pll_prediv, pll_mult,
+				    sysdiv);
+	*mipi_div = OV5640_MIPI_DIV;
+
+	return _rate / *mipi_div;
+}
+
+static int ov5640_set_mipi_pclk(struct ov5640_dev *sensor, unsigned long rate)
+{
+	u8 prediv, mult, sysdiv, mipi_div;
+	int ret;
+
+	ov5640_calc_mipi_clk(sensor, rate, &prediv, &mult, &sysdiv, &mipi_div);
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
+			     0xff, sysdiv << 4 | (mipi_div - 1));
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2, 0xff, mult);
+	if (ret)
+		return ret;
+
+	return ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3, 0xf, prediv);
+}
+
+static unsigned long ov5640_calc_pclk(struct ov5640_dev *sensor,
+				      unsigned long rate,
+				      u8 *pll_prediv, u8 *pll_mult, u8 *sysdiv,
+				      u8 *pll_rdiv, u8 *bit_div, u8 *pclk_div)
+{
+	unsigned long _rate = rate * OV5640_PLL_ROOT_DIV * OV5640_BIT_DIV *
+				OV5640_PCLK_ROOT_DIV;
+
+	_rate = ov5640_calc_sys_clk(sensor, _rate, pll_prediv, pll_mult,
+				    sysdiv);
+	*pll_rdiv = OV5640_PLL_ROOT_DIV;
+	*bit_div = OV5640_BIT_DIV;
+	*pclk_div = OV5640_PCLK_ROOT_DIV;
+
+	return _rate / *pll_rdiv / *bit_div / *pclk_div;
+}
+
+static int ov5640_set_dvp_pclk(struct ov5640_dev *sensor, unsigned long rate)
+{
+	u8 prediv, mult, sysdiv, pll_rdiv, bit_div, pclk_div;
+	int ret;
+
+	ov5640_calc_pclk(sensor, rate, &prediv, &mult, &sysdiv, &pll_rdiv,
+			 &bit_div, &pclk_div);
+
+	if (bit_div == 2)
+		bit_div = 8;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL0,
+			     0x0f, bit_div);
+	if (ret)
+		return ret;
+
+	/*
+	 * We need to set sysdiv according to the clock, and to clear
+	 * the MIPI divider.
+	 */
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1,
+			     0xff, sysdiv << 4);
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL2,
+			     0xff, mult);
+	if (ret)
+		return ret;
+
+	ret = ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL3,
+			     0x1f, prediv | ((pll_rdiv - 1) << 4));
+	if (ret)
+		return ret;
+
+	return ov5640_mod_reg(sensor, OV5640_REG_SYS_ROOT_DIVIDER, 0x30,
+			      (ilog2(pclk_div) << 4));
+}
+
 /* download ov5640 settings to sensor through i2c */
 static int ov5640_load_regs(struct ov5640_dev *sensor,
 			    const struct ov5640_mode_info *mode)
@@ -1610,6 +1878,8 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 {
 	const struct ov5640_mode_info *mode = sensor->current_mode;
 	enum ov5640_downsize_mode dn_mode, orig_dn_mode;
+	unsigned long rate;
+	unsigned char bpp;
 	s32 exposure;
 	int ret;
 
@@ -1626,6 +1896,23 @@ static int ov5640_set_mode(struct ov5640_dev *sensor,
 	if (ret)
 		return ret;
 
+	/*
+	 * All the formats we support have 16 bits per pixel, except for JPEG
+	 * which is 8 bits per pixel.
+	 */
+	bpp = sensor->fmt.code == MEDIA_BUS_FMT_JPEG_1X8 ? 8 : 16;
+	rate = mode->pixel_clock * bpp;
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2) {
+		rate = rate / sensor->ep.bus.mipi_csi2.num_data_lanes;
+		ret = ov5640_set_mipi_pclk(sensor, rate);
+	} else {
+		rate = rate / sensor->ep.bus.parallel.bus_width;
+		ret = ov5640_set_dvp_pclk(sensor, rate);
+	}
+
+	if (ret < 0)
+		return 0;
+
 	if ((dn_mode == SUBSAMPLING && orig_dn_mode == SCALING) ||
 	    (dn_mode == SCALING && orig_dn_mode == SUBSAMPLING)) {
 		/*
-- 
2.17.0
