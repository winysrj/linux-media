Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030318AbbD1PoM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:12 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH 10/14] s3c-camif: Check if fmt is NULL before use
Date: Tue, 28 Apr 2015 12:43:49 -0300
Message-Id: <14da8840d09d05132cc6183b85cffecb71f2bde4.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/platform/s3c-camif/camif-capture.c:463 queue_setup() warn: variable dereferenced before check 'fmt' (see line 460)

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index db4d7d23beb9..76e6289a5612 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -449,19 +449,22 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *pfmt,
 	struct camif_vp *vp = vb2_get_drv_priv(vq);
 	struct camif_dev *camif = vp->camif;
 	struct camif_frame *frame = &vp->out_frame;
-	const struct camif_fmt *fmt = vp->out_fmt;
+	const struct camif_fmt *fmt;
 	unsigned int size;
 
 	if (pfmt) {
 		pix = &pfmt->fmt.pix;
 		fmt = s3c_camif_find_format(vp, &pix->pixelformat, -1);
+		if (fmt == NULL)
+			return -EINVAL;
 		size = (pix->width * pix->height * fmt->depth) / 8;
 	} else {
+		fmt = vp->out_fmt;
+		if (fmt == NULL)
+			return -EINVAL;
 		size = (frame->f_width * frame->f_height * fmt->depth) / 8;
 	}
 
-	if (fmt == NULL)
-		return -EINVAL;
 	*num_planes = 1;
 
 	if (pix)
-- 
2.1.0

