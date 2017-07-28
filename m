Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:17945 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751693AbdG1KFx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 06:05:53 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1 3/5] [media] stm32-dcmi: cleanup variable/fields namings
Date: Fri, 28 Jul 2017 12:05:00 +0200
Message-ID: <1501236302-18097-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1501236302-18097-1-git-send-email-hugues.fruchet@st.com>
References: <1501236302-18097-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Uniformize "pixfmt" variables to "pix".
Change "current_fmt" & "dcmi_fmt" variables to variables
with "sd_" prefix to explicitly refer to subdev format.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 103 ++++++++++++++++--------------
 1 file changed, 54 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 526e354..4733d1f 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -132,9 +132,9 @@ struct stm32_dcmi {
 	struct dcmi_graph_entity	entity;
 	struct v4l2_format		fmt;
 
-	const struct dcmi_format	**user_formats;
-	unsigned int			num_user_formats;
-	const struct dcmi_format	*current_fmt;
+	const struct dcmi_format	**sd_formats;
+	unsigned int			nb_of_sd_formats;
+	const struct dcmi_format	*sd_format;
 
 	/* Protect this data structure */
 	struct mutex			lock;
@@ -684,12 +684,12 @@ static int dcmi_g_fmt_vid_cap(struct file *file, void *priv,
 static const struct dcmi_format *find_format_by_fourcc(struct stm32_dcmi *dcmi,
 						       unsigned int fourcc)
 {
-	unsigned int num_formats = dcmi->num_user_formats;
+	unsigned int num_formats = dcmi->nb_of_sd_formats;
 	const struct dcmi_format *fmt;
 	unsigned int i;
 
 	for (i = 0; i < num_formats; i++) {
-		fmt = dcmi->user_formats[i];
+		fmt = dcmi->sd_formats[i];
 		if (fmt->fourcc == fourcc)
 			return fmt;
 	}
@@ -698,40 +698,42 @@ static const struct dcmi_format *find_format_by_fourcc(struct stm32_dcmi *dcmi,
 }
 
 static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
-			const struct dcmi_format **current_fmt)
+			const struct dcmi_format **sd_format)
 {
-	const struct dcmi_format *dcmi_fmt;
-	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
+	const struct dcmi_format *sd_fmt;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_TRY,
 	};
 	int ret;
 
-	dcmi_fmt = find_format_by_fourcc(dcmi, pixfmt->pixelformat);
-	if (!dcmi_fmt) {
-		dcmi_fmt = dcmi->user_formats[dcmi->num_user_formats - 1];
-		pixfmt->pixelformat = dcmi_fmt->fourcc;
+	sd_fmt = find_format_by_fourcc(dcmi, pix->pixelformat);
+	if (!sd_fmt) {
+		sd_fmt = dcmi->sd_formats[dcmi->nb_of_sd_formats - 1];
+		pix->pixelformat = sd_fmt->fourcc;
 	}
 
 	/* Limit to hardware capabilities */
-	pixfmt->width = clamp(pixfmt->width, MIN_WIDTH, MAX_WIDTH);
-	pixfmt->height = clamp(pixfmt->height, MIN_HEIGHT, MAX_HEIGHT);
+	pix->width = clamp(pix->width, MIN_WIDTH, MAX_WIDTH);
+	pix->height = clamp(pix->height, MIN_HEIGHT, MAX_HEIGHT);
 
-	v4l2_fill_mbus_format(&format.format, pixfmt, dcmi_fmt->mbus_code);
+	v4l2_fill_mbus_format(&format.format, pix, sd_fmt->mbus_code);
 	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, set_fmt,
 			       &pad_cfg, &format);
 	if (ret < 0)
 		return ret;
 
-	v4l2_fill_pix_format(pixfmt, &format.format);
+	/* Update pix regarding to what sensor can do */
+	v4l2_fill_pix_format(pix, &format.format);
 
-	pixfmt->field = V4L2_FIELD_NONE;
-	pixfmt->bytesperline = pixfmt->width * dcmi_fmt->bpp;
-	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
 
-	if (current_fmt)
-		*current_fmt = dcmi_fmt;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = pix->width * sd_fmt->bpp;
+	pix->sizeimage = pix->bytesperline * pix->height;
+
+	if (sd_format)
+		*sd_format = sd_fmt;
 
 	return 0;
 }
@@ -741,22 +743,25 @@ static int dcmi_set_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f)
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
-	const struct dcmi_format *current_fmt;
+	const struct dcmi_format *sd_format;
+	struct v4l2_mbus_framefmt *mf = &format.format;
+	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	ret = dcmi_try_fmt(dcmi, f, &current_fmt);
+	ret = dcmi_try_fmt(dcmi, f, &sd_format);
 	if (ret)
 		return ret;
 
-	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
-			      current_fmt->mbus_code);
+	/* pix to mbus format */
+	v4l2_fill_mbus_format(mf, pix,
+			      sd_format->mbus_code);
 	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
 			       set_fmt, NULL, &format);
 	if (ret < 0)
 		return ret;
 
 	dcmi->fmt = *f;
-	dcmi->current_fmt = current_fmt;
+	dcmi->sd_format = sd_format;
 
 	return 0;
 }
@@ -785,10 +790,10 @@ static int dcmi_enum_fmt_vid_cap(struct file *file, void  *priv,
 {
 	struct stm32_dcmi *dcmi = video_drvdata(file);
 
-	if (f->index >= dcmi->num_user_formats)
+	if (f->index >= dcmi->nb_of_sd_formats)
 		return -EINVAL;
 
-	f->pixelformat = dcmi->user_formats[f->index]->fourcc;
+	f->pixelformat = dcmi->sd_formats[f->index]->fourcc;
 	return 0;
 }
 
@@ -830,18 +835,18 @@ static int dcmi_enum_framesizes(struct file *file, void *fh,
 				struct v4l2_frmsizeenum *fsize)
 {
 	struct stm32_dcmi *dcmi = video_drvdata(file);
-	const struct dcmi_format *dcmi_fmt;
+	const struct dcmi_format *sd_fmt;
 	struct v4l2_subdev_frame_size_enum fse = {
 		.index = fsize->index,
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	int ret;
 
-	dcmi_fmt = find_format_by_fourcc(dcmi, fsize->pixel_format);
-	if (!dcmi_fmt)
+	sd_fmt = find_format_by_fourcc(dcmi, fsize->pixel_format);
+	if (!sd_fmt)
 		return -EINVAL;
 
-	fse.code = dcmi_fmt->mbus_code;
+	fse.code = sd_fmt->mbus_code;
 
 	ret = v4l2_subdev_call(dcmi->entity.subdev, pad, enum_frame_size,
 			       NULL, &fse);
@@ -859,7 +864,7 @@ static int dcmi_enum_frameintervals(struct file *file, void *fh,
 				    struct v4l2_frmivalenum *fival)
 {
 	struct stm32_dcmi *dcmi = video_drvdata(file);
-	const struct dcmi_format *dcmi_fmt;
+	const struct dcmi_format *sd_fmt;
 	struct v4l2_subdev_frame_interval_enum fie = {
 		.index = fival->index,
 		.width = fival->width,
@@ -868,11 +873,11 @@ static int dcmi_enum_frameintervals(struct file *file, void *fh,
 	};
 	int ret;
 
-	dcmi_fmt = find_format_by_fourcc(dcmi, fival->pixel_format);
-	if (!dcmi_fmt)
+	sd_fmt = find_format_by_fourcc(dcmi, fival->pixel_format);
+	if (!sd_fmt)
 		return -EINVAL;
 
-	fie.code = dcmi_fmt->mbus_code;
+	fie.code = sd_fmt->mbus_code;
 
 	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
 			       enum_frame_interval, NULL, &fie);
@@ -994,7 +999,7 @@ static int dcmi_set_default_fmt(struct stm32_dcmi *dcmi)
 			.width		= CIF_WIDTH,
 			.height		= CIF_HEIGHT,
 			.field		= V4L2_FIELD_NONE,
-			.pixelformat	= dcmi->user_formats[0]->fourcc,
+			.pixelformat	= dcmi->sd_formats[0]->fourcc,
 		},
 	};
 	int ret;
@@ -1002,7 +1007,7 @@ static int dcmi_set_default_fmt(struct stm32_dcmi *dcmi)
 	ret = dcmi_try_fmt(dcmi, &f, NULL);
 	if (ret)
 		return ret;
-	dcmi->current_fmt = dcmi->user_formats[0];
+	dcmi->sd_format = dcmi->sd_formats[0];
 	dcmi->fmt = f;
 	return 0;
 }
@@ -1025,7 +1030,7 @@ static int dcmi_set_default_fmt(struct stm32_dcmi *dcmi)
 
 static int dcmi_formats_init(struct stm32_dcmi *dcmi)
 {
-	const struct dcmi_format *dcmi_fmts[ARRAY_SIZE(dcmi_formats)];
+	const struct dcmi_format *sd_fmts[ARRAY_SIZE(dcmi_formats)];
 	unsigned int num_fmts = 0, i, j;
 	struct v4l2_subdev *subdev = dcmi->entity.subdev;
 	struct v4l2_subdev_mbus_code_enum mbus_code = {
@@ -1040,13 +1045,13 @@ static int dcmi_formats_init(struct stm32_dcmi *dcmi)
 
 			/* Code supported, have we got this fourcc yet? */
 			for (j = 0; j < num_fmts; j++)
-				if (dcmi_fmts[j]->fourcc ==
+				if (sd_fmts[j]->fourcc ==
 						dcmi_formats[i].fourcc)
 					/* Already available */
 					break;
 			if (j == num_fmts)
 				/* New */
-				dcmi_fmts[num_fmts++] = dcmi_formats + i;
+				sd_fmts[num_fmts++] = dcmi_formats + i;
 		}
 		mbus_code.index++;
 	}
@@ -1054,18 +1059,18 @@ static int dcmi_formats_init(struct stm32_dcmi *dcmi)
 	if (!num_fmts)
 		return -ENXIO;
 
-	dcmi->num_user_formats = num_fmts;
-	dcmi->user_formats = devm_kcalloc(dcmi->dev,
-					 num_fmts, sizeof(struct dcmi_format *),
-					 GFP_KERNEL);
-	if (!dcmi->user_formats) {
-		dev_err(dcmi->dev, "could not allocate memory\n");
+	dcmi->nb_of_sd_formats = num_fmts;
+	dcmi->sd_formats = devm_kcalloc(dcmi->dev,
+					num_fmts, sizeof(struct dcmi_format *),
+					GFP_KERNEL);
+	if (!dcmi->sd_formats) {
+		dev_err(dcmi->dev, "Could not allocate memory\n");
 		return -ENOMEM;
 	}
 
-	memcpy(dcmi->user_formats, dcmi_fmts,
+	memcpy(dcmi->sd_formats, sd_fmts,
 	       num_fmts * sizeof(struct dcmi_format *));
-	dcmi->current_fmt = dcmi->user_formats[0];
+	dcmi->sd_format = dcmi->sd_formats[0];
 
 	return 0;
 }
-- 
1.9.1
