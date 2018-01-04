Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35862 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752036AbeADS1H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 13:27:07 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] media: fix usage of whitespaces and on indentation
Date: Thu,  4 Jan 2018 13:26:41 -0500
Message-Id: <4a3fad709bbc74c85fffff8903d17b5e35723365.1515089828.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1515089828.git.mchehab@s-opensource.com>
References: <cover.1515089828.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1515089828.git.mchehab@s-opensource.com>
References: <cover.1515089828.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On several places, whitespaces are being used for indentation,
or even at the end of the line.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/Kconfig                            |  8 ++---
 drivers/media/dvb-core/Makefile                  |  2 +-
 drivers/media/dvb-core/dvb_ca_en50221.c          |  2 +-
 drivers/media/dvb-frontends/cx24116.c            |  2 +-
 drivers/media/dvb-frontends/drx39xyj/drxj.c      |  2 +-
 drivers/media/dvb-frontends/drxk.h               |  6 ++--
 drivers/media/dvb-frontends/mb86a20s.c           |  2 +-
 drivers/media/dvb-frontends/mn88473.c            |  2 +-
 drivers/media/dvb-frontends/tda18271c2dd.h       |  4 +--
 drivers/media/i2c/Kconfig                        | 10 +++----
 drivers/media/i2c/adv7343.c                      |  2 +-
 drivers/media/i2c/adv7393.c                      |  2 +-
 drivers/media/i2c/cx25840/cx25840-core.c         |  6 ++--
 drivers/media/i2c/cx25840/cx25840-ir.c           |  4 +--
 drivers/media/i2c/smiapp/smiapp-core.c           |  2 +-
 drivers/media/i2c/tvp5150_reg.h                  |  4 +--
 drivers/media/pci/cx18/cx18-fileops.c            |  2 +-
 drivers/media/pci/cx18/cx18-streams.c            |  2 +-
 drivers/media/pci/cx23885/cx23888-ir.c           |  4 +--
 drivers/media/pci/ivtv/ivtv-cards.c              |  2 +-
 drivers/media/pci/pluto2/pluto2.c                |  2 +-
 drivers/media/pci/pt1/pt1.c                      |  2 +-
 drivers/media/pci/pt1/va1j5jf8007s.c             |  2 +-
 drivers/media/pci/pt1/va1j5jf8007s.h             |  2 +-
 drivers/media/pci/pt1/va1j5jf8007t.c             |  2 +-
 drivers/media/pci/pt1/va1j5jf8007t.h             |  2 +-
 drivers/media/pci/saa7146/mxb.c                  |  2 +-
 drivers/media/pci/tw5864/tw5864-video.c          |  2 +-
 drivers/media/platform/Kconfig                   | 38 ++++++++++++------------
 drivers/media/platform/arv.c                     |  4 +--
 drivers/media/platform/blackfin/ppi.c            |  2 +-
 drivers/media/platform/davinci/dm355_ccdc.c      |  4 +--
 drivers/media/platform/davinci/dm644x_ccdc.c     |  6 ++--
 drivers/media/platform/davinci/vpfe_capture.c    |  6 ++--
 drivers/media/platform/exynos4-is/fimc-core.h    |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.h    |  4 +--
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.h  |  2 +-
 drivers/media/platform/omap3isp/isp.c            |  2 +-
 drivers/media/platform/sti/hva/hva.h             |  2 +-
 drivers/media/platform/via-camera.h              |  2 +-
 drivers/media/radio/radio-maxiradio.c            |  2 +-
 drivers/media/radio/radio-mr800.c                | 24 +++++++--------
 drivers/media/radio/si470x/radio-si470x-common.c | 24 +++++++--------
 drivers/media/radio/wl128x/fmdrv_common.h        | 10 +++----
 drivers/media/rc/Kconfig                         |  8 ++---
 drivers/media/tuners/mt2063.c                    |  4 +--
 drivers/media/tuners/si2157.c                    |  2 +-
 drivers/media/tuners/tuner-i2c.h                 |  2 +-
 drivers/media/usb/as102/as10x_cmd_cfg.c          |  6 ++--
 drivers/media/usb/cx231xx/cx231xx-avcore.c       |  2 +-
 drivers/media/usb/em28xx/Kconfig                 | 14 ++++-----
 drivers/media/usb/gspca/autogain_functions.c     | 12 ++++----
 drivers/media/usb/gspca/cpia1.c                  |  2 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.h        |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c      | 12 ++++----
 drivers/media/usb/tm6000/tm6000.h                |  2 +-
 drivers/media/usb/usbtv/Kconfig                  | 16 +++++-----
 drivers/media/v4l2-core/Kconfig                  |  4 +--
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |  2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c        |  2 +-
 include/media/dvb_frontend.h                     | 12 ++++----
 include/media/dvb_vb2.h                          |  2 +-
 include/media/dvbdev.h                           |  4 +--
 include/media/v4l2-async.h                       |  8 ++---
 include/media/v4l2-common.h                      |  4 +--
 include/media/v4l2-ctrls.h                       |  2 +-
 include/media/v4l2-dev.h                         | 16 +++++-----
 include/media/v4l2-event.h                       |  2 +-
 include/media/v4l2-subdev.h                      |  8 ++---
 69 files changed, 185 insertions(+), 185 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3f69b948d102..145e12bfb819 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -80,11 +80,11 @@ config MEDIA_SDR_SUPPORT
 config MEDIA_CEC_SUPPORT
        bool "HDMI CEC support"
        ---help---
-         Enable support for HDMI CEC (Consumer Electronics Control),
-         which is an optional HDMI feature.
+	 Enable support for HDMI CEC (Consumer Electronics Control),
+	 which is an optional HDMI feature.
 
-         Say Y when you have an HDMI receiver, transmitter or a USB CEC
-         adapter that supports HDMI CEC.
+	 Say Y when you have an HDMI receiver, transmitter or a USB CEC
+	 adapter that supports HDMI CEC.
 
 source "drivers/media/cec/Kconfig"
 
diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
index 3756ccf83384..05827ee2a406 100644
--- a/drivers/media/dvb-core/Makefile
+++ b/drivers/media/dvb-core/Makefile
@@ -6,7 +6,7 @@
 dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
 dvb-vb2-$(CONFIG_DVB_MMSP) := dvb_vb2.o
 
-dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o		 	\
+dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o			\
 		 dvb_ca_en50221.o dvb_frontend.o 		\
 		 $(dvb-net-y) dvb_ringbuffer.o $(dvb-vb2-y) dvb_math.o
 
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 77858046d347..ca98fa4d3ffa 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -786,7 +786,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot,
  * @ca: CA instance.
  * @slot: Slot to write to.
  * @buf: The data in this buffer is treated as a complete link-level packet to
- * 	 be written.
+ *	 be written.
  * @bytes_write: Size of ebuf.
  *
  * return: Number of bytes written, or < 0 on error.
diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 0ef5f8614b58..786c56a4ef76 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -963,7 +963,7 @@ static int cx24116_send_diseqc_msg(struct dvb_frontend *fe,
 
 	/* Validate length */
 	if (d->msg_len > sizeof(d->msg))
-                return -EINVAL;
+		return -EINVAL;
 
 	/* Dump DiSEqC message */
 	if (debug) {
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 1cc7c03cd032..5706898e84cc 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -11727,7 +11727,7 @@ static int drx_check_firmware(struct drx_demod_instance *demod, u8 *mc_data,
  *		- In case of UCODE_UPLOAD: I2C error.
  *		- In case of UCODE_VERIFY: I2C error or image on device
  *		  is not equal to image provided to this control function.
- * 	-EINVAL:
+ *	-EINVAL:
  *		- Invalid arguments.
  *		- Provided image is corrupt
  */
diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index b16fedbb53a3..76466f7ec3a0 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -10,7 +10,7 @@
  *
  * @adr:		I2C address of the DRX-K
  * @parallel_ts:	True means that the device uses parallel TS,
- * 			Serial otherwise.
+ *			Serial otherwise.
  * @dynamic_clk:	True means that the clock will be dynamically
  *			adjusted. Static clock otherwise.
  * @enable_merr_cfg:	Enable SIO_PDR_PERR_CFG/SIO_PDR_MVAL_CFG.
@@ -67,8 +67,8 @@ extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 static inline struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 					struct i2c_adapter *i2c)
 {
-        printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-        return NULL;
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
 }
 #endif
 
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 6ce1b8f46a39..36e95196dff4 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -2057,7 +2057,7 @@ static void mb86a20s_release(struct dvb_frontend *fe)
 
 static int mb86a20s_get_frontend_algo(struct dvb_frontend *fe)
 {
-        return DVBFE_ALGO_HW;
+	return DVBFE_ALGO_HW;
 }
 
 static const struct dvb_frontend_ops mb86a20s_ops;
diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
index 58247432a628..ca722084e534 100644
--- a/drivers/media/dvb-frontends/mn88473.c
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -764,7 +764,7 @@ MODULE_DEVICE_TABLE(i2c, mn88473_id_table);
 
 static struct i2c_driver mn88473_driver = {
 	.driver = {
-		.name	             = "mn88473",
+		.name		     = "mn88473",
 		.suppress_bind_attrs = true,
 	},
 	.probe		= mn88473_probe,
diff --git a/drivers/media/dvb-frontends/tda18271c2dd.h b/drivers/media/dvb-frontends/tda18271c2dd.h
index 289653db68e4..afeb9536e9c9 100644
--- a/drivers/media/dvb-frontends/tda18271c2dd.h
+++ b/drivers/media/dvb-frontends/tda18271c2dd.h
@@ -9,8 +9,8 @@ struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
 static inline struct dvb_frontend *tda18271c2dd_attach(struct dvb_frontend *fe,
 					 struct i2c_adapter *i2c, u8 adr)
 {
-        printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-        return NULL;
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
 }
 #endif
 
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index e2ea1f8af283..db4ed9b9df4c 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -777,12 +777,12 @@ config VIDEO_S5K6A3
 	  camera sensor.
 
 config VIDEO_S5K4ECGX
-        tristate "Samsung S5K4ECGX sensor support"
-        depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	tristate "Samsung S5K4ECGX sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select CRC32
-        ---help---
-          This is a V4L2 sensor-level driver for Samsung S5K4ECGX 5M
-          camera sensor with an embedded SoC image signal processor.
+	---help---
+	  This is a V4L2 sensor-level driver for Samsung S5K4ECGX 5M
+	  camera sensor with an embedded SoC image signal processor.
 
 config VIDEO_S5K5BAF
 	tristate "Samsung S5K5BAF sensor support"
diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 11f9029433cf..4a441ee99dd8 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -100,7 +100,7 @@ static const u8 adv7343_init_reg_val[] = {
 };
 
 /*
- * 			    2^32
+ *			    2^32
  * FSC(reg) =  FSC (HZ) * --------
  *			  27000000
  */
diff --git a/drivers/media/i2c/adv7393.c b/drivers/media/i2c/adv7393.c
index f19ad4ecd11e..b6234c8231c9 100644
--- a/drivers/media/i2c/adv7393.c
+++ b/drivers/media/i2c/adv7393.c
@@ -103,7 +103,7 @@ static const u8 adv7393_init_reg_val[] = {
 };
 
 /*
- * 			    2^32
+ *			    2^32
  * FSC(reg) =  FSC (HZ) * --------
  *			  27000000
  */
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 2189980a0f29..4a9c137095fe 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -2065,10 +2065,10 @@ static void cx23885_dif_setup(struct i2c_client *client, u32 ifHz)
 
 	/* Assuming TV */
 	/* Calculate the PLL frequency word based on the adjusted ifHz */
-        pll_freq = div_u64((u64)ifHz * 268435456, 50000000);
-        pll_freq_word = (u32)pll_freq;
+	pll_freq = div_u64((u64)ifHz * 268435456, 50000000);
+	pll_freq_word = (u32)pll_freq;
 
-        cx25840_write4(client, DIF_PLL_FREQ_WORD,  pll_freq_word);
+	cx25840_write4(client, DIF_PLL_FREQ_WORD,  pll_freq_word);
 
 	/* Round down to the nearest 100KHz */
 	ifHz = (ifHz / 100000) * 100000;
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 9b65c7d2fa84..548382b2b2e6 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -131,7 +131,7 @@ static inline struct cx25840_ir_state *to_ir_state(struct v4l2_subdev *sd)
  * Rx and Tx Clock Divider register computations
  *
  * Note the largest clock divider value of 0xffff corresponds to:
- * 	(0xffff + 1) * 1000 / 108/2 MHz = 1,213,629.629... ns
+ *	(0xffff + 1) * 1000 / 108/2 MHz = 1,213,629.629... ns
  * which fits in 21 bits, so we'll use unsigned int for time arguments.
  */
 static inline u16 count_to_clock_divider(unsigned int d)
@@ -187,7 +187,7 @@ static inline unsigned int clock_divider_to_freq(unsigned int divider,
  * Low Pass Filter register calculations
  *
  * Note the largest count value of 0xffff corresponds to:
- * 	0xffff * 1000 / 108/2 MHz = 1,213,611.11... ns
+ *	0xffff * 1000 / 108/2 MHz = 1,213,611.11... ns
  * which fits in 21 bits, so we'll use unsigned int for time arguments.
  */
 static inline u16 count_to_lpf_count(unsigned int d)
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e6b717b83b18..3b7ace395ee6 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1791,7 +1791,7 @@ static int smiapp_set_format_source(struct v4l2_subdev *subdev,
 	if (csi_format->compressed == old_csi_format->compressed)
 		return 0;
 
-	valid_link_freqs = 
+	valid_link_freqs =
 		&sensor->valid_link_freqs[sensor->csi_format->compressed
 					  - sensor->compressed_min_bpp];
 
diff --git a/drivers/media/i2c/tvp5150_reg.h b/drivers/media/i2c/tvp5150_reg.h
index 654c44284787..c43b7b844021 100644
--- a/drivers/media/i2c/tvp5150_reg.h
+++ b/drivers/media/i2c/tvp5150_reg.h
@@ -67,10 +67,10 @@
 
 #define VIDEO_STD_NTSC_MJ_BIT_AS                 0x01
 #define VIDEO_STD_PAL_BDGHIN_BIT_AS              0x03
-#define VIDEO_STD_PAL_M_BIT_AS		         0x05
+#define VIDEO_STD_PAL_M_BIT_AS			 0x05
 #define VIDEO_STD_PAL_COMBINATION_N_BIT_AS	 0x07
 #define VIDEO_STD_NTSC_4_43_BIT_AS		 0x09
-#define VIDEO_STD_SECAM_BIT_AS		         0x0b
+#define VIDEO_STD_SECAM_BIT_AS			 0x0b
 
 /* Reserved 29h-2bh */
 
diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
index 4f9c2395941b..2dfe91f2bd97 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -633,7 +633,7 @@ unsigned int cx18_v4l2_enc_poll(struct file *filp, poll_table *wait)
 
 		if (v4l2_event_pending(&id->fh))
 			res |= POLLPRI;
-                if (eof && videobuf_poll == POLLERR)
+		if (eof && videobuf_poll == POLLERR)
 			return res | POLLHUP;
 		return res | videobuf_poll;
 	}
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index f35f78d66985..b9c6831c21c3 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -116,7 +116,7 @@ static int cx18_prepare_buffer(struct videobuf_queue *q,
 	unsigned int width, unsigned int height,
 	enum v4l2_field field)
 {
-        struct cx18 *cx = s->cx;
+	struct cx18 *cx = s->cx;
 	int rc = 0;
 
 	/* check settings */
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index 040323b0f945..b0d4e4437b87 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -170,7 +170,7 @@ static inline int cx23888_ir_and_or4(struct cx23885_dev *dev, u32 addr,
  * Rx and Tx Clock Divider register computations
  *
  * Note the largest clock divider value of 0xffff corresponds to:
- * 	(0xffff + 1) * 1000 / 108/2 MHz = 1,213,629.629... ns
+ *	(0xffff + 1) * 1000 / 108/2 MHz = 1,213,629.629... ns
  * which fits in 21 bits, so we'll use unsigned int for time arguments.
  */
 static inline u16 count_to_clock_divider(unsigned int d)
@@ -226,7 +226,7 @@ static inline unsigned int clock_divider_to_freq(unsigned int divider,
  * Low Pass Filter register calculations
  *
  * Note the largest count value of 0xffff corresponds to:
- * 	0xffff * 1000 / 108/2 MHz = 1,213,611.11... ns
+ *	0xffff * 1000 / 108/2 MHz = 1,213,611.11... ns
  * which fits in 21 bits, so we'll use unsigned int for time arguments.
  */
 static inline u16 count_to_lpf_count(unsigned int d)
diff --git a/drivers/media/pci/ivtv/ivtv-cards.c b/drivers/media/pci/ivtv/ivtv-cards.c
index 410d97bdf541..c63792964a03 100644
--- a/drivers/media/pci/ivtv/ivtv-cards.c
+++ b/drivers/media/pci/ivtv/ivtv-cards.c
@@ -65,7 +65,7 @@ static struct ivtv_card_tuner_i2c ivtv_i2c_tda8290 = {
 
 /********************** card configuration *******************************/
 
-/* Please add new PCI IDs to: http://pci-ids.ucw.cz/ 
+/* Please add new PCI IDs to: http://pci-ids.ucw.cz/
    This keeps the PCI ID database up to date. Note that the entries
    must be added under vendor 0x4444 (Conexant) as subsystem IDs.
    New vendor IDs should still be added to the vendor ID list. */
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index ecdca0ba3e66..5e6fe686f420 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2005 Andreas Oberritter <obi@linuxtv.org>
  *
  * based on pluto2.c 1.10 - http://instinct-wp8.no-ip.org/pluto/
- * 	by Dany Salman <salmandany@yahoo.fr>
+ *	by Dany Salman <salmandany@yahoo.fr>
  *	Copyright (c) 2004 TDF
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index ac16cf3b065b..4f6867af8311 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
  * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
+ *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/pci/pt1/va1j5jf8007s.c b/drivers/media/pci/pt1/va1j5jf8007s.c
index 2cf776531dc6..f49867aef054 100644
--- a/drivers/media/pci/pt1/va1j5jf8007s.c
+++ b/drivers/media/pci/pt1/va1j5jf8007s.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
  * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
+ *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/pci/pt1/va1j5jf8007s.h b/drivers/media/pci/pt1/va1j5jf8007s.h
index efbe6ccae8b4..f8ce5609095d 100644
--- a/drivers/media/pci/pt1/va1j5jf8007s.h
+++ b/drivers/media/pci/pt1/va1j5jf8007s.h
@@ -4,7 +4,7 @@
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
  * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
+ *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/pci/pt1/va1j5jf8007t.c b/drivers/media/pci/pt1/va1j5jf8007t.c
index d9788d153bb6..a52984a6f9b3 100644
--- a/drivers/media/pci/pt1/va1j5jf8007t.c
+++ b/drivers/media/pci/pt1/va1j5jf8007t.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
  * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
+ *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/pci/pt1/va1j5jf8007t.h b/drivers/media/pci/pt1/va1j5jf8007t.h
index 6fb119c6e73a..95eb7d294d20 100644
--- a/drivers/media/pci/pt1/va1j5jf8007t.h
+++ b/drivers/media/pci/pt1/va1j5jf8007t.h
@@ -4,7 +4,7 @@
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
  * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- * 	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
+ *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 0144f305ea24..2526fc051b65 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -3,7 +3,7 @@
 
     Copyright (C) 1998-2006 Michael Hunold <michael@mihu.de>
 
-    Visit http://www.themm.net/~mihu/linux/saa7146/mxb.html 
+    Visit http://www.themm.net/~mihu/linux/saa7146/mxb.html
     for further details about this card.
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index e7bd2b8484e3..ff2b7da90c08 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -730,7 +730,7 @@ static int tw5864_frameinterval_get(struct tw5864_input *input,
 		frameinterval->denominator = 25;
 		break;
 	default:
-	        dev_warn(&dev->pci->dev, "tw5864_frameinterval_get requested for unknown std %d\n",
+		dev_warn(&dev->pci->dev, "tw5864_frameinterval_get requested for unknown std %d\n",
 			 input->std);
 		return -EINVAL;
 	}
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index fd0c99859d6f..614fbef08ddc 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -353,10 +353,10 @@ config VIDEO_STI_HVA_DEBUGFS
 	depends on DEBUG_FS
 	help
 	  Select this to see information about the internal state and the last
-          operation of STMicroelectronics HVA multi-format video encoder in
-          debugfs.
+	  operation of STMicroelectronics HVA multi-format video encoder in
+	  debugfs.
 
-          Choose N unless you know you need this.
+	  Choose N unless you know you need this.
 
 config VIDEO_STI_DELTA
 	tristate "STMicroelectronics DELTA multi-format video decoder V4L2 driver"
@@ -586,10 +586,10 @@ config VIDEO_SAMSUNG_S5P_CEC
        select CEC_CORE
        select CEC_NOTIFIER
        ---help---
-         This is a driver for Samsung S5P HDMI CEC interface. It uses the
-         generic CEC framework interface.
-         CEC bus is present in the HDMI connector and enables communication
-         between compatible devices.
+	 This is a driver for Samsung S5P HDMI CEC interface. It uses the
+	 generic CEC framework interface.
+	 CEC bus is present in the HDMI connector and enables communication
+	 between compatible devices.
 
 config VIDEO_STI_HDMI_CEC
        tristate "STMicroelectronics STiH4xx HDMI CEC driver"
@@ -597,10 +597,10 @@ config VIDEO_STI_HDMI_CEC
        select CEC_CORE
        select CEC_NOTIFIER
        ---help---
-         This is a driver for STIH4xx HDMI CEC interface. It uses the
-         generic CEC framework interface.
-         CEC bus is present in the HDMI connector and enables communication
-         between compatible devices.
+	 This is a driver for STIH4xx HDMI CEC interface. It uses the
+	 generic CEC framework interface.
+	 CEC bus is present in the HDMI connector and enables communication
+	 between compatible devices.
 
 config VIDEO_STM32_HDMI_CEC
        tristate "STMicroelectronics STM32 HDMI CEC driver"
@@ -609,10 +609,10 @@ config VIDEO_STM32_HDMI_CEC
        select REGMAP_MMIO
        select CEC_CORE
        ---help---
-         This is a driver for STM32 interface. It uses the
-         generic CEC framework interface.
-         CEC bus is present in the HDMI connector and enables communication
-         between compatible devices.
+	 This is a driver for STM32 interface. It uses the
+	 generic CEC framework interface.
+	 CEC bus is present in the HDMI connector and enables communication
+	 between compatible devices.
 
 config VIDEO_TEGRA_HDMI_CEC
        tristate "Tegra HDMI CEC driver"
@@ -620,10 +620,10 @@ config VIDEO_TEGRA_HDMI_CEC
        select CEC_CORE
        select CEC_NOTIFIER
        ---help---
-         This is a driver for the Tegra HDMI CEC interface. It uses the
-         generic CEC framework interface.
-         The CEC bus is present in the HDMI connector and enables communication
-         between compatible devices.
+	 This is a driver for the Tegra HDMI CEC interface. It uses the
+	 generic CEC framework interface.
+	 The CEC bus is present in the HDMI connector and enables communication
+	 between compatible devices.
 
 endif #CEC_PLATFORM_DRIVERS
 
diff --git a/drivers/media/platform/arv.c b/drivers/media/platform/arv.c
index 8fe59bf6cd3f..1351374bb1ef 100644
--- a/drivers/media/platform/arv.c
+++ b/drivers/media/platform/arv.c
@@ -66,7 +66,7 @@ extern struct cpuinfo_m32r	boot_cpu_data;
  *	Note that M32700UT does not support CIF mode, but QVGA is
  *	supported by M32700UT hardware using VGA mode of AR LSI.
  *
- * 	Supported: VGA  (Normal mode, Interlace mode)
+ *	Supported: VGA  (Normal mode, Interlace mode)
  *		   QVGA (Always Interlace mode of VGA)
  *
  */
@@ -590,7 +590,7 @@ static void ar_interrupt(int irq, void *dev)
 
 /*
  * ar_initialize()
- * 	ar_initialize() is called by video_register_device() and
+ *	ar_initialize() is called by video_register_device() and
  *	initializes AR LSI and peripherals.
  *
  *	-1 is returned in all failures.
diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index 478eb2f7d723..d3dc765c1609 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -52,7 +52,7 @@ static irqreturn_t ppi_irq_err(int irq, void *dev_id)
 		struct bfin_ppi_regs *reg = info->base;
 		unsigned short status;
 
-		/* register on bf561 is cleared when read 
+		/* register on bf561 is cleared when read
 		 * others are W1C
 		 */
 		status = bfin_read16(&reg->status);
diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index 89cb3094d7e6..238d01b7f066 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -20,10 +20,10 @@
  * pre-process the Bayer RGB data, before writing it to SDRAM.
  *
  * TODO: 1) Raw bayer parameter settings and bayer capture
- * 	 2) Split module parameter structure to module specific ioctl structs
+ *	 2) Split module parameter structure to module specific ioctl structs
  *	 3) add support for lense shading correction
  *	 4) investigate if enum used for user space type definition
- * 	    to be replaced by #defines or integer
+ *	    to be replaced by #defines or integer
  */
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 5fa0a1f32536..592d3fc91e26 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -22,9 +22,9 @@
  * may be supported using the same module.
  *
  * TODO: Test Raw bayer parameter settings and bayer capture
- * 	 Split module parameter structure to module specific ioctl structs
- * 	 investigate if enum used for user space type definition
- * 	 to be replaced by #defines or integer
+ *	 Split module parameter structure to module specific ioctl structs
+ *	 investigate if enum used for user space type definition
+ *	 to be replaced by #defines or integer
  */
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 7b3f6f8e3dc8..498f69b53de3 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -26,8 +26,8 @@
  *
  *
  *    decoder(TVP5146/		YUV/
- * 	     MT9T001)   -->  Raw Bayer RGB ---> MUX -> VPFE (CCDC/ISIF)
- *    				data input              |      |
+ *	     MT9T001)   -->  Raw Bayer RGB ---> MUX -> VPFE (CCDC/ISIF)
+ *				data input              |      |
  *							V      |
  *						      SDRAM    |
  *							       V
@@ -47,7 +47,7 @@
  *    block such as IPIPE (on DM355 only).
  *
  *    Features supported
- *  		- MMAP IO
+ *		- MMAP IO
  *		- Capture using TVP5146 over BT.656
  *		- support for interfacing decoders using sub device model
  *		- Work with DM355 or DM6446 CCDC to do Raw Bayer RGB/YUV
diff --git a/drivers/media/platform/exynos4-is/fimc-core.h b/drivers/media/platform/exynos4-is/fimc-core.h
index c0373aede81a..82d514df97f0 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.h
+++ b/drivers/media/platform/exynos4-is/fimc-core.h
@@ -303,7 +303,7 @@ struct fimc_m2m_device {
  * @input: capture input type, grp_id of the attached subdev
  * @user_subdev_api: true if subdevs are not configured by the host driver
  * @inh_sensor_ctrls: a flag indicating v4l2 controls are inherited from
- * 		      an image sensor subdev
+ *		      an image sensor subdev
  */
 struct fimc_vid_cap {
 	struct fimc_ctx			*ctx;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.h b/drivers/media/platform/exynos4-is/fimc-lite.h
index 9ae1e96a1bc7..3e238b8c834a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.h
+++ b/drivers/media/platform/exynos4-is/fimc-lite.h
@@ -56,9 +56,9 @@ enum {
  * @max_height: maximum camera interface input height in pixels
  * @out_width_align: minimum output width alignment in pixels
  * @win_hor_offs_align: minimum camera interface crop window horizontal
- * 			offset alignment in pixels
+ *			offset alignment in pixels
  * @out_hor_offs_align: minimum output DMA compose rectangle horizontal
- * 			offset alignment in pixels
+ *			offset alignment in pixels
  * @max_dma_bufs: number of output DMA buffer start address registers
  * @num_instances: total number of FIMC-LITE IP instances available
  */
diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
index 0dc9ed01fffe..cd37bb2a610f 100644
--- a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.h
@@ -26,7 +26,7 @@
  * @inst_addr	: VPU decoder instance address
  * @signaled    : 1 - Host has received ack message from VPU, 0 - not received
  * @ctx         : context for v4l2 layer integration
- * @dev	        : platform device of VPU
+ * @dev		: platform device of VPU
  * @wq          : wait queue to wait VPU message ack
  * @handler     : ipi handler for each decoder
  */
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index b7ff3842afc0..8eb000e3d8fd 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -920,7 +920,7 @@ static void isp_pipeline_suspend(struct isp_pipeline *pipe)
 
 /*
  * isp_pipeline_is_last - Verify if entity has an enabled link to the output
- * 			  video node
+ *			  video node
  * @me: ISP module's media entity
  *
  * Returns 1 if the entity has an enabled link to the output video node or 0
diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
index 8882d901d119..1226d60cc367 100644
--- a/drivers/media/platform/sti/hva/hva.h
+++ b/drivers/media/platform/sti/hva/hva.h
@@ -245,7 +245,7 @@ struct hva_enc;
  * @dbg:             context debug info
  */
 struct hva_ctx {
-	struct hva_dev		        *hva_dev;
+	struct hva_dev			*hva_dev;
 	struct v4l2_fh			fh;
 	struct v4l2_ctrl_handler	ctrl_handler;
 	struct hva_controls		ctrls;
diff --git a/drivers/media/platform/via-camera.h b/drivers/media/platform/via-camera.h
index 2d67f8ce258d..54f16318b1b3 100644
--- a/drivers/media/platform/via-camera.h
+++ b/drivers/media/platform/via-camera.h
@@ -29,7 +29,7 @@
 #define   VCR_CI_BSS	  0x00000002  /* WTF "bit stream selection" */
 #define   VCR_CI_3BUFS	  0x00000004  /* 1 = 3 buffers, 0 = 2 buffers */
 #define   VCR_CI_VIPEN	  0x00000008  /* VIP enable */
-#define   VCR_CI_CCIR601_8  0	        /* CCIR601 input stream, 8 bit */
+#define   VCR_CI_CCIR601_8  0		/* CCIR601 input stream, 8 bit */
 #define   VCR_CI_CCIR656_8  0x00000010  /* ... CCIR656, 8 bit */
 #define   VCR_CI_CCIR601_16 0x00000020  /* ... CCIR601, 16 bit */
 #define   VCR_CI_CCIR656_16 0x00000030  /* ... CCIR656, 16 bit */
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 3aa5ad391581..95f06f3b35dc 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -13,7 +13,7 @@
  * anybody does please mail me.
  *
  * For the pdf file see:
- * http://www.nxp.com/acrobat_download2/expired_datasheets/TEA5757_5759_3.pdf 
+ * http://www.nxp.com/acrobat_download2/expired_datasheets/TEA5757_5759_3.pdf
  *
  *
  * CHANGES:
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index c9f59129af79..dc6c4f985911 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -31,22 +31,22 @@
  * http://www.spinics.net/lists/linux-usb-devel/msg10109.html
  *
  * Version 0.01:	First working version.
- * 			It's required to blacklist AverMedia USB Radio
- * 			in usbhid/hid-quirks.c
+ *			It's required to blacklist AverMedia USB Radio
+ *			in usbhid/hid-quirks.c
  * Version 0.10:	A lot of cleanups and fixes: unpluging the device,
- * 			few mutex locks were added, codinstyle issues, etc.
- * 			Added stereo support. Thanks to
- * 			Douglas Schilling Landgraf <dougsland@gmail.com> and
- * 			David Ellingsworth <david@identd.dyndns.org>
- * 			for discussion, help and support.
+ *			few mutex locks were added, codinstyle issues, etc.
+ *			Added stereo support. Thanks to
+ *			Douglas Schilling Landgraf <dougsland@gmail.com> and
+ *			David Ellingsworth <david@identd.dyndns.org>
+ *			for discussion, help and support.
  * Version 0.11:	Converted to v4l2_device.
  *
  * Many things to do:
- * 	- Correct power management of device (suspend & resume)
- * 	- Add code for scanning and smooth tuning
- * 	- Add code for sensitivity value
- * 	- Correct mistakes
- * 	- In Japan another FREQ_MIN and FREQ_MAX
+ *	- Correct power management of device (suspend & resume)
+ *	- Add code for scanning and smooth tuning
+ *	- Add code for sensitivity value
+ *	- Correct mistakes
+ *	- In Japan another FREQ_MIN and FREQ_MAX
  */
 
 /* kernel includes */
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index c89a7d5b8c55..63869388152b 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -33,18 +33,18 @@
  *		- switched from bit structs to bit masks
  *		- header file cleaned and integrated
  * 2008-01-14	Tobias Lorenz <tobias.lorenz@gmx.net>
- * 		Version 1.0.2
- * 		- hex values are now lower case
- * 		- commented USB ID for ADS/Tech moved on todo list
- * 		- blacklisted si470x in hid-quirks.c
- * 		- rds buffer handling functions integrated into *_work, *_read
- * 		- rds_command in si470x_poll exchanged against simple retval
- * 		- check for firmware version 15
- * 		- code order and prototypes still remain the same
- * 		- spacing and bottom of band codes remain the same
+ *		Version 1.0.2
+ *		- hex values are now lower case
+ *		- commented USB ID for ADS/Tech moved on todo list
+ *		- blacklisted si470x in hid-quirks.c
+ *		- rds buffer handling functions integrated into *_work, *_read
+ *		- rds_command in si470x_poll exchanged against simple retval
+ *		- check for firmware version 15
+ *		- code order and prototypes still remain the same
+ *		- spacing and bottom of band codes remain the same
  * 2008-01-16	Tobias Lorenz <tobias.lorenz@gmx.net>
  *		Version 1.0.3
- * 		- code reordered to avoid function prototypes
+ *		- code reordered to avoid function prototypes
  *		- switch/case defaults are now more user-friendly
  *		- unified comment style
  *		- applied all checkpatch.pl v1.12 suggestions
@@ -88,8 +88,8 @@
  *		- more safety checks, let si470x_get_freq return errno
  *		- vidioc behavior corrected according to v4l2 spec
  * 2008-10-20	Alexey Klimov <klimov.linux@gmail.com>
- * 		- add support for KWorld USB FM Radio FM700
- * 		- blacklisted KWorld radio in hid-core.c and hid-ids.h
+ *		- add support for KWorld USB FM Radio FM700
+ *		- blacklisted KWorld radio in hid-core.c and hid-ids.h
  * 2008-12-03	Mark Lord <mlord@pobox.com>
  *		- add support for DealExtreme USB Radio
  * 2009-01-31	Bob Ross <pigiron@gmx.com>
diff --git a/drivers/media/radio/wl128x/fmdrv_common.h b/drivers/media/radio/wl128x/fmdrv_common.h
index 7f1514eb1c07..552e22ea6bf3 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.h
+++ b/drivers/media/radio/wl128x/fmdrv_common.h
@@ -311,11 +311,11 @@ struct fm_event_msg_hdr {
 #define FM_RDS_GROUP_TYPE_MASK_15B	    ((unsigned long)1<<31)
 
 /* RX Alternate Frequency info */
-#define FM_RDS_MIN_AF		          1
-#define FM_RDS_MAX_AF		        204
-#define FM_RDS_MAX_AF_JAPAN	        140
-#define FM_RDS_1_AF_FOLLOWS	        225
-#define FM_RDS_25_AF_FOLLOWS	        249
+#define FM_RDS_MIN_AF			  1
+#define FM_RDS_MAX_AF			204
+#define FM_RDS_MAX_AF_JAPAN		140
+#define FM_RDS_1_AF_FOLLOWS		225
+#define FM_RDS_25_AF_FOLLOWS		249
 
 /* RDS system type (RDS/RBDS) */
 #define FM_RDS_SYSTEM_RDS		0
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 0f863822889e..f14ead5954e0 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -26,7 +26,7 @@ config LIRC
 	   IR transmitting (aka "blasting") and for the lirc daemon.
 
 menuconfig RC_DECODERS
-        bool "Remote controller decoders"
+	bool "Remote controller decoders"
 	depends on RC_CORE
 	default y
 
@@ -452,9 +452,9 @@ config IR_SERIAL_TRANSMITTER
 	   Serial Port Transmitter support
 
 config IR_SIR
-        tristate "Built-in SIR IrDA port"
-        depends on RC_CORE
-        ---help---
+	tristate "Built-in SIR IrDA port"
+	depends on RC_CORE
+	---help---
 	   Say Y if you want to use a IrDA SIR port Transceivers.
 
 	   To compile this driver as a module, choose M here: the module will
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 5c87c5c6a455..80dc3e241b4a 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -1168,7 +1168,7 @@ static u32 mt2063_set_dnc_output_enable(struct mt2063_state *state,
 
 /*
  * MT2063_SetReceiverMode() - Set the MT2063 receiver mode, according with
- * 			      the selected enum mt2063_delivery_sys type.
+ *			      the selected enum mt2063_delivery_sys type.
  *
  *  (DNC1GC & DNC2GC are the values, which are used, when the specific
  *   DNC Output is selected, the other is always off)
@@ -1544,7 +1544,7 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
 	 * Save original LO1 and LO2 register values
 	 */
 	ofLO1 = state->AS_Data.f_LO1;
-	ofLO2 = state->AS_Data.f_LO2; 
+	ofLO2 = state->AS_Data.f_LO2;
 
 	/*
 	 * Find and set RF Band setting
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index e35b1faf0ddc..9e34d31d724d 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -532,7 +532,7 @@ MODULE_DEVICE_TABLE(i2c, si2157_id_table);
 
 static struct i2c_driver si2157_driver = {
 	.driver = {
-		.name	             = "si2157",
+		.name		     = "si2157",
 		.suppress_bind_attrs = true,
 	},
 	.probe		= si2157_probe,
diff --git a/drivers/media/tuners/tuner-i2c.h b/drivers/media/tuners/tuner-i2c.h
index bda67a5a76f2..56dc2339a989 100644
--- a/drivers/media/tuners/tuner-i2c.h
+++ b/drivers/media/tuners/tuner-i2c.h
@@ -75,7 +75,7 @@ static inline int tuner_i2c_xfer_send_recv(struct tuner_i2c_props *props,
  *
  * state structure must contain the following:
  *
- * 	struct list_head	hybrid_tuner_instance_list;
+ *	struct list_head	hybrid_tuner_instance_list;
  *	struct tuner_i2c_props	i2c_props;
  *
  * hybrid_tuner_instance_list (both within state structure and globally)
diff --git a/drivers/media/usb/as102/as10x_cmd_cfg.c b/drivers/media/usb/as102/as10x_cmd_cfg.c
index c87f2ca223a2..fabbfead96d8 100644
--- a/drivers/media/usb/as102/as10x_cmd_cfg.c
+++ b/drivers/media/usb/as102/as10x_cmd_cfg.c
@@ -133,9 +133,9 @@ int as10x_cmd_set_context(struct as10x_bus_adapter_t *adap, uint16_t tag,
  * as10x_cmd_eLNA_change_mode - send eLNA change mode command to AS10x
  * @adap:      pointer to AS10x bus adapter
  * @mode:      mode selected:
- *	        - ON    : 0x0 => eLNA always ON
- *	        - OFF   : 0x1 => eLNA always OFF
- *	        - AUTO  : 0x2 => eLNA follow hysteresis parameters
+ *		- ON    : 0x0 => eLNA always ON
+ *		- OFF   : 0x1 => eLNA always OFF
+ *		- AUTO  : 0x2 => eLNA follow hysteresis parameters
  *				 to be ON or OFF
  *
  * Return 0 on success or negative value in case of error.
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 2f52d66b4dae..0df62d3951cf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -105,7 +105,7 @@ void uninitGPIO(struct cx231xx *dev)
 
 /******************************************************************************
  *                    A F E - B L O C K    C O N T R O L   functions          *
- * 				[ANALOG FRONT END]			      *
+ *				[ANALOG FRONT END]			      *
  ******************************************************************************/
 static int afe_write_byte(struct cx231xx *dev, u16 saddr, u8 data)
 {
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index 4cc029f18aa8..451e076525d3 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -71,10 +71,10 @@ config VIDEO_EM28XX_DVB
 	  Empiatech em28xx chips.
 
 config VIDEO_EM28XX_RC
-        tristate "EM28XX Remote Controller support"
-        depends on RC_CORE
-        depends on VIDEO_EM28XX
-        depends on !(RC_CORE=m && VIDEO_EM28XX=y)
-        default VIDEO_EM28XX
-        ---help---
-          Enables Remote Controller support on em28xx driver.
+	tristate "EM28XX Remote Controller support"
+	depends on RC_CORE
+	depends on VIDEO_EM28XX
+	depends on !(RC_CORE=m && VIDEO_EM28XX=y)
+	default VIDEO_EM28XX
+	---help---
+	  Enables Remote Controller support on em28xx driver.
diff --git a/drivers/media/usb/gspca/autogain_functions.c b/drivers/media/usb/gspca/autogain_functions.c
index f721e83596be..6dfab2b077f7 100644
--- a/drivers/media/usb/gspca/autogain_functions.c
+++ b/drivers/media/usb/gspca/autogain_functions.c
@@ -32,7 +32,7 @@ int gspca_expo_autogain(
 	int i, steps, retval = 0;
 
 	if (v4l2_ctrl_g_ctrl(gspca_dev->autogain) == 0)
-	        return 0;
+		return 0;
 
 	orig_gain = gain = v4l2_ctrl_g_ctrl(gspca_dev->gain);
 	orig_exposure = exposure = v4l2_ctrl_g_ctrl(gspca_dev->exposure);
@@ -75,11 +75,11 @@ int gspca_expo_autogain(
 	}
 
 	if (gain != orig_gain) {
-	        v4l2_ctrl_s_ctrl(gspca_dev->gain, gain);
+		v4l2_ctrl_s_ctrl(gspca_dev->gain, gain);
 		retval = 1;
 	}
 	if (exposure != orig_exposure) {
-	        v4l2_ctrl_s_ctrl(gspca_dev->exposure, exposure);
+		v4l2_ctrl_s_ctrl(gspca_dev->exposure, exposure);
 		retval = 1;
 	}
 
@@ -112,7 +112,7 @@ int gspca_coarse_grained_expo_autogain(
 	int steps, retval = 0;
 
 	if (v4l2_ctrl_g_ctrl(gspca_dev->autogain) == 0)
-	        return 0;
+		return 0;
 
 	orig_gain = gain = v4l2_ctrl_g_ctrl(gspca_dev->gain);
 	orig_exposure = exposure = v4l2_ctrl_g_ctrl(gspca_dev->exposure);
@@ -158,11 +158,11 @@ int gspca_coarse_grained_expo_autogain(
 	}
 
 	if (gain != orig_gain) {
-	        v4l2_ctrl_s_ctrl(gspca_dev->gain, gain);
+		v4l2_ctrl_s_ctrl(gspca_dev->gain, gain);
 		retval = 1;
 	}
 	if (exposure != orig_exposure) {
-	        v4l2_ctrl_s_ctrl(gspca_dev->exposure, exposure);
+		v4l2_ctrl_s_ctrl(gspca_dev->exposure, exposure);
 		retval = 1;
 	}
 
diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index 8d41cd46a79d..2b09af8865f4 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -543,7 +543,7 @@ static int do_command(struct gspca_dev *gspca_dev, u16 command,
 			input_report_key(gspca_dev->input_dev, KEY_CAMERA, a);
 			input_sync(gspca_dev->input_dev);
 #endif
-	        	sd->params.qx3.button = a;
+			sd->params.qx3.button = a;
 		}
 		if (sd->params.qx3.button) {
 			/* button pressed - unlock the latch */
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.h b/drivers/media/usb/gspca/stv06xx/stv06xx.h
index f9d74e4d7cf9..480186706bba 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.h
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.h
@@ -59,7 +59,7 @@
 
 /* Refers to the CIF 352x288 and QCIF 176x144 */
 /* 1: 288 lines, 2: 144 lines */
-#define STV_Y_CTRL		        0x15c3
+#define STV_Y_CTRL			0x15c3
 
 #define STV_RESET                       0x1620
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
index 51b3312eaea1..71537097c13f 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
@@ -319,12 +319,12 @@ static struct tda829x_config tda829x_no_probe = {
 };
 
 static struct tda18271_std_map hauppauge_tda18271_dvbt_std_map = {
-        .dvbt_6   = { .if_freq = 3300, .agc_mode = 3, .std = 4,
-                      .if_lvl = 1, .rfagc_top = 0x37, },
-        .dvbt_7   = { .if_freq = 3800, .agc_mode = 3, .std = 5,
-                      .if_lvl = 1, .rfagc_top = 0x37, },
-        .dvbt_8   = { .if_freq = 4300, .agc_mode = 3, .std = 6,
-                      .if_lvl = 1, .rfagc_top = 0x37, },
+	.dvbt_6   = { .if_freq = 3300, .agc_mode = 3, .std = 4,
+		      .if_lvl = 1, .rfagc_top = 0x37, },
+	.dvbt_7   = { .if_freq = 3800, .agc_mode = 3, .std = 5,
+		      .if_lvl = 1, .rfagc_top = 0x37, },
+	.dvbt_8   = { .if_freq = 4300, .agc_mode = 3, .std = 6,
+		      .if_lvl = 1, .rfagc_top = 0x37, },
 };
 
 static struct tda18271_config hauppauge_tda18271_dvb_config = {
diff --git a/drivers/media/usb/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
index 23a0ceb4bfea..e1e45770e28d 100644
--- a/drivers/media/usb/tm6000/tm6000.h
+++ b/drivers/media/usb/tm6000/tm6000.h
@@ -177,7 +177,7 @@ struct tm6000_core {
 	struct tm6000_capabilities	caps;
 
 	/* Used to load alsa/dvb */
-        struct work_struct		request_module_wk;
+	struct work_struct		request_module_wk;
 
 	/* Tuner configuration */
 	int				tuner_type;		/* type of the tuner */
diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
index b833c5b9094e..14a0941fa0d0 100644
--- a/drivers/media/usb/usbtv/Kconfig
+++ b/drivers/media/usb/usbtv/Kconfig
@@ -1,11 +1,11 @@
 config VIDEO_USBTV
-        tristate "USBTV007 video capture support"
-        depends on VIDEO_V4L2 && SND
-        select SND_PCM
-        select VIDEOBUF2_VMALLOC
+	tristate "USBTV007 video capture support"
+	depends on VIDEO_V4L2 && SND
+	select SND_PCM
+	select VIDEOBUF2_VMALLOC
 
-        ---help---
-          This is a video4linux2 driver for USBTV007 based video capture devices.
+	---help---
+	  This is a video4linux2 driver for USBTV007 based video capture devices.
 
-          To compile this driver as a module, choose M here: the
-          module will be called usbtv
+	  To compile this driver as a module, choose M here: the
+	  module will be called usbtv
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index fbcb275e867b..bf52fbd07aed 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -41,8 +41,8 @@ config VIDEO_TUNER
 
 # Used by drivers that need v4l2-mem2mem.ko
 config V4L2_MEM2MEM_DEV
-        tristate
-        depends on VIDEOBUF2_CORE
+	tristate
+	depends on VIDEOBUF2_CORE
 
 # Used by LED subsystem flash drivers
 config V4L2_FLASH_LED_CLASS
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 821f2aa299ae..8d79691b1dce 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -38,7 +38,7 @@ struct v4l2_clip32 {
 
 struct v4l2_window32 {
 	struct v4l2_rect        w;
-	__u32		  	field;	/* enum v4l2_field */
+	__u32			field;	/* enum v4l2_field */
 	__u32			chromakey;
 	compat_caddr_t		clips; /* actually struct v4l2_clip32 * */
 	__u32			clipcount;
diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 930f9c53a64e..e2ee5f00c445 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -249,7 +249,7 @@ EXPORT_SYMBOL_GPL(v4l2_find_dv_timings_cea861_vic);
  * @t2: with this struct.
  * @pclock_delta: the allowed pixelclock deviation.
  * @match_reduced_fps: if true, then fail if V4L2_DV_FL_REDUCED_FPS does not
- * 	match.
+ *	match.
  *
  * Compare t1 with t2 with a given margin of error for the pixelclock.
  */
diff --git a/include/media/dvb_frontend.h b/include/media/dvb_frontend.h
index 0b40886fd7d3..331c8269c00e 100644
--- a/include/media/dvb_frontend.h
+++ b/include/media/dvb_frontend.h
@@ -99,10 +99,10 @@ struct dvb_tuner_info {
  * struct analog_parameters - Parameters to tune into an analog/radio channel
  *
  * @frequency:	Frequency used by analog TV tuner (either in 62.5 kHz step,
- * 		for TV, or 62.5 Hz for radio)
+ *		for TV, or 62.5 Hz for radio)
  * @mode:	Tuner mode, as defined on enum v4l2_tuner_type
  * @audmode:	Audio mode as defined for the rxsubchans field at videodev2.h,
- * 		e. g. V4L2_TUNER_MODE_*
+ *		e. g. V4L2_TUNER_MODE_*
  * @std:	TV standard bitmap as defined at videodev2.h, e. g. V4L2_STD_*
  *
  * Hybrid tuners should be supported by both V4L2 and DVB APIs. This
@@ -205,7 +205,7 @@ enum dvbfe_search {
  * @get_frequency:	get the actual tuned frequency
  * @get_bandwidth:	get the bandwitdh used by the low pass filters
  * @get_if_frequency:	get the Intermediate Frequency, in Hz. For baseband,
- * 			should return 0.
+ *			should return 0.
  * @get_status:		returns the frontend lock status
  * @get_rf_strength:	returns the RF signal strength. Used mostly to support
  *			analog TV and radio. Digital TV should report, instead,
@@ -364,7 +364,7 @@ struct dtv_frontend_properties;
  *			implementing this callback only if DVBv3 API
  *			compatibility is wanted.
  * @read_snr:		legacy callback function to return the Signal/Noise
- * 			rate. Newer drivers should provide such info via
+ *			rate. Newer drivers should provide such info via
  *			DVBv5 API, e. g. @set_frontend/@get_frontend,
  *			implementing this callback only if DVBv3 API
  *			compatibility is wanted.
@@ -490,7 +490,7 @@ struct dvb_fe_events {
  * @fec_inner:		Forward error correction inner Code Rate
  * @transmission_mode:	Transmission Mode
  * @bandwidth_hz:	Bandwidth, in Hz. A zero value means that userspace
- * 			wants to autodetect.
+ *			wants to autodetect.
  * @guard_interval:	Guard Interval
  * @hierarchy:		Hierarchy
  * @symbol_rate:	Symbol Rate
@@ -538,7 +538,7 @@ struct dvb_fe_events {
  * @lna:		Power ON/OFF/AUTO the Linear Now-noise Amplifier (LNA)
  * @strength:		DVBv5 API statistics: Signal Strength
  * @cnr:		DVBv5 API statistics: Signal to Noise ratio of the
- * 			(main) carrier
+ *			(main) carrier
  * @pre_bit_error:	DVBv5 API statistics: pre-Viterbi bit error count
  * @pre_bit_count:	DVBv5 API statistics: pre-Viterbi bit count
  * @post_bit_error:	DVBv5 API statistics: post-Viterbi bit error count
diff --git a/include/media/dvb_vb2.h b/include/media/dvb_vb2.h
index 5431e5a7e140..dda61af7c4cd 100644
--- a/include/media/dvb_vb2.h
+++ b/include/media/dvb_vb2.h
@@ -213,7 +213,7 @@ int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req);
  * @b:		&struct dmx_buffer passed from userspace in
  *		order to handle &DMX_QUERYBUF.
  *
- * 
+ *
  */
 int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
 
diff --git a/include/media/dvbdev.h b/include/media/dvbdev.h
index bbc1c20c0529..554db879527f 100644
--- a/include/media/dvbdev.h
+++ b/include/media/dvbdev.h
@@ -193,7 +193,7 @@ struct dvb_device {
  * @module:	initialized with THIS_MODULE at the caller
  * @device:	pointer to struct device that corresponds to the device driver
  * @adapter_nums: Array with a list of the numbers for @dvb_register_adapter;
- * 		to select among them. Typically, initialized with:
+ *		to select among them. Typically, initialized with:
  *		DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nums)
  */
 int dvb_register_adapter(struct dvb_adapter *adap, const char *name,
@@ -259,7 +259,7 @@ void dvb_unregister_device(struct dvb_device *dvbdev);
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 /**
  * dvb_create_media_graph - Creates media graph for the Digital TV part of the
- * 				device.
+ *				device.
  *
  * @adap:			pointer to &struct dvb_adapter
  * @create_rf_connector:	if true, it creates the RF connector too
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 96e19246b934..1592d323c577 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -28,7 +28,7 @@ struct v4l2_async_notifier;
  *	in order to identify a match
  *
  * @V4L2_ASYNC_MATCH_CUSTOM: Match will use the logic provided by &struct
- * 	v4l2_async_subdev.match ops
+ *	v4l2_async_subdev.match ops
  * @V4L2_ASYNC_MATCH_DEVNAME: Match will use the device name
  * @V4L2_ASYNC_MATCH_I2C: Match will check for I2C adapter ID and address
  * @V4L2_ASYNC_MATCH_FWNODE: Match will use firmware node
@@ -55,7 +55,7 @@ enum v4l2_async_match_type {
  *		string containing the device name to be matched.
  *		Used if @match_type is %V4L2_ASYNC_MATCH_DEVNAME.
  * @match.i2c:	embedded struct with I2C parameters to be matched.
- * 		Both @match.i2c.adapter_id and @match.i2c.address
+ *		Both @match.i2c.adapter_id and @match.i2c.address
  *		should be matched.
  *		Used if @match_type is %V4L2_ASYNC_MATCH_I2C.
  * @match.i2c.adapter_id:
@@ -188,7 +188,7 @@ void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier);
 
 /**
  * v4l2_async_register_subdev - registers a sub-device to the asynchronous
- * 	subdevice framework
+ *	subdevice framework
  *
  * @sd: pointer to &struct v4l2_subdev
  */
@@ -218,7 +218,7 @@ int __must_check v4l2_async_register_subdev_sensor_common(
 
 /**
  * v4l2_async_unregister_subdev - unregisters a sub-device to the asynchronous
- * 	subdevice framework
+ *	subdevice framework
  *
  * @sd: pointer to &struct v4l2_subdev
  */
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index f420c45f7915..7fc0bc6b8007 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -127,7 +127,7 @@ struct v4l2_subdev_ops;
  * @client_type:  name of the chip that's on the adapter.
  * @addr: I2C address. If zero, it will use @probe_addrs
  * @probe_addrs: array with a list of address. The last entry at such
- * 	array should be %I2C_CLIENT_END.
+ *	array should be %I2C_CLIENT_END.
  *
  * returns a &struct v4l2_subdev pointer.
  */
@@ -146,7 +146,7 @@ struct i2c_board_info;
  * @info: pointer to struct i2c_board_info used to replace the irq,
  *	 platform_data and addr arguments.
  * @probe_addrs: array with a list of address. The last entry at such
- * 	array should be %I2C_CLIENT_END.
+ *	array should be %I2C_CLIENT_END.
  *
  * returns a &struct v4l2_subdev pointer.
  */
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5ccf5019408a..5253b5471897 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -1146,7 +1146,7 @@ int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 
 /**
  * v4l2_ctrl_subdev_subscribe_event - Helper function to implement
- * 	as a &struct v4l2_subdev_core_ops subscribe_event function
+ *	as a &struct v4l2_subdev_core_ops subscribe_event function
  *	that just subscribes control events.
  *
  * @sd: pointer to &struct v4l2_subdev
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 88773a67a806..267fd2bed17b 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -66,7 +66,7 @@ struct v4l2_ctrl_handler;
  * enum v4l2_video_device_flags - Flags used by &struct video_device
  *
  * @V4L2_FL_REGISTERED:
- * 	indicates that a &struct video_device is registered.
+ *	indicates that a &struct video_device is registered.
  *	Drivers can clear this flag if they want to block all future
  *	device access. It is cleared by video_unregister_device.
  * @V4L2_FL_USES_V4L2_FH:
@@ -198,7 +198,7 @@ struct v4l2_file_operations {
 
 /*
  * Newer version of video_device, handled by videodev2.c
- * 	This version moves redundant code from video device code to
+ *	This version moves redundant code from video device code to
  *	the common handler
  */
 
@@ -317,7 +317,7 @@ struct video_device
  * @vdev: struct video_device to register
  * @type: type of device to register, as defined by &enum vfl_devnode_type
  * @nr:   which device node number is desired:
- * 	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
+ *	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
  * @warn_if_nr_in_use: warn if the desired device node number
  *        was already in use and another number was chosen instead.
  * @owner: module that owns the video device node
@@ -351,13 +351,13 @@ int __must_check __video_register_device(struct video_device *vdev,
  * @vdev: struct video_device to register
  * @type: type of device to register, as defined by &enum vfl_devnode_type
  * @nr:   which device node number is desired:
- * 	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
+ *	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
  *
  * Internally, it calls __video_register_device(). Please see its
  * documentation for more details.
  *
  * .. note::
- * 	if video_register_device fails, the release() callback of
+ *	if video_register_device fails, the release() callback of
  *	&struct video_device structure is *not* called, so the caller
  *	is responsible for freeing any data. Usually that means that
  *	you video_device_release() should be called on failure.
@@ -375,7 +375,7 @@ static inline int __must_check video_register_device(struct video_device *vdev,
  * @vdev: struct video_device to register
  * @type: type of device to register, as defined by &enum vfl_devnode_type
  * @nr:   which device node number is desired:
- * 	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
+ *	(0 == /dev/video0, 1 == /dev/video1, ..., -1 == first free)
  *
  * This function is identical to video_register_device() except that no
  * warning is issued if the desired device node number was already in use.
@@ -384,7 +384,7 @@ static inline int __must_check video_register_device(struct video_device *vdev,
  * documentation for more details.
  *
  * .. note::
- * 	if video_register_device fails, the release() callback of
+ *	if video_register_device fails, the release() callback of
  *	&struct video_device structure is *not* called, so the caller
  *	is responsible for freeing any data. Usually that means that
  *	you video_device_release() should be called on failure.
@@ -423,7 +423,7 @@ void video_device_release(struct video_device *vdev);
 
 /**
  * video_device_release_empty - helper function to implement the
- * 	video_device->release\(\) callback.
+ *	video_device->release\(\) callback.
  *
  * @vdev: pointer to &struct video_device
  *
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 4e83529117f7..17833e886e11 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -184,7 +184,7 @@ int v4l2_event_subdev_unsubscribe(struct v4l2_subdev *sd,
 				  struct v4l2_event_subscription *sub);
 /**
  * v4l2_src_change_event_subscribe - helper function that calls
- * 	v4l2_event_subscribe() if the event is %V4L2_EVENT_SOURCE_CHANGE.
+ *	v4l2_event_subscribe() if the event is %V4L2_EVENT_SOURCE_CHANGE.
  *
  * @fh: pointer to struct v4l2_fh
  * @sub: pointer to &struct v4l2_event_subscription
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 71b8ff4b2e0e..980a86c08fce 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -116,7 +116,7 @@ struct v4l2_decode_vbi_line {
  * @V4L2_SUBDEV_IO_PIN_OUTPUT: set it if pin is an output.
  * @V4L2_SUBDEV_IO_PIN_INPUT: set it if pin is an input.
  * @V4L2_SUBDEV_IO_PIN_SET_VALUE: to set the output value via
- * 				  &struct v4l2_subdev_io_pin_config->value.
+ *				  &struct v4l2_subdev_io_pin_config->value.
  * @V4L2_SUBDEV_IO_PIN_ACTIVE_LOW: pin active is bit 0.
  *				   Otherwise, ACTIVE HIGH is assumed.
  */
@@ -253,14 +253,14 @@ struct v4l2_subdev_core_ops {
  *
  * .. note::
  *
- * 	On devices that have both AM/FM and TV, it is up to the driver
+ *	On devices that have both AM/FM and TV, it is up to the driver
  *	to explicitly call s_radio when the tuner should be switched to
  *	radio mode, before handling other &struct v4l2_subdev_tuner_ops
  *	that would require it. An example of such usage is::
  *
  *	  static void s_frequency(void *priv, const struct v4l2_frequency *f)
  *	  {
- * 		...
+ *		...
  *		if (f.type == V4L2_TUNER_RADIO)
  *			v4l2_device_call_all(v4l2_dev, 0, tuner, s_radio);
  *		...
@@ -333,7 +333,7 @@ enum v4l2_mbus_frame_desc_flags {
  *
  * @flags:	bitmask flags, as defined by &enum v4l2_mbus_frame_desc_flags.
  * @pixelcode:	media bus pixel code, valid if @flags
- * 		%FRAME_DESC_FL_BLOB is not set.
+ *		%FRAME_DESC_FL_BLOB is not set.
  * @length:	number of octets per frame, valid if @flags
  *		%V4L2_MBUS_FRAME_DESC_FL_LEN_MAX is set.
  */
-- 
2.14.3
