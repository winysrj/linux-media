Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:61405 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751403AbdGNJlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 05:41:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH 14/14] [media] fix warning on v4l2_subdev_call() result interpreted as bool
Date: Fri, 14 Jul 2017 11:36:56 +0200
Message-Id: <20170714093938.1469319-1-arnd@arndb.de>
In-Reply-To: <20170714092540.1217397-1-arnd@arndb.de>
References: <20170714092540.1217397-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_subdev_call is a macro returning whatever the callback return
type is, usually 'int'. With gcc-7 and ccache, this can lead to
many wanings like:

media/platform/pxa_camera.c: In function 'pxa_mbus_build_fmts_xlate':
media/platform/pxa_camera.c:766:27: error: ?: using integer constants in boolean context [-Werror=int-in-bool-context]
  while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
media/atomisp/pci/atomisp2/atomisp_cmd.c: In function 'atomisp_s_ae_window':
media/atomisp/pci/atomisp2/atomisp_cmd.c:6414:52: error: ?: using integer constants in boolean context [-Werror=int-in-bool-context]
  if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,

The best workaround I could come up with is to change all the
callers that use the return code from v4l2_subdev_call() in an
'if' or 'while' condition.

In case of simple 'if' checks, adding a temporary variable is
usually ok, and sometimes this can be used to propagate or
print an error code, so I do that.

For the 'while' loops, I ended up adding an otherwise useless
comparison with zero, which unfortunately makes the code a little
uglied.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/cx18/cx18-ioctl.c                      |  6 ++++--
 drivers/media/pci/saa7146/mxb.c                          |  5 +++--
 drivers/media/platform/atmel/atmel-isc.c                 |  4 ++--
 drivers/media/platform/atmel/atmel-isi.c                 |  4 ++--
 drivers/media/platform/blackfin/bfin_capture.c           |  4 ++--
 drivers/media/platform/omap3isp/ispccdc.c                |  5 +++--
 drivers/media/platform/pxa_camera.c                      |  3 ++-
 drivers/media/platform/rcar-vin/rcar-core.c              |  2 +-
 drivers/media/platform/rcar-vin/rcar-dma.c               |  4 +++-
 drivers/media/platform/soc_camera/soc_camera.c           |  4 ++--
 drivers/media/platform/stm32/stm32-dcmi.c                |  4 ++--
 drivers/media/platform/ti-vpe/cal.c                      |  6 ++++--
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 13 +++++++------
 13 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 80b902b12a78..1803f28fc501 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -188,6 +188,7 @@ static int cx18_g_fmt_sliced_vbi_cap(struct file *file, void *fh,
 {
 	struct cx18 *cx = fh2id(fh)->cx;
 	struct v4l2_sliced_vbi_format *vbifmt = &fmt->fmt.sliced;
+	int ret;
 
 	/* sane, V4L2 spec compliant, defaults */
 	vbifmt->reserved[0] = 0;
@@ -201,8 +202,9 @@ static int cx18_g_fmt_sliced_vbi_cap(struct file *file, void *fh,
 	 * digitizer/slicer.  Note, cx18_av_vbi() wipes the passed in
 	 * fmt->fmt.sliced under valid calling conditions
 	 */
-	if (v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced))
-		return -EINVAL;
+	ret = v4l2_subdev_call(cx->sd_av, vbi, g_sliced_fmt, &fmt->fmt.sliced);
+	if (ret)
+		return ret;
 
 	vbifmt->service_set = cx18_get_service_set(vbifmt);
 	return 0;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 504d78807639..d2d843c38579 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -525,8 +525,9 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 		return err;
 
 	/* switch video in saa7111a */
-	if (saa7111a_call(mxb, video, s_routing, i, SAA7111_FMT_CCIR, 0))
-		pr_err("VIDIOC_S_INPUT: could not address saa7111a\n");
+	err = saa7111a_call(mxb, video, s_routing, i, SAA7111_FMT_CCIR, 0);
+	if (err)
+		pr_err("VIDIOC_S_INPUT: could not address saa7111a: %d\n", err);
 
 	mxb->cur_audinput = video_audio_connect[input];
 	/* switch the audio-source only if necessary */
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d6534252cdcd..704b34a0cc00 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1475,8 +1475,8 @@ static int isc_formats_init(struct isc_device *isc)
 		fmt++;
 	}
 
-	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
-	       NULL, &mbus_code)) {
+	while (v4l2_subdev_call(subdev, pad, enum_mbus_code,
+	       NULL, &mbus_code) == 0) {
 		mbus_code.index++;
 		fmt = find_format_by_code(mbus_code.code, &i);
 		if (!fmt)
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 891fa2505efa..30b7e6f298ed 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1013,8 +1013,8 @@ static int isi_formats_init(struct atmel_isi *isi)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 
-	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
-				 NULL, &mbus_code)) {
+	while (v4l2_subdev_call(subdev, pad, enum_mbus_code,
+				NULL, &mbus_code) == 0) {
 		for (i = 0; i < ARRAY_SIZE(isi_formats); i++) {
 			if (isi_formats[i].mbus_code != mbus_code.code)
 				continue;
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 1c5166df46f5..864c98f21a0e 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -157,8 +157,8 @@ static int bcap_init_sensor_formats(struct bcap_device *bcap_dev)
 	unsigned int num_formats = 0;
 	int i, j;
 
-	while (!v4l2_subdev_call(bcap_dev->sd, pad,
-				enum_mbus_code, NULL, &code)) {
+	while (v4l2_subdev_call(bcap_dev->sd, pad,
+				enum_mbus_code, NULL, &code) == 0) {
 		num_formats++;
 		code.index++;
 	}
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 7207558d722c..a94157461f58 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1132,6 +1132,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	unsigned int sph;
 	u32 syn_mode;
 	u32 ccdc_pattern;
+	int ret;
 
 	ccdc->bt656 = false;
 	ccdc->fields = 0;
@@ -1140,7 +1141,6 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	sensor = media_entity_to_v4l2_subdev(pad->entity);
 	if (ccdc->input == CCDC_INPUT_PARALLEL) {
 		struct v4l2_mbus_config cfg;
-		int ret;
 
 		ret = v4l2_subdev_call(sensor, video, g_mbus_config, &cfg);
 		if (!ret)
@@ -1158,7 +1158,8 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	 */
 	fmt_src.pad = pad->index;
 	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
-	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
+	ret = v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src);
+	if (!ret) {
 		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
 		depth_in = fmt_info->width;
 	}
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 399095170b6e..5236c7b171ea 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -763,7 +763,8 @@ static struct soc_camera_format_xlate *pxa_mbus_build_fmts_xlate(
 	};
 	struct soc_camera_format_xlate *user_formats;
 
-	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
+	while (v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code) ==
+               0) {
 		raw_fmts++;
 		code.index++;
 	}
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 77dff047c41c..a41f4a3d9b69 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -54,7 +54,7 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
 
 	code.index = 0;
 	code.pad = entity->source_pad;
-	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
+	while (v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code) == 0) {
 		code.index++;
 		switch (code.code) {
 		case MEDIA_BUS_FMT_YUYV8_1X16:
diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index b136844499f6..ee16e9886041 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -143,6 +143,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	u32 vnmc, dmr, dmr2, interrupts;
 	v4l2_std_id std;
 	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
+	int ret;
 
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
@@ -155,7 +156,8 @@ static int rvin_setup(struct rvin_dev *vin)
 		/* Default to TB */
 		vnmc = VNMC_IM_FULL;
 		/* Use BT if video standard can be read and is 60 Hz format */
-		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
+		ret = v4l2_subdev_call(vin_to_source(vin), video, g_std, &std);
+		if (ret) {
 			if (std & V4L2_STD_525_60)
 				vnmc = VNMC_IM_FULL | VNMC_FOC;
 		}
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 45a0429d75bb..3ef648fc2db6 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -454,7 +454,7 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 
-	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
+	while (v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code) == 0) {
 		raw_fmts++;
 		code.index++;
 	}
@@ -1202,7 +1202,7 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 		goto evidstart;
 
 	/* Try to improve our guess of a reasonable window format */
-	if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt)) {
+	if (v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt) == 0) {
 		icd->user_width		= mf->width;
 		icd->user_height	= mf->height;
 		icd->colorspace		= mf->colorspace;
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 83d32a5d0f40..96084dfd5d11 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1034,8 +1034,8 @@ static int dcmi_formats_init(struct stm32_dcmi *dcmi)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 
-	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
-				 NULL, &mbus_code)) {
+	while (v4l2_subdev_call(subdev, pad, enum_mbus_code,
+				 NULL, &mbus_code) == 0) {
 		for (i = 0; i < ARRAY_SIZE(dcmi_formats); i++) {
 			if (dcmi_formats[i].mbus_code != mbus_code.code)
 				continue;
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 177faa36bc16..df0216a6367c 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1348,9 +1348,11 @@ static void cal_stop_streaming(struct vb2_queue *vq)
 	struct cal_dmaqueue *dma_q = &ctx->vidq;
 	struct cal_buffer *buf, *tmp;
 	unsigned long flags;
+	int ret;
 
-	if (v4l2_subdev_call(ctx->sensor, video, s_stream, 0))
-		ctx_err(ctx, "stream off failed in subdev\n");
+	ret = v4l2_subdev_call(ctx->sensor, video, s_stream, 0);
+	if (ret)
+		ctx_err(ctx, "stream off failed in subdev: %d\n", ret);
 
 	csi2_ppi_disable(ctx);
 	disable_irqs(ctx);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 97093baf28ac..fe56a037f065 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -6405,19 +6405,20 @@ int atomisp_s_ae_window(struct atomisp_sub_device *asd,
 	struct atomisp_device *isp = asd->isp;
 	/* Coverity CID 298071 - initialzize struct */
 	struct v4l2_subdev_selection sel = { 0 };
+	int ret;
 
 	sel.r.left = arg->x_left;
 	sel.r.top = arg->y_top;
 	sel.r.width = arg->x_right - arg->x_left + 1;
 	sel.r.height = arg->y_bottom - arg->y_top + 1;
 
-	if (v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
-			     pad, set_selection, NULL, &sel)) {
-		dev_err(isp->dev, "failed to call sensor set_selection.\n");
-		return -EINVAL;
-	}
+	ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
+			       pad, set_selection, NULL, &sel);
+	if (ret)
+		dev_err(isp->dev, "failed to call sensor set_selection: %d\n",
+			ret);
 
-	return 0;
+	return ret;
 }
 
 int atomisp_flash_enable(struct atomisp_sub_device *asd, int num_frames)
-- 
2.9.0
