Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5821DC4360F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25BF22085A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446678;
	bh=JSs0b8/8hSd3ywa4oCHVrbTo9uYdOh4HFqVJez/dp8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FY8FfiT2XXkFuTSUJ/CxFMAA7VZOtJu8pZYQvgZSV6FkJoqoriv3Lup9jnRn0y+Wl
	 P6UUbG4Qq3gz2qoZWZmYa+HsUMuIBo/LAtZjbD0w/gp/Ivf2ozNsduP2q/8MLO7z3F
	 Vw/uQKQti1WQ/RkbTbs507mSn5H5eM8zbV4k3vik=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbfCANYa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:30 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50528 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732895AbfCANYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UYfddN859fhkWKFQi0QZbxnqnhkIt0SRRwZ5Q1g+icQ=; b=dYqlg8W9yTIlO8yHtgHqltxsdN
        9bYbNhDxgpaBN1d+azRvP7mEO2f6PQ6DzeDIwm8ARynBxFGwyTdYhQIkbTuwOJ8RZ/aNeiM2FTlqx
        m6dvOijLlX3Gb96/pGVab1WcXLgq1/cVxwVICYO+CtE1qKt8nCYlxMx9x96JwiJ68eXyS3M0hzzbC
        9vyZybDA2DAvhGc3JPjk7guJKjt0mLeCfwkGrDkbI4qK+gRjYEBrF/NKkbJ8Q0ee/eKwU/H5Vtkqa
        i7SApA5gNCAxYbYIJiPK8CSOLAe2vrHyX1VwSKqvMJXP6j0DrU8frVW0HpJEL64D9ZZpwDiNQtlhi
        zdO5zPNQ==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi9N-0003y0-So; Fri, 01 Mar 2019 13:24:29 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi9L-0002NN-RO; Fri, 01 Mar 2019 10:24:27 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 05/10] media: vim2m: use different framesizes for bayer formats
Date:   Fri,  1 Mar 2019 10:24:21 -0300
Message-Id: <52c07fa56e91243f05022ebae6a65da26e44e1f3.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551446121.git.mchehab+samsung@kernel.org>
References: <cover.1551446121.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The only real restriction at vim2m is that width should be
multiple of two, as the copy routine always copy two pixels
each time.

However, Bayer formats are defined as having a 2x2 matrix.
So, odd vertical numbers would cause color distortions at the
last line. So, it makes sense to use step 2 for vertical alignment
on Bayer.

With this patch, the reported formats for video capture will
be:

	[0]: 'RGBP' (16-bit RGB 5-6-5)
		Size: Stepwise 32x32 - 640x480 with step 2/1
	[1]: 'RGBR' (16-bit RGB 5-6-5 BE)
		Size: Stepwise 32x32 - 640x480 with step 2/1
	[2]: 'RGB3' (24-bit RGB 8-8-8)
		Size: Stepwise 32x32 - 640x480 with step 2/1
	[3]: 'BGR3' (24-bit BGR 8-8-8)
		Size: Stepwise 32x32 - 640x480 with step 2/1
	[4]: 'YUYV' (YUYV 4:2:2)
		Size: Stepwise 32x32 - 640x480 with step 2/1
	[5]: 'BA81' (8-bit Bayer BGBG/GRGR)
		Size: Stepwise 32x32 - 640x480 with step 2/2
	[6]: 'GBRG' (8-bit Bayer GBGB/RGRG)
		Size: Stepwise 32x32 - 640x480 with step 2/2
	[7]: 'GRBG' (8-bit Bayer GRGR/BGBG)
		Size: Stepwise 32x32 - 640x480 with step 2/2
	[8]: 'RGGB' (8-bit Bayer RGRG/GBGB)
		Size: Stepwise 32x32 - 640x480 with step 2/2

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 38 ++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index bac9d4733d65..5157a59aeb58 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -50,7 +50,14 @@ MODULE_PARM_DESC(default_transtime, "default transaction time in ms");
 #define MIN_H 32
 #define MAX_W 640
 #define MAX_H 480
-#define WIDTH_ALIGN 2 /* 2-byte alignment */
+
+/* Pixel alignment for non-bayer formats */
+#define WIDTH_ALIGN 2
+#define HEIGHT_ALIGN 1
+
+/* Pixel alignment for bayer formats */
+#define BAYER_WIDTH_ALIGN  2
+#define BAYER_HEIGHT_ALIGN 2
 
 /* Flags that indicate a format can be used for capture/output */
 #define MEM2MEM_CAPTURE	(1 << 0)
@@ -162,6 +169,24 @@ static struct vim2m_fmt *find_format(u32 fourcc)
 	return &formats[k];
 }
 
+void static get_alignment(u32 fourcc,
+			  unsigned int *walign, unsigned int *halign)
+{
+	switch(fourcc) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+		*walign = BAYER_WIDTH_ALIGN;
+		*halign = BAYER_HEIGHT_ALIGN;
+		return;
+	default:
+		*walign = WIDTH_ALIGN;
+		*halign = HEIGHT_ALIGN;
+		return;
+	}
+}
+
 struct vim2m_dev {
 	struct v4l2_device	v4l2_dev;
 	struct video_device	vfd;
@@ -689,8 +714,10 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 	fsize->stepwise.min_height =MIN_H;
 	fsize->stepwise.max_width = MAX_W;
 	fsize->stepwise.max_height = MAX_H;
-	fsize->stepwise.step_width = WIDTH_ALIGN;
-	fsize->stepwise.step_height = 1;
+
+	get_alignment(fsize->pixel_format,
+		      &fsize->stepwise.step_width,
+		      &fsize->stepwise.step_height);
 	return 0;
 }
 
@@ -733,6 +760,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 
 static int vidioc_try_fmt(struct v4l2_format *f, struct vim2m_fmt *fmt)
 {
+	int walign, halign;
 	/* V4L2 specification suggests the driver corrects the format struct
 	 * if any of the dimensions is unsupported */
 	if (f->fmt.pix.height < MIN_H)
@@ -745,7 +773,9 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct vim2m_fmt *fmt)
 	else if (f->fmt.pix.width > MAX_W)
 		f->fmt.pix.width = MAX_W;
 
-	f->fmt.pix.width &= ~(WIDTH_ALIGN - 1);
+	get_alignment(f->fmt.pix.pixelformat, &walign, &halign);
+	f->fmt.pix.width &= ~(walign - 1);
+	f->fmt.pix.height &= ~(halign - 1);
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
-- 
2.20.1

