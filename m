Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42431
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751962AbdCALwV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Mar 2017 06:52:21 -0500
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
Subject: [PATCH v6 2/2] [media] s5p-mfc: Handle 'v4l2_pix_format:field' in try_fmt and g_fmt
Date: Wed,  1 Mar 2017 08:51:08 -0300
Message-Id: <20170301115108.14187-3-thibault.saunier@osg.samsung.com>
In-Reply-To: <20170301115108.14187-1-thibault.saunier@osg.samsung.com>
References: <20170301115108.14187-1-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is required by the standard that the field order is set by the
driver, default to NONE in case any is provided, but we can basically
accept any value provided by the userspace as we will anyway not
be able to do any deinterlacing.

In this patch we also make sure to pass the interlacing mode provided
by userspace from the output to the capture side of the device so
that the information is given back to userspace. This way it can
handle it and potentially deinterlace afterward.

Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>

---

Changes in v6:
- Pass user output field value to the capture as the device is not
  doing any deinterlacing and thus decoded content will still be
  interlaced on the output.

Changes in v5:
- Just adapt the field and never error out.

Changes in v4: None
Changes in v3:
- Do not check values in the g_fmt functions as Andrzej explained in previous review

Changes in v2:
- Fix a silly build error that slipped in while rebasing the patches

 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index ab23236aa942..3816a37de4bc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -652,6 +652,8 @@ struct s5p_mfc_ctx {
 	size_t me_buffer_size;
 	size_t tmv_buffer_size;
 
+	enum v4l2_field field;
+
 	enum v4l2_mpeg_mfc51_video_force_frame_type force_frame_type;
 
 	struct list_head ref_queue;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 367ef8e8dbf0..6e5ca86fb331 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -345,7 +345,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		   rectangle. */
 		pix_mp->width = ctx->buf_width;
 		pix_mp->height = ctx->buf_height;
-		pix_mp->field = V4L2_FIELD_NONE;
+		pix_mp->field = ctx->field;
 		pix_mp->num_planes = 2;
 		/* Set pixelformat to the format in which MFC
 		   outputs the decoded frame */
@@ -380,6 +380,9 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 
+	if (f->fmt.pix.field == V4L2_FIELD_ANY)
+		f->fmt.pix.field = V4L2_FIELD_NONE;
+
 	mfc_debug(2, "Type is %d\n", f->type);
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		fmt = find_format(f, MFC_FMT_DEC);
@@ -436,6 +439,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto out;
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		/* src_fmt is validated by call to vidioc_try_fmt */
+		ctx->field = f->fmt.pix.field;
 		ctx->src_fmt = find_format(f, MFC_FMT_DEC);
 		ctx->codec_mode = ctx->src_fmt->codec_mode;
 		mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
-- 
2.11.1
