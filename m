Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3069 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2EKHzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 13/16] saa7146: fix querycap, vbi/video separation and g/s_register
Date: Fri, 11 May 2012 09:55:07 +0200
Message-Id: <c0ca322310df780003d36102e0e6f91c83b593a1.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The querycap ioctl returned an incorrect version number and incorrect
capabilities (mixing up vbi and video caps).

The reason for that was that video nodes could do vbi activities: that
should be separated between the vbi and video nodes.

There were also a few minor problems with dbg_g/s_register that have
been resolved. The mxb/saa7146 driver now passes the v4l2_compliance tests.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c  |    8 +++++--
 drivers/media/common/saa7146_video.c |   35 +++++++++++++++++++++++----
 drivers/media/dvb/ttpci/av7110_v4l.c |   34 +++++++++++++++++----------
 drivers/media/dvb/ttpci/budget-av.c  |    6 ++---
 drivers/media/video/hexium_gemini.c  |   12 +++++-----
 drivers/media/video/hexium_orion.c   |    6 ++---
 drivers/media/video/mxb.c            |   43 +++++++++++++++++++++++-----------
 include/media/saa7146.h              |    2 --
 include/media/saa7146_vv.h           |    4 +++-
 9 files changed, 103 insertions(+), 47 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index afa922f..9242ec7 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -478,7 +478,8 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 		v4l2_ctrl_handler_free(hdl);
 		return -ENOMEM;
 	}
-	ext_vv->ops = saa7146_video_ioctl_ops;
+	ext_vv->vid_ops = saa7146_video_ioctl_ops;
+	ext_vv->vbi_ops = saa7146_vbi_ioctl_ops;
 	ext_vv->core_ops = &saa7146_video_ioctl_ops;
 
 	DEB_EE("dev:%p\n", dev);
@@ -579,7 +580,10 @@ int saa7146_register_device(struct video_device **vid, struct saa7146_dev* dev,
 		return -ENOMEM;
 
 	vfd->fops = &video_fops;
-	vfd->ioctl_ops = &dev->ext_vv_data->ops;
+	if (type == VFL_TYPE_GRABBER)
+		vfd->ioctl_ops = &dev->ext_vv_data->vid_ops;
+	else
+		vfd->ioctl_ops = &dev->ext_vv_data->vbi_ops;
 	vfd->release = video_device_release;
 	vfd->lock = &dev->v4l2_lock;
 	vfd->v4l2_dev = &dev->v4l2_dev;
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 4ca9a25..9d19320 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -446,18 +446,24 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 
 static int vidioc_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
 	strcpy((char *)cap->driver, "saa7146 v4l2");
 	strlcpy((char *)cap->card, dev->ext->name, sizeof(cap->card));
 	sprintf((char *)cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->version = SAA7146_VERSION_CODE;
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_VIDEO_OVERLAY |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING;
 	cap->device_caps |= dev->ext_vv_data->capabilities;
+	if (vdev->vfl_type == VFL_TYPE_GRABBER)
+		cap->device_caps &=
+			~(V4L2_CAP_VBI_CAPTURE | V4L2_CAP_SLICED_VBI_OUTPUT);
+	else
+		cap->device_caps &=
+			~(V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OVERLAY);
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
@@ -990,10 +996,14 @@ static int vidioc_g_chip_ident(struct file *file, void *__fh,
 
 	chip->ident = V4L2_IDENT_NONE;
 	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST && !chip->match.addr) {
-		chip->ident = V4L2_IDENT_SAA7146;
+	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
+		if (v4l2_chip_match_host(&chip->match))
+			chip->ident = V4L2_IDENT_SAA7146;
 		return 0;
 	}
+	if (chip->match.type != V4L2_CHIP_MATCH_I2C_DRIVER &&
+	    chip->match.type != V4L2_CHIP_MATCH_I2C_ADDR)
+		return -EINVAL;
 	return v4l2_device_call_until_err(&dev->v4l2_dev, 0,
 			core, g_chip_ident, chip);
 }
@@ -1008,7 +1018,6 @@ const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 	.vidioc_g_fmt_vid_overlay    = vidioc_g_fmt_vid_overlay,
 	.vidioc_try_fmt_vid_overlay  = vidioc_try_fmt_vid_overlay,
 	.vidioc_s_fmt_vid_overlay    = vidioc_s_fmt_vid_overlay,
-	.vidioc_g_fmt_vbi_cap        = vidioc_g_fmt_vbi_cap,
 	.vidioc_g_chip_ident         = vidioc_g_chip_ident,
 
 	.vidioc_overlay 	     = vidioc_overlay,
@@ -1027,6 +1036,24 @@ const struct v4l2_ioctl_ops saa7146_video_ioctl_ops = {
 	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
 };
 
+const struct v4l2_ioctl_ops saa7146_vbi_ioctl_ops = {
+	.vidioc_querycap             = vidioc_querycap,
+	.vidioc_g_fmt_vbi_cap        = vidioc_g_fmt_vbi_cap,
+	.vidioc_g_chip_ident         = vidioc_g_chip_ident,
+
+	.vidioc_reqbufs              = vidioc_reqbufs,
+	.vidioc_querybuf             = vidioc_querybuf,
+	.vidioc_qbuf                 = vidioc_qbuf,
+	.vidioc_dqbuf                = vidioc_dqbuf,
+	.vidioc_g_std                = vidioc_g_std,
+	.vidioc_s_std                = vidioc_s_std,
+	.vidioc_streamon             = vidioc_streamon,
+	.vidioc_streamoff            = vidioc_streamoff,
+	.vidioc_g_parm		     = vidioc_g_parm,
+	.vidioc_subscribe_event      = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event    = v4l2_event_unsubscribe,
+};
+
 /*********************************************************************************/
 /* buffer handling functions                                                  */
 
diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index ee8ee1d..3b7a624 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -802,18 +802,28 @@ int av7110_init_v4l(struct av7110 *av7110)
 		ERR("cannot init capture device. skipping\n");
 		return -ENODEV;
 	}
-	vv_data->ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data->ops.vidioc_g_input = vidioc_g_input;
-	vv_data->ops.vidioc_s_input = vidioc_s_input;
-	vv_data->ops.vidioc_g_tuner = vidioc_g_tuner;
-	vv_data->ops.vidioc_s_tuner = vidioc_s_tuner;
-	vv_data->ops.vidioc_g_frequency = vidioc_g_frequency;
-	vv_data->ops.vidioc_s_frequency = vidioc_s_frequency;
-	vv_data->ops.vidioc_g_audio = vidioc_g_audio;
-	vv_data->ops.vidioc_s_audio = vidioc_s_audio;
-	vv_data->ops.vidioc_g_sliced_vbi_cap = vidioc_g_sliced_vbi_cap;
-	vv_data->ops.vidioc_g_fmt_sliced_vbi_out = vidioc_g_fmt_sliced_vbi_out;
-	vv_data->ops.vidioc_s_fmt_sliced_vbi_out = vidioc_s_fmt_sliced_vbi_out;
+	vv_data->vid_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data->vid_ops.vidioc_g_input = vidioc_g_input;
+	vv_data->vid_ops.vidioc_s_input = vidioc_s_input;
+	vv_data->vid_ops.vidioc_g_tuner = vidioc_g_tuner;
+	vv_data->vid_ops.vidioc_s_tuner = vidioc_s_tuner;
+	vv_data->vid_ops.vidioc_g_frequency = vidioc_g_frequency;
+	vv_data->vid_ops.vidioc_s_frequency = vidioc_s_frequency;
+	vv_data->vid_ops.vidioc_g_audio = vidioc_g_audio;
+	vv_data->vid_ops.vidioc_s_audio = vidioc_s_audio;
+
+	vv_data->vbi_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data->vbi_ops.vidioc_g_input = vidioc_g_input;
+	vv_data->vbi_ops.vidioc_s_input = vidioc_s_input;
+	vv_data->vbi_ops.vidioc_g_tuner = vidioc_g_tuner;
+	vv_data->vbi_ops.vidioc_s_tuner = vidioc_s_tuner;
+	vv_data->vbi_ops.vidioc_g_frequency = vidioc_g_frequency;
+	vv_data->vbi_ops.vidioc_s_frequency = vidioc_s_frequency;
+	vv_data->vbi_ops.vidioc_g_audio = vidioc_g_audio;
+	vv_data->vbi_ops.vidioc_s_audio = vidioc_s_audio;
+	vv_data->vbi_ops.vidioc_g_sliced_vbi_cap = vidioc_g_sliced_vbi_cap;
+	vv_data->vbi_ops.vidioc_g_fmt_sliced_vbi_out = vidioc_g_fmt_sliced_vbi_out;
+	vv_data->vbi_ops.vidioc_s_fmt_sliced_vbi_out = vidioc_s_fmt_sliced_vbi_out;
 
 	if (saa7146_register_device(&av7110->v4l_dev, dev, "av7110", VFL_TYPE_GRABBER)) {
 		ERR("cannot register capture device. skipping\n");
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index 8b32e28..12ddb53 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -1483,9 +1483,9 @@ static int budget_av_attach(struct saa7146_dev *dev, struct saa7146_pci_extensio
 			ERR("cannot init vv subsystem\n");
 			return err;
 		}
-		vv_data.ops.vidioc_enum_input = vidioc_enum_input;
-		vv_data.ops.vidioc_g_input = vidioc_g_input;
-		vv_data.ops.vidioc_s_input = vidioc_s_input;
+		vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
+		vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
+		vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
 
 		if ((err = saa7146_register_device(&budget_av->vd, dev, "knc1", VFL_TYPE_GRABBER))) {
 			/* fixme: proper cleanup here */
diff --git a/drivers/media/video/hexium_gemini.c b/drivers/media/video/hexium_gemini.c
index a62322d..2265032 100644
--- a/drivers/media/video/hexium_gemini.c
+++ b/drivers/media/video/hexium_gemini.c
@@ -399,12 +399,12 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	hexium->cur_input = 0;
 
 	saa7146_vv_init(dev, &vv_data);
-	vv_data.ops.vidioc_queryctrl = vidioc_queryctrl;
-	vv_data.ops.vidioc_g_ctrl = vidioc_g_ctrl;
-	vv_data.ops.vidioc_s_ctrl = vidioc_s_ctrl;
-	vv_data.ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data.ops.vidioc_g_input = vidioc_g_input;
-	vv_data.ops.vidioc_s_input = vidioc_s_input;
+	vv_data.vid_ops.vidioc_queryctrl = vidioc_queryctrl;
+	vv_data.vid_ops.vidioc_g_ctrl = vidioc_g_ctrl;
+	vv_data.vid_ops.vidioc_s_ctrl = vidioc_s_ctrl;
+	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
+	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
 	ret = saa7146_register_device(&hexium->video_dev, dev, "hexium gemini", VFL_TYPE_GRABBER);
 	if (ret < 0) {
 		pr_err("cannot register capture v4l2 device. skipping.\n");
diff --git a/drivers/media/video/hexium_orion.c b/drivers/media/video/hexium_orion.c
index 23debc9..e549339 100644
--- a/drivers/media/video/hexium_orion.c
+++ b/drivers/media/video/hexium_orion.c
@@ -371,9 +371,9 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	DEB_EE("\n");
 
 	saa7146_vv_init(dev, &vv_data);
-	vv_data.ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data.ops.vidioc_g_input = vidioc_g_input;
-	vv_data.ops.vidioc_s_input = vidioc_s_input;
+	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
+	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
 	if (0 != saa7146_register_device(&hexium->video_dev, dev, "hexium orion", VFL_TYPE_GRABBER)) {
 		pr_err("cannot register capture v4l2 device. skipping.\n");
 		return -1;
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 0ea221d..b520a45 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -669,13 +669,28 @@ static int vidioc_g_register(struct file *file, void *fh, struct v4l2_dbg_regist
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
-	return call_all(dev, core, g_register, reg);
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (v4l2_chip_match_host(&reg->match)) {
+		reg->val = saa7146_read(dev, reg->reg);
+		reg->size = 4;
+		return 0;
+	}
+	call_all(dev, core, g_register, reg);
+	return 0;
 }
 
 static int vidioc_s_register(struct file *file, void *fh, struct v4l2_dbg_register *reg)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (v4l2_chip_match_host(&reg->match)) {
+		saa7146_write(dev, reg->reg, reg->val);
+		reg->size = 4;
+		return 0;
+	}
 	return call_all(dev, core, s_register, reg);
 }
 #endif
@@ -696,20 +711,20 @@ static int mxb_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_data
 	}
 	mxb = (struct mxb *)dev->ext_priv;
 
-	vv_data.ops.vidioc_enum_input = vidioc_enum_input;
-	vv_data.ops.vidioc_g_input = vidioc_g_input;
-	vv_data.ops.vidioc_s_input = vidioc_s_input;
-	vv_data.ops.vidioc_querystd = vidioc_querystd;
-	vv_data.ops.vidioc_g_tuner = vidioc_g_tuner;
-	vv_data.ops.vidioc_s_tuner = vidioc_s_tuner;
-	vv_data.ops.vidioc_g_frequency = vidioc_g_frequency;
-	vv_data.ops.vidioc_s_frequency = vidioc_s_frequency;
-	vv_data.ops.vidioc_enumaudio = vidioc_enumaudio;
-	vv_data.ops.vidioc_g_audio = vidioc_g_audio;
-	vv_data.ops.vidioc_s_audio = vidioc_s_audio;
+	vv_data.vid_ops.vidioc_enum_input = vidioc_enum_input;
+	vv_data.vid_ops.vidioc_g_input = vidioc_g_input;
+	vv_data.vid_ops.vidioc_s_input = vidioc_s_input;
+	vv_data.vid_ops.vidioc_querystd = vidioc_querystd;
+	vv_data.vid_ops.vidioc_g_tuner = vidioc_g_tuner;
+	vv_data.vid_ops.vidioc_s_tuner = vidioc_s_tuner;
+	vv_data.vid_ops.vidioc_g_frequency = vidioc_g_frequency;
+	vv_data.vid_ops.vidioc_s_frequency = vidioc_s_frequency;
+	vv_data.vid_ops.vidioc_enumaudio = vidioc_enumaudio;
+	vv_data.vid_ops.vidioc_g_audio = vidioc_g_audio;
+	vv_data.vid_ops.vidioc_s_audio = vidioc_s_audio;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	vv_data.ops.vidioc_g_register = vidioc_g_register;
-	vv_data.ops.vidioc_s_register = vidioc_s_register;
+	vv_data.vid_ops.vidioc_g_register = vidioc_g_register;
+	vv_data.vid_ops.vidioc_s_register = vidioc_s_register;
 #endif
 	if (saa7146_register_device(&mxb->video_dev, dev, "mxb", VFL_TYPE_GRABBER)) {
 		ERR("cannot register capture v4l2 device. skipping.\n");
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index c791940..773e527 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -18,8 +18,6 @@
 #include <linux/vmalloc.h>	/* for vmalloc() */
 #include <linux/mm.h>		/* for vmalloc_to_page() */
 
-#define SAA7146_VERSION_CODE 0x000600	/* 0.6.0 */
-
 #define saa7146_write(sxy,adr,dat)    writel((dat),(sxy->mem+(adr)))
 #define saa7146_read(sxy,adr)         readl(sxy->mem+(adr))
 
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index 2bbdf30..944ecdf 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -161,7 +161,8 @@ struct saa7146_ext_vv
 	int (*std_callback)(struct saa7146_dev*, struct saa7146_standard *);
 
 	/* the extension can override this */
-	struct v4l2_ioctl_ops ops;
+	struct v4l2_ioctl_ops vid_ops;
+	struct v4l2_ioctl_ops vbi_ops;
 	/* pointer to the saa7146 core ops */
 	const struct v4l2_ioctl_ops *core_ops;
 
@@ -200,6 +201,7 @@ void saa7146_set_gpio(struct saa7146_dev *saa, u8 pin, u8 data);
 
 /* from saa7146_video.c */
 extern const struct v4l2_ioctl_ops saa7146_video_ioctl_ops;
+extern const struct v4l2_ioctl_ops saa7146_vbi_ioctl_ops;
 extern struct saa7146_use_ops saa7146_video_uops;
 int saa7146_start_preview(struct saa7146_fh *fh);
 int saa7146_stop_preview(struct saa7146_fh *fh);
-- 
1.7.10

