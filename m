Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37082 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1GYSfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 14:35:18 -0400
Received: by wwe5 with SMTP id 5so4343748wwe.1
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 11:35:17 -0700 (PDT)
Subject: [PATCH 3/3] it913x_fe frontend and tuner driver v1.05
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 19:35:12 +0100
Message-ID: <1311618912.7655.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fronted and Tuner Driver for ITE IT913x Series with inital support for
IT9137 integrated demodulator and tuner device.

The driver is loosely based on AF9035 series. However, support is not intended for
this device specificity.

The IT9137 tuner has been tested on UHF bands, but VHF has only been simulated.

Possible TODO the tuner sections may be separated from the main driver. All future devices 
should use the it913x_fe_script_loader for other tuner devices.
 

 Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/frontends/Kconfig          |    7 +
 drivers/media/dvb/frontends/Makefile         |    1 +
 drivers/media/dvb/frontends/it913x-fe-priv.h |  342 ++++++++++++
 drivers/media/dvb/frontends/it913x-fe.c      |  747 ++++++++++++++++++++++++++
 drivers/media/dvb/frontends/it913x-fe.h      |  196 +++++++
 5 files changed, 1293 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/it913x-fe-priv.h
 create mode 100644 drivers/media/dvb/frontends/it913x-fe.c
 create mode 100644 drivers/media/dvb/frontends/it913x-fe.h

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 32e08e3..0a9afcf 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -661,6 +661,13 @@ config DVB_IX2505V
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
 
+config DVB_IT913X_FE
+	tristate "it913x frontend and it9137 tuner"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help A DVB-T tuner module.
+	  Say Y when you want to support this frontend.
+
 comment "Tools to develop new frontends"
 
 config DVB_DUMMY_FE
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 6a6ba05..3da75ea 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -91,4 +91,5 @@ obj-$(CONFIG_DVB_STV0367) += stv0367.o
 obj-$(CONFIG_DVB_CXD2820R) += cxd2820r.o
 obj-$(CONFIG_DVB_DRXK) += drxk.o
 obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
+obj-$(CONFIG_DVB_IT913X_FE) += it913x-fe.o
 
diff --git a/drivers/media/dvb/frontends/it913x-fe-priv.h b/drivers/media/dvb/frontends/it913x-fe-priv.h
new file mode 100644
index 0000000..b80634ab
--- /dev/null
+++ b/drivers/media/dvb/frontends/it913x-fe-priv.h
@@ -0,0 +1,342 @@
+
+struct it913xset {	u32 pro;
+			u32 address;
+			u8 reg[15];
+			u8 count;
+};
+
+struct adctable {	u32 adcFrequency;
+			u32 bandwidth;
+			u32 coeff_1_2048;
+			u32 coeff_1_4096;
+			u32 coeff_1_8191;
+			u32 coeff_1_8192;
+			u32 coeff_1_8193;
+			u32 coeff_2_2k;
+			u32 coeff_2_4k;
+			u32 coeff_2_8k;
+			u16 bfsfcw_fftinx_ratio;
+			u16 fftinx_bfsfcw_ratio;
+};
+
+/* clock and coeff tables only table 3 is used with IT9137*/
+/* TODO other tables relate AF9035 may be removed */
+static struct adctable tab1[] = {
+	{	20156250, BANDWIDTH_6_MHZ,
+		0x02b8ba6e, 0x015c5d37, 0x00ae340d, 0x00ae2e9b, 0x00ae292a,
+		0x015c5d37, 0x00ae2e9b, 0x0057174e, 0x02f1, 0x015c	},
+	{	20156250, BANDWIDTH_7_MHZ,
+		0x032cd980, 0x01966cc0, 0x00cb3cba, 0x00cb3660, 0x00cb3007,
+		0x01966cc0, 0x00cb3660, 0x00659b30, 0x0285, 0x0196	},
+	{	20156250, BANDWIDTH_8_MHZ,
+		0x03a0f893, 0x01d07c49, 0x00e84567, 0x00e83e25, 0x00e836e3,
+		0x01d07c49, 0x00e83e25, 0x00741f12, 0x0234, 0x01d0	},
+	{	20156250, BANDWIDTH_5_MHZ,
+		0x02449b5c, 0x01224dae, 0x00912b60, 0x009126d7, 0x0091224e,
+		0x01224dae, 0x009126d7, 0x0048936b, 0x0387, 0x0122	}
+};
+
+static struct adctable tab2[] = {
+	{	20187500, BANDWIDTH_6_MHZ,
+		0x02b7a654, 0x015bd32a, 0x00adef04, 0x00ade995, 0x00ade426,
+		0x015bd32a, 0x00ade995, 0x0056f4ca, 0x02f2, 0x015c	},
+	{	20187500, BANDWIDTH_7_MHZ,
+		0x032b9761, 0x0195cbb1, 0x00caec30, 0x00cae5d8, 0x00cadf81,
+		0x0195cbb1, 0x00cae5d8, 0x006572ec, 0x0286, 0x0196	},
+	{	20187500, BANDWIDTH_8_MHZ,
+		0x039f886f, 0x01cfc438, 0x00e7e95b, 0x00e7e21c, 0x00e7dadd,
+		0x01cfc438, 0x00e7e21c, 0x0073f10e, 0x0235, 0x01d0	},
+	{	20187500, BANDWIDTH_5_MHZ,
+		0x0243b546, 0x0121daa3, 0x0090f1d9, 0x0090ed51, 0x0090e8ca,
+		0x0121daa3, 0x0090ed51, 0x004876a9, 0x0388, 0x0122	}
+
+};
+
+static struct adctable tab3[] = {
+	{	20250000, BANDWIDTH_6_MHZ,
+		0x02b580ad, 0x015ac057, 0x00ad6597, 0x00ad602b, 0x00ad5ac1,
+		0x015ac057, 0x00ad602b, 0x0056b016, 0x02f4, 0x015b	},
+	{	20250000, BANDWIDTH_7_MHZ,
+		0x03291620, 0x01948b10, 0x00ca4bda, 0x00ca4588, 0x00ca3f36,
+		0x01948b10, 0x00ca4588, 0x006522c4, 0x0288, 0x0195	},
+	{	20250000, BANDWIDTH_8_MHZ,
+		0x039cab92, 0x01ce55c9, 0x00e7321e, 0x00e72ae4, 0x00e723ab,
+		0x01ce55c9, 0x00e72ae4, 0x00739572, 0x0237, 0x01ce	},
+	{	20250000, BANDWIDTH_5_MHZ,
+		0x0241eb3b, 0x0120f59e, 0x00907f53, 0x00907acf, 0x0090764b,
+		0x0120f59e, 0x00907acf, 0x00483d67, 0x038b, 0x0121	}
+
+};
+
+static struct adctable tab4[] = {
+	{	20583333, BANDWIDTH_6_MHZ,
+		0x02aa4598, 0x015522cc, 0x00aa96bb, 0x00aa9166, 0x00aa8c12,
+		0x015522cc, 0x00aa9166, 0x005548b3, 0x0300, 0x0155	},
+	{	20583333, BANDWIDTH_7_MHZ,
+		0x031bfbdc, 0x018dfdee, 0x00c7052f, 0x00c6fef7, 0x00c6f8bf,
+		0x018dfdee, 0x00c6fef7, 0x00637f7b, 0x0293, 0x018e	},
+	{	20583333, BANDWIDTH_8_MHZ,
+		0x038db21f, 0x01c6d910, 0x00e373a3, 0x00e36c88, 0x00e3656d,
+		0x01c6d910, 0x00e36c88, 0x0071b644, 0x0240, 0x01c7	},
+	{	20583333, BANDWIDTH_5_MHZ,
+		0x02388f54, 0x011c47aa, 0x008e2846, 0x008e23d5, 0x008e1f64,
+		0x011c47aa, 0x008e23d5, 0x004711ea, 0x039a, 0x011c	}
+
+};
+
+static struct adctable tab5[] = {
+	{	20416667, BANDWIDTH_6_MHZ,
+		0x02afd765, 0x0157ebb3, 0x00abfb39, 0x00abf5d9, 0x00abf07a,
+		0x0157ebb3, 0x00abf5d9, 0x0055faed, 0x02fa, 0x0158	},
+	{	20416667, BANDWIDTH_7_MHZ,
+		0x03227b4b, 0x01913da6, 0x00c8a518, 0x00c89ed3, 0x00c8988e,
+		0x01913da6, 0x00c89ed3, 0x00644f69, 0x028d, 0x0191	},
+	{	20416667, BANDWIDTH_8_MHZ,
+		0x03951f32, 0x01ca8f99, 0x00e54ef7, 0x00e547cc, 0x00e540a2,
+		0x01ca8f99, 0x00e547cc, 0x0072a3e6, 0x023c, 0x01cb	},
+	{	20416667, BANDWIDTH_5_MHZ,
+		0x023d337f, 0x011e99c0, 0x008f515a, 0x008f4ce0, 0x008f4865,
+		0x011e99c0, 0x008f4ce0, 0x0047a670, 0x0393, 0x011f	}
+
+};
+
+static struct adctable tab6[] = {
+	{	20480000, BANDWIDTH_6_MHZ,
+		0x02adb6db, 0x0156db6e, 0x00ab7312, 0x00ab6db7, 0x00ab685c,
+		0x0156db6e, 0x00ab6db7, 0x0055b6db, 0x02fd, 0x0157	},
+	{	20480000, BANDWIDTH_7_MHZ,
+		0x03200000, 0x01900000, 0x00c80640, 0x00c80000, 0x00c7f9c0,
+		0x01900000, 0x00c80000, 0x00640000, 0x028f, 0x0190	},
+	{	20480000, BANDWIDTH_8_MHZ,
+		0x03924925, 0x01c92492, 0x00e4996e, 0x00e49249, 0x00e48b25,
+		0x01c92492, 0x00e49249, 0x00724925, 0x023d, 0x01c9	},
+	{	20480000, BANDWIDTH_5_MHZ,
+		0x023b6db7, 0x011db6db, 0x008edfe5, 0x008edb6e, 0x008ed6f7,
+		0x011db6db, 0x008edb6e, 0x00476db7, 0x0396, 0x011e	}
+};
+
+static struct adctable tab7[] = {
+	{	20500000, BANDWIDTH_6_MHZ,
+		0x02ad0b99, 0x015685cc, 0x00ab4840, 0x00ab42e6, 0x00ab3d8c,
+		0x015685cc, 0x00ab42e6, 0x0055a173, 0x02fd, 0x0157	},
+	{	20500000, BANDWIDTH_7_MHZ,
+		0x031f3832, 0x018f9c19, 0x00c7d44b, 0x00c7ce0c, 0x00c7c7ce,
+		0x018f9c19, 0x00c7ce0c, 0x0063e706, 0x0290, 0x0190	},
+	{	20500000, BANDWIDTH_8_MHZ,
+		0x039164cb, 0x01c8b266, 0x00e46056, 0x00e45933, 0x00e45210,
+		0x01c8b266, 0x00e45933, 0x00722c99, 0x023e, 0x01c9	},
+	{	20500000, BANDWIDTH_5_MHZ,
+		0x023adeff, 0x011d6f80, 0x008ebc36, 0x008eb7c0, 0x008eb34a,
+		0x011d6f80, 0x008eb7c0, 0x00475be0, 0x0396, 0x011d	}
+
+};
+
+static struct adctable tab8[] = {
+	{	20625000, BANDWIDTH_6_MHZ,
+		0x02a8e4bd, 0x0154725e, 0x00aa3e81, 0x00aa392f, 0x00aa33de,
+		0x0154725e, 0x00aa392f, 0x00551c98, 0x0302, 0x0154	},
+	{	20625000, BANDWIDTH_7_MHZ,
+		0x031a6032, 0x018d3019, 0x00c69e41, 0x00c6980c, 0x00c691d8,
+		0x018d3019, 0x00c6980c, 0x00634c06, 0x0294, 0x018d	},
+	{	20625000, BANDWIDTH_8_MHZ,
+		0x038bdba6, 0x01c5edd3, 0x00e2fe02, 0x00e2f6ea, 0x00e2efd2,
+		0x01c5edd3, 0x00e2f6ea, 0x00717b75, 0x0242, 0x01c6	},
+	{	20625000, BANDWIDTH_5_MHZ,
+		0x02376948, 0x011bb4a4, 0x008ddec1, 0x008dda52, 0x008dd5e3,
+		0x011bb4a4, 0x008dda52, 0x0046ed29, 0x039c, 0x011c	}
+
+};
+
+struct table {
+		u32 xtal;
+		struct adctable *table;
+};
+
+static struct table fe_clockTable[] = {
+		{12000000, tab3},	/* FPGA     */
+		{16384000, tab6},	/* 16.38MHz */
+		{20480000, tab6},	/* 20.48MHz */
+		{36000000, tab3},	/* 36.00MHz */
+		{30000000, tab1},	/* 30.00MHz */
+		{26000000, tab4},	/* 26.00MHz */
+		{28000000, tab5},	/* 28.00MHz */
+		{32000000, tab7},	/* 32.00MHz */
+		{34000000, tab2},	/* 34.00MHz */
+		{24000000, tab1},	/* 24.00MHz */
+		{22000000, tab8},	/* 22.00MHz */
+		{12000000, tab3}	/* 12.00MHz */
+};
+
+/* fe get */
+fe_code_rate_t fe_code[] = {
+	FEC_1_2,
+	FEC_2_3,
+	FEC_3_4,
+	FEC_5_6,
+	FEC_7_8,
+	FEC_NONE,
+};
+
+fe_guard_interval_t fe_gi[] = {
+	GUARD_INTERVAL_1_32,
+	GUARD_INTERVAL_1_16,
+	GUARD_INTERVAL_1_8,
+	GUARD_INTERVAL_1_4,
+};
+
+fe_hierarchy_t fe_hi[] = {
+	HIERARCHY_NONE,
+	HIERARCHY_1,
+	HIERARCHY_2,
+	HIERARCHY_4,
+};
+
+fe_transmit_mode_t fe_mode[] = {
+	TRANSMISSION_MODE_2K,
+	TRANSMISSION_MODE_8K,
+	TRANSMISSION_MODE_4K,
+};
+
+fe_modulation_t fe_con[] = {
+	QPSK,
+	QAM_16,
+	QAM_64,
+};
+
+/* Standard demodulator functions */
+static struct it913xset set_solo_fe[] = {
+	{PRO_LINK, DVBT_INTEN, {0x04}, 0x01},
+	{PRO_LINK, DVBT_ENABLE, {0x05}, 0x01},
+	{PRO_DMOD, MP2IF_MPEG_PAR_MODE, {0x00}, 0x01},
+	{PRO_LINK, HOSTB_MPEG_SER_MODE, {0x00}, 0x01},
+	{PRO_LINK, HOSTB_MPEG_PAR_MODE, {0x00}, 0x01},
+	{PRO_DMOD, DCA_UPPER_CHIP, {0x00}, 0x01},
+	{PRO_LINK, HOSTB_DCA_UPPER, {0x00}, 0x01},
+	{PRO_DMOD, DCA_LOWER_CHIP, {0x00}, 0x01},
+	{PRO_LINK, HOSTB_DCA_LOWER, {0x00}, 0x01},
+	{PRO_DMOD, DCA_PLATCH, {0x00}, 0x01},
+	{PRO_DMOD, DCA_FPGA_LATCH, {0x00}, 0x01},
+	{PRO_DMOD, DCA_STAND_ALONE, {0x01}, 0x01},
+	{PRO_DMOD, DCA_ENABLE, {0x00}, 0x01},
+	{PRO_DMOD, MP2IF_MPEG_PAR_MODE, {0x00}, 0x01},
+	{PRO_DMOD, BFS_FCW, {0x00, 0x00, 0x00}, 0x03},
+	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+};
+
+
+static struct it913xset init_1[] = {
+	{PRO_LINK, LOCK3_OUT, {0x01}, 0x01},
+	{PRO_LINK, PADMISCDRSR, {0x01}, 0x01},
+	{PRO_LINK, PADMISCDR2, {0x00}, 0x01},
+	{PRO_LINK, PADMISCDR4, {0x00}, 0x01}, /* Power up */
+	{PRO_LINK, PADMISCDR8, {0x00}, 0x01},
+	{0xff, 0x0000, {0x00}, 0x00} /* Terminating Entry */
+};
+
+/* ---------IT9137 0x38 tuner init---------- */
+static struct it913xset it9137_set[] = {
+	{PRO_DMOD, 0x0043, {0x00}, 0x01},
+	{PRO_DMOD, 0x0046, {0x38}, 0x01},
+	{PRO_DMOD, 0x0051, {0x01}, 0x01},
+	{PRO_DMOD, 0x005f, {0x00, 0x00}, 0x02},
+	{PRO_DMOD, 0x0068, {0x0a}, 0x01},
+	{PRO_DMOD, 0x0070, {0x0a, 0x05, 0x02}, 0x03},
+	{PRO_DMOD, 0x0075, {0x8c, 0x8c, 0x8c, 0xc8, 0x01}, 0x05},
+	{PRO_DMOD, 0x007e, {0x04, 0x00}, 0x02},
+	{PRO_DMOD, 0x0081, {	0x0a, 0x12, 0x02, 0x0a, 0x03, 0xc8, 0xb8,
+				0xd0, 0xc3, 0x01	}, 0x0a},
+	{PRO_DMOD, 0x008e, {0x01}, 0x01},
+	{PRO_DMOD, 0x0092, {0x06, 0x00, 0x00, 0x00, 0x00}, 0x05},
+	{PRO_DMOD, 0x0099, {0x01}, 0x01},
+	{PRO_DMOD, 0x009b, {0x3c, 0x28}, 0x02},
+	{PRO_DMOD, 0x009f, {0xe1, 0xcf}, 0x02},
+	{PRO_DMOD, 0x00a3, {0x01, 0x5a, 0x01, 0x01}, 0x04},
+	{PRO_DMOD, 0x00a9, {0x00, 0x01}, 0x02},
+	{PRO_DMOD, 0x00b0, {0x01}, 0x01},
+	{PRO_DMOD, 0x00b3, {0x02, 0x32}, 0x02},
+	{PRO_DMOD, 0x00b6, {0x14}, 0x01},
+	{PRO_DMOD, 0x00c0, {0x11, 0x00, 0x05}, 0x03},
+	{PRO_DMOD, 0x00c4, {0x00}, 0x01},
+	{PRO_DMOD, 0x00c6, {0x19, 0x00}, 0x02},
+	{PRO_DMOD, 0x00cc, {0x2e, 0x51, 0x33}, 0x03},
+	{PRO_DMOD, 0x00f3, {0x05, 0x8c, 0x8c}, 0x03},
+	{PRO_DMOD, 0x00f8, {0x03, 0x06, 0x06}, 0x03},
+	{PRO_DMOD, 0x00fc, {	0x02, 0x02, 0x02, 0x09, 0x50, 0x7b, 0x77,
+				0x00, 0x02, 0xc8, 0x05, 0x7b	}, 0x0c},
+	{PRO_DMOD, 0x0109, {0x02}, 0x01},
+	{PRO_DMOD, 0x0115, {0x0a, 0x03}, 0x02},
+	{PRO_DMOD, 0x011a, {0xc8, 0x7b, 0xbc, 0xa0}, 0x04},
+	{PRO_DMOD, 0x0122, {0x02, 0x18, 0xc3}, 0x03},
+	{PRO_DMOD, 0x0127, {0x00, 0x07}, 0x02},
+	{PRO_DMOD, 0x012a, {0x53, 0x51, 0x4e, 0x43}, 0x04},
+	{PRO_DMOD, 0x0137, {0x01, 0x00, 0x07, 0x00, 0x06}, 0x05},
+	{PRO_DMOD, 0x013d, {0x00, 0x01, 0x5b, 0xc8}, 0x04},
+	{PRO_DMOD, 0xf130, {0x04}, 0x01},
+	{PRO_DMOD, 0xf132, {0x04}, 0x01},
+	{PRO_DMOD, 0xf144, {0x1a}, 0x01},
+	{PRO_DMOD, 0xf146, {0x00}, 0x01},
+	{PRO_DMOD, 0xf14a, {0x01}, 0x01},
+	{PRO_DMOD, 0xf14c, {0x00, 0x00}, 0x02},
+	{PRO_DMOD, 0xf14f, {0x04}, 0x01},
+	{PRO_DMOD, 0xf158, {0x7f}, 0x01},
+	{PRO_DMOD, 0xf15a, {0x00, 0x08}, 0x02},
+	{PRO_DMOD, 0xf15d, {0x03, 0x05}, 0x02},
+	{PRO_DMOD, 0xf163, {0x05}, 0x01},
+	{PRO_DMOD, 0xf166, {0x01, 0x40, 0x0f}, 0x03},
+	{PRO_DMOD, 0xf17a, {0x00, 0x00}, 0x02},
+	{PRO_DMOD, 0xf183, {0x01}, 0x01},
+	{PRO_DMOD, 0xf19d, {0x40}, 0x01},
+	{PRO_DMOD, 0xf1bc, {0x36, 0x00}, 0x02},
+	{PRO_DMOD, 0xf1cb, {0xa0, 0x01}, 0x02},
+	{PRO_DMOD, 0xf204, {0x10}, 0x01},
+	{PRO_DMOD, 0xf214, {0x00}, 0x01},
+	{PRO_DMOD, 0xf24c, {0x88, 0x95, 0x9a, 0x90}, 0x04},
+	{PRO_DMOD, 0xf25a, {0x07, 0xe8, 0x03, 0xb0, 0x04}, 0x05},
+	{PRO_DMOD, 0xf270, {0x01, 0x02, 0x01, 0x02}, 0x04},
+	{PRO_DMOD, 0xf40e, {0x0a, 0x40, 0x08}, 0x03},
+	{PRO_DMOD, 0xf55f, {0x0a}, 0x01},
+	{PRO_DMOD, 0xf561, {0x15, 0x20}, 0x02},
+	{PRO_DMOD, 0xf5df, {0xfb, 0x00}, 0x02},
+	{PRO_DMOD, 0xf5e3, {0x09, 0x01, 0x01}, 0x03},
+	{PRO_DMOD, 0xf5f8, {0x01}, 0x01},
+	{PRO_DMOD, 0xf5fd, {0x01}, 0x01},
+	{PRO_DMOD, 0xf600, {	0x05, 0x08, 0x0b, 0x0e, 0x11, 0x14, 0x17,
+				0x1f	}, 0x08},
+	{PRO_DMOD, 0xf60e, {0x00, 0x04, 0x32, 0x10}, 0x04},
+	{PRO_DMOD, 0xf707, {0xfc, 0x00, 0x37, 0x00}, 0x04},
+	{PRO_DMOD, 0xf78b, {0x01}, 0x01},
+	{PRO_DMOD, 0xf80f, {0x40, 0x54, 0x5a}, 0x03},
+	{PRO_DMOD, 0xf905, {0x01}, 0x01},
+	{PRO_DMOD, 0xfb06, {0x03}, 0x01},
+	{PRO_DMOD, 0xfd8b, {0x00}, 0x01},
+	{PRO_LINK, GPIOH5_EN, {0x01}, 0x01},
+	{PRO_LINK, GPIOH5_ON, {0x01}, 0x01},
+	{PRO_LINK, GPIOH5_O, {0x00}, 0x01},
+	{PRO_LINK, GPIOH5_O, {0x01}, 0x01},/* ?, but enable */
+	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+};
+
+static struct it913xset it9137_tuner[] = {
+	{PRO_DMOD, 0xec57, {0x00}, 0x01},
+	{PRO_DMOD, 0xec58, {0x00}, 0x01},
+	{PRO_DMOD, 0xec40, {0x00}, 0x01},
+	{PRO_DMOD, 0xec02, {	0x00, 0x0c, 0x00, 0x40, 0x00, 0x80, 0x80,
+				0x00, 0x00, 0x00, 0x00	}, 0x0b},
+	{PRO_DMOD, 0xec0d, {	0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00, 0x00	}, 0x0b},
+	{PRO_DMOD, 0xec19, {	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00}, 0x08},
+	{PRO_DMOD, 0xec22, {	0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+				0x00, 0x00, 0x00	}, 0x0a},
+	{PRO_DMOD, 0xec3f, {0x01}, 0x01},
+	/* Clear any existing tune */
+	{PRO_DMOD, 0xec4c, {0xa8, 0x00, 0x00, 0x00, 0x00}, 0x05},
+	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+};
+
+static struct it913xset set_it9137_template[] = {
+	{PRO_DMOD, 0xee06, {0x00}, 0x01},
+	{PRO_DMOD, 0xec56, {0x00}, 0x01},
+	{PRO_DMOD, 0xec4c, {0x00, 0x00, 0x00, 0x00, 0x00}, 0x05},
+	{0xff, 0x0000, {0x00}, 0x00}, /* Terminating Entry */
+};
diff --git a/drivers/media/dvb/frontends/it913x-fe.c b/drivers/media/dvb/frontends/it913x-fe.c
new file mode 100644
index 0000000..c92b3ec
--- /dev/null
+++ b/drivers/media/dvb/frontends/it913x-fe.c
@@ -0,0 +1,747 @@
+/*
+ *  Driver for it913x-fe Frontend
+ *
+ *  with support for on chip it9137 integral tuner
+ *
+ *  Copyright (C) 2011 Malcolm Priestley (tvboxspy@gmail.com)
+ *  IT9137 Copyright (C) ITE Tech Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include "dvb_frontend.h"
+#include "it913x-fe.h"
+#include "it913x-fe-priv.h"
+
+static int it913x_debug;
+
+module_param_named(debug, it913x_debug, int, 0644);
+MODULE_PARM_DESC(debug, "set debugging level (1=info (or-able)).");
+
+#define dprintk(level, args...) do { \
+	if (level & it913x_debug) \
+		printk(KERN_DEBUG "it913x-fe: " args); \
+} while (0)
+
+#define deb_info(args...)  dprintk(0x01, args)
+#define debug_data_snipet(level, name, p) \
+	  dprintk(level, name" (%02x%02x%02x%02x%02x%02x%02x%02x)", \
+		*p, *(p+1), *(p+2), *(p+3), *(p+4), \
+			*(p+5), *(p+6), *(p+7));
+
+struct it913x_fe_state {
+	struct dvb_frontend frontend;
+	struct i2c_adapter *i2c_adap;
+	u8 i2c_addr;
+	u32 frequency;
+	u8 adf;
+	u32 crystalFrequency;
+	u32 adcFrequency;
+	u8 tuner_type;
+	struct adctable *table;
+	fe_status_t it913x_status;
+};
+
+static int it913x_read_reg(struct it913x_fe_state *state,
+		u32 reg, u8 *data, u8 count)
+{
+	int ret;
+	u8 pro = PRO_DMOD; /* All reads from demodulator */
+	u8 b[4];
+	struct i2c_msg msg[2] = {
+		{ .addr = state->i2c_addr + (pro << 1), .flags = 0,
+			.buf = b, .len = sizeof(b) },
+		{ .addr = state->i2c_addr + (pro << 1), .flags = I2C_M_RD,
+			.buf = data, .len = count }
+	};
+	b[0] = (u8) reg >> 24;
+	b[1] = (u8)(reg >> 16) & 0xff;
+	b[2] = (u8)(reg >> 8) & 0xff;
+	b[3] = (u8) reg & 0xff;
+
+	ret = i2c_transfer(state->i2c_adap, msg, 2);
+
+	return ret;
+}
+
+static int it913x_read_reg_u8(struct it913x_fe_state *state, u32 reg)
+{
+	int ret;
+	u8 b[1];
+	ret = it913x_read_reg(state, reg, &b[0], sizeof(b));
+	return (ret < 0) ? -ENODEV : b[0];
+}
+
+static int it913x_write(struct it913x_fe_state *state,
+		u8 pro, u32 reg, u8 buf[], u8 count)
+{
+	u8 b[256];
+	struct i2c_msg msg[1] = {
+		{ .addr = state->i2c_addr + (pro << 1), .flags = 0,
+		  .buf = b, .len = count + 4 }
+	};
+	int ret;
+
+	b[0] = (u8) reg >> 24;
+	b[1] = (u8)(reg >> 16) & 0xff;
+	b[2] = (u8)(reg >> 8) & 0xff;
+	b[3] = (u8) reg & 0xff;
+	memcpy(&b[4], buf, count);
+
+	ret = i2c_transfer(state->i2c_adap, msg, 1);
+
+	if (ret < 0)
+		return -EIO;
+
+	return 0;
+}
+
+static int it913x_write_reg(struct it913x_fe_state *state,
+		u8 pro, u32 reg, u32 data)
+{
+	int ret;
+	u8 b[4];
+	u8 s;
+
+	b[0] = data >> 24;
+	b[1] = (data >> 16) & 0xff;
+	b[2] = (data >> 8) & 0xff;
+	b[3] = data & 0xff;
+	/* expand write as needed */
+	if (data < 0x100)
+		s = 3;
+	else if (data < 0x1000)
+		s = 2;
+	else if (data < 0x100000)
+		s = 1;
+	else
+		s = 0;
+
+	ret = it913x_write(state, pro, reg, &b[s], sizeof(b) - s);
+
+	return ret;
+}
+
+static int it913x_fe_script_loader(struct it913x_fe_state *state,
+		struct it913xset *loadscript)
+{
+	int ret, i;
+	if (loadscript == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < 1000; ++i) {
+		if (loadscript[i].pro == 0xff)
+			break;
+		ret = it913x_write(state, loadscript[i].pro,
+			loadscript[i].address,
+			loadscript[i].reg, loadscript[i].count);
+		if (ret < 0)
+			return -ENODEV;
+	}
+	return 0;
+}
+
+static int it9137_set_tuner(struct it913x_fe_state *state,
+		enum fe_bandwidth bandwidth, u32 frequency_m)
+{
+	struct it913xset *set_tuner = set_it9137_template;
+	int ret;
+	u32 frequency = frequency_m / 1000;
+	u32 freq;
+	u16 n_div;
+	u8 n;
+	u8 l_band;
+	u8 lna_band;
+	u8 bw;
+
+	deb_info("Tuner Frequency %d Bandwidth %d", frequency, bandwidth);
+
+	if (frequency >= 51000 && frequency <= 440000) {
+		l_band = 0;
+		lna_band = 0;
+	} else if (frequency > 440000 && frequency <= 484000) {
+		l_band = 1;
+		lna_band = 1;
+	} else if (frequency > 484000 && frequency <= 533000) {
+		l_band = 1;
+		lna_band = 2;
+	} else if (frequency > 533000 && frequency <= 587000) {
+		l_band = 1;
+		lna_band = 3;
+	} else if (frequency > 587000 && frequency <= 645000) {
+		l_band = 1;
+		lna_band = 4;
+	} else if (frequency > 645000 && frequency <= 710000) {
+		l_band = 1;
+		lna_band = 5;
+	} else if (frequency > 710000 && frequency <= 782000) {
+		l_band = 1;
+		lna_band = 6;
+	} else if (frequency > 782000 && frequency <= 860000) {
+		l_band = 1;
+		lna_band = 7;
+	} else if (frequency > 1450000 && frequency <= 1492000) {
+		l_band = 1;
+		lna_band = 0;
+	} else if (frequency > 1660000 && frequency <= 1685000) {
+		l_band = 1;
+		lna_band = 1;
+	} else
+		return -EINVAL;
+	set_tuner[0].reg[0] = lna_band;
+
+	if (bandwidth == BANDWIDTH_5_MHZ)
+		bw = 0;
+	else if (bandwidth == BANDWIDTH_6_MHZ)
+		bw = 2;
+	else if (bandwidth == BANDWIDTH_7_MHZ)
+		bw = 4;
+	else if (bandwidth == BANDWIDTH_8_MHZ)
+		bw = 6;
+	else
+		bw = 6;
+	set_tuner[1].reg[0] = bw;
+	set_tuner[2].reg[0] = 0xa0 | (l_band << 3);
+
+	if (frequency > 49000 && frequency <= 74000) {
+		n_div = 48;
+		n = 0;
+	} else if (frequency > 74000 && frequency <= 111000) {
+		n_div = 32;
+		n = 1;
+	} else if (frequency > 111000 && frequency <= 148000) {
+		n_div = 24;
+		n = 2;
+	} else if (frequency > 148000 && frequency <= 222000) {
+		n_div = 16;
+		n = 3;
+	} else if (frequency > 222000 && frequency <= 296000) {
+		n_div = 12;
+		n = 4;
+	} else if (frequency > 296000 && frequency <= 445000) {
+		n_div = 8;
+		n = 5;
+	} else if (frequency > 445000 && frequency <= 560000) {
+		n_div = 6;
+		n = 6;
+	} else if (frequency > 560000 && frequency <= 860000) {
+		n_div = 4;
+		n = 7;
+	} else if (frequency > 1450000 && frequency <= 1680000) {
+		n_div = 2;
+		n = 0;
+	} else
+		return -EINVAL;
+
+
+	/* Frequency + 3000 TODO not sure this is bandwidth setting */
+	/* Xtal frequency 21327? but it works */
+	freq = (u32) (n_div * 32  * (frequency + 3000) / 21327);
+	freq += (u32) n << 13;
+	set_tuner[2].reg[1] =  freq & 0xff;
+	set_tuner[2].reg[2] =  (freq >> 8) & 0xff;
+
+	/* frequency */
+	freq = (u32) (n_div * 32  * frequency / 21327);
+	freq += (u32) n << 13;
+	set_tuner[2].reg[3] =  freq & 0xff;
+	set_tuner[2].reg[4] =  (freq >> 8) & 0xff;
+
+	deb_info("Frequency = %08x, Bandwidth = %02x, ", freq, bw);
+
+	ret = it913x_fe_script_loader(state, set_tuner);
+
+	return (ret < 0) ? -ENODEV : 0;
+
+}
+
+static int it913x_fe_select_bw(struct it913x_fe_state *state,
+			enum fe_bandwidth bandwidth, u32 adcFrequency)
+{
+	int ret, i;
+	u8 buffer[256];
+	u32 coeff[8];
+	u16 bfsfcw_fftinx_ratio;
+	u16 fftinx_bfsfcw_ratio;
+	u8 count;
+	u8 bw;
+	u8 adcmultiplier;
+
+	deb_info("Bandwidth %d Adc %d", bandwidth, adcFrequency);
+
+	if (bandwidth == BANDWIDTH_5_MHZ)
+		bw = 3;
+	else if (bandwidth == BANDWIDTH_6_MHZ)
+		bw = 0;
+	else if (bandwidth == BANDWIDTH_7_MHZ)
+		bw = 1;
+	else if (bandwidth == BANDWIDTH_8_MHZ)
+		bw = 2;
+	else
+		bw = 2;
+
+	ret = it913x_write_reg(state, PRO_DMOD, REG_BW, bw);
+
+	if (state->table == NULL)
+		return -EINVAL;
+
+	/* In write order */
+	coeff[0] = state->table[bw].coeff_1_2048;
+	coeff[1] = state->table[bw].coeff_2_2k;
+	coeff[2] = state->table[bw].coeff_1_8191;
+	coeff[3] = state->table[bw].coeff_1_8192;
+	coeff[4] = state->table[bw].coeff_1_8193;
+	coeff[5] = state->table[bw].coeff_2_8k;
+	coeff[6] = state->table[bw].coeff_1_4096;
+	coeff[7] = state->table[bw].coeff_2_4k;
+	bfsfcw_fftinx_ratio = state->table[bw].bfsfcw_fftinx_ratio;
+	fftinx_bfsfcw_ratio = state->table[bw].fftinx_bfsfcw_ratio;
+
+	/* ADC multiplier */
+	ret = it913x_read_reg_u8(state, ADC_X_2);
+	if (ret < 0)
+		return -EINVAL;
+
+	adcmultiplier = ret;
+
+	count = 0;
+
+	/*  Build Buffer for COEFF Registers */
+	for (i = 0; i < 8; i++) {
+		if (adcmultiplier == 1)
+			coeff[i] /= 2;
+		buffer[count++] = (coeff[i] >> 24) & 0x3;
+		buffer[count++] = (coeff[i] >> 16) & 0xff;
+		buffer[count++] = (coeff[i] >> 8) & 0xff;
+		buffer[count++] = coeff[i] & 0xff;
+	}
+
+	/* bfsfcw_fftinx_ratio register 0x21-0x22 */
+	buffer[count++] = bfsfcw_fftinx_ratio & 0xff;
+	buffer[count++] = (bfsfcw_fftinx_ratio >> 8) & 0xff;
+	/* fftinx_bfsfcw_ratio register 0x23-0x24 */
+	buffer[count++] = fftinx_bfsfcw_ratio & 0xff;
+	buffer[count++] = (fftinx_bfsfcw_ratio >> 8) & 0xff;
+	/* start at COEFF_1_2048 and write through to fftinx_bfsfcw_ratio*/
+	ret = it913x_write(state, PRO_DMOD, COEFF_1_2048, buffer, count);
+
+	for (i = 0; i < 42; i += 8)
+		debug_data_snipet(0x1, "Buffer", &buffer[i]);
+
+	return ret;
+}
+
+
+
+static int it913x_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	int ret, i;
+	fe_status_t old_status = state->it913x_status;
+	*status = 0;
+
+	if (state->it913x_status == 0) {
+		ret = it913x_read_reg_u8(state, EMPTY_CHANNEL_STATUS);
+		if (ret == 0x1) {
+			*status |= FE_HAS_SIGNAL;
+			for (i = 0; i < 40; i++) {
+				ret = it913x_read_reg_u8(state, MP2IF_SYNC_LK);
+				if (ret == 0x1)
+					break;
+				msleep(25);
+			}
+			if (ret == 0x1)
+				*status |= FE_HAS_CARRIER
+					| FE_HAS_VITERBI
+					| FE_HAS_SYNC;
+			state->it913x_status = *status;
+		}
+	}
+
+	if (state->it913x_status & FE_HAS_SYNC) {
+		ret = it913x_read_reg_u8(state, TPSD_LOCK);
+		if (ret == 0x1)
+			*status |= FE_HAS_LOCK
+				| state->it913x_status;
+		else
+			state->it913x_status = 0;
+		if (old_status != state->it913x_status)
+			ret = it913x_write_reg(state, PRO_LINK, GPIOH3_O, ret);
+	}
+
+	return 0;
+}
+
+static int it913x_fe_read_signal_strength(struct dvb_frontend *fe,
+		u16 *strength)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	int ret = it913x_read_reg_u8(state, SIGNAL_LEVEL);
+	/*SIGNAL_LEVEL always returns 100%! so using FE_HAS_SIGNAL as switch*/
+	if (state->it913x_status & FE_HAS_SIGNAL)
+		ret = (ret * 0xff) / 0x64;
+	else
+		ret = 0x0;
+	ret |= ret << 0x8;
+	*strength = ret;
+	return 0;
+}
+
+static int it913x_fe_read_snr(struct dvb_frontend *fe, u16* snr)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	int ret = it913x_read_reg_u8(state, SIGNAL_QUALITY);
+	ret = (ret * 0xff) / 0x64;
+	ret |= (ret << 0x8);
+	*snr = ~ret;
+	return 0;
+}
+
+static int it913x_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	*ber = 0;
+	return 0;
+}
+
+static int it913x_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	*ucblocks = 0;
+	return 0;
+}
+
+static int it913x_fe_get_frontend(struct dvb_frontend *fe,
+			struct dvb_frontend_parameters *p)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	int ret;
+	u8 reg[8];
+
+	ret = it913x_read_reg(state, REG_TPSD_TX_MODE, reg, sizeof(reg));
+
+	if (reg[3] < 3)
+		p->u.ofdm.constellation = fe_con[reg[3]];
+
+	if (reg[0] < 3)
+		p->u.ofdm.transmission_mode = fe_mode[reg[0]];
+
+	if (reg[1] < 4)
+		p->u.ofdm.guard_interval = fe_gi[reg[1]];
+
+	if (reg[2] < 4)
+		p->u.ofdm.hierarchy_information = fe_hi[reg[2]];
+
+	p->u.ofdm.code_rate_HP = (reg[6] < 6) ? fe_code[reg[6]] : FEC_NONE;
+	p->u.ofdm.code_rate_LP = (reg[7] < 6) ? fe_code[reg[7]] : FEC_NONE;
+
+	return 0;
+}
+
+static int it913x_fe_set_frontend(struct dvb_frontend *fe,
+			struct dvb_frontend_parameters *p)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	int ret, i;
+	u8 empty_ch, last_ch;
+
+	state->it913x_status = 0;
+
+	/* Set bw*/
+	ret = it913x_fe_select_bw(state, p->u.ofdm.bandwidth,
+		state->adcFrequency);
+
+	/* Training Mode Off */
+	ret = it913x_write_reg(state, PRO_LINK, TRAINING_MODE, 0x0);
+
+	/* Clear Empty Channel */
+	ret = it913x_write_reg(state, PRO_DMOD, EMPTY_CHANNEL_STATUS, 0x0);
+
+	/* Clear bits */
+	ret = it913x_write_reg(state, PRO_DMOD, MP2IF_SYNC_LK, 0x0);
+	/* LED on */
+	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x1);
+	/* Select Band*/
+	if ((p->frequency >= 51000000) && (p->frequency <= 230000000))
+		i = 0;
+	else if ((p->frequency >= 350000000) && (p->frequency <= 900000000))
+			i = 1;
+	else if ((p->frequency >= 1450000000) && (p->frequency <= 1680000000))
+			i = 2;
+		else
+			return -EOPNOTSUPP;
+
+	ret = it913x_write_reg(state, PRO_DMOD, FREE_BAND, i);
+
+	deb_info("Frontend Set Tuner Type %02x", state->tuner_type);
+	switch (state->tuner_type) {
+	case IT9137: /* Tuner type 0x38 */
+		ret = it9137_set_tuner(state,
+			p->u.ofdm.bandwidth, p->frequency);
+		break;
+	default:
+		if (fe->ops.tuner_ops.set_params) {
+			fe->ops.tuner_ops.set_params(fe, p);
+			if (fe->ops.i2c_gate_ctrl)
+				fe->ops.i2c_gate_ctrl(fe, 0);
+		}
+		break;
+	}
+	/* LED off */
+	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x0);
+	/* Trigger ofsm */
+	ret = it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x0);
+	last_ch = 2;
+	for (i = 0; i < 40; ++i) {
+		empty_ch = it913x_read_reg_u8(state, EMPTY_CHANNEL_STATUS);
+		if (last_ch == 1 && empty_ch == 1)
+			break;
+		if (last_ch == 2 && empty_ch == 2)
+			return 0;
+		last_ch = empty_ch;
+		msleep(25);
+	}
+	for (i = 0; i < 40; ++i) {
+		if (it913x_read_reg_u8(state, D_TPSD_LOCK) == 1)
+			break;
+		msleep(25);
+	}
+
+	state->frequency = p->frequency;
+	return 0;
+}
+
+static int it913x_fe_suspend(struct it913x_fe_state *state)
+{
+	int ret, i;
+	u8 b;
+
+	ret = it913x_write_reg(state, PRO_DMOD, SUSPEND_FLAG, 0x1);
+
+	ret |= it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x0);
+
+	for (i = 0; i < 128; i++) {
+		ret = it913x_read_reg(state, SUSPEND_FLAG, &b, 1);
+		if (ret < 0)
+			return -EINVAL;
+		if (b == 0)
+			break;
+
+	}
+
+	ret |= it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x8);
+	/* Turn LED off */
+	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x0);
+
+	return 0;
+}
+
+static int it913x_fe_sleep(struct dvb_frontend *fe)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	return it913x_fe_suspend(state);
+}
+
+
+static u32 compute_div(u32 a, u32 b, u32 x)
+{
+	u32 res = 0;
+	u32 c = 0;
+	u32 i = 0;
+
+	if (a > b) {
+		c = a / b;
+		a = a - c * b;
+	}
+
+	for (i = 0; i < x; i++) {
+		if (a >= b) {
+			res += 1;
+			a -= b;
+		}
+		a <<= 1;
+		res <<= 1;
+	}
+
+	res = (c << x) + res;
+
+	return res;
+}
+
+static int it913x_fe_start(struct it913x_fe_state *state)
+{
+	struct it913xset *set_fe;
+	struct it913xset *set_mode;
+	int ret;
+	u8 adf = (state->adf & 0xf);
+	u32 adc, xtal;
+	u8 b[4];
+
+	if (adf < 12) {
+		state->crystalFrequency = fe_clockTable[adf].xtal ;
+		state->table = fe_clockTable[adf].table;
+		state->adcFrequency = state->table->adcFrequency;
+
+		adc = compute_div(state->adcFrequency, 1000000ul, 19ul);
+		xtal = compute_div(state->crystalFrequency, 1000000ul, 19ul);
+
+	} else
+		return -EINVAL;
+
+	deb_info("Xtal Freq :%d Adc Freq :%d Adc %08x Xtal %08x",
+		state->crystalFrequency, state->adcFrequency, adc, xtal);
+
+	/* Set LED indicator on GPIOH3 */
+	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_EN, 0x1);
+	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_ON, 0x1);
+	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x1);
+
+	ret |= it913x_write_reg(state, PRO_DMOD, 0xed81, 0x10);
+	ret |= it913x_write_reg(state, PRO_LINK, 0xf641, state->tuner_type);
+	ret |= it913x_write_reg(state, PRO_DMOD, 0xf5ca, 0x01);
+	ret |= it913x_write_reg(state, PRO_DMOD, 0xf715, 0x01);
+
+	b[0] = xtal & 0xff;
+	b[1] = (xtal >> 8) & 0xff;
+	b[2] = (xtal >> 16) & 0xff;
+	b[3] = (xtal >> 24);
+	ret |= it913x_write(state, PRO_DMOD, XTAL_CLK, b , 4);
+
+	b[0] = adc & 0xff;
+	b[1] = (adc >> 8) & 0xff;
+	b[2] = (adc >> 16) & 0xff;
+	ret |= it913x_write(state, PRO_DMOD, ADC_FREQ, b, 3);
+
+	switch (state->tuner_type) {
+	case IT9137: /* Tuner type 0x38 */
+		set_fe = it9137_set;
+		break;
+	default:
+		return -EINVAL;
+	}
+	/* set the demod */
+	ret = it913x_fe_script_loader(state, set_fe);
+	/* Always solo frontend */
+	set_mode = set_solo_fe;
+	ret |= it913x_fe_script_loader(state, set_mode);
+
+	ret |= it913x_fe_suspend(state);
+	return 0;
+}
+
+static int it913x_fe_init(struct dvb_frontend *fe)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	struct it913xset *set_tuner;
+	int ret = 0;
+
+	switch (state->tuner_type) {
+	case IT9137: /* Tuner type 0x38 */
+		set_tuner = it9137_tuner;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* set any tuner reg(s) */
+	ret = it913x_fe_script_loader(state, set_tuner);
+
+	it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x0);
+
+	ret |= it913x_fe_script_loader(state, init_1);
+
+	return (ret < 0) ? -ENODEV : 0;
+}
+
+static void it913x_fe_release(struct dvb_frontend *fe)
+{
+	struct it913x_fe_state *state = fe->demodulator_priv;
+	kfree(state);
+}
+
+static struct dvb_frontend_ops it913x_fe_ofdm_ops;
+
+struct dvb_frontend *it913x_fe_attach(struct i2c_adapter *i2c_adap,
+		u8 i2c_addr, u8 adf, u8 type)
+{
+	struct it913x_fe_state *state = NULL;
+	int ret;
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof(struct it913x_fe_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	state->i2c_adap = i2c_adap;
+	state->i2c_addr = i2c_addr;
+	state->adf = adf;
+	state->tuner_type = type;
+
+	ret = it913x_fe_start(state);
+	if (ret < 0)
+		goto error;
+
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &it913x_fe_ofdm_ops,
+			sizeof(struct dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+
+	return &state->frontend;
+error:
+	kfree(state);
+	return NULL;
+}
+EXPORT_SYMBOL(it913x_fe_attach);
+
+static struct dvb_frontend_ops it913x_fe_ofdm_ops = {
+
+	.info = {
+		.name			= "it913x-fe DVB-T",
+		.type			= FE_OFDM,
+		.frequency_min		= 51000000,
+		.frequency_max		= 1680000000,
+		.frequency_stepsize	= 62500,
+		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
+			FE_CAN_FEC_7_8 | FE_CAN_FEC_8_9 | FE_CAN_FEC_AUTO |
+			FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO |
+			FE_CAN_HIERARCHY_AUTO,
+	},
+
+	.release = it913x_fe_release,
+
+	.init = it913x_fe_init,
+	.sleep = it913x_fe_sleep,
+
+	.set_frontend = it913x_fe_set_frontend,
+	.get_frontend = it913x_fe_get_frontend,
+
+	.read_status = it913x_fe_read_status,
+	.read_signal_strength = it913x_fe_read_signal_strength,
+	.read_snr = it913x_fe_read_snr,
+	.read_ber = it913x_fe_read_ber,
+	.read_ucblocks = it913x_fe_read_ucblocks,
+};
+
+MODULE_DESCRIPTION("it913x Frontend and it9137 tuner");
+MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
+MODULE_VERSION("1.05");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/frontends/it913x-fe.h b/drivers/media/dvb/frontends/it913x-fe.h
new file mode 100644
index 0000000..9d97f32
--- /dev/null
+++ b/drivers/media/dvb/frontends/it913x-fe.h
@@ -0,0 +1,196 @@
+/*
+ *  Driver for it913x Frontend
+ *
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
+ */
+
+#ifndef IT913X_FE_H
+#define IT913X_FE_H
+
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+#if defined(CONFIG_DVB_IT913X_FE) || (defined(CONFIG_DVB_IT913X_FE_MODULE) && \
+defined(MODULE))
+extern struct dvb_frontend *it913x_fe_attach(struct i2c_adapter *i2c_adap,
+			u8 i2c_addr, u8 adf, u8 type);
+#else
+static inline struct dvb_frontend *it913x_fe_attach(
+		struct i2c_adapter *i2c_adap,	u8 i2c_addr, u8 adf, u8 type)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_IT913X_FE */
+#define I2C_BASE_ADDR		0x10
+#define DEV_0			0x0
+#define DEV_1			0x10
+#define PRO_LINK		0x0
+#define PRO_DMOD		0x1
+#define DEV_0_DMOD		(PRO_DMOD << 0x7)
+#define DEV_1_DMOD		(DEV_0_DMOD | DEV_1)
+#define CHIP2_I2C_ADDR		0x3a
+
+#define AFE_MEM0		0xfb24
+
+#define MP2_SW_RST		0xf99d
+#define MP2IF2_SW_RST		0xf9a4
+
+#define	PADODPU			0xd827
+#define THIRDODPU		0xd828
+#define AGC_O_D			0xd829
+
+#define EP0_TX_EN		0xdd11
+#define EP0_TX_NAK		0xdd13
+#define EP4_TX_LEN_LSB		0xdd88
+#define EP4_TX_LEN_MSB		0xdd89
+#define EP4_MAX_PKT		0xdd0c
+#define EP5_TX_LEN_LSB		0xdd8a
+#define EP5_TX_LEN_MSB		0xdd8b
+#define EP5_MAX_PKT		0xdd0d
+
+#define IO_MUX_POWER_CLK	0xd800
+#define CLK_O_EN		0xd81a
+#define I2C_CLK			0xf103
+#define I2C_CLK_100		0x7
+#define I2C_CLK_400		0x1a
+
+#define D_TPSD_LOCK		0xf5a9
+#define MP2IF2_EN		0xf9a3
+#define MP2IF_SERIAL		0xf985
+#define TSIS_ENABLE		0xf9cd
+#define MP2IF2_HALF_PSB		0xf9a5
+#define MP2IF_STOP_EN		0xf9b5
+#define MPEG_FULL_SPEED		0xf990
+#define TOP_HOSTB_SER_MODE	0xd91c
+
+#define PID_RST			0xf992
+#define PID_EN			0xf993
+#define PID_INX_EN		0xf994
+#define PID_INX			0xf995
+#define PID_LSB			0xf996
+#define PID_MSB			0xf997
+
+#define MP2IF_MPEG_PAR_MODE	0xf986
+#define DCA_UPPER_CHIP		0xf731
+#define DCA_LOWER_CHIP		0xf732
+#define DCA_PLATCH		0xf730
+#define DCA_FPGA_LATCH		0xf778
+#define DCA_STAND_ALONE		0xf73c
+#define DCA_ENABLE		0xf776
+
+#define DVBT_INTEN		0xf41f
+#define DVBT_ENABLE		0xf41a
+#define HOSTB_DCA_LOWER		0xd91f
+#define HOSTB_MPEG_PAR_MODE	0xd91b
+#define HOSTB_MPEG_SER_MODE	0xd91c
+#define HOSTB_MPEG_SER_DO7	0xd91d
+#define HOSTB_DCA_UPPER		0xd91e
+#define PADMISCDR2		0xd830
+#define PADMISCDR4		0xd831
+#define PADMISCDR8		0xd832
+#define PADMISCDRSR		0xd833
+#define LOCK3_OUT		0xd8fd
+
+#define GPIOH1_O		0xd8af
+#define GPIOH1_EN		0xd8b0
+#define GPIOH1_ON		0xd8b1
+#define GPIOH3_O		0xd8b3
+#define GPIOH3_EN		0xd8b4
+#define GPIOH3_ON		0xd8b5
+#define GPIOH5_O		0xd8bb
+#define GPIOH5_EN		0xd8bc
+#define GPIOH5_ON		0xd8bd
+
+#define AFE_MEM0		0xfb24
+
+#define REG_TPSD_TX_MODE	0xf900
+#define REG_TPSD_GI		0xf901
+#define REG_TPSD_HIER		0xf902
+#define REG_TPSD_CONST		0xf903
+#define REG_BW			0xf904
+#define REG_PRIV		0xf905
+#define REG_TPSD_HP_CODE	0xf906
+#define REG_TPSD_LP_CODE	0xf907
+
+#define MP2IF_SYNC_LK		0xf999
+#define ADC_FREQ		0xf1cd
+
+#define TRIGGER_OFSM		0x0000
+/* COEFF Registers start at 0x0001 to 0x0020 */
+#define COEFF_1_2048		0x0001
+#define XTAL_CLK		0x0025
+#define BFS_FCW			0x0029
+#define TPSD_LOCK		0x003c
+#define TRAINING_MODE		0x0040
+#define ADC_X_2			0x0045
+#define TUNER_ID		0x0046
+#define EMPTY_CHANNEL_STATUS	0x0047
+#define SIGNAL_LEVEL		0x0048
+#define SIGNAL_QUALITY		0x0049
+#define EST_SIGNAL_LEVEL	0x004a
+#define FREE_BAND		0x004b
+#define SUSPEND_FLAG		0x004c
+/* Build in tuners */
+#define IT9137 0x38
+
+enum {
+	CMD_DEMOD_READ = 0,
+	CMD_DEMOD_WRITE,
+	CMD_TUNER_READ,
+	CMD_TUNER_WRITE,
+	CMD_REG_EEPROM_READ,
+	CMD_REG_EEPROM_WRITE,
+	CMD_DATA_READ,
+	CMD_VAR_READ = 8,
+	CMD_VAR_WRITE,
+	CMD_PLATFORM_GET,
+	CMD_PLATFORM_SET,
+	CMD_IP_CACHE,
+	CMD_IP_ADD,
+	CMD_IP_REMOVE,
+	CMD_PID_ADD,
+	CMD_PID_REMOVE,
+	CMD_SIPSI_GET,
+	CMD_SIPSI_MPE_RESET,
+	CMD_H_PID_ADD = 0x15,
+	CMD_H_PID_REMOVE,
+	CMD_ABORT,
+	CMD_IR_GET,
+	CMD_IR_SET,
+	CMD_FW_DOWNLOAD = 0x21,
+	CMD_QUERYINFO,
+	CMD_BOOT,
+	CMD_FW_DOWNLOAD_BEGIN,
+	CMD_FW_DOWNLOAD_END,
+	CMD_RUN_CODE,
+	CMD_SCATTER_READ = 0x28,
+	CMD_SCATTER_WRITE,
+	CMD_GENERIC_READ,
+	CMD_GENERIC_WRITE
+};
+
+enum {
+	READ_LONG,
+	WRITE_LONG,
+	READ_SHORT,
+	WRITE_SHORT,
+	READ_DATA,
+	WRITE_DATA,
+	WRITE_CMD,
+};
+
+#endif /* IT913X_FE_H */
-- 
1.7.4.1





