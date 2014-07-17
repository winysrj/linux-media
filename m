Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1947 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaGQSne (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 14:43:34 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6HIhVDe084328
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 20:43:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id C03282A1FD1
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 20:43:29 +0200 (CEST)
Message-ID: <53C81951.8070004@xs4all.nl>
Date: Thu, 17 Jul 2014 20:43:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH for v3.17] saa7146: fix compile warning
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fall-out from the recent struct v4l2_framebuffer change.

drivers/media/common/saa7146/saa7146_fops.c: In function ‘saa7146_vv_init’:
drivers/media/common/saa7146/saa7146_fops.c:536:6: warning: assignment from incompatible pointer type [enabled by default]
  fmt = &vv->ov_fb.fmt;
        ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146/saa7146_fops.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index f2cc521..d9e1d63 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -533,13 +533,12 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
 		saa7146_vbi_uops.init(dev,vv);
 
-	fmt = &vv->ov_fb.fmt;
-	fmt->width = vv->standard->h_max_out;
-	fmt->height = vv->standard->v_max_out;
-	fmt->pixelformat = V4L2_PIX_FMT_RGB565;
-	fmt->bytesperline = 2 * fmt->width;
-	fmt->sizeimage = fmt->bytesperline * fmt->height;
-	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	vv->ov_fb.fmt.width = vv->standard->h_max_out;
+	vv->ov_fb.fmt.height = vv->standard->v_max_out;
+	vv->ov_fb.fmt.pixelformat = V4L2_PIX_FMT_RGB565;
+	vv->ov_fb.fmt.bytesperline = 2 * vv->ov_fb.fmt.width;
+	vv->ov_fb.fmt.sizeimage = vv->ov_fb.fmt.bytesperline * vv->ov_fb.fmt.height;
+	vv->ov_fb.fmt.colorspace = V4L2_COLORSPACE_SRGB;
 
 	fmt = &vv->video_fmt;
 	fmt->width = 384;
-- 
2.0.0

