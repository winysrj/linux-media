Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46492 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbeIKBQf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 21:16:35 -0400
Date: Mon, 10 Sep 2018 17:20:42 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3 v2] media: replace strcpy() by strscpy()
Message-ID: <20180910172042.50792973@coco.lan>
In-Reply-To: <20180910171415.7eac2732@coco.lan>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
        <ac8f27b58748f6d474ffd141f29536638f793953.1536581758.git.mchehab+samsung@kernel.org>
        <CAGXu5jKAN6JihMhxz_tMZ6q_Feik3j5RD5QwhuRFmAyiNQJXpA@mail.gmail.com>
        <20180910164847.3f015458@coco.lan>
        <20180910171415.7eac2732@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The strcpy() function is being deprecated upstream. Replace
it by the safer strscpy().

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

--

v2: removed the changes at the imon driver. There, the is a debugfs
node with a store function using DEVICE_ATTR() passing a char * buf
without any sizing information.

So, for now, keep using strcpy() there.


diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 77d8fcdd4f66..efbf13c5ab82 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -451,7 +451,7 @@ static int vidioc_querycap(struct file *file, void *fh, struct v4l2_capability *
 	struct video_device *vdev = video_devdata(file);
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
-	strcpy((char *)cap->driver, "saa7146 v4l2");
+	strscpy((char *)cap->driver, "saa7146 v4l2", sizeof(cap->driver));
 	strscpy((char *)cap->card, dev->ext->name, sizeof(cap->card));
 	sprintf((char *)cap->bus_info, "PCI:%s", pci_name(dev->pci));
 	cap->device_caps =
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c4e7ebfe4d29..961207cf09eb 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2422,7 +2422,7 @@ static int dvb_frontend_handle_ioctl(struct file *file,
 		struct dvb_frontend_info *info = parg;
 		memset(info, 0, sizeof(*info));
 
-		strcpy(info->name, fe->ops.info.name);
+		strscpy(info->name, fe->ops.info.name, sizeof(info->name));
 		info->symbol_rate_min = fe->ops.info.symbol_rate_min;
 		info->symbol_rate_max = fe->ops.info.symbol_rate_max;
 		info->symbol_rate_tolerance = fe->ops.info.symbol_rate_tolerance;
diff --git a/drivers/media/dvb-frontends/mt312.c b/drivers/media/dvb-frontends/mt312.c
index aad07adda37d..03e74a729168 100644
--- a/drivers/media/dvb-frontends/mt312.c
+++ b/drivers/media/dvb-frontends/mt312.c
@@ -815,17 +815,20 @@ struct dvb_frontend *mt312_attach(const struct mt312_config *config,
 
 	switch (state->id) {
 	case ID_VP310:
-		strcpy(state->frontend.ops.info.name, "Zarlink VP310 DVB-S");
+		strscpy(state->frontend.ops.info.name, "Zarlink VP310 DVB-S",
+			sizeof(state->frontend.ops.info.name));
 		state->xtal = MT312_PLL_CLK;
 		state->freq_mult = 9;
 		break;
 	case ID_MT312:
-		strcpy(state->frontend.ops.info.name, "Zarlink MT312 DVB-S");
+		strscpy(state->frontend.ops.info.name, "Zarlink MT312 DVB-S",
+			sizeof(state->frontend.ops.info.name));
 		state->xtal = MT312_PLL_CLK;
 		state->freq_mult = 6;
 		break;
 	case ID_ZL10313:
-		strcpy(state->frontend.ops.info.name, "Zarlink ZL10313 DVB-S");
+		strscpy(state->frontend.ops.info.name, "Zarlink ZL10313 DVB-S",
+			sizeof(state->frontend.ops.info.name));
 		state->xtal = MT312_PLL_CLK_10_111;
 		state->freq_mult = 9;
 		break;
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index 6293bd920fa6..333e4a1da13b 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -288,8 +288,9 @@ struct dvb_frontend *zl10039_attach(struct dvb_frontend *fe,
 	state->id = state->id & 0x0f;
 	switch (state->id) {
 	case ID_ZL10039:
-		strcpy(fe->ops.tuner_ops.info.name,
-			"Zarlink ZL10039 DVB-S tuner");
+		strscpy(fe->ops.tuner_ops.info.name,
+			"Zarlink ZL10039 DVB-S tuner",
+			sizeof(fe->ops.tuner_ops.info.name));
 		break;
 	default:
 		dprintk("Chip ID=%x does not match a known type\n", state->id);
diff --git a/drivers/media/firewire/firedtv-fe.c b/drivers/media/firewire/firedtv-fe.c
index 69087ae6c1d0..683957885ac4 100644
--- a/drivers/media/firewire/firedtv-fe.c
+++ b/drivers/media/firewire/firedtv-fe.c
@@ -247,7 +247,7 @@ void fdtv_frontend_init(struct firedtv *fdtv, const char *name)
 		dev_err(fdtv->device, "no frontend for model type %d\n",
 			fdtv->type);
 	}
-	strcpy(fi->name, name);
+	strscpy(fi->name, name, sizeof(fi->name));
 
 	fdtv->fe.dvb = &fdtv->adapter;
 	fdtv->fe.sec_priv = fdtv;
diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 034ebf754007..907323f0ca3b 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -317,7 +317,7 @@ static int ad5820_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);
 	coil->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	coil->subdev.internal_ops = &ad5820_internal_ops;
-	strcpy(coil->subdev.name, "ad5820 focus");
+	strscpy(coil->subdev.name, "ad5820 focus", sizeof(coil->subdev.name));
 
 	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
 	if (ret < 0)
diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index 49c6644cbba7..f122f03bd6b7 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -362,7 +362,8 @@ static int lm3560_subdev_init(struct lm3560_flash *flash,
 
 	v4l2_i2c_subdev_init(&flash->subdev_led[led_no], client, &lm3560_ops);
 	flash->subdev_led[led_no].flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	strcpy(flash->subdev_led[led_no].name, led_name);
+	strscpy(flash->subdev_led[led_no].name, led_name,
+		sizeof(flash->subdev_led[led_no].name));
 	rval = lm3560_init_controls(flash, led_no);
 	if (rval)
 		goto err_out;
diff --git a/drivers/media/i2c/lm3646.c b/drivers/media/i2c/lm3646.c
index 7e9967af36ec..12ef2653987b 100644
--- a/drivers/media/i2c/lm3646.c
+++ b/drivers/media/i2c/lm3646.c
@@ -278,7 +278,8 @@ static int lm3646_subdev_init(struct lm3646_flash *flash)
 
 	v4l2_i2c_subdev_init(&flash->subdev_led, client, &lm3646_ops);
 	flash->subdev_led.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	strcpy(flash->subdev_led.name, LM3646_NAME);
+	strscpy(flash->subdev_led.name, LM3646_NAME,
+		sizeof(flash->subdev_led.name));
 	rval = lm3646_init_controls(flash);
 	if (rval)
 		goto err_out;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 9ca9b3997073..21ca5186f9ed 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1698,7 +1698,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 		return ret;
 
 	v4l2_i2c_subdev_init(oif_sd, client, &oif_subdev_ops);
-	strcpy(oif_sd->name, "S5C73M3-OIF");
+	strscpy(oif_sd->name, "S5C73M3-OIF", sizeof(oif_sd->name));
 
 	oif_sd->internal_ops = &oif_internal_ops;
 	oif_sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index 2a4882cddc51..344666293f7d 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -703,7 +703,7 @@ static int sr030pc30_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	sd = &info->sd;
-	strcpy(sd->name, MODULE_NAME);
+	strscpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	info->pdata = client->dev.platform_data;
 
 	v4l2_i2c_subdev_init(sd, client, &sr030pc30_ops);
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 95045448a112..413bf287547c 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2782,7 +2782,7 @@ static int bttv_g_tuner(struct file *file, void *priv,
 	t->rxsubchans = V4L2_TUNER_SUB_MONO;
 	t->capability = V4L2_TUNER_CAP_NORM;
 	bttv_call_all(btv, tuner, g_tuner, t);
-	strcpy(t->name, "Television");
+	strscpy(t->name, "Television", sizeof(t->name));
 	t->type       = V4L2_TUNER_ANALOG_TV;
 	if (btread(BT848_DSTATUS)&BT848_DSTATUS_HLOC)
 		t->signal = 0xffff;
@@ -3257,7 +3257,7 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 
 	if (0 != t->index)
 		return -EINVAL;
-	strcpy(t->name, "Radio");
+	strscpy(t->name, "Radio", sizeof(t->name));
 	t->type = V4L2_TUNER_RADIO;
 	radio_enable(btv);
 
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 8579de5bb61b..3083434bb636 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1280,7 +1280,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 	if (0 != t->index)
 		return -EINVAL;
-	strcpy(t->name, "Television");
+	strscpy(t->name, "Television", sizeof(t->name));
 	call_all(dev, tuner, g_tuner, t);
 
 	dprintk(1, "VIDIOC_G_TUNER: tuner type %d\n", t->type);
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index db1e8ff35474..ee9d329c4038 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -526,7 +526,7 @@ static int snd_cx23885_pcm(struct cx23885_audio_dev *chip, int device,
 	if (err < 0)
 		return err;
 	pcm->private_data = chip;
-	strcpy(pcm->name, name);
+	strscpy(pcm->name, name, sizeof(pcm->name));
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_cx23885_pcm_ops);
 
 	return 0;
@@ -571,7 +571,7 @@ struct cx23885_audio_dev *cx23885_audio_register(struct cx23885_dev *dev)
 	if (err < 0)
 		goto error;
 
-	strcpy(card->driver, "CX23885");
+	strscpy(card->driver, "CX23885", sizeof(card->driver));
 	sprintf(card->shortname, "Conexant CX23885");
 	sprintf(card->longname, "%s at %s", card->shortname, dev->name);
 
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index b5ac7a6a9a62..92d32a733f1b 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -639,7 +639,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct cx23885_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
 
-	strcpy(cap->driver, "cx23885");
+	strscpy(cap->driver, "cx23885", sizeof(cap->driver));
 	strscpy(cap->card, cx23885_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
@@ -731,7 +731,7 @@ int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i)
 
 	i->index = n;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
-	strcpy(i->name, iname[INPUT(n)->type]);
+	strscpy(i->name, iname[INPUT(n)->type], sizeof(i->name));
 	i->std = CX23885_NORMS;
 	if ((CX23885_VMUX_TELEVISION == INPUT(n)->type) ||
 		(CX23885_VMUX_CABLE == INPUT(n)->type)) {
@@ -828,7 +828,7 @@ static int cx23885_query_audinput(struct file *file, void *priv,
 
 	memset(i, 0, sizeof(*i));
 	i->index = n;
-	strcpy(i->name, iname[n]);
+	strscpy(i->name, iname[n], sizeof(i->name));
 	i->capability = V4L2_AUDCAP_STEREO;
 	return 0;
 
@@ -887,7 +887,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	strcpy(t->name, "Television");
+	strscpy(t->name, "Television", sizeof(t->name));
 
 	call_all(dev, tuner, g_tuner, t);
 	return 0;
@@ -1186,7 +1186,8 @@ int cx23885_video_register(struct cx23885_dev *dev)
 
 	/* Initialize VBI template */
 	cx23885_vbi_template = cx23885_video_template;
-	strcpy(cx23885_vbi_template.name, "cx23885-vbi");
+	strscpy(cx23885_vbi_template.name, "cx23885-vbi",
+		sizeof(cx23885_vbi_template.name));
 
 	dev->tvnorm = V4L2_STD_NTSC_M;
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index ef6380651c10..0a6c90e92557 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -674,7 +674,7 @@ static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
 	}
 	pcm->private_data = chip;
 	pcm->info_flags = 0;
-	strcpy(pcm->name, name);
+	strscpy(pcm->name, name, sizeof(pcm->name));
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_cx25821_pcm_ops);
 
 	return 0;
@@ -725,7 +725,7 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 		return err;
 	}
 
-	strcpy(card->driver, "cx25821");
+	strscpy(card->driver, "cx25821", sizeof(card->driver));
 
 	/* Card "creation" */
 	chip = card->private_data;
@@ -754,10 +754,10 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 		goto error;
 	}
 
-	strcpy(card->shortname, "cx25821");
+	strscpy(card->shortname, "cx25821", sizeof(card->shortname));
 	sprintf(card->longname, "%s at 0x%lx irq %d", chip->dev->name,
 		chip->iobase, chip->irq);
-	strcpy(card->mixername, "CX25821");
+	strscpy(card->mixername, "CX25821", sizeof(card->mixername));
 
 	pr_info("%s/%i: ALSA support for cx25821 boards\n", card->driver,
 		devno);
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 21607fbb6758..3d23c2e64102 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -441,7 +441,7 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE;
 
-	strcpy(cap->driver, "cx25821");
+	strscpy(cap->driver, "cx25821", sizeof(cap->driver));
 	strscpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	if (chan->id >= VID_CHANNEL_NUM)
@@ -486,7 +486,7 @@ static int cx25821_vidioc_enum_input(struct file *file, void *priv,
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = CX25821_NORMS;
-	strcpy(i->name, "Composite");
+	strscpy(i->name, "Composite", sizeof(i->name));
 	return 0;
 }
 
@@ -534,7 +534,7 @@ static int cx25821_vidioc_enum_output(struct file *file, void *priv,
 
 	o->type = V4L2_INPUT_TYPE_CAMERA;
 	o->std = CX25821_NORMS;
-	strcpy(o->name, "Composite");
+	strscpy(o->name, "Composite", sizeof(o->name));
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 89a65478ae36..b683cbe13dee 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -616,7 +616,7 @@ static int snd_cx88_pcm(struct cx88_audio_dev *chip, int device,
 	if (err < 0)
 		return err;
 	pcm->private_data = chip;
-	strcpy(pcm->name, name);
+	strscpy(pcm->name, name, sizeof(pcm->name));
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_cx88_pcm_ops);
 
 	return 0;
@@ -968,12 +968,12 @@ static int cx88_audio_initdev(struct pci_dev *pci,
 			goto error;
 	}
 
-	strcpy(card->driver, "CX88x");
+	strscpy(card->driver, "CX88x", sizeof(card->driver));
 	sprintf(card->shortname, "Conexant CX%x", pci->device);
 	sprintf(card->longname, "%s at %#llx",
 		card->shortname,
 		(unsigned long long)pci_resource_start(pci, 0));
-	strcpy(card->mixername, "CX88");
+	strscpy(card->mixername, "CX88", sizeof(card->mixername));
 
 	dprintk(0, "%s/%i: ALSA support for cx2388x boards\n",
 		card->driver, devno);
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index cf4e926cc388..199756547f03 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -803,7 +803,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct cx8802_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	strcpy(cap->driver, "cx88_blackbird");
+	strscpy(cap->driver, "cx88_blackbird", sizeof(cap->driver));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
 	return cx88_querycap(file, core, cap);
 }
@@ -995,7 +995,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	strcpy(t->name, "Television");
+	strscpy(t->name, "Television", sizeof(t->name));
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->rangehigh  = 0xffffffffUL;
 	call_all(core, tuner, g_tuner, t);
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 07e1483e987d..382af90fd4a9 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -3693,7 +3693,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	core->height  = 240;
 	core->field   = V4L2_FIELD_INTERLACED;
 
-	strcpy(core->v4l2_dev.name, core->name);
+	strscpy(core->v4l2_dev.name, core->name, sizeof(core->v4l2_dev.name));
 	if (v4l2_device_register(NULL, &core->v4l2_dev)) {
 		kfree(core);
 		return NULL;
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index f5d0624023da..df4e7a0686e0 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -842,7 +842,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct cx8800_dev *dev = video_drvdata(file);
 	struct cx88_core *core = dev->core;
 
-	strcpy(cap->driver, "cx8800");
+	strscpy(cap->driver, "cx8800", sizeof(cap->driver));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
 	return cx88_querycap(file, core, cap);
 }
@@ -897,7 +897,7 @@ int cx88_enum_input(struct cx88_core  *core, struct v4l2_input *i)
 	if (!INPUT(n).type)
 		return -EINVAL;
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
-	strcpy(i->name, iname[INPUT(n).type]);
+	strscpy(i->name, iname[INPUT(n).type], sizeof(i->name));
 	if ((INPUT(n).type == CX88_VMUX_TELEVISION) ||
 	    (INPUT(n).type == CX88_VMUX_CABLE))
 		i->type = V4L2_INPUT_TYPE_TUNER;
@@ -952,7 +952,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	strcpy(t->name, "Television");
+	strscpy(t->name, "Television", sizeof(t->name));
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->rangehigh  = 0xffffffffUL;
 	call_all(core, tuner, g_tuner, t);
@@ -1065,7 +1065,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 	if (unlikely(t->index > 0))
 		return -EINVAL;
 
-	strcpy(t->name, "Radio");
+	strscpy(t->name, "Radio", sizeof(t->name));
 
 	call_all(core, tuner, g_tuner, t);
 	return 0;
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 1ddb0576fb7b..a84c8270ea13 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1046,7 +1046,7 @@ static int dm1105_probe(struct pci_dev *pdev,
 
 	/* i2c */
 	i2c_set_adapdata(&dev->i2c_adap, dev);
-	strcpy(dev->i2c_adap.name, DRIVER_NAME);
+	strscpy(dev->i2c_adap.name, DRIVER_NAME, sizeof(dev->i2c_adap.name));
 	dev->i2c_adap.owner = THIS_MODULE;
 	dev->i2c_adap.dev.parent = &pdev->dev;
 	dev->i2c_adap.algo = &dm1105_algo;
@@ -1057,7 +1057,8 @@ static int dm1105_probe(struct pci_dev *pdev,
 		goto err_dm1105_hw_exit;
 
 	i2c_set_adapdata(&dev->i2c_bb_adap, dev);
-	strcpy(dev->i2c_bb_adap.name, DM1105_I2C_GPIO_NAME);
+	strscpy(dev->i2c_bb_adap.name, DM1105_I2C_GPIO_NAME,
+		sizeof(dev->i2c_bb_adap.name));
 	dev->i2c_bb_adap.owner = THIS_MODULE;
 	dev->i2c_bb_adap.dev.parent = &pdev->dev;
 	dev->i2c_bb_adap.algo_data = &dev->i2c_bit;
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index bf6e1621ad6b..17d69bd5d7f1 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -307,8 +307,8 @@ static int dt3155_querycap(struct file *filp, void *p,
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
-	strcpy(cap->driver, DT3155_NAME);
-	strcpy(cap->card, DT3155_NAME " frame grabber");
+	strscpy(cap->driver, DT3155_NAME, sizeof(cap->driver));
+	strscpy(cap->card, DT3155_NAME " frame grabber", sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(pd->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
@@ -322,7 +322,7 @@ static int dt3155_enum_fmt_vid_cap(struct file *filp,
 	if (f->index)
 		return -EINVAL;
 	f->pixelformat = V4L2_PIX_FMT_GREY;
-	strcpy(f->description, "8-bit Greyscale");
+	strscpy(f->description, "8-bit Greyscale", sizeof(f->description));
 	return 0;
 }
 
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 8001d3e9134e..7285edcdd323 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1019,8 +1019,8 @@ static int meyeioc_stilljcapt(int *len)
 static int vidioc_querycap(struct file *file, void *fh,
 				struct v4l2_capability *cap)
 {
-	strcpy(cap->driver, "meye");
-	strcpy(cap->card, "meye");
+	strscpy(cap->driver, "meye", sizeof(cap->driver));
+	strscpy(cap->card, "meye", sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(meye.mchip_dev));
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
@@ -1035,7 +1035,7 @@ static int vidioc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 	if (i->index != 0)
 		return -EINVAL;
 
-	strcpy(i->name, "Camera");
+	strscpy(i->name, "Camera", sizeof(i->name));
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 
 	return 0;
@@ -1118,12 +1118,12 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh,
 	if (f->index == 0) {
 		/* standard YUV 422 capture */
 		f->flags = 0;
-		strcpy(f->description, "YUV422");
+		strscpy(f->description, "YUV422", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_YUYV;
 	} else {
 		/* compressed MJPEG capture */
 		f->flags = V4L2_FMT_FLAG_COMPRESSED;
-		strcpy(f->description, "MJPEG");
+		strscpy(f->description, "MJPEG", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_MJPEG;
 	}
 
diff --git a/drivers/media/pci/ngene/ngene-i2c.c b/drivers/media/pci/ngene/ngene-i2c.c
index 092d46c2a3a9..02a06f6c97f8 100644
--- a/drivers/media/pci/ngene/ngene-i2c.c
+++ b/drivers/media/pci/ngene/ngene-i2c.c
@@ -161,7 +161,7 @@ int ngene_i2c_init(struct ngene *dev, int dev_nr)
 
 	i2c_set_adapdata(adap, &(dev->channel[dev_nr]));
 
-	strcpy(adap->name, "nGene");
+	strscpy(adap->name, "nGene", sizeof(adap->name));
 
 	adap->algo = &ngene_i2c_algo;
 	adap->algo_data = (void *)&(dev->channel[dev_nr]);
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index 5e6fe686f420..872c796621d2 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -633,7 +633,7 @@ static int pluto2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* i2c */
 	i2c_set_adapdata(&pluto->i2c_adap, pluto);
-	strcpy(pluto->i2c_adap.name, DRIVER_NAME);
+	strscpy(pluto->i2c_adap.name, DRIVER_NAME, sizeof(pluto->i2c_adap.name));
 	pluto->i2c_adap.owner = THIS_MODULE;
 	pluto->i2c_adap.dev.parent = &pdev->dev;
 	pluto->i2c_adap.algo_data = &pluto->i2c_bit;
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 7f878fc41b7e..f4b8030e2369 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1354,7 +1354,7 @@ static int pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	i2c_adap->algo = &pt1_i2c_algo;
 	i2c_adap->algo_data = NULL;
 	i2c_adap->dev.parent = &pdev->dev;
-	strcpy(i2c_adap->name, DRIVER_NAME);
+	strscpy(i2c_adap->name, DRIVER_NAME, sizeof(i2c_adap->name));
 	i2c_set_adapdata(i2c_adap, pt1);
 	ret = i2c_add_adapter(i2c_adap);
 	if (ret < 0)
diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index b90cfde6e301..dc9cdaaee1fb 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -901,7 +901,7 @@ static int snd_card_saa7134_pcm(snd_card_saa7134_t *saa7134, int device)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_card_saa7134_capture_ops);
 	pcm->private_data = saa7134;
 	pcm->info_flags = 0;
-	strcpy(pcm->name, "SAA7134 PCM");
+	strscpy(pcm->name, "SAA7134 PCM", sizeof(pcm->name));
 	return 0;
 }
 
@@ -1074,7 +1074,7 @@ static int snd_card_saa7134_new_mixer(snd_card_saa7134_t * chip)
 	unsigned int idx;
 	int err, addr;
 
-	strcpy(card->mixername, "SAA7134 Mixer");
+	strscpy(card->mixername, "SAA7134 Mixer", sizeof(card->mixername));
 
 	for (idx = 0; idx < ARRAY_SIZE(snd_saa7134_volume_controls); idx++) {
 		kcontrol = snd_ctl_new1(&snd_saa7134_volume_controls[idx],
@@ -1138,7 +1138,7 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 	if (err < 0)
 		return err;
 
-	strcpy(card->driver, "SAA7134");
+	strscpy(card->driver, "SAA7134", sizeof(card->driver));
 
 	/* Card "creation" */
 
@@ -1178,7 +1178,7 @@ static int alsa_card_saa7134_create(struct saa7134_dev *dev, int devnum)
 
 	/* End of "creation" */
 
-	strcpy(card->shortname, "SAA7134");
+	strscpy(card->shortname, "SAA7134", sizeof(card->shortname));
 	sprintf(card->longname, "%s at 0x%lx irq %d",
 		chip->dev->name, chip->iobase, chip->irq);
 
diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index cf1e526de56a..42fac53b4027 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -437,7 +437,7 @@ int saa7134_i2c_register(struct saa7134_dev *dev)
 {
 	dev->i2c_adap = saa7134_adap_template;
 	dev->i2c_adap.dev.parent = &dev->pci->dev;
-	strcpy(dev->i2c_adap.name,dev->name);
+	strscpy(dev->i2c_adap.name,dev->name, sizeof(dev->i2c_adap.name));
 	dev->i2c_adap.algo_data = dev;
 	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
 	i2c_add_adapter(&dev->i2c_adap);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index b41de940a1ee..1a22ae7cbdd9 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1445,7 +1445,8 @@ int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 	if (card_in(dev, i->index).type == SAA7134_NO_INPUT)
 		return -EINVAL;
 	i->index = n;
-	strcpy(i->name, saa7134_input_name[card_in(dev, n).type]);
+	strscpy(i->name, saa7134_input_name[card_in(dev, n).type],
+		sizeof(i->name));
 	switch (card_in(dev, n).type) {
 	case SAA7134_INPUT_TV:
 	case SAA7134_INPUT_TV_MONO:
@@ -1502,7 +1503,7 @@ int saa7134_querycap(struct file *file, void *priv,
 
 	unsigned int tuner_type = dev->tuner_type;
 
-	strcpy(cap->driver, "saa7134");
+	strscpy(cap->driver, "saa7134", sizeof(cap->driver));
 	strscpy(cap->card, saa7134_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
@@ -1747,7 +1748,7 @@ int saa7134_g_tuner(struct file *file, void *priv,
 	if (n == SAA7134_INPUT_MAX)
 		return -EINVAL;
 	if (card_in(dev, n).type != SAA7134_NO_INPUT) {
-		strcpy(t->name, "Television");
+		strscpy(t->name, "Television", sizeof(t->name));
 		t->type = V4L2_TUNER_ANALOG_TV;
 		saa_call_all(dev, tuner, g_tuner, t);
 		t->capability = V4L2_TUNER_CAP_NORM |
@@ -1939,7 +1940,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	strcpy(t->name, "Radio");
+	strscpy(t->name, "Radio", sizeof(t->name));
 
 	saa_call_all(dev, tuner, g_tuner, t);
 	t->audmode &= V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO;
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index d697e1ad929c..f33349e16359 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -179,7 +179,7 @@ static void saa7164_histogram_reset(struct saa7164_histogram *hg, char *name)
 	int i;
 
 	memset(hg, 0, sizeof(struct saa7164_histogram));
-	strcpy(hg->name, name);
+	strscpy(hg->name, name, sizeof(hg->name));
 
 	/* First 30ms x 1ms */
 	for (i = 0; i < 30; i++)
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 50161921e4e7..adec2bab8352 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -258,7 +258,7 @@ int saa7164_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 	if (i->index >= 7)
 		return -EINVAL;
 
-	strcpy(i->name, inputs[i->index]);
+	strscpy(i->name, inputs[i->index], sizeof(i->name));
 
 	if (i->index == 0)
 		i->type = V4L2_INPUT_TYPE_TUNER;
@@ -325,7 +325,7 @@ int saa7164_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	if (0 != t->index)
 		return -EINVAL;
 
-	strcpy(t->name, "tuner");
+	strscpy(t->name, "tuner", sizeof(t->name));
 	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO;
 	t->rangelow = SAA7164_TV_MIN_FREQ;
 	t->rangehigh = SAA7164_TV_MAX_FREQ;
@@ -497,7 +497,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct saa7164_port *port = fh->port;
 	struct saa7164_dev *dev = port->dev;
 
-	strcpy(cap->driver, dev->name);
+	strscpy(cap->driver, dev->name, sizeof(cap->driver));
 	strscpy(cap->card, saa7164_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 17b7cabf9a1f..841c7e94405d 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -208,7 +208,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct saa7164_port *port = fh->port;
 	struct saa7164_dev *dev = port->dev;
 
-	strcpy(cap->driver, dev->name);
+	strscpy(cap->driver, dev->name, sizeof(cap->driver));
 	strscpy(cap->card, saa7164_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
index 4c2da27fee4b..4d5ddbcb3514 100644
--- a/drivers/media/pci/smipcie/smipcie-main.c
+++ b/drivers/media/pci/smipcie/smipcie-main.c
@@ -191,7 +191,7 @@ static int smi_i2c_init(struct smi_dev *dev)
 	/* i2c bus 0 */
 	smi_i2c_cfg(dev, I2C_A_SW_CTL);
 	i2c_set_adapdata(&dev->i2c_bus[0], dev);
-	strcpy(dev->i2c_bus[0].name, "SMI-I2C0");
+	strscpy(dev->i2c_bus[0].name, "SMI-I2C0", sizeof(dev->i2c_bus[0].name));
 	dev->i2c_bus[0].owner = THIS_MODULE;
 	dev->i2c_bus[0].dev.parent = &dev->pci_dev->dev;
 	dev->i2c_bus[0].algo_data = &dev->i2c_bit[0];
@@ -213,7 +213,7 @@ static int smi_i2c_init(struct smi_dev *dev)
 	/* i2c bus 1 */
 	smi_i2c_cfg(dev, I2C_B_SW_CTL);
 	i2c_set_adapdata(&dev->i2c_bus[1], dev);
-	strcpy(dev->i2c_bus[1].name, "SMI-I2C1");
+	strscpy(dev->i2c_bus[1].name, "SMI-I2C1", sizeof(dev->i2c_bus[1].name));
 	dev->i2c_bus[1].owner = THIS_MODULE;
 	dev->i2c_bus[1].dev.parent = &dev->pci_dev->dev;
 	dev->i2c_bus[1].algo_data = &dev->i2c_bit[1];
diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 2ac33b5cc454..2cc05a9d57ac 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -354,7 +354,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 
 	snd_pcm_chip(pcm) = solo_dev;
 	pcm->info_flags = 0;
-	strcpy(pcm->name, card->shortname);
+	strscpy(pcm->name, card->shortname, sizeof(pcm->name));
 
 	for (i = 0, ss = pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream;
 	     ss; ss = ss->next, i++)
@@ -394,8 +394,8 @@ int solo_g723_init(struct solo_dev *solo_dev)
 
 	card = solo_dev->snd_card;
 
-	strcpy(card->driver, SOLO6X10_NAME);
-	strcpy(card->shortname, "SOLO-6x10 Audio");
+	strscpy(card->driver, SOLO6X10_NAME, sizeof(card->driver));
+	strscpy(card->shortname, "SOLO-6x10 Audio", sizeof(card->shortname));
 	sprintf(card->longname, "%s on %s IRQ %d", card->shortname,
 		pci_name(solo_dev->pdev), solo_dev->pdev->irq);
 
@@ -404,7 +404,7 @@ int solo_g723_init(struct solo_dev *solo_dev)
 		goto snd_error;
 
 	/* Mixer controls */
-	strcpy(card->mixername, "SOLO-6x10");
+	strscpy(card->mixername, "SOLO-6x10", sizeof(card->mixername));
 	kctl = snd_solo_capture_volume;
 	kctl.count = solo_dev->nr_chans;
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 25f9f2ebff1d..9d27e7463070 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -775,7 +775,7 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	strcpy(cap->driver, SOLO6X10_NAME);
+	strscpy(cap->driver, SOLO6X10_NAME, sizeof(cap->driver));
 	snprintf(cap->card, sizeof(cap->card), "Softlogic 6x10 Enc %d",
 		 solo_enc->ch);
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
@@ -834,17 +834,18 @@ static int solo_enc_enum_fmt_cap(struct file *file, void *priv,
 		switch (dev_type) {
 		case SOLO_DEV_6010:
 			f->pixelformat = V4L2_PIX_FMT_MPEG4;
-			strcpy(f->description, "MPEG-4 part 2");
+			strscpy(f->description, "MPEG-4 part 2",
+				sizeof(f->description));
 			break;
 		case SOLO_DEV_6110:
 			f->pixelformat = V4L2_PIX_FMT_H264;
-			strcpy(f->description, "H.264");
+			strscpy(f->description, "H.264", sizeof(f->description));
 			break;
 		}
 		break;
 	case 1:
 		f->pixelformat = V4L2_PIX_FMT_MJPEG;
-		strcpy(f->description, "MJPEG");
+		strscpy(f->description, "MJPEG", sizeof(f->description));
 		break;
 	default:
 		return -EINVAL;
@@ -1126,7 +1127,8 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 					solo_enc->md_thresholds->p_new.p_u16);
 		break;
 	case V4L2_CID_OSD_TEXT:
-		strcpy(solo_enc->osd_text, ctrl->p_new.p_char);
+		strscpy(solo_enc->osd_text, ctrl->p_new.p_char,
+			sizeof(solo_enc->osd_text));
 		return solo_osd_print(solo_enc);
 	default:
 		return -EINVAL;
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 351bc434d3a2..69fc939fd3d9 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -383,8 +383,8 @@ static int solo_querycap(struct file *file, void  *priv,
 {
 	struct solo_dev *solo_dev = video_drvdata(file);
 
-	strcpy(cap->driver, SOLO6X10_NAME);
-	strcpy(cap->card, "Softlogic 6x10");
+	strscpy(cap->driver, SOLO6X10_NAME, sizeof(cap->driver));
+	strscpy(cap->card, "Softlogic 6x10", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 1858efedaf1a..411177ec4d72 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -419,8 +419,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct sta2x11_vip *vip = video_drvdata(file);
 
-	strcpy(cap->driver, KBUILD_MODNAME);
-	strcpy(cap->card, KBUILD_MODNAME);
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(vip->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
@@ -580,7 +580,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strcpy(f->description, "4:2:2, packed, UYVY");
+	strscpy(f->description, "4:2:2, packed, UYVY", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_UYVY;
 	f->flags = 0;
 	return 0;
diff --git a/drivers/media/pci/ttpci/av7110_v4l.c b/drivers/media/pci/ttpci/av7110_v4l.c
index e4cf42c32284..d1fe15365f4a 100644
--- a/drivers/media/pci/ttpci/av7110_v4l.c
+++ b/drivers/media/pci/ttpci/av7110_v4l.c
@@ -332,7 +332,7 @@ static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
 		return -EINVAL;
 
 	memset(t, 0, sizeof(*t));
-	strcpy((char *)t->name, "Television");
+	strscpy((char *)t->name, "Television", sizeof(t->name));
 
 	t->type = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO |
diff --git a/drivers/media/pci/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
index 30c9b62d9d0c..35b696bdb2df 100644
--- a/drivers/media/pci/ttpci/budget-core.c
+++ b/drivers/media/pci/ttpci/budget-core.c
@@ -504,10 +504,12 @@ int ttpci_budget_init(struct budget *budget, struct saa7146_dev *dev,
 	if (bi->type != BUDGET_FS_ACTIVY)
 		saa7146_write(dev, GPIO_CTRL, 0x500000);	/* GPIO 3 = 1 */
 
-	strscpy(budget->i2c_adap.name, budget->card->name, sizeof(budget->i2c_adap.name));
+	strscpy(budget->i2c_adap.name, budget->card->name,
+		sizeof(budget->i2c_adap.name));
 
 	saa7146_i2c_adapter_prepare(dev, &budget->i2c_adap, SAA7146_I2C_BUS_BIT_RATE_120);
-	strcpy(budget->i2c_adap.name, budget->card->name);
+	strscpy(budget->i2c_adap.name, budget->card->name,
+		sizeof(budget->i2c_adap.name));
 
 	if (i2c_add_adapter(&budget->i2c_adap) < 0) {
 		ret = -ENOMEM;
diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index ff2b7da90c08..5a1f3aa4101a 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -610,7 +610,7 @@ static int tw5864_querycap(struct file *file, void *priv,
 {
 	struct tw5864_input *input = video_drvdata(file);
 
-	strcpy(cap->driver, "tw5864");
+	strscpy(cap->driver, "tw5864", sizeof(cap->driver));
 	snprintf(cap->card, sizeof(cap->card), "TW5864 Encoder %d",
 		 input->nr);
 	sprintf(cap->bus_info, "PCI:%s", pci_name(input->root->pci));
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 08e7dd6ecb07..d3f727045ae8 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -734,7 +734,7 @@ static int tw68_querycap(struct file *file, void  *priv,
 {
 	struct tw68_dev *dev = video_drvdata(file);
 
-	strcpy(cap->driver, "tw68");
+	strscpy(cap->driver, "tw68", sizeof(cap->driver));
 	strscpy(cap->card, "Techwell Capture Card",
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 28590cf3770b..cac6aec0ffa7 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2455,7 +2455,8 @@ vpfe_get_pdata(struct platform_device *pdev)
 
 		/* we only support camera */
 		sdinfo->inputs[0].index = i;
-		strcpy(sdinfo->inputs[0].name, "Camera");
+		strscpy(sdinfo->inputs[0].name, "Camera",
+			sizeof(sdinfo->inputs[0].name));
 		sdinfo->inputs[0].type = V4L2_INPUT_TYPE_CAMERA;
 		sdinfo->inputs[0].std = V4L2_STD_ALL;
 		sdinfo->inputs[0].capabilities = V4L2_IN_CAP_STD;
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 776a92d7387f..dc637bffe63c 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1238,8 +1238,8 @@ static int isc_querycap(struct file *file, void *priv,
 {
 	struct isc_device *isc = video_drvdata(file);
 
-	strcpy(cap->driver, ATMEL_ISC_NAME);
-	strcpy(cap->card, "Atmel Image Sensor Controller");
+	strscpy(cap->driver, ATMEL_ISC_NAME, sizeof(cap->driver));
+	strscpy(cap->card, "Atmel Image Sensor Controller", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", isc->v4l2_dev.name);
 
@@ -1393,7 +1393,7 @@ static int isc_enum_input(struct file *file, void *priv,
 
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = 0;
-	strcpy(inp->name, "Camera");
+	strscpy(inp->name, "Camera", sizeof(inp->name));
 
 	return 0;
 }
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index a96c9337ae58..d6bf96ad474c 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -816,10 +816,12 @@ static int vpbe_display_enum_fmt(struct file *file, void  *priv,
 	fmt->index = index;
 	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
 	if (index == 0) {
-		strcpy(fmt->description, "YUV 4:2:2 - UYVY");
+		strscpy(fmt->description, "YUV 4:2:2 - UYVY",
+			sizeof(fmt->description));
 		fmt->pixelformat = V4L2_PIX_FMT_UYVY;
 	} else {
-		strcpy(fmt->description, "Y/CbCr 4:2:0");
+		strscpy(fmt->description, "Y/CbCr 4:2:0",
+			sizeof(fmt->description));
 		fmt->pixelformat = V4L2_PIX_FMT_NV12;
 	}
 
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index ddcad7b3e76c..ca78eb29641a 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -616,7 +616,7 @@ struct v4l2_subdev *venc_sub_dev_init(struct v4l2_device *v4l2_dev,
 
 	v4l2_subdev_init(&venc->sd, &venc_ops);
 
-	strcpy(venc->sd.name, venc_name);
+	strscpy(venc->sd.name, venc_name, sizeof(venc->sd.name));
 	if (v4l2_device_register_subdev(v4l2_dev, &venc->sd) < 0) {
 		v4l2_err(v4l2_dev,
 			"vpbe unable to register venc sub device\n");
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index f0c2508a6e2e..62bced38db10 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -949,11 +949,13 @@ static int vpif_enum_fmt_vid_cap(struct file *file, void  *priv,
 	/* Fill in the information about format */
 	if (ch->vpifparams.iface.if_type == VPIF_IF_RAW_BAYER) {
 		fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		strcpy(fmt->description, "Raw Mode -Bayer Pattern GrRBGb");
+		strscpy(fmt->description, "Raw Mode -Bayer Pattern GrRBGb",
+			sizeof(fmt->description));
 		fmt->pixelformat = V4L2_PIX_FMT_SBGGR8;
 	} else {
 		fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		strcpy(fmt->description, "YCbCr4:2:2 Semi-Planar");
+		strscpy(fmt->description, "YCbCr4:2:2 Semi-Planar",
+			sizeof(fmt->description));
 		fmt->pixelformat = V4L2_PIX_FMT_NV16;
 	}
 	return 0;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index fec4341eb93e..78eba66f4b2b 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -602,7 +602,8 @@ static int vpif_enum_fmt_vid_out(struct file *file, void  *priv,
 
 	/* Fill in the information about format */
 	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	strcpy(fmt->description, "YCbCr4:2:2 YC Planar");
+	strscpy(fmt->description, "YCbCr4:2:2 YC Planar",
+		sizeof(fmt->description));
 	fmt->pixelformat = V4L2_PIX_FMT_YUV422P;
 	fmt->flags = 0;
 	return 0;
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 0273302aa741..ca6d0317ab42 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -565,9 +565,9 @@ static const struct videobuf_queue_ops viu_video_qops = {
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	strcpy(cap->driver, "viu");
-	strcpy(cap->card, "viu");
-	strcpy(cap->bus_info, "platform:viu");
+	strscpy(cap->driver, "viu", sizeof(cap->driver));
+	strscpy(cap->card, "viu", sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:viu", sizeof(cap->bus_info));
 	cap->device_caps =	V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING     |
 				V4L2_CAP_VIDEO_OVERLAY |
@@ -941,7 +941,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = fh->dev->vdev->tvnorms;
-	strcpy(inp->name, "Camera");
+	strscpy(inp->name, "Camera", sizeof(inp->name));
 	return 0;
 }
 
diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index 57d2c483ad09..2986cb4b88d0 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -341,7 +341,7 @@ static int cafe_smbus_setup(struct cafe_camera *cam)
 		return -ENOMEM;
 	adap->owner = THIS_MODULE;
 	adap->algo = &cafe_smbus_algo;
-	strcpy(adap->name, "cafe_ccic");
+	strscpy(adap->name, "cafe_ccic", sizeof(adap->name));
 	adap->dev.parent = &cam->pdev->dev;
 	i2c_set_adapdata(adap, cam);
 	ret = i2c_add_adapter(adap);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 39fcfa60ed01..f9526193a9c9 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1303,8 +1303,8 @@ static int mcam_vidioc_querycap(struct file *file, void *priv,
 {
 	struct mcam_camera *cam = video_drvdata(file);
 
-	strcpy(cap->driver, "marvell_ccic");
-	strcpy(cap->card, "marvell_ccic");
+	strscpy(cap->driver, "marvell_ccic", sizeof(cap->driver));
+	strscpy(cap->card, "marvell_ccic", sizeof(cap->card));
 	strscpy(cap->bus_info, cam->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
@@ -1421,7 +1421,7 @@ static int mcam_vidioc_enum_input(struct file *filp, void *priv,
 		return -EINVAL;
 
 	input->type = V4L2_INPUT_TYPE_CAMERA;
-	strcpy(input->name, "Camera");
+	strscpy(input->name, "Camera", sizeof(input->name));
 	return 0;
 }
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 1a00b1fa7990..44b6859d7238 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -312,7 +312,7 @@ static int soc_camera_enum_input(struct file *file, void *priv,
 	/* default is camera */
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = icd->vdev->tvnorms;
-	strcpy(inp->name, "Camera");
+	strscpy(inp->name, "Camera", sizeof(inp->name));
 
 	return 0;
 }
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 878b7044e393..5fc7efa76345 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -812,7 +812,7 @@ static int viacam_enum_input(struct file *filp, void *priv,
 
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 	input->std = V4L2_STD_ALL; /* Not sure what should go here */
-	strcpy(input->name, "Camera");
+	strscpy(input->name, "Camera", sizeof(input->name));
 	return 0;
 }
 
@@ -990,8 +990,8 @@ static int viacam_s_fmt_vid_cap(struct file *filp, void *priv,
 static int viacam_querycap(struct file *filp, void *priv,
 		struct v4l2_capability *cap)
 {
-	strcpy(cap->driver, "via-camera");
-	strcpy(cap->card, "via-camera");
+	strscpy(cap->driver, "via-camera", sizeof(cap->driver));
+	strscpy(cap->card, "via-camera", sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index 71105fa4c5f9..4d822dbed972 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -241,11 +241,11 @@ static int vivid_received(struct cec_adapter *adap, struct cec_msg *msg)
 		cec_ops_set_osd_string(msg, &disp_ctl, osd);
 		switch (disp_ctl) {
 		case CEC_OP_DISP_CTL_DEFAULT:
-			strcpy(dev->osd, osd);
+			strscpy(dev->osd, osd, sizeof(dev->osd));
 			dev->osd_jiffies = jiffies;
 			break;
 		case CEC_OP_DISP_CTL_UNTIL_CLEARED:
-			strcpy(dev->osd, osd);
+			strscpy(dev->osd, osd, sizeof(dev->osd));
 			dev->osd_jiffies = 0;
 			break;
 		case CEC_OP_DISP_CTL_CLEAR:
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 31db363602e5..06961e7d8036 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -197,8 +197,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct vivid_dev *dev = video_drvdata(file);
 
-	strcpy(cap->driver, "vivid");
-	strcpy(cap->card, "vivid");
+	strscpy(cap->driver, "vivid", sizeof(cap->driver));
+	strscpy(cap->card, "vivid", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", dev->v4l2_dev.name);
 
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 19a516b80691..c45ffaf303ce 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -191,7 +191,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	dsbr100_getstat(radio);
-	strcpy(v->name, "FM");
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = FREQ_MIN * FREQ_MUL;
 	v->rangehigh = FREQ_MAX * FREQ_MUL;
diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index 0a59d97d4627..5cb153727841 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -222,7 +222,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	 * retval = ma901radio_get_stat(radio, &is_stereo, &v->signal);
 	 */
 
-	strcpy(v->name, "FM");
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = FREQ_MIN * FREQ_MUL;
 	v->rangehigh = FREQ_MAX * FREQ_MUL;
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index e7c35b184e21..ab1324f68199 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -291,7 +291,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (retval)
 		return retval;
 
-	strcpy(v->name, "FM");
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = FREQ_MIN * FREQ_MUL;
 	v->rangehigh = FREQ_MAX * FREQ_MUL;
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index c40e1753f34b..1d7ab5462c77 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -622,7 +622,7 @@ static int si470x_vidioc_g_tuner(struct file *file, void *priv,
 	}
 
 	/* driver constants */
-	strcpy(tuner->name, "FM");
+	strscpy(tuner->name, "FM", sizeof(tuner->name));
 	tuner->type = V4L2_TUNER_RADIO;
 	tuner->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 			    V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_BLOCK_IO |
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 79d7890afe70..a2877c0a2aab 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -249,7 +249,7 @@ static int fm_v4l2_vidioc_g_audio(struct file *file, void *priv,
 		struct v4l2_audio *audio)
 {
 	memset(audio, 0, sizeof(*audio));
-	strcpy(audio->name, "Radio");
+	strscpy(audio->name, "Radio", sizeof(audio->name));
 	audio->capability = V4L2_AUDCAP_STEREO;
 
 	return 0;
@@ -293,7 +293,7 @@ static int fm_v4l2_vidioc_g_tuner(struct file *file, void *priv,
 	if (ret != 0)
 		return ret;
 
-	strcpy(tuner->name, "FM");
+	strscpy(tuner->name, "FM", sizeof(tuner->name));
 	tuner->type = V4L2_TUNER_RADIO;
 	/* Store rangelow and rangehigh freq in unit of 62.5 Hz */
 	tuner->rangelow = bottom_freq * 16;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index aa25c19437ad..efbf210147c7 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1218,7 +1218,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	dprintk(1, "%s called\n", __func__);
 
 	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	strcpy(f->description, "Packed YUV2");
+	strscpy(f->description, "Packed YUV2", sizeof(f->description));
 
 	f->flags = 0;
 	f->pixelformat = V4L2_PIX_FMT_UYVY;
@@ -1349,7 +1349,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	input->index = tmp;
-	strcpy(input->name, inames[AUVI_INPUT(tmp).type]);
+	strscpy(input->name, inames[AUVI_INPUT(tmp).type], sizeof(input->name));
 	if ((AUVI_INPUT(tmp).type == AU0828_VMUX_TELEVISION) ||
 	    (AUVI_INPUT(tmp).type == AU0828_VMUX_CABLE)) {
 		input->type |= V4L2_INPUT_TYPE_TUNER;
@@ -1465,9 +1465,9 @@ static int vidioc_enumaudio(struct file *file, void *priv, struct v4l2_audio *a)
 	dprintk(1, "%s called\n", __func__);
 
 	if (a->index == 0)
-		strcpy(a->name, "Television");
+		strscpy(a->name, "Television", sizeof(a->name));
 	else
-		strcpy(a->name, "Line in");
+		strscpy(a->name, "Line in", sizeof(a->name));
 
 	a->capability = V4L2_AUDCAP_STEREO;
 	return 0;
@@ -1482,9 +1482,9 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 
 	a->index = dev->ctrl_ainput;
 	if (a->index == 0)
-		strcpy(a->name, "Television");
+		strscpy(a->name, "Television", sizeof(a->name));
 	else
-		strcpy(a->name, "Line in");
+		strscpy(a->name, "Line in", sizeof(a->name));
 
 	a->capability = V4L2_AUDCAP_STEREO;
 	return 0;
@@ -1518,7 +1518,7 @@ static int vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
 		dev->std_set_in_tuner_core, dev->dev_state);
 
-	strcpy(t->name, "Auvitek tuner");
+	strscpy(t->name, "Auvitek tuner", sizeof(t->name));
 
 	au0828_init_tuner(dev);
 	i2c_gate_ctrl(dev, 1);
@@ -1978,7 +1978,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->vdev.lock = &dev->lock;
 	dev->vdev.queue = &dev->vb_vidq;
 	dev->vdev.queue->lock = &dev->vb_queue_lock;
-	strcpy(dev->vdev.name, "au0828a video");
+	strscpy(dev->vdev.name, "au0828a video", sizeof(dev->vdev.name));
 
 	/* Setup the VBI device */
 	dev->vbi_dev = au0828_video_template;
@@ -1986,7 +1986,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->vbi_dev.lock = &dev->lock;
 	dev->vbi_dev.queue = &dev->vb_vbiq;
 	dev->vbi_dev.queue->lock = &dev->vb_vbi_queue_lock;
-	strcpy(dev->vbi_dev.name, "au0828a vbi");
+	strscpy(dev->vbi_dev.name, "au0828a vbi", sizeof(dev->vbi_dev.name));
 
 	/* Init entities at the Media Controller */
 	au0828_analog_create_entities(dev);
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 99f106b13280..aa7f3c307b22 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -219,12 +219,12 @@ static int cpia2_querycap(struct file *file, void *fh, struct v4l2_capability *v
 {
 	struct camera_data *cam = video_drvdata(file);
 
-	strcpy(vc->driver, "cpia2");
+	strscpy(vc->driver, "cpia2", sizeof(vc->driver));
 
 	if (cam->params.pnp_id.product == 0x151)
-		strcpy(vc->card, "QX5 Microscope");
+		strscpy(vc->card, "QX5 Microscope", sizeof(vc->card));
 	else
-		strcpy(vc->card, "CPiA2 Camera");
+		strscpy(vc->card, "CPiA2 Camera", sizeof(vc->card));
 	switch (cam->params.pnp_id.device_type) {
 	case DEVICE_STV_672:
 		strcat(vc->card, " (672/");
@@ -281,7 +281,7 @@ static int cpia2_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 {
 	if (i->index)
 		return -EINVAL;
-	strcpy(i->name, "Camera");
+	strscpy(i->name, "Camera", sizeof(i->name));
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	return 0;
 }
@@ -319,11 +319,11 @@ static int cpia2_enum_fmt_vid_cap(struct file *file, void *fh,
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
 	switch(index) {
 	case 0:
-		strcpy(f->description, "MJPEG");
+		strscpy(f->description, "MJPEG", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_MJPEG;
 		break;
 	case 1:
-		strcpy(f->description, "JPEG");
+		strscpy(f->description, "JPEG", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_JPEG;
 		break;
 	default:
diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 32ee7b3f21c9..77f2c65eb79a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -679,10 +679,10 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 			&snd_cx231xx_pcm_capture);
 	pcm->info_flags = 0;
 	pcm->private_data = dev;
-	strcpy(pcm->name, "Conexant cx231xx Capture");
-	strcpy(card->driver, "Cx231xx-Audio");
-	strcpy(card->shortname, "Cx231xx Audio");
-	strcpy(card->longname, "Conexant cx231xx Audio");
+	strscpy(pcm->name, "Conexant cx231xx Capture", sizeof(pcm->name));
+	strscpy(card->driver, "Cx231xx-Audio", sizeof(card->driver));
+	strscpy(card->shortname, "Cx231xx Audio", sizeof(card->shortname));
+	strscpy(card->longname, "Conexant cx231xx Audio", sizeof(card->longname));
 
 	INIT_WORK(&dev->wq_trigger, audio_trigger);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 7759bc66f18c..29160df76cf7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1169,7 +1169,7 @@ int cx231xx_enum_input(struct file *file, void *priv,
 	i->index = n;
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 
-	strcpy(i->name, iname[INPUT(n)->type]);
+	strscpy(i->name, iname[INPUT(n)->type], sizeof(i->name));
 
 	if ((CX231XX_VMUX_TELEVISION == INPUT(n)->type) ||
 	    (CX231XX_VMUX_CABLE == INPUT(n)->type))
@@ -1244,7 +1244,7 @@ int cx231xx_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	if (0 != t->index)
 		return -EINVAL;
 
-	strcpy(t->name, "Tuner");
+	strscpy(t->name, "Tuner", sizeof(t->name));
 
 	t->type = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM;
@@ -1716,7 +1716,7 @@ static int radio_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 	if (t->index)
 		return -EINVAL;
 
-	strcpy(t->name, "Radio");
+	strscpy(t->name, "Radio", sizeof(t->name));
 
 	call_all(dev, tuner, g_tuner, t);
 
@@ -2242,7 +2242,8 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 
 	/* Initialize VBI template */
 	cx231xx_vbi_template = cx231xx_video_template;
-	strcpy(cx231xx_vbi_template.name, "cx231xx-vbi");
+	strscpy(cx231xx_vbi_template.name, "cx231xx-vbi",
+		sizeof(cx231xx_vbi_template.name));
 
 	/* Allocate and fill vbi video_device struct */
 	cx231xx_vdev_init(dev, &dev->vbi_dev, &cx231xx_vbi_template, "vbi");
diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 8e799ae1df69..d5e2c19f600d 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -938,11 +938,11 @@ static int em28xx_audio_init(struct em28xx *dev)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_em28xx_pcm_capture);
 	pcm->info_flags = 0;
 	pcm->private_data = dev;
-	strcpy(pcm->name, "Empia 28xx Capture");
+	strscpy(pcm->name, "Empia 28xx Capture", sizeof(pcm->name));
 
-	strcpy(card->driver, "Em28xx-Audio");
-	strcpy(card->shortname, "Em28xx Audio");
-	strcpy(card->longname, "Empia Em28xx Audio");
+	strscpy(card->driver, "Em28xx-Audio", sizeof(card->driver));
+	strscpy(card->shortname, "Em28xx Audio", sizeof(card->shortname));
+	strscpy(card->longname, "Empia Em28xx Audio", sizeof(card->longname));
 
 	INIT_WORK(&adev->wq_trigger, audio_trigger);
 
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index e19d6342e0d0..02c13d71e6c1 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -985,7 +985,8 @@ int em28xx_i2c_register(struct em28xx *dev, unsigned int bus,
 
 	dev->i2c_adap[bus] = em28xx_adap_template;
 	dev->i2c_adap[bus].dev.parent = &dev->intf->dev;
-	strcpy(dev->i2c_adap[bus].name, dev_name(&dev->intf->dev));
+	strscpy(dev->i2c_adap[bus].name, dev_name(&dev->intf->dev),
+		sizeof(dev->i2c_adap[bus].name));
 
 	dev->i2c_bus[bus].bus = bus;
 	dev->i2c_bus[bus].algo_type = algo_type;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 5e8a26fa719a..917602954bfb 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1675,7 +1675,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 
-	strcpy(i->name, iname[INPUT(n)->type]);
+	strscpy(i->name, iname[INPUT(n)->type], sizeof(i->name));
 
 	if (INPUT(n)->type == EM28XX_VMUX_TELEVISION)
 		i->type = V4L2_INPUT_TYPE_TUNER;
@@ -1716,28 +1716,28 @@ static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
 
 	switch (a->index) {
 	case EM28XX_AMUX_VIDEO:
-		strcpy(a->name, "Television");
+		strscpy(a->name, "Television", sizeof(a->name));
 		break;
 	case EM28XX_AMUX_LINE_IN:
-		strcpy(a->name, "Line In");
+		strscpy(a->name, "Line In", sizeof(a->name));
 		break;
 	case EM28XX_AMUX_VIDEO2:
-		strcpy(a->name, "Television alt");
+		strscpy(a->name, "Television alt", sizeof(a->name));
 		break;
 	case EM28XX_AMUX_PHONE:
-		strcpy(a->name, "Phone");
+		strscpy(a->name, "Phone", sizeof(a->name));
 		break;
 	case EM28XX_AMUX_MIC:
-		strcpy(a->name, "Mic");
+		strscpy(a->name, "Mic", sizeof(a->name));
 		break;
 	case EM28XX_AMUX_CD:
-		strcpy(a->name, "CD");
+		strscpy(a->name, "CD", sizeof(a->name));
 		break;
 	case EM28XX_AMUX_AUX:
-		strcpy(a->name, "Aux");
+		strscpy(a->name, "Aux", sizeof(a->name));
 		break;
 	case EM28XX_AMUX_PCM_OUT:
-		strcpy(a->name, "PCM");
+		strscpy(a->name, "PCM", sizeof(a->name));
 		break;
 	default:
 		return -EINVAL;
@@ -1776,7 +1776,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	strcpy(t->name, "Tuner");
+	strscpy(t->name, "Tuner", sizeof(t->name));
 
 	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, g_tuner, t);
 	return 0;
@@ -2045,7 +2045,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 	if (unlikely(t->index > 0))
 		return -EINVAL;
 
-	strcpy(t->name, "Radio");
+	strscpy(t->name, "Radio", sizeof(t->name));
 
 	v4l2_device_call_all(&dev->v4l2->v4l2_dev, 0, tuner, g_tuner, t);
 
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 9ab071f8993d..e082086428a4 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -578,8 +578,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct hdpvr_device *dev = video_drvdata(file);
 
-	strcpy(cap->driver, "hdpvr");
-	strcpy(cap->card, "Hauppauge HD PVR");
+	strscpy(cap->driver, "hdpvr", sizeof(cap->driver));
+	strscpy(cap->card, "Hauppauge HD PVR", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_AUDIO |
 			    V4L2_CAP_READWRITE;
@@ -1238,7 +1238,8 @@ int hdpvr_register_videodev(struct hdpvr_device *dev, struct device *parent,
 
 	/* setup and register video device */
 	dev->video_dev = hdpvr_video_template;
-	strcpy(dev->video_dev.name, "Hauppauge HD PVR");
+	strscpy(dev->video_dev.name, "Hauppauge HD PVR",
+		sizeof(dev->video_dev.name));
 	dev->video_dev.v4l2_dev = &dev->v4l2_dev;
 	video_set_drvdata(&dev->video_dev, dev);
 
diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 350635826aae..365c78b748dd 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -571,7 +571,8 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
 			memset(osd_str + osd_len, ' ', 4 - osd_len);
 			osd_len = 4;
 			osd_str[osd_len] = '\0';
-			strcpy(adap->log_addrs.osd_name, osd_str);
+			strscpy(adap->log_addrs.osd_name, osd_str,
+				sizeof(adap->log_addrs.osd_name));
 		}
 		err = pulse8_send_and_wait(pulse8, cmd, 1 + osd_len,
 					   MSGCODE_COMMAND_ACCEPTED, 0);
diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
index 54b036d39c5b..72704f4d5330 100644
--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -1027,7 +1027,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 
 	/* Init video_device structure */
 	pdev->vdev = pwc_template;
-	strcpy(pdev->vdev.name, name);
+	strscpy(pdev->vdev.name, name, sizeof(pdev->vdev.name));
 	pdev->vdev.queue = &pdev->vb_queue;
 	pdev->vdev.queue->lock = &pdev->vb_queue_lock;
 	video_set_drvdata(&pdev->vdev, pdev);
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index 0a94de0991c1..7b33ac00ba0e 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -492,7 +492,7 @@ static int pwc_querycap(struct file *file, void *fh, struct v4l2_capability *cap
 {
 	struct pwc_device *pdev = video_drvdata(file);
 
-	strcpy(cap->driver, PWC_NAME);
+	strscpy(cap->driver, PWC_NAME, sizeof(cap->driver));
 	strscpy(cap->card, pdev->vdev.name, sizeof(cap->card));
 	usb_make_path(pdev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index cecdcbcd400c..d9964da05976 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -141,7 +141,8 @@ static void rain_irq_work_handler(struct work_struct *work)
 			    !memcmp(rain->cmd, "STA", 3)) {
 				rain_process_msg(rain);
 			} else {
-				strcpy(rain->cmd_reply, rain->cmd);
+				strscpy(rain->cmd_reply, rain->cmd,
+					sizeof(rain->cmd_reply));
 				complete(&rain->cmd_done);
 			}
 			rain->cmd_idx = 0;
diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
index 62a12d5356ad..c3a15564e5cb 100644
--- a/drivers/media/usb/stk1160/stk1160-i2c.c
+++ b/drivers/media/usb/stk1160/stk1160-i2c.c
@@ -260,7 +260,7 @@ int stk1160_i2c_register(struct stk1160 *dev)
 
 	dev->i2c_adap = adap_template;
 	dev->i2c_adap.dev.parent = dev->dev;
-	strcpy(dev->i2c_adap.name, "stk1160");
+	strscpy(dev->i2c_adap.name, "stk1160", sizeof(dev->i2c_adap.name));
 	dev->i2c_adap.algo_data = dev;
 
 	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index bbf191b71f38..701ed3d4afe6 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -344,8 +344,8 @@ static int vidioc_querycap(struct file *file,
 {
 	struct stk1160 *dev = video_drvdata(file);
 
-	strcpy(cap->driver, "stk1160");
-	strcpy(cap->card, "stk1160");
+	strscpy(cap->driver, "stk1160", sizeof(cap->driver));
+	strscpy(cap->card, "stk1160", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 5accb5241072..e11d5d5b7c26 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -793,8 +793,8 @@ static int stk_vidioc_querycap(struct file *filp,
 {
 	struct stk_camera *dev = video_drvdata(filp);
 
-	strcpy(cap->driver, "stk");
-	strcpy(cap->card, "stk");
+	strscpy(cap->driver, "stk", sizeof(cap->driver));
+	strscpy(cap->card, "stk", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
@@ -809,7 +809,7 @@ static int stk_vidioc_enum_input(struct file *filp,
 	if (input->index != 0)
 		return -EINVAL;
 
-	strcpy(input->name, "Syntek USB Camera");
+	strscpy(input->name, "Syntek USB Camera", sizeof(input->name));
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 	return 0;
 }
@@ -859,23 +859,23 @@ static int stk_vidioc_enum_fmt_vid_cap(struct file *filp,
 	switch (fmtd->index) {
 	case 0:
 		fmtd->pixelformat = V4L2_PIX_FMT_RGB565;
-		strcpy(fmtd->description, "r5g6b5");
+		strscpy(fmtd->description, "r5g6b5", sizeof(fmtd->description));
 		break;
 	case 1:
 		fmtd->pixelformat = V4L2_PIX_FMT_RGB565X;
-		strcpy(fmtd->description, "r5g6b5BE");
+		strscpy(fmtd->description, "r5g6b5BE", sizeof(fmtd->description));
 		break;
 	case 2:
 		fmtd->pixelformat = V4L2_PIX_FMT_UYVY;
-		strcpy(fmtd->description, "yuv4:2:2");
+		strscpy(fmtd->description, "yuv4:2:2", sizeof(fmtd->description));
 		break;
 	case 3:
 		fmtd->pixelformat = V4L2_PIX_FMT_SBGGR8;
-		strcpy(fmtd->description, "Raw bayer");
+		strscpy(fmtd->description, "Raw bayer", sizeof(fmtd->description));
 		break;
 	case 4:
 		fmtd->pixelformat = V4L2_PIX_FMT_YUYV;
-		strcpy(fmtd->description, "yuv4:2:2");
+		strscpy(fmtd->description, "yuv4:2:2", sizeof(fmtd->description));
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index f18cffae4c85..b965931793b5 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -429,8 +429,8 @@ static int tm6000_audio_init(struct tm6000_core *dev)
 		snd_printk(KERN_ERR "cannot create card instance %d\n", devnr);
 		return rc;
 	}
-	strcpy(card->driver, "tm6000-alsa");
-	strcpy(card->shortname, "TM5600/60x0");
+	strscpy(card->driver, "tm6000-alsa", sizeof(card->driver));
+	strscpy(card->shortname, "TM5600/60x0", sizeof(card->shortname));
 	sprintf(card->longname, "TM5600/60x0 Audio at bus %d device %d",
 		dev->udev->bus->busnum, dev->udev->devnum);
 
@@ -456,7 +456,7 @@ static int tm6000_audio_init(struct tm6000_core *dev)
 
 	pcm->info_flags = 0;
 	pcm->private_data = chip;
-	strcpy(pcm->name, "Trident TM5600/60x0");
+	strscpy(pcm->name, "Trident TM5600/60x0", sizeof(pcm->name));
 
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_tm6000_pcm_ops);
 
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index a541c965c810..a00246bc893b 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1090,7 +1090,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	else
 		i->type = V4L2_INPUT_TYPE_CAMERA;
 
-	strcpy(i->name, iname[dev->vinput[n].type]);
+	strscpy(i->name, iname[dev->vinput[n].type], sizeof(i->name));
 
 	i->std = TM6000_STD;
 
@@ -1187,7 +1187,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	strcpy(t->name, "Television");
+	strscpy(t->name, "Television", sizeof(t->name));
 	t->type       = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO;
 	t->rangehigh  = 0xffffffffUL;
@@ -1267,7 +1267,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 		return -EINVAL;
 
 	memset(t, 0, sizeof(*t));
-	strcpy(t->name, "Radio");
+	strscpy(t->name, "Radio", sizeof(t->name));
 	t->type = V4L2_TUNER_RADIO;
 	t->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
 	t->rxsubchans = V4L2_TUNER_SUB_STEREO;
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index eed56895c2b9..6eb84cf007b4 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -1686,7 +1686,7 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	/* i2c */
 	memset(&ttusb->i2c_adap, 0, sizeof(struct i2c_adapter));
-	strcpy(ttusb->i2c_adap.name, "TTUSB DEC");
+	strscpy(ttusb->i2c_adap.name, "TTUSB DEC", sizeof(ttusb->i2c_adap.name));
 
 	i2c_set_adapdata(&ttusb->i2c_adap, ttusb);
 
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index f4e758e5f3ec..dd2ff8ed6c6a 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -504,9 +504,9 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	switch (chan) {
 	case 0:
 		if (usbvision_device_data[usbvision->dev_model].video_channels == 4) {
-			strcpy(vi->name, "White Video Input");
+			strscpy(vi->name, "White Video Input", sizeof(vi->name));
 		} else {
-			strcpy(vi->name, "Television");
+			strscpy(vi->name, "Television", sizeof(vi->name));
 			vi->type = V4L2_INPUT_TYPE_TUNER;
 			vi->tuner = chan;
 			vi->std = USBVISION_NORMS;
@@ -515,22 +515,23 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	case 1:
 		vi->type = V4L2_INPUT_TYPE_CAMERA;
 		if (usbvision_device_data[usbvision->dev_model].video_channels == 4)
-			strcpy(vi->name, "Green Video Input");
+			strscpy(vi->name, "Green Video Input", sizeof(vi->name));
 		else
-			strcpy(vi->name, "Composite Video Input");
+			strscpy(vi->name, "Composite Video Input",
+				sizeof(vi->name));
 		vi->std = USBVISION_NORMS;
 		break;
 	case 2:
 		vi->type = V4L2_INPUT_TYPE_CAMERA;
 		if (usbvision_device_data[usbvision->dev_model].video_channels == 4)
-			strcpy(vi->name, "Yellow Video Input");
+			strscpy(vi->name, "Yellow Video Input", sizeof(vi->name));
 		else
-			strcpy(vi->name, "S-Video Input");
+			strscpy(vi->name, "S-Video Input", sizeof(vi->name));
 		vi->std = USBVISION_NORMS;
 		break;
 	case 3:
 		vi->type = V4L2_INPUT_TYPE_CAMERA;
-		strcpy(vi->name, "Red Video Input");
+		strscpy(vi->name, "Red Video Input", sizeof(vi->name));
 		vi->std = USBVISION_NORMS;
 		break;
 	}
@@ -589,9 +590,9 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (vt->index)	/* Only tuner 0 */
 		return -EINVAL;
 	if (vt->type == V4L2_TUNER_RADIO)
-		strcpy(vt->name, "Radio");
+		strscpy(vt->name, "Radio", sizeof(vt->name));
 	else
-		strcpy(vt->name, "Television");
+		strscpy(vt->name, "Television", sizeof(vt->name));
 
 	/* Let clients fill in the remainder of this struct */
 	call_all(usbvision, tuner, g_tuner, vt);
@@ -814,7 +815,8 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 {
 	if (vfd->index >= USBVISION_SUPPORTED_PALETTES - 1)
 		return -EINVAL;
-	strcpy(vfd->description, usbvision_v4l2_format[vfd->index].desc);
+	strscpy(vfd->description, usbvision_v4l2_format[vfd->index].desc,
+		sizeof(vfd->description));
 	vfd->pixelformat = usbvision_v4l2_format[vfd->index].format;
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4dd83bae0fd7..7e06a078ab63 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2138,7 +2138,7 @@ static int uvc_probe(struct usb_interface *intf,
 	if (udev->serial)
 		strscpy(dev->mdev.serial, udev->serial,
 			sizeof(dev->mdev.serial));
-	strcpy(dev->mdev.bus_info, udev->devpath);
+	strscpy(dev->mdev.bus_info, udev->devpath, sizeof(dev->mdev.bus_info));
 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 	media_device_init(&dev->mdev);
 
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 0ba98583c736..ab35554cbffa 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -719,7 +719,7 @@ static int zr364xx_vidioc_enum_input(struct file *file, void *priv,
 {
 	if (i->index != 0)
 		return -EINVAL;
-	strcpy(i->name, DRIVER_DESC " Camera");
+	strscpy(i->name, DRIVER_DESC " Camera", sizeof(i->name));
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	return 0;
 }
@@ -765,7 +765,7 @@ static int zr364xx_vidioc_enum_fmt_vid_cap(struct file *file,
 	if (f->index > 0)
 		return -EINVAL;
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
-	strcpy(f->description, formats[0].name);
+	strscpy(f->description, formats[0].name, sizeof(f->description));
 	f->pixelformat = formats[0].fourcc;
 	return 0;
 }
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index e55c815b9b65..bdf6ee5ad96c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -639,7 +639,8 @@ static int vpfe_probe(struct platform_device *pdev)
 		goto probe_disable_clock;
 
 	vpfe_dev->media_dev.dev = vpfe_dev->pdev;
-	strcpy((char *)&vpfe_dev->media_dev.model, "davinci-media");
+	strscpy((char *)&vpfe_dev->media_dev.model, "davinci-media",
+		sizeof(vpfe_dev->media_dev.model));
 
 	ret = media_device_register(&vpfe_dev->media_dev);
 	if (ret) {
diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index ceeeb3069a02..7b457a4b7df5 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -597,7 +597,7 @@ static int csi2_probe(struct platform_device *pdev)
 	csi2->sd.dev = &pdev->dev;
 	csi2->sd.owner = THIS_MODULE;
 	csi2->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
-	strcpy(csi2->sd.name, DEVICE_NAME);
+	strscpy(csi2->sd.name, DEVICE_NAME, sizeof(csi2->sd.name));
 	csi2->sd.entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	csi2->sd.grp_id = IMX_MEDIA_GRP_ID_CSI2;
 
diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index e69a43ae74c2..94dadbba7cd5 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -1048,7 +1048,7 @@ static int zr36057_init (struct zoran *zr)
 	*zr->video_dev = zoran_template;
 	zr->video_dev->v4l2_dev = &zr->v4l2_dev;
 	zr->video_dev->lock = &zr->lock;
-	strcpy(zr->video_dev->name, ZR_DEVNAME(zr));
+	strscpy(zr->video_dev->name, ZR_DEVNAME(zr), sizeof(zr->video_dev->name));
 	/* It's not a mem2mem device, but you can both capture and output from
 	   one and the same device. This should really be split up into two
 	   device nodes, but that's a job for another day. */


Thanks,
Mauro
