Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35212 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbbESLBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 07:01:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michael Buesch <m@bues.ch>, Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Takashi Iwai <tiwai@suse.de>,
	Amber Thrall <amber.rose.thrall@gmail.com>,
	Federico Simoncelli <fsimonce@redhat.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] drivers: Simplify the return code
Date: Tue, 19 May 2015 08:00:57 -0300
Message-Id: <a24b23db60ffee5cb32403d7c8cacd25b13f4510.1432033220.git.mchehab@osg.samsung.com>
In-Reply-To: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
References: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
In-Reply-To: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
References: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the last thing we do in a function is to call another
function and then return its value, we don't need to store
the returned code into some ancillary var.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgs8gxx.c b/drivers/media/dvb-frontends/lgs8gxx.c
index 3c92f36ea5c7..9b0166cdc7c2 100644
--- a/drivers/media/dvb-frontends/lgs8gxx.c
+++ b/drivers/media/dvb-frontends/lgs8gxx.c
@@ -544,11 +544,7 @@ static int lgs8gxx_set_mpeg_mode(struct lgs8gxx_state *priv,
 	t |= clk_pol ? TS_CLK_INVERTED : TS_CLK_NORMAL;
 	t |= clk_gated ? TS_CLK_GATED : TS_CLK_FREERUN;
 
-	ret = lgs8gxx_write_reg(priv, reg_addr, t);
-	if (ret != 0)
-		return ret;
-
-	return 0;
+	return lgs8gxx_write_reg(priv, reg_addr, t);
 }
 
 /* A/D input peak-to-peak voltage range */
diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index a493c0b0b5fe..1fb8ac93970f 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -1310,11 +1310,7 @@ static int adv7180_resume(struct device *dev)
 	if (ret < 0)
 		return ret;
 
-	ret = adv7180_set_power(state, state->powered);
-	if (ret)
-		return ret;
-
-	return 0;
+	return adv7180_set_power(state, state->powered);
 }
 
 static SIMPLE_DEV_PM_OPS(adv7180_pm_ops, adv7180_suspend, adv7180_resume);
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 3632958f2158..7a0263db4d1a 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2103,7 +2103,6 @@ verify_window_lock(struct bttv_fh *fh, struct v4l2_window *win,
 {
 	enum v4l2_field field;
 	unsigned int width_mask;
-	int rc;
 
 	if (win->w.width < 48)
 		win->w.width = 48;
@@ -2156,13 +2155,10 @@ verify_window_lock(struct bttv_fh *fh, struct v4l2_window *win,
 	win->w.width -= win->w.left & ~width_mask;
 	win->w.left = (win->w.left - width_mask - 1) & width_mask;
 
-	rc = limit_scaled_size_lock(fh, &win->w.width, &win->w.height,
+	return limit_scaled_size_lock(fh, &win->w.width, &win->w.height,
 			       field, width_mask,
 			       /* width_bias: round down */ 0,
 			       adjust_size, adjust_crop);
-	if (0 != rc)
-		return rc;
-	return 0;
 }
 
 static int setup_window_lock(struct bttv_fh *fh, struct bttv *btv,
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 039bed3cc919..59dade6c156b 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -522,15 +522,11 @@ static int eeprom_read_ushort(struct i2c_adapter *adapter, u16 tag, u16 *data)
 
 static int eeprom_write_ushort(struct i2c_adapter *adapter, u16 tag, u16 data)
 {
-	int stat;
 	u8 buf[2];
 
 	buf[0] = data >> 8;
 	buf[1] = data & 0xff;
-	stat = WriteEEProm(adapter, tag, 2, buf);
-	if (stat)
-		return stat;
-	return 0;
+	return WriteEEProm(adapter, tag, 2, buf);
 }
 
 static s16 osc_deviation(void *priv, s16 deviation, int flag)
diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index 1d2c310ce838..f78938d13950 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -354,15 +354,10 @@ static int saa7134_alsa_dma_free(struct saa7134_dmasound *dma)
 
 static int dsp_buffer_init(struct saa7134_dev *dev)
 {
-	int err;
-
 	BUG_ON(!dev->dmasound.bufsize);
 
-	err = saa7134_alsa_dma_init(dev,
+	return saa7134_alsa_dma_init(dev,
 			       (dev->dmasound.bufsize + PAGE_SIZE) >> PAGE_SHIFT);
-	if (0 != err)
-		return err;
-	return 0;
 }
 
 /*
diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
index 3932aa81e18c..d70a18d8e6c1 100644
--- a/drivers/media/tuners/fc0011.c
+++ b/drivers/media/tuners/fc0011.c
@@ -152,11 +152,7 @@ static int fc0011_vcocal_trigger(struct fc0011_priv *priv)
 	err = fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RESET);
 	if (err)
 		return err;
-	err = fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
-	if (err)
-		return err;
-
-	return 0;
+	return fc0011_writereg(priv, FC11_REG_VCOCAL, FC11_VCOCAL_RUN);
 }
 
 /* Read VCO calibration value */
@@ -168,11 +164,7 @@ static int fc0011_vcocal_read(struct fc0011_priv *priv, u8 *value)
 	if (err)
 		return err;
 	usleep_range(10000, 20000);
-	err = fc0011_readreg(priv, FC11_REG_VCOCAL, value);
-	if (err)
-		return err;
-
-	return 0;
+	return fc0011_readreg(priv, FC11_REG_VCOCAL, value);
 }
 
 static int fc0011_set_params(struct dvb_frontend *fe)
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index ae917c042a52..2ab3342d6b6c 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -1184,14 +1184,9 @@ static int anysee_ci_write_attribute_mem(struct dvb_ca_en50221 *ci, int slot,
 	int addr, u8 val)
 {
 	struct dvb_usb_device *d = ci->data;
-	int ret;
 	u8 buf[] = {CMD_CI, 0x03, 0x40 | addr >> 8, addr & 0xff, 0x00, 1, val};
 
-	ret = anysee_ctrl_msg(d, buf, sizeof(buf), NULL, 0);
-	if (ret)
-		return ret;
-
-	return 0;
+	return anysee_ctrl_msg(d, buf, sizeof(buf), NULL, 0);
 }
 
 static int anysee_ci_read_cam_control(struct dvb_ca_en50221 *ci, int slot,
@@ -1213,14 +1208,9 @@ static int anysee_ci_write_cam_control(struct dvb_ca_en50221 *ci, int slot,
 	u8 addr, u8 val)
 {
 	struct dvb_usb_device *d = ci->data;
-	int ret;
 	u8 buf[] = {CMD_CI, 0x05, 0x40, addr, 0x00, 1, val};
 
-	ret = anysee_ctrl_msg(d, buf, sizeof(buf), NULL, 0);
-	if (ret)
-		return ret;
-
-	return 0;
+	return anysee_ctrl_msg(d, buf, sizeof(buf), NULL, 0);
 }
 
 static int anysee_ci_slot_reset(struct dvb_ca_en50221 *ci, int slot)
@@ -1237,11 +1227,7 @@ static int anysee_ci_slot_reset(struct dvb_ca_en50221 *ci, int slot)
 
 	msleep(300);
 
-	ret = anysee_wr_reg_mask(d, REG_IOA, (1 << 7), 0x80);
-	if (ret)
-		return ret;
-
-	return 0;
+	return anysee_wr_reg_mask(d, REG_IOA, (1 << 7), 0x80);
 }
 
 static int anysee_ci_slot_shutdown(struct dvb_ca_en50221 *ci, int slot)
@@ -1255,23 +1241,14 @@ static int anysee_ci_slot_shutdown(struct dvb_ca_en50221 *ci, int slot)
 
 	msleep(30);
 
-	ret = anysee_wr_reg_mask(d, REG_IOA, (1 << 7), 0x80);
-	if (ret)
-		return ret;
-
-	return 0;
+	return anysee_wr_reg_mask(d, REG_IOA, (1 << 7), 0x80);
 }
 
 static int anysee_ci_slot_ts_enable(struct dvb_ca_en50221 *ci, int slot)
 {
 	struct dvb_usb_device *d = ci->data;
-	int ret;
 
-	ret = anysee_wr_reg_mask(d, REG_IOD, (0 << 1), 0x02);
-	if (ret)
-		return ret;
-
-	return 0;
+	return anysee_wr_reg_mask(d, REG_IOD, (0 << 1), 0x02);
 }
 
 static int anysee_ci_poll_slot_status(struct dvb_ca_en50221 *ci, int slot,
diff --git a/drivers/media/usb/dvb-usb/dtv5100.c b/drivers/media/usb/dvb-usb/dtv5100.c
index 3d11df41cac0..1ddb26369a5d 100644
--- a/drivers/media/usb/dvb-usb/dtv5100.c
+++ b/drivers/media/usb/dvb-usb/dtv5100.c
@@ -158,12 +158,8 @@ static int dtv5100_probe(struct usb_interface *intf,
 			return ret;
 	}
 
-	ret = dvb_usb_device_init(intf, &dtv5100_properties,
+	return dvb_usb_device_init(intf, &dtv5100_properties,
 				  THIS_MODULE, NULL, adapter_nr);
-	if (ret)
-		return ret;
-
-	return 0;
 }
 
 static struct usb_device_id dtv5100_table[] = {
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 08fb0f2da64d..420cd41ac509 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -241,11 +241,7 @@ static int usbtv_setup_capture(struct usbtv *usbtv)
 	if (ret)
 		return ret;
 
-	ret = usbtv_select_input(usbtv, usbtv->input);
-	if (ret)
-		return ret;
-
-	return 0;
+	return usbtv_select_input(usbtv, usbtv->input);
 }
 
 /* Copy data from chunk into a frame buffer, deinterlacing the data
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index f669cedca8bd..994df1938d64 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -562,11 +562,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
 	default:
 		BUG();
 	}
-	err = videobuf_dma_map(q->dev, &mem->dma);
-	if (0 != err)
-		return err;
-
-	return 0;
+	return videobuf_dma_map(q->dev, &mem->dma);
 }
 
 static int __videobuf_sync(struct videobuf_queue *q,
-- 
2.1.0

