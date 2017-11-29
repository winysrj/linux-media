Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52328 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752157AbdK2TIz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:55 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Luis Oliveira <lolivei@synopsys.com>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Benoit Parrot <bparrot@ti.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>, Sean Young <sean@mess.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 19/22] media: drivers: remove "/**" from non-kernel-doc comments
Date: Wed, 29 Nov 2017 14:08:37 -0500
Message-Id: <a655999ebb1db154d7fbb0c30c0949f4a50a5e1f.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several comments are wrongly tagged as kernel-doc, causing
those warnings:

  drivers/media/rc/st_rc.c:98: warning: No description found for parameter 'irq'
  drivers/media/rc/st_rc.c:98: warning: No description found for parameter 'data'
  drivers/media/pci/solo6x10/solo6x10-enc.c:183: warning: No description found for parameter 'solo_dev'
  drivers/media/pci/solo6x10/solo6x10-enc.c:183: warning: No description found for parameter 'ch'
  drivers/media/pci/solo6x10/solo6x10-enc.c:183: warning: No description found for parameter 'qp'
  drivers/media/usb/pwc/pwc-dec23.c:652: warning: Cannot understand  *
   on line 652 - I thought it was a doc line
  drivers/media/usb/dvb-usb/cinergyT2-fe.c:40: warning: No description found for parameter 'op'
  drivers/media/usb/dvb-usb/friio-fe.c:301: warning: Cannot understand  * (reg, val) commad list to initialize this module.
   on line 301 - I thought it was a doc line
  drivers/media/rc/streamzap.c:201: warning: No description found for parameter 'urb'
  drivers/media/rc/streamzap.c:333: warning: No description found for parameter 'intf'
  drivers/media/rc/streamzap.c:333: warning: No description found for parameter 'id'
  drivers/media/rc/streamzap.c:464: warning: No description found for parameter 'interface'
  drivers/media/i2c/ov5647.c:432: warning: Cannot understand  * @short Subdev core operations registration
   on line 432 - I thought it was a doc line
  drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'd'
  drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'addr'
  drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'wbuf'
  drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'wlen'
  drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'rbuf'
  drivers/media/usb/dvb-usb/friio.c:35: warning: No description found for parameter 'rlen'
  drivers/media/platform/vim2m.c:350: warning: No description found for parameter 'priv'
  drivers/media/dvb-frontends/tua6100.c:34: warning: cannot understand function prototype: 'struct tua6100_priv '
  drivers/media/platform/sti/hva/hva-h264.c:140: warning: cannot understand function prototype: 'struct hva_h264_stereo_video_sei '
  drivers/media/platform/sti/hva/hva-h264.c:150: warning: Cannot understand  * @frame_width: width in pixels of the buffer containing the input frame
   on line 150 - I thought it was a doc line
  drivers/media/platform/sti/hva/hva-h264.c:356: warning: Cannot understand  * @ slice_size: slice size
   on line 356 - I thought it was a doc line
  drivers/media/platform/sti/hva/hva-h264.c:369: warning: Cannot understand  * @ bitstream_size: bitstream size
   on line 369 - I thought it was a doc line
  drivers/media/platform/sti/hva/hva-h264.c:395: warning: Cannot understand  * @seq_info:  sequence information buffer
   on line 395 - I thought it was a doc line
  drivers/media/dvb-frontends/sp887x.c:137: warning: No description found for parameter 'fe'
  drivers/media/dvb-frontends/sp887x.c:137: warning: No description found for parameter 'fw'
  drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'n'
  drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'd'
  drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'quotient_i'
  drivers/media/dvb-frontends/sp887x.c:287: warning: No description found for parameter 'quotient_f'
  drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c:83: warning: cannot understand function prototype: 'struct ttusb '
  drivers/media/platform/sh_veu.c:277: warning: No description found for parameter 'priv'
  drivers/media/dvb-frontends/zl10036.c:33: warning: cannot understand function prototype: 'int zl10036_debug; '
  drivers/media/dvb-frontends/zl10036.c:179: warning: No description found for parameter 'state'
  drivers/media/dvb-frontends/zl10036.c:179: warning: No description found for parameter 'frequency'
  drivers/media/platform/rcar_fdp1.c:1139: warning: No description found for parameter 'priv'
  drivers/media/platform/ti-vpe/vpe.c:933: warning: No description found for parameter 'priv'
  drivers/media/usb/gspca/ov519.c:36: warning: No description found for parameter 'fmt'
  drivers/media/usb/dvb-usb/dib0700_devices.c:3367: warning: No description found for parameter 'adap'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/sp887x.c              |  6 +++---
 drivers/media/dvb-frontends/tua6100.c             |  2 +-
 drivers/media/dvb-frontends/zl10036.c             |  8 ++++----
 drivers/media/i2c/ov5647.c                        |  4 ++--
 drivers/media/pci/solo6x10/solo6x10-enc.c         |  2 +-
 drivers/media/platform/rcar_fdp1.c                |  2 +-
 drivers/media/platform/sh_veu.c                   |  2 +-
 drivers/media/platform/sti/hva/hva-h264.c         | 18 +++++++++++++-----
 drivers/media/platform/ti-vpe/vpe.c               |  2 +-
 drivers/media/platform/vim2m.c                    |  2 +-
 drivers/media/rc/st_rc.c                          |  6 +++---
 drivers/media/rc/streamzap.c                      |  6 +++---
 drivers/media/usb/dvb-usb/cinergyT2-fe.c          |  2 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c       |  8 ++++----
 drivers/media/usb/dvb-usb/friio-fe.c              |  2 +-
 drivers/media/usb/dvb-usb/friio.c                 |  2 +-
 drivers/media/usb/gspca/ov519.c                   |  2 +-
 drivers/media/usb/pwc/pwc-dec23.c                 |  7 +++----
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c |  6 +++---
 19 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
index 7c511c3cd4ca..d2c402b52c6e 100644
--- a/drivers/media/dvb-frontends/sp887x.c
+++ b/drivers/media/dvb-frontends/sp887x.c
@@ -57,7 +57,7 @@ static int sp887x_writereg (struct sp887x_state* state, u16 reg, u16 data)
 	int ret;
 
 	if ((ret = i2c_transfer(state->i2c, &msg, 1)) != 1) {
-		/**
+		/*
 		 *  in case of soft reset we ignore ACK errors...
 		 */
 		if (!(reg == 0xf1a && data == 0x000 &&
@@ -130,7 +130,7 @@ static void sp887x_setup_agc (struct sp887x_state* state)
 
 #define BLOCKSIZE 30
 #define FW_SIZE 0x4000
-/**
+/*
  *  load firmware and setup MPEG interface...
  */
 static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware *fw)
@@ -279,7 +279,7 @@ static int configure_reg0xc05(struct dtv_frontend_properties *p, u16 *reg0xc05)
 	return 0;
 }
 
-/**
+/*
  *  estimates division of two 24bit numbers,
  *  derived from the ves1820/stv0299 driver code
  */
diff --git a/drivers/media/dvb-frontends/tua6100.c b/drivers/media/dvb-frontends/tua6100.c
index 18e6d4c5be21..1d41abd47f04 100644
--- a/drivers/media/dvb-frontends/tua6100.c
+++ b/drivers/media/dvb-frontends/tua6100.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Driver for Infineon tua6100 pll.
  *
  * (c) 2006 Andrew de Quincey
diff --git a/drivers/media/dvb-frontends/zl10036.c b/drivers/media/dvb-frontends/zl10036.c
index 062282739ce5..89dd65ae88ad 100644
--- a/drivers/media/dvb-frontends/zl10036.c
+++ b/drivers/media/dvb-frontends/zl10036.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Driver for Zarlink zl10036 DVB-S silicon tuner
  *
  * Copyright (C) 2006 Tino Reichardt
@@ -157,7 +157,7 @@ static int zl10036_sleep(struct dvb_frontend *fe)
 	return ret;
 }
 
-/**
+/*
  * register map of the ZL10036/ZL10038
  *
  * reg[default] content
@@ -219,7 +219,7 @@ static int zl10036_set_bandwidth(struct zl10036_state *state, u32 fbw)
 	if (fbw <= 28820) {
 		br = _BR_MAXIMUM;
 	} else {
-		/**
+		/*
 		 *  f(bw)=34,6MHz f(xtal)=10.111MHz
 		 *  br = (10111/34600) * 63 * 1/K = 14;
 		 */
@@ -315,7 +315,7 @@ static int zl10036_set_params(struct dvb_frontend *fe)
 	||  (frequency > fe->ops.info.frequency_max))
 		return -EINVAL;
 
-	/**
+	/*
 	 * alpha = 1.35 for dvb-s
 	 * fBW = (alpha*symbolrate)/(2*0.8)
 	 * 1.35 / (2*0.8) = 27 / 32
diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 34179d232a35..da39c49de503 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -428,8 +428,8 @@ static int ov5647_sensor_set_register(struct v4l2_subdev *sd,
 }
 #endif
 
-/**
- * @short Subdev core operations registration
+/*
+ * Subdev core operations registration
  */
 static const struct v4l2_subdev_core_ops ov5647_subdev_core_ops = {
 	.s_power		= ov5647_sensor_power,
diff --git a/drivers/media/pci/solo6x10/solo6x10-enc.c b/drivers/media/pci/solo6x10/solo6x10-enc.c
index d28211bb9674..58d6b5131dd0 100644
--- a/drivers/media/pci/solo6x10/solo6x10-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-enc.c
@@ -175,7 +175,7 @@ int solo_osd_print(struct solo_enc_dev *solo_enc)
 	return 0;
 }
 
-/**
+/*
  * Set channel Quality Profile (0-3).
  */
 void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 3245bc45f4a0..b13dec3081e5 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -1132,7 +1132,7 @@ static int fdp1_device_process(struct fdp1_ctx *ctx)
  * mem2mem callbacks
  */
 
-/**
+/*
  * job_ready() - check whether an instance is ready to be scheduled to run
  */
 static int fdp1_m2m_job_ready(void *priv)
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 15a562af13c7..dedc1b024f6f 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -267,7 +267,7 @@ static void sh_veu_process(struct sh_veu_dev *veu,
 	sh_veu_reg_write(veu, VEU_EIER, 1); /* enable interrupt in VEU */
 }
 
-/**
+/*
  * sh_veu_device_run() - prepares and starts the device
  *
  * This will be called by the framework when it decides to schedule a particular
diff --git a/drivers/media/platform/sti/hva/hva-h264.c b/drivers/media/platform/sti/hva/hva-h264.c
index a7e5eed17ada..17f1eb0ba957 100644
--- a/drivers/media/platform/sti/hva/hva-h264.c
+++ b/drivers/media/platform/sti/hva/hva-h264.c
@@ -134,7 +134,7 @@ enum hva_h264_sei_payload_type {
 	SEI_FRAME_PACKING_ARRANGEMENT = 45
 };
 
-/**
+/*
  * stereo Video Info struct
  */
 struct hva_h264_stereo_video_sei {
@@ -146,7 +146,9 @@ struct hva_h264_stereo_video_sei {
 	u8 right_view_self_contained_flag;
 };
 
-/**
+/*
+ * struct hva_h264_td
+ *
  * @frame_width: width in pixels of the buffer containing the input frame
  * @frame_height: height in pixels of the buffer containing the input frame
  * @frame_num: the parameter to be written in the slice header
@@ -352,7 +354,9 @@ struct hva_h264_td {
 	u32 addr_brc_in_out_parameter;
 };
 
-/**
+/*
+ * struct hva_h264_slice_po
+ *
  * @ slice_size: slice size
  * @ slice_start_time: start time
  * @ slice_stop_time: stop time
@@ -365,7 +369,9 @@ struct hva_h264_slice_po {
 	u32 slice_num;
 };
 
-/**
+/*
+ * struct hva_h264_po
+ *
  * @ bitstream_size: bitstream size
  * @ dct_bitstream_size: dtc bitstream size
  * @ stuffing_bits: number of stuffing bits inserted by the encoder
@@ -391,7 +397,9 @@ struct hva_h264_task {
 	struct hva_h264_po po;
 };
 
-/**
+/*
+ * struct hva_h264_ctx
+ *
  * @seq_info:  sequence information buffer
  * @ref_frame: reference frame buffer
  * @rec_frame: reconstructed frame buffer
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 45bd10544189..e395aa85c8ad 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -926,7 +926,7 @@ static struct vpe_ctx *file2ctx(struct file *file)
  * mem2mem callbacks
  */
 
-/**
+/*
  * job_ready() - check whether an instance is ready to be scheduled to run
  */
 static int job_ready(void *priv)
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 7bf9fa2f8534..065483e62db4 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -343,7 +343,7 @@ static void schedule_irq(struct vim2m_dev *dev, int msec_timeout)
  * mem2mem callbacks
  */
 
-/**
+/*
  * job_ready() - check whether an instance is ready to be scheduled to run
  */
 static int job_ready(void *priv)
diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index a8e39c635f34..d2efd7b2c3bc 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -49,7 +49,7 @@ struct st_rc_device {
 #define IRB_RX_NOISE_SUPPR      0x5c	/* noise suppression  */
 #define IRB_RX_POLARITY_INV     0x68	/* polarity inverter  */
 
-/**
+/*
  * IRQ set: Enable full FIFO                 1  -> bit  3;
  *          Enable overrun IRQ               1  -> bit  2;
  *          Enable last symbol IRQ           1  -> bit  1:
@@ -72,7 +72,7 @@ static void st_rc_send_lirc_timeout(struct rc_dev *rdev)
 	ir_raw_event_store(rdev, &ev);
 }
 
-/**
+/*
  * RX graphical example to better understand the difference between ST IR block
  * output and standard definition used by LIRC (and most of the world!)
  *
@@ -317,7 +317,7 @@ static int st_rc_probe(struct platform_device *pdev)
 	device_init_wakeup(dev, true);
 	dev_pm_set_wake_irq(dev, rc_dev->irq);
 
-	/**
+	/*
 	 * for LIRC_MODE_MODE2 or LIRC_MODE_PULSE or LIRC_MODE_RAW
 	 * lircd expects a long space first before a signal train to sync.
 	 */
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 4eebfcfc10f3..c9a70fda88a8 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -191,7 +191,7 @@ static void sz_push_half_space(struct streamzap_ir *sz,
 	sz_push_full_space(sz, value & SZ_SPACE_MASK);
 }
 
-/**
+/*
  * streamzap_callback - usb IRQ handler callback
  *
  * This procedure is invoked on reception of data from
@@ -321,7 +321,7 @@ static struct rc_dev *streamzap_init_rc_dev(struct streamzap_ir *sz)
 	return NULL;
 }
 
-/**
+/*
  *	streamzap_probe
  *
  *	Called by usb-core to associated with a candidate device
@@ -450,7 +450,7 @@ static int streamzap_probe(struct usb_interface *intf,
 	return retval;
 }
 
-/**
+/*
  * streamzap_disconnect
  *
  * Called by the usb core when the device is removed from the system.
diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index f9772ad0a2a5..5a2f81311fb7 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -26,7 +26,7 @@
 #include "cinergyT2.h"
 
 
-/**
+/*
  *  convert linux-dvb frontend parameter set into TPS.
  *  See ETSI ETS-300744, section 4.6.2, table 9 for details.
  *
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 92098c1b78e5..366b05529915 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1677,10 +1677,10 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
 		return -EINVAL;
 	}
 
-	/** Update PLL if needed ratio **/
+	/* Update PLL if needed ratio */
 	state->dib8000_ops.update_pll(fe, &dib8090_pll_config_12mhz, fe->dtv_property_cache.bandwidth_hz / 1000, 0);
 
-	/** Get optimize PLL ratio to remove spurious **/
+	/* Get optimize PLL ratio to remove spurious */
 	pll_ratio = dib8090_compute_pll_parameters(fe);
 	if (pll_ratio == 17)
 		timf = 21387946;
@@ -1691,7 +1691,7 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
 	else
 		timf = 18179756;
 
-	/** Update ratio **/
+	/* Update ratio */
 	state->dib8000_ops.update_pll(fe, &dib8090_pll_config_12mhz, fe->dtv_property_cache.bandwidth_hz / 1000, pll_ratio);
 
 	state->dib8000_ops.ctrl_timf(fe, DEMOD_TIMF_SET, timf);
@@ -3357,7 +3357,7 @@ static int novatd_sleep_override(struct dvb_frontend* fe)
 	return state->sleep(fe);
 }
 
-/**
+/*
  * novatd_frontend_attach - Nova-TD specific attach
  *
  * Nova-TD has GPIO0, 1 and 2 for LEDs. So do not fiddle with them except for
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index 41261317bd5c..b6046e0e07f6 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -297,7 +297,7 @@ static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
 }
 
 
-/**
+/*
  * (reg, val) commad list to initialize this module.
  *  captured on a Windows box.
  */
diff --git a/drivers/media/usb/dvb-usb/friio.c b/drivers/media/usb/dvb-usb/friio.c
index 62abe6c43a32..16875945e662 100644
--- a/drivers/media/usb/dvb-usb/friio.c
+++ b/drivers/media/usb/dvb-usb/friio.c
@@ -21,7 +21,7 @@ MODULE_PARM_DESC(debug,
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-/**
+/*
  * Indirect I2C access to the PLL via FE.
  * whole I2C protocol data to the PLL is sent via the FE's I2C register.
  * This is done by a control msg to the FE with the I2C data accompanied, and
diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index f1537daf4e2e..1b30434b72ef 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -1,4 +1,4 @@
-/**
+/*
  * OV519 driver
  *
  * Copyright (C) 2008-2011 Jean-François Moine <moinejf@free.fr>
diff --git a/drivers/media/usb/pwc/pwc-dec23.c b/drivers/media/usb/pwc/pwc-dec23.c
index 3792fedff951..1283b3bd9800 100644
--- a/drivers/media/usb/pwc/pwc-dec23.c
+++ b/drivers/media/usb/pwc/pwc-dec23.c
@@ -649,11 +649,10 @@ static void DecompressBand23(struct pwc_dec23_private *pdec,
 }
 
 /**
- *
  * Uncompress a pwc23 buffer.
- *
- * src: raw data
- * dst: image output
+ * @pdev: pointer to pwc device's internal struct
+ * @src: raw data
+ * @dst: image output
  */
 void pwc_dec23_decompress(struct pwc_device *pdev,
 			  const void *src,
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index b842f367249f..a142b9dc0feb 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -76,7 +76,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define TTUSB_REV_2_2	0x22
 #define TTUSB_BUDGET_NAME "ttusb_stc_fw"
 
-/**
+/*
  *  since we're casting (struct ttusb*) <-> (struct dvb_demux*) around
  *  the dvb_demux field must be the first in struct!!
  */
@@ -713,7 +713,7 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 					}
 				}
 
-			/**
+			/*
 			 * if length is valid and we reached the end:
 			 * goto next muxpack
 			 */
@@ -729,7 +729,7 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 					/* maximum bytes, until we know the length */
 					ttusb->muxpack_len = 2;
 
-				/**
+				/*
 				 * no muxpacks left?
 				 * return to search-sync state
 				 */
-- 
2.14.3
