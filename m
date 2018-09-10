Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbeIJRNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 13:13:20 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/3] media: replace strncpy() by strscpy()
Date: Mon, 10 Sep 2018 08:19:16 -0400
Message-Id: <7da460f4d77659c3fc19743c287f0b24f6cd596a.1536581758.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536581757.git.mchehab+samsung@kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536581757.git.mchehab+samsung@kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The strncpy() function is being deprecated upstream. Replace
it by the safer strscpy().

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/as102_fe.c           |  2 +-
 drivers/media/dvb-frontends/dib7000p.c           |  3 ++-
 drivers/media/dvb-frontends/dib8000.c            |  4 ++--
 drivers/media/dvb-frontends/dib9000.c            |  6 ++++--
 drivers/media/dvb-frontends/dvb-pll.c            |  2 +-
 drivers/media/dvb-frontends/m88ds3103.c          |  2 +-
 drivers/media/pci/bt8xx/dst.c                    |  3 ++-
 drivers/media/pci/mantis/mantis_i2c.c            |  2 +-
 drivers/media/pci/saa7134/saa7134-go7007.c       |  2 +-
 drivers/media/platform/am437x/am437x-vpfe.c      |  2 +-
 drivers/media/platform/davinci/vpfe_capture.c    |  2 +-
 drivers/media/platform/davinci/vpif_capture.c    |  2 +-
 drivers/media/platform/davinci/vpif_display.c    |  3 +--
 drivers/media/platform/exynos4-is/fimc-capture.c |  2 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c     |  2 +-
 drivers/media/platform/mtk-vpu/mtk_vpu.c         |  2 +-
 drivers/media/platform/mx2_emmaprp.c             |  4 ++--
 drivers/media/platform/s5p-g2d/g2d.c             |  6 +++---
 drivers/media/platform/ti-vpe/vpe.c              |  6 +++---
 drivers/media/platform/vicodec/vicodec-core.c    |  4 ++--
 drivers/media/platform/vim2m.c                   |  4 ++--
 drivers/media/radio/si4713/si4713.c              |  2 +-
 drivers/media/usb/go7007/go7007-usb.c            | 16 ++++++++--------
 drivers/media/usb/go7007/go7007-v4l2.c           |  2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c            |  9 +++------
 drivers/media/usb/pulse8-cec/pulse8-cec.c        |  4 ++--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c          |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c         |  4 ++--
 drivers/staging/media/bcm2048/radio-bcm2048.c    |  4 ++--
 drivers/staging/media/imx/imx-ic-common.c        |  2 +-
 drivers/staging/media/imx/imx-media-vdic.c       |  2 +-
 drivers/staging/media/zoran/zoran_driver.c       | 10 +++++-----
 32 files changed, 61 insertions(+), 61 deletions(-)

diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
index f59a102b0a64..9ba8f39fe310 100644
--- a/drivers/media/dvb-frontends/as102_fe.c
+++ b/drivers/media/dvb-frontends/as102_fe.c
@@ -467,7 +467,7 @@ struct dvb_frontend *as102_attach(const char *name,
 
 	/* init frontend callback ops */
 	memcpy(&fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
-	strncpy(fe->ops.info.name, name, sizeof(fe->ops.info.name));
+	strscpy(fe->ops.info.name, name, sizeof(fe->ops.info.name));
 
 	return fe;
 
diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 58387860b62d..d8cfdb4ce16e 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2771,7 +2771,8 @@ static struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_a
 	dibx000_init_i2c_master(&st->i2c_master, DIB7000P, st->i2c_adap, st->i2c_addr);
 
 	/* init 7090 tuner adapter */
-	strncpy(st->dib7090_tuner_adap.name, "DiB7090 tuner interface", sizeof(st->dib7090_tuner_adap.name));
+	strscpy(st->dib7090_tuner_adap.name, "DiB7090 tuner interface",
+		sizeof(st->dib7090_tuner_adap.name));
 	st->dib7090_tuner_adap.algo = &dib7090_tuner_xfer_algo;
 	st->dib7090_tuner_adap.algo_data = NULL;
 	st->dib7090_tuner_adap.dev.parent = st->i2c_adap->dev.parent;
diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 3c3f8cb14845..286f8000b445 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4458,8 +4458,8 @@ static struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_ad
 	dibx000_init_i2c_master(&state->i2c_master, DIB8000, state->i2c.adap, state->i2c.addr);
 
 	/* init 8096p tuner adapter */
-	strncpy(state->dib8096p_tuner_adap.name, "DiB8096P tuner interface",
-			sizeof(state->dib8096p_tuner_adap.name));
+	strscpy(state->dib8096p_tuner_adap.name, "DiB8096P tuner interface",
+		sizeof(state->dib8096p_tuner_adap.name));
 	state->dib8096p_tuner_adap.algo = &dib8096p_tuner_xfer_algo;
 	state->dib8096p_tuner_adap.algo_data = NULL;
 	state->dib8096p_tuner_adap.dev.parent = state->i2c.adap->dev.parent;
diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index 0183fb1346ef..c986687def30 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -2521,7 +2521,8 @@ struct dvb_frontend *dib9000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, c
 	dibx000_init_i2c_master(&st->i2c_master, DIB7000MC, st->i2c.i2c_adap, st->i2c.i2c_addr);
 
 	st->tuner_adap.dev.parent = i2c_adap->dev.parent;
-	strncpy(st->tuner_adap.name, "DIB9000_FW TUNER ACCESS", sizeof(st->tuner_adap.name));
+	strscpy(st->tuner_adap.name, "DIB9000_FW TUNER ACCESS",
+		sizeof(st->tuner_adap.name));
 	st->tuner_adap.algo = &dib9000_tuner_algo;
 	st->tuner_adap.algo_data = NULL;
 	i2c_set_adapdata(&st->tuner_adap, st);
@@ -2529,7 +2530,8 @@ struct dvb_frontend *dib9000_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, c
 		goto error;
 
 	st->component_bus.dev.parent = i2c_adap->dev.parent;
-	strncpy(st->component_bus.name, "DIB9000_FW COMPONENT BUS ACCESS", sizeof(st->component_bus.name));
+	strscpy(st->component_bus.name, "DIB9000_FW COMPONENT BUS ACCESS",
+		sizeof(st->component_bus.name));
 	st->component_bus.algo = &dib9000_component_bus_algo;
 	st->component_bus.algo_data = NULL;
 	st->component_bus_speed = 340;
diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 6d4b2eec67b4..d4c03a3f81a8 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -843,7 +843,7 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 	memcpy(&fe->ops.tuner_ops, &dvb_pll_tuner_ops,
 	       sizeof(struct dvb_tuner_ops));
 
-	strncpy(fe->ops.tuner_ops.info.name, desc->name,
+	strscpy(fe->ops.tuner_ops.info.name, desc->name,
 		sizeof(fe->ops.tuner_ops.info.name));
 	switch (c->delivery_system) {
 	case SYS_DVBS:
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 123f2a33738b..46857be36779 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1470,7 +1470,7 @@ static int m88ds3103_probe(struct i2c_client *client,
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
 	if (dev->chip_id == M88RS6000_CHIP_ID)
-		strncpy(dev->fe.ops.info.name, "Montage Technology M88RS6000",
+		strscpy(dev->fe.ops.info.name, "Montage Technology M88RS6000",
 			sizeof(dev->fe.ops.info.name));
 	if (!pdata->attach_in_use)
 		dev->fe.ops.release = NULL;
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index b98de2a22f78..72dc82ae192a 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -1100,7 +1100,8 @@ static int dst_get_device_id(struct dst_state *state)
 			/*	Card capabilities	*/
 			state->dst_hw_cap = p_dst_type->dst_feature;
 			pr_err("Recognise [%s]\n", p_dst_type->device_id);
-			strncpy(&state->fw_name[0], p_dst_type->device_id, 6);
+			strscpy((char *)state->fw_name, p_dst_type->device_id,
+				sizeof(state->fw_name));
 			/*	Multiple tuners		*/
 			if (p_dst_type->tuner_type & TUNER_TYPE_MULTI) {
 				switch (use_dst_type) {
diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
index 6528a2180119..f8b503ef42bc 100644
--- a/drivers/media/pci/mantis/mantis_i2c.c
+++ b/drivers/media/pci/mantis/mantis_i2c.c
@@ -225,7 +225,7 @@ int mantis_i2c_init(struct mantis_pci *mantis)
 
 	init_waitqueue_head(&mantis->i2c_wq);
 	mutex_init(&mantis->i2c_lock);
-	strncpy(i2c_adapter->name, "Mantis I2C", sizeof(i2c_adapter->name));
+	strscpy(i2c_adapter->name, "Mantis I2C", sizeof(i2c_adapter->name));
 	i2c_set_adapdata(i2c_adapter, mantis);
 
 	i2c_adapter->owner	= THIS_MODULE;
diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index 275c5e151818..626e130a9770 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -444,7 +444,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 	sd = &saa->sd;
 	v4l2_subdev_init(sd, &saa7134_go7007_sd_ops);
 	v4l2_set_subdevdata(sd, saa);
-	strncpy(sd->name, "saa7134-go7007", sizeof(sd->name));
+	strscpy(sd->name, "saa7134-go7007", sizeof(sd->name));
 
 	/* Allocate a couple pages for receiving the compressed stream */
 	saa->top = (u8 *)get_zeroed_page(GFP_KERNEL);
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index cac6aec0ffa7..fdc195a69f94 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1540,7 +1540,7 @@ static int vpfe_enum_fmt(struct file *file, void  *priv,
 	if (!fmt)
 		return -EINVAL;
 
-	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 	f->type = vpfe->fmt.type;
 
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index ea3ddd5a42bd..6f094dea6bc2 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1759,7 +1759,7 @@ static int vpfe_probe(struct platform_device *pdev)
 
 	mutex_lock(&ccdc_lock);
 
-	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
+	strscpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
 	/* Get VINT0 irq resource */
 	res1 = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res1) {
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 62bced38db10..b246af6cc21f 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1254,7 +1254,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	} else {
 		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
 	}
-	strncpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);
+	strscpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);
 	std_info->width = bt->width;
 	std_info->height = bt->height;
 	std_info->frm_fmt = bt->interlaced ? 0 : 1;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 78eba66f4b2b..65f51ebef6b4 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -987,8 +987,7 @@ static int vpif_s_dv_timings(struct file *file, void *priv,
 	} else {
 		std_info->l5 = std_info->vsize - (bt->vfrontporch - 1);
 	}
-	strncpy(std_info->name, "Custom timings BT656/1120",
-			VPIF_MAX_NAME);
+	strscpy(std_info->name, "Custom timings BT656/1120", VPIF_MAX_NAME);
 	std_info->width = bt->width;
 	std_info->height = bt->height;
 	std_info->frm_fmt = bt->interlaced ? 0 : 1;
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index f56220e549bb..e5200153de59 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -742,7 +742,7 @@ static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
 			       f->index);
 	if (!fmt)
 		return -EINVAL;
-	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 	if (fmt->fourcc == MEDIA_BUS_FMT_JPEG_1X8)
 		f->flags |= V4L2_FMT_FLAG_COMPRESSED;
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index a19f8b164a47..24e4b295faa9 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -252,7 +252,7 @@ static int fimc_m2m_enum_fmt_mplane(struct file *file, void *priv,
 	if (!fmt)
 		return -EINVAL;
 
-	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 	return 0;
 }
diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
index f8d35e3ac1dc..9f4bca037b59 100644
--- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
+++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
@@ -615,7 +615,7 @@ static void vpu_init_ipi_handler(void *data, unsigned int len, void *priv)
 	struct vpu_run *run = (struct vpu_run *)data;
 
 	vpu->run.signaled = run->signaled;
-	strncpy(vpu->run.fw_ver, run->fw_ver, VPU_FW_VER_LEN);
+	strscpy(vpu->run.fw_ver, run->fw_ver, VPU_FW_VER_LEN);
 	vpu->run.dec_capability = run->dec_capability;
 	vpu->run.enc_capability = run->enc_capability;
 	wake_up_interruptible(&vpu->run.wq);
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 27b078cf98e3..ea1de4d491ab 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -385,8 +385,8 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
-	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
+	strscpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver));
+	strscpy(cap->card, MEM2MEM_NAME, sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index e901201b6fcc..3bc0c8111042 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -297,8 +297,8 @@ static int g2d_release(struct file *file)
 static int vidioc_querycap(struct file *file, void *priv,
 				struct v4l2_capability *cap)
 {
-	strncpy(cap->driver, G2D_NAME, sizeof(cap->driver) - 1);
-	strncpy(cap->card, G2D_NAME, sizeof(cap->card) - 1);
+	strscpy(cap->driver, G2D_NAME, sizeof(cap->driver));
+	strscpy(cap->card, G2D_NAME, sizeof(cap->card));
 	cap->bus_info[0] = 0;
 	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -312,7 +312,7 @@ static int vidioc_enum_fmt(struct file *file, void *prv, struct v4l2_fmtdesc *f)
 		return -EINVAL;
 	fmt = &formats[f->index];
 	f->pixelformat = fmt->fourcc;
-	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	return 0;
 }
 
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d70871d0ad2d..44a28e155697 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1491,8 +1491,8 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 static int vpe_querycap(struct file *file, void *priv,
 			struct v4l2_capability *cap)
 {
-	strncpy(cap->driver, VPE_MODULE_NAME, sizeof(cap->driver) - 1);
-	strncpy(cap->card, VPE_MODULE_NAME, sizeof(cap->card) - 1);
+	strscpy(cap->driver, VPE_MODULE_NAME, sizeof(cap->driver));
+	strscpy(cap->card, VPE_MODULE_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		VPE_MODULE_NAME);
 	cap->device_caps  = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
@@ -1519,7 +1519,7 @@ static int __enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 	if (!fmt)
 		return -EINVAL;
 
-	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 	return 0;
 }
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 3c96b7567c8d..fd7f7d133129 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -398,8 +398,8 @@ static const struct v4l2_fwht_pixfmt_info *find_fmt(u32 fmt)
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	strncpy(cap->driver, VICODEC_NAME, sizeof(cap->driver) - 1);
-	strncpy(cap->card, VICODEC_NAME, sizeof(cap->card) - 1);
+	strscpy(cap->driver, VICODEC_NAME, sizeof(cap->driver));
+	strscpy(cap->card, VICODEC_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", VICODEC_NAME);
 	cap->device_caps =  V4L2_CAP_STREAMING |
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 60c522ee2e03..a7335cc997c9 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -431,8 +431,8 @@ static void device_isr(struct timer_list *t)
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
-	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
+	strscpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver));
+	strscpy(cap->card, MEM2MEM_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", MEM2MEM_NAME);
 	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index f4a53f1e856e..289bbed255cb 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1272,7 +1272,7 @@ static int si4713_g_modulator(struct v4l2_subdev *sd, struct v4l2_modulator *vm)
 	if (vm->index > 0)
 		return -EINVAL;
 
-	strncpy(vm->name, "FM Modulator", 32);
+	strscpy(vm->name, "FM Modulator", 32);
 	vm->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW |
 		V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_CONTROLS;
 
diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 19c6a0354ce0..abe98488be23 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1132,7 +1132,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	usb->usbdev = usbdev;
 	usb_make_path(usbdev, go->bus_info, sizeof(go->bus_info));
 	go->board_id = id->driver_info;
-	strncpy(go->name, name, sizeof(go->name));
+	strscpy(go->name, name, sizeof(go->name));
 	if (board->flags & GO7007_USB_EZUSB)
 		go->hpi_ops = &go7007_usb_ezusb_hpi_ops;
 	else
@@ -1198,7 +1198,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 				go->board_id = GO7007_BOARDID_ENDURA;
 				usb->board = board = &board_endura;
 				go->board_info = &board->main_info;
-				strncpy(go->name, "Pelco Endura",
+				strscpy(go->name, "Pelco Endura",
 					sizeof(go->name));
 			} else {
 				u16 channel;
@@ -1232,21 +1232,21 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		case 1:
 			go->tuner_type = TUNER_SONY_BTF_PG472Z;
 			go->std = V4L2_STD_PAL;
-			strncpy(go->name, "Plextor PX-TV402U-EU",
-					sizeof(go->name));
+			strscpy(go->name, "Plextor PX-TV402U-EU",
+				sizeof(go->name));
 			break;
 		case 2:
 			go->tuner_type = TUNER_SONY_BTF_PK467Z;
 			go->std = V4L2_STD_NTSC_M_JP;
 			num_i2c_devs -= 2;
-			strncpy(go->name, "Plextor PX-TV402U-JP",
-					sizeof(go->name));
+			strscpy(go->name, "Plextor PX-TV402U-JP",
+				sizeof(go->name));
 			break;
 		case 3:
 			go->tuner_type = TUNER_SONY_BTF_PB463Z;
 			num_i2c_devs -= 2;
-			strncpy(go->name, "Plextor PX-TV402U-NA",
-					sizeof(go->name));
+			strscpy(go->name, "Plextor PX-TV402U-NA",
+				sizeof(go->name));
 			break;
 		default:
 			pr_debug("unable to detect tuner type!\n");
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index 7a2781fa83e7..bebdfcecf600 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -327,7 +327,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmt->flags = V4L2_FMT_FLAG_COMPRESSED;
 
-	strncpy(fmt->description, desc, sizeof(fmt->description));
+	strscpy(fmt->description, desc, sizeof(fmt->description));
 
 	return 0;
 }
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index e082086428a4..034983c11532 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -769,8 +769,7 @@ static int vidioc_enum_input(struct file *file, void *_fh, struct v4l2_input *i)
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 
-	strncpy(i->name, iname[n], sizeof(i->name) - 1);
-	i->name[sizeof(i->name) - 1] = '\0';
+	strscpy(i->name, iname[n], sizeof(i->name));
 
 	i->audioset = 1<<HDPVR_RCA_FRONT | 1<<HDPVR_RCA_BACK | 1<<HDPVR_SPDIF;
 
@@ -841,8 +840,7 @@ static int vidioc_enumaudio(struct file *file, void *priv,
 
 	audio->capability = V4L2_AUDCAP_STEREO;
 
-	strncpy(audio->name, audio_iname[n], sizeof(audio->name) - 1);
-	audio->name[sizeof(audio->name) - 1] = '\0';
+	strscpy(audio->name, audio_iname[n], sizeof(audio->name));
 
 	return 0;
 }
@@ -874,7 +872,6 @@ static int vidioc_g_audio(struct file *file, void *private_data,
 	audio->index = dev->options.audio_input;
 	audio->capability = V4L2_AUDCAP_STEREO;
 	strscpy(audio->name, audio_iname[audio->index], sizeof(audio->name));
-	audio->name[sizeof(audio->name) - 1] = '\0';
 	return 0;
 }
 
@@ -991,7 +988,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *private_data,
 		return -EINVAL;
 
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
-	strncpy(f->description, "MPEG2-TS with AVC/AAC streams", 32);
+	strscpy(f->description, "MPEG2-TS with AVC/AAC streams", 32);
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
 
 	return 0;
diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 365c78b748dd..7f961fb23dc6 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -435,7 +435,7 @@ static int pulse8_setup(struct pulse8 *pulse8, struct serio *serio,
 	err = pulse8_send_and_wait(pulse8, cmd, 1, cmd[0], 0);
 	if (err)
 		return err;
-	strncpy(log_addrs->osd_name, data, 13);
+	strscpy(log_addrs->osd_name, data, 13);
 	dev_dbg(pulse8->dev, "OSD name: %s\n", log_addrs->osd_name);
 
 	return 0;
@@ -566,7 +566,7 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 		char *osd_str = cmd + 1;
 
 		cmd[0] = MSGCODE_SET_OSD_NAME;
-		strncpy(cmd + 1, adap->log_addrs.osd_name, 13);
+		strscpy(cmd + 1, adap->log_addrs.osd_name, 13);
 		if (osd_len < 4) {
 			memset(osd_str + osd_len, ' ', 4 - osd_len);
 			osd_len = 4;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index a8519da0020b..2b5b8de5982b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2459,7 +2459,7 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 		if (!(qctrl.flags & V4L2_CTRL_FLAG_READ_ONLY)) {
 			ciptr->set_value = ctrl_cx2341x_set;
 		}
-		strncpy(hdw->mpeg_ctrl_info[idx].desc,qctrl.name,
+		strscpy(hdw->mpeg_ctrl_info[idx].desc, qctrl.name,
 			PVR2_CTLD_INFO_DESC_SIZE);
 		hdw->mpeg_ctrl_info[idx].desc[PVR2_CTLD_INFO_DESC_SIZE-1] = 0;
 		ciptr->default_value = qctrl.default_value;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index cea232a3302d..666e7b89e182 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -284,7 +284,7 @@ static int pvr2_enumaudio(struct file *file, void *priv, struct v4l2_audio *vin)
 
 	if (vin->index > 0)
 		return -EINVAL;
-	strncpy(vin->name, "PVRUSB2 Audio", 14);
+	strscpy(vin->name, "PVRUSB2 Audio", 14);
 	vin->capability = V4L2_AUDCAP_STEREO;
 	return 0;
 }
@@ -293,7 +293,7 @@ static int pvr2_g_audio(struct file *file, void *priv, struct v4l2_audio *vin)
 {
 	/* pkt: FIXME: see above comment (VIDIOC_ENUMAUDIO) */
 	vin->index = 0;
-	strncpy(vin->name, "PVRUSB2 Audio", 14);
+	strscpy(vin->name, "PVRUSB2 Audio", 14);
 	vin->capability = V4L2_AUDCAP_STEREO;
 	return 0;
 }
diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 874d290f9622..1debfbad89ee 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2403,7 +2403,7 @@ static int bcm2048_vidioc_g_audio(struct file *file, void *priv,
 	if (audio->index > 1)
 		return -EINVAL;
 
-	strncpy(audio->name, "Radio", 32);
+	strscpy(audio->name, "Radio", 32);
 	audio->capability = V4L2_AUDCAP_STEREO;
 
 	return 0;
@@ -2431,7 +2431,7 @@ static int bcm2048_vidioc_g_tuner(struct file *file, void *priv,
 	if (tuner->index > 0)
 		return -EINVAL;
 
-	strncpy(tuner->name, "FM Receiver", 32);
+	strscpy(tuner->name, "FM Receiver", 32);
 	tuner->type = V4L2_TUNER_RADIO;
 	tuner->rangelow =
 		dev_to_v4l2(bcm2048_get_region_bottom_frequency(bdev));
diff --git a/drivers/staging/media/imx/imx-ic-common.c b/drivers/staging/media/imx/imx-ic-common.c
index cfdd4900a3be..c21271028762 100644
--- a/drivers/staging/media/imx/imx-ic-common.c
+++ b/drivers/staging/media/imx/imx-ic-common.c
@@ -63,7 +63,7 @@ static int imx_ic_probe(struct platform_device *pdev)
 	priv->sd.owner = THIS_MODULE;
 	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	priv->sd.grp_id = pdata->grp_id;
-	strncpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
+	strscpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
 
 	ret = ic_ops[priv->task_id]->init(priv);
 	if (ret)
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 482250d47e7c..23a29fa47aa7 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -963,7 +963,7 @@ static int imx_vdic_probe(struct platform_device *pdev)
 	priv->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
 	/* get our group id */
 	priv->sd.grp_id = pdata->grp_id;
-	strncpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
+	strscpy(priv->sd.name, pdata->sd_name, sizeof(priv->sd.name));
 
 	mutex_init(&priv->lock);
 
diff --git a/drivers/staging/media/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
index e30c3ef31a9b..0d67ae2a41ee 100644
--- a/drivers/staging/media/zoran/zoran_driver.c
+++ b/drivers/staging/media/zoran/zoran_driver.c
@@ -1526,8 +1526,8 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
 
 	for (num = i = 0; i < NUM_FORMATS; i++) {
 		if (zoran_formats[i].flags & flag && num++ == fmt->index) {
-			strncpy(fmt->description, zoran_formats[i].name,
-				sizeof(fmt->description) - 1);
+			strscpy(fmt->description, zoran_formats[i].name,
+				sizeof(fmt->description));
 			/* fmt struct pre-zeroed, so adding '\0' not needed */
 			fmt->pixelformat = zoran_formats[i].fourcc;
 			if (zoran_formats[i].flags & ZORAN_FORMAT_COMPRESSED)
@@ -2301,8 +2301,8 @@ static int zoran_enum_input(struct file *file, void *__fh,
 	if (inp->index >= zr->card.inputs)
 		return -EINVAL;
 
-	strncpy(inp->name, zr->card.input[inp->index].name,
-		sizeof(inp->name) - 1);
+	strscpy(inp->name, zr->card.input[inp->index].name,
+		sizeof(inp->name));
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = V4L2_STD_ALL;
 
@@ -2344,7 +2344,7 @@ static int zoran_enum_output(struct file *file, void *__fh,
 
 	outp->index = 0;
 	outp->type = V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY;
-	strncpy(outp->name, "Autodetect", sizeof(outp->name)-1);
+	strscpy(outp->name, "Autodetect", sizeof(outp->name));
 
 	return 0;
 }
-- 
2.17.1
