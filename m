Return-path: <linux-media-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1117 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZF1Q1i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:38 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 24/62] drivers/media: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:29 -0700
Message-Id: <0f97e10498e3638cfc949ca73717367cb19004d2.1246173681.git.joe@perches.com>
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c   |    2 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    2 +-
 drivers/media/dvb/frontends/cx24123.c       |    2 +-
 drivers/media/dvb/frontends/dib0070.c       |    2 +-
 drivers/media/dvb/frontends/stv0900_sw.c    |    2 +-
 drivers/media/video/cx231xx/cx231xx-video.c |    4 ++--
 drivers/media/video/cx23885/cx23885.h       |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c b/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
index efb4a6c..bc37018 100644
--- a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
@@ -410,7 +410,7 @@ static int skystar2_rev28_attach(struct flexcop_device *fc,
 	if (!fc->fe)
 		return 0;
 
-	i2c_tuner = cx24123_get_tuner_i2c_adapter(fc->fe);;
+	i2c_tuner = cx24123_get_tuner_i2c_adapter(fc->fe);
 	if (!i2c_tuner)
 		return 0;
 
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 818b2ab..49fd781 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -310,7 +310,7 @@ static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *tun_i2c;
 	tun_i2c = dib7000p_get_i2c_master(adap->fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 	return dvb_attach(mt2266_attach, adap->fe, tun_i2c,
-		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;;
+		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;
 }
 
 /* STK7700-PH: Digital/Analog Hybrid Tuner, e.h. Cinergy HT USB HE */
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index 0592f04..d8f921b 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -458,7 +458,7 @@ static int cx24123_set_symbolrate(struct cx24123_state *state, u32 srate)
 	/*  check if symbol rate is within limits */
 	if ((srate > state->frontend.ops.info.symbol_rate_max) ||
 	    (srate < state->frontend.ops.info.symbol_rate_min))
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 
 	/* choose the sampling rate high enough for the required operation,
 	   while optimizing the power consumed by the demodulator */
diff --git a/drivers/media/dvb/frontends/dib0070.c b/drivers/media/dvb/frontends/dib0070.c
index fe895bf..da92cbe 100644
--- a/drivers/media/dvb/frontends/dib0070.c
+++ b/drivers/media/dvb/frontends/dib0070.c
@@ -167,7 +167,7 @@ static int dib0070_tune_digital(struct dvb_frontend *fe, struct dvb_frontend_par
 					break;
 				case BAND_SBAND:
 					LO4_SET_VCO_HFDIV(lo4, 0, 0);
-					LO4_SET_CTRIM(lo4, 1);;
+					LO4_SET_CTRIM(lo4, 1);
 					c = 1;
 					break;
 				case BAND_UHF:
diff --git a/drivers/media/dvb/frontends/stv0900_sw.c b/drivers/media/dvb/frontends/stv0900_sw.c
index a5a3153..962fde1 100644
--- a/drivers/media/dvb/frontends/stv0900_sw.c
+++ b/drivers/media/dvb/frontends/stv0900_sw.c
@@ -1721,7 +1721,7 @@ static enum fe_stv0900_signal_type stv0900_dvbs1_acq_workaround(struct dvb_front
 
 	s32 srate, demod_timeout,
 		fec_timeout, freq1, freq0;
-	enum fe_stv0900_signal_type signal_type = STV0900_NODATA;;
+	enum fe_stv0900_signal_type signal_type = STV0900_NODATA;
 
 	switch (demod) {
 	case STV0900_DEMOD_1:
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 609bae6..3650372 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -923,8 +923,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.width = dev->width;
 	f->fmt.pix.height = dev->height;
-	f->fmt.pix.pixelformat = dev->format->fourcc;;
-	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;;
+	f->fmt.pix.pixelformat = dev->format->fourcc;
+	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * dev->height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 1a2ac51..2915103 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -391,7 +391,7 @@ struct sram_channel {
 	u32  cmds_start;
 	u32  ctrl_start;
 	u32  cdt;
-	u32  fifo_start;;
+	u32  fifo_start;
 	u32  fifo_size;
 	u32  ptr1_reg;
 	u32  ptr2_reg;
-- 
1.6.3.1.10.g659a0.dirty

