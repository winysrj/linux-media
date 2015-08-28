Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43934 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752023AbbH1Ltk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 8/8] saa7164: video and vbi ports share the same input/tuner/std
Date: Fri, 28 Aug 2015 13:48:33 +0200
Message-Id: <1440762513-30457-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vbi port should pass any tuner/input/standard information on
to the video port since in the input and tuner are shared between
the two.

There is no reason to duplicate this code, just pass the ioctls on
to the video encoder port.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c |  85 ++++++++-----
 drivers/media/pci/saa7164/saa7164-vbi.c     | 190 +++-------------------------
 drivers/media/pci/saa7164/saa7164.h         |  11 ++
 3 files changed, 82 insertions(+), 204 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index ca936e2..1b184c3 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -205,10 +205,8 @@ static int saa7164_encoder_initialize(struct saa7164_port *port)
 }
 
 /* -- V4L2 --------------------------------------------------------- */
-static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
+int saa7164_s_std(struct saa7164_port *port, v4l2_std_id id)
 {
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
 	struct saa7164_dev *dev = port->dev;
 	unsigned int i;
 
@@ -234,17 +232,27 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	return 0;
 }
 
-static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
 
+	return saa7164_s_std(fh->port, id);
+}
+
+int saa7164_g_std(struct saa7164_port *port, v4l2_std_id *id)
+{
 	*id = port->std;
 	return 0;
 }
 
-static int vidioc_enum_input(struct file *file, void *priv,
-	struct v4l2_input *i)
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
+{
+	struct saa7164_encoder_fh *fh = file->private_data;
+
+	return saa7164_g_std(fh->port, id);
+}
+
+int saa7164_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 {
 	static const char * const inputs[] = {
 		"tuner", "composite", "svideo", "aux",
@@ -268,10 +276,8 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+int saa7164_g_input(struct saa7164_port *port, unsigned int *i)
 {
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
 	struct saa7164_dev *dev = port->dev;
 
 	if (saa7164_api_get_videomux(port) != SAA_OK)
@@ -284,10 +290,15 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
-static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
+
+	return saa7164_g_input(fh->port, i);
+}
+
+int saa7164_s_input(struct saa7164_port *port, unsigned int i)
+{
 	struct saa7164_dev *dev = port->dev;
 
 	dprintk(DBGLVL_ENC, "%s() input=%d\n", __func__, i);
@@ -303,8 +314,14 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_g_tuner(struct file *file, void *priv,
-	struct v4l2_tuner *t)
+static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	struct saa7164_encoder_fh *fh = file->private_data;
+
+	return saa7164_s_input(fh->port, i);
+}
+
+int saa7164_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
 {
 	struct saa7164_encoder_fh *fh = file->private_data;
 	struct saa7164_port *port = fh->port;
@@ -323,8 +340,8 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_s_tuner(struct file *file, void *priv,
-	const struct v4l2_tuner *t)
+int saa7164_s_tuner(struct file *file, void *priv,
+			   const struct v4l2_tuner *t)
 {
 	if (0 != t->index)
 		return -EINVAL;
@@ -333,25 +350,26 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int vidioc_g_frequency(struct file *file, void *priv,
-	struct v4l2_frequency *f)
+int saa7164_g_frequency(struct saa7164_port *port, struct v4l2_frequency *f)
 {
-	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-
 	if (f->tuner)
 		return -EINVAL;
 
 	f->frequency = port->freq;
-
 	return 0;
 }
 
-static int vidioc_s_frequency(struct file *file, void *priv,
-	const struct v4l2_frequency *f)
+static int vidioc_g_frequency(struct file *file, void *priv,
+	struct v4l2_frequency *f)
 {
 	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
+
+	return saa7164_g_frequency(fh->port, f);
+}
+
+int saa7164_s_frequency(struct saa7164_port *port,
+			const struct v4l2_frequency *f)
+{
 	struct saa7164_dev *dev = port->dev;
 	struct saa7164_port *tsport;
 	struct dvb_frontend *fe;
@@ -377,8 +395,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	/* Update the hardware */
 	if (port->nr == SAA7164_PORT_ENC1)
 		tsport = &dev->ports[SAA7164_PORT_TS1];
-	else
-	if (port->nr == SAA7164_PORT_ENC2)
+	else if (port->nr == SAA7164_PORT_ENC2)
 		tsport = &dev->ports[SAA7164_PORT_TS2];
 	else
 		BUG();
@@ -395,6 +412,14 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return 0;
 }
 
+static int vidioc_s_frequency(struct file *file, void *priv,
+			      const struct v4l2_frequency *f)
+{
+	struct saa7164_encoder_fh *fh = file->private_data;
+
+	return saa7164_s_frequency(fh->port, f);
+}
+
 static int saa7164_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct saa7164_port *port =
@@ -940,11 +965,11 @@ static const struct v4l2_file_operations mpeg_fops = {
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_g_std		 = vidioc_g_std,
-	.vidioc_enum_input	 = vidioc_enum_input,
+	.vidioc_enum_input	 = saa7164_enum_input,
 	.vidioc_g_input		 = vidioc_g_input,
 	.vidioc_s_input		 = vidioc_s_input,
-	.vidioc_g_tuner		 = vidioc_g_tuner,
-	.vidioc_s_tuner		 = vidioc_s_tuner,
+	.vidioc_g_tuner		 = saa7164_g_tuner,
+	.vidioc_s_tuner		 = saa7164_s_tuner,
 	.vidioc_g_frequency	 = vidioc_g_frequency,
 	.vidioc_s_frequency	 = vidioc_s_frequency,
 	.vidioc_querycap	 = vidioc_querycap,
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 0d8052d..ee54491 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -21,16 +21,6 @@
 
 #include "saa7164.h"
 
-static struct saa7164_tvnorm saa7164_tvnorms[] = {
-	{
-		.name      = "NTSC-M",
-		.id        = V4L2_STD_NTSC_M,
-	}, {
-		.name      = "NTSC-JP",
-		.id        = V4L2_STD_NTSC_M_JP,
-	}
-};
-
 /* Take the encoder configuration from the port struct and
  * flush it to the hardware.
  */
@@ -39,23 +29,13 @@ static void saa7164_vbi_configure(struct saa7164_port *port)
 	struct saa7164_dev *dev = port->dev;
 	dprintk(DBGLVL_VBI, "%s()\n", __func__);
 
-	port->vbi_params.width = port->width;
-	port->vbi_params.height = port->height;
+	port->vbi_params.width = port->enc_port->width;
+	port->vbi_params.height = port->enc_port->height;
 	port->vbi_params.is_50hz =
-		(port->encodernorm.id & V4L2_STD_625_50) != 0;
+		(port->enc_port->encodernorm.id & V4L2_STD_625_50) != 0;
 
 	/* Set up the DIF (enable it) for analog mode by default */
 	saa7164_api_initialize_dif(port);
-
-	/* Configure the correct video standard */
-#if 0
-	saa7164_api_configure_dif(port, port->encodernorm.id);
-#endif
-
-#if 0
-	/* Ensure the audio decoder is correct configured */
-	saa7164_api_set_audio_std(port);
-#endif
 	dprintk(DBGLVL_VBI, "%s() ends\n", __func__);
 }
 
@@ -182,186 +162,48 @@ static int saa7164_vbi_initialize(struct saa7164_port *port)
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-	unsigned int i;
-
-	dprintk(DBGLVL_VBI, "%s(id=0x%x)\n", __func__, (u32)id);
-
-	for (i = 0; i < ARRAY_SIZE(saa7164_tvnorms); i++) {
-		if (id & saa7164_tvnorms[i].id)
-			break;
-	}
-	if (i == ARRAY_SIZE(saa7164_tvnorms))
-		return -EINVAL;
-
-	port->encodernorm = saa7164_tvnorms[i];
-	port->std = id;
-
-	/* Update the audio decoder while is not running in
-	 * auto detect mode.
-	 */
-	saa7164_api_set_audio_std(port);
-
-	dprintk(DBGLVL_VBI, "%s(id=0x%x) OK\n", __func__, (u32)id);
 
-	return 0;
+	return saa7164_s_std(fh->port->enc_port, id);
 }
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct saa7164_encoder_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-
-	*id = port->std;
-	return 0;
-}
-
-static int vidioc_enum_input(struct file *file, void *priv,
-	struct v4l2_input *i)
-{
-	int n;
-
-	char *inputs[] = { "tuner", "composite", "svideo", "aux",
-		"composite 2", "svideo 2", "aux 2" };
-
-	if (i->index >= 7)
-		return -EINVAL;
 
-	strcpy(i->name, inputs[i->index]);
-
-	if (i->index == 0)
-		i->type = V4L2_INPUT_TYPE_TUNER;
-	else
-		i->type  = V4L2_INPUT_TYPE_CAMERA;
-
-	for (n = 0; n < ARRAY_SIZE(saa7164_tvnorms); n++)
-		i->std |= saa7164_tvnorms[n].id;
-
-	return 0;
+	return saa7164_g_std(fh->port->enc_port, id);
 }
 
 static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
 	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	if (saa7164_api_get_videomux(port) != SAA_OK)
-		return -EIO;
-
-	*i = (port->mux_input - 1);
 
-	dprintk(DBGLVL_VBI, "%s() input=%d\n", __func__, *i);
-
-	return 0;
+	return saa7164_g_input(fh->port->enc_port, i);
 }
 
 static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	dprintk(DBGLVL_VBI, "%s() input=%d\n", __func__, i);
-
-	if (i >= 7)
-		return -EINVAL;
-
-	port->mux_input = i + 1;
-
-	if (saa7164_api_set_videomux(port) != SAA_OK)
-		return -EIO;
-
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-	struct v4l2_tuner *t)
-{
-	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-
-	if (0 != t->index)
-		return -EINVAL;
 
-	strcpy(t->name, "tuner");
-	t->type = V4L2_TUNER_ANALOG_TV;
-	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO;
-
-	dprintk(DBGLVL_VBI, "VIDIOC_G_TUNER: tuner type %d\n", t->type);
-
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-	const struct v4l2_tuner *t)
-{
-	/* Update the A/V core */
-	return 0;
+	return saa7164_s_input(fh->port->enc_port, i);
 }
 
 static int vidioc_g_frequency(struct file *file, void *priv,
 	struct v4l2_frequency *f)
 {
 	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-
-	f->type = V4L2_TUNER_ANALOG_TV;
-	f->frequency = port->freq;
 
-	return 0;
+	return saa7164_g_frequency(fh->port->enc_port, f);
 }
 
 static int vidioc_s_frequency(struct file *file, void *priv,
 	const struct v4l2_frequency *f)
 {
 	struct saa7164_vbi_fh *fh = file->private_data;
-	struct saa7164_port *port = fh->port;
-	struct saa7164_dev *dev = port->dev;
-	struct saa7164_port *tsport;
-	struct dvb_frontend *fe;
-
-	/* TODO: Pull this for the std */
-	struct analog_parameters params = {
-		.mode      = V4L2_TUNER_ANALOG_TV,
-		.audmode   = V4L2_TUNER_MODE_STEREO,
-		.std       = port->encodernorm.id,
-		.frequency = f->frequency
-	};
-
-	/* Stop the encoder */
-	dprintk(DBGLVL_VBI, "%s() frequency=%d tuner=%d\n", __func__,
-		f->frequency, f->tuner);
-
-	if (f->tuner != 0)
-		return -EINVAL;
-
-	if (f->type != V4L2_TUNER_ANALOG_TV)
-		return -EINVAL;
-
-	port->freq = f->frequency;
-
-	/* Update the hardware */
-	if (port->nr == SAA7164_PORT_VBI1)
-		tsport = &dev->ports[SAA7164_PORT_TS1];
-	else
-	if (port->nr == SAA7164_PORT_VBI2)
-		tsport = &dev->ports[SAA7164_PORT_TS2];
-	else
-		BUG();
-
-	fe = tsport->dvb.frontend;
+	int ret = saa7164_s_frequency(fh->port->enc_port, f);
 
-	if (fe && fe->ops.tuner_ops.set_analog_params)
-		fe->ops.tuner_ops.set_analog_params(fe, &params);
-	else
-		printk(KERN_ERR "%s() No analog tuner, aborting\n", __func__);
-
-	saa7164_vbi_initialize(port);
-
-	return 0;
+	if (ret == 0)
+		saa7164_vbi_initialize(fh->port);
+	return ret;
 }
 
 static int vidioc_querycap(struct file *file, void  *priv,
@@ -829,11 +671,11 @@ static const struct v4l2_file_operations vbi_fops = {
 static const struct v4l2_ioctl_ops vbi_ioctl_ops = {
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_g_std		 = vidioc_g_std,
-	.vidioc_enum_input	 = vidioc_enum_input,
+	.vidioc_enum_input	 = saa7164_enum_input,
 	.vidioc_g_input		 = vidioc_g_input,
 	.vidioc_s_input		 = vidioc_s_input,
-	.vidioc_g_tuner		 = vidioc_g_tuner,
-	.vidioc_s_tuner		 = vidioc_s_tuner,
+	.vidioc_g_tuner		 = saa7164_g_tuner,
+	.vidioc_s_tuner		 = saa7164_s_tuner,
 	.vidioc_g_frequency	 = vidioc_g_frequency,
 	.vidioc_s_frequency	 = vidioc_s_frequency,
 	.vidioc_querycap	 = vidioc_querycap,
@@ -906,7 +748,7 @@ int saa7164_vbi_register(struct saa7164_port *port)
 		goto failed;
 	}
 
-	port->std = V4L2_STD_NTSC_M;
+	port->enc_port = &dev->ports[port->nr - 2];
 	video_set_drvdata(port->v4l_device, port);
 	result = video_register_device(port->v4l_device,
 		VFL_TYPE_VBI, -1);
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 9e3256c..8337524 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -424,6 +424,7 @@ struct saa7164_port {
 	/* V4L VBI */
 	struct tmComResVBIFormatDescrHeader vbi_fmt_ntsc;
 	struct saa7164_vbi_params vbi_params;
+	struct saa7164_port *enc_port;
 
 	/* Debug */
 	u32 sync_errors;
@@ -599,6 +600,16 @@ extern int saa7164_buffer_zero_offsets(struct saa7164_port *port, int i);
 
 /* ----------------------------------------------------------- */
 /* saa7164-encoder.c                                            */
+int saa7164_s_std(struct saa7164_port *port, v4l2_std_id id);
+int saa7164_g_std(struct saa7164_port *port, v4l2_std_id *id);
+int saa7164_enum_input(struct file *file, void *priv, struct v4l2_input *i);
+int saa7164_g_input(struct saa7164_port *port, unsigned int *i);
+int saa7164_s_input(struct saa7164_port *port, unsigned int i);
+int saa7164_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t);
+int saa7164_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *t);
+int saa7164_g_frequency(struct saa7164_port *port, struct v4l2_frequency *f);
+int saa7164_s_frequency(struct saa7164_port *port,
+			const struct v4l2_frequency *f);
 int saa7164_encoder_register(struct saa7164_port *port);
 void saa7164_encoder_unregister(struct saa7164_port *port);
 
-- 
2.1.4

