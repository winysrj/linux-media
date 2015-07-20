Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58815 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753031AbbGTNKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:10:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/6] fsl-viu: small fixes.
Date: Mon, 20 Jul 2015 15:09:32 +0200
Message-Id: <1437397773-5752-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
References: <1437397773-5752-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Fix an off-by-one index check in vidioc_enum_fmt()
- Fill in the pix.sizeimage field in vidioc_try_fmt_cap()
- Fix an off-by-one index check in vidioc_s_input()

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 906442e..69ee2b6 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -581,7 +581,7 @@ static int vidioc_enum_fmt(struct file *file, void  *priv,
 {
 	int index = f->index;
 
-	if (f->index > NUM_FORMATS)
+	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
 	strlcpy(f->description, formats[index].name, sizeof(f->description));
@@ -633,6 +633,7 @@ static int vidioc_try_fmt_cap(struct file *file, void *priv,
 	f->fmt.pix.width &= ~0x03;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
@@ -958,7 +959,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct viu_fh *fh = priv;
 
-	if (i > 1)
+	if (i)
 		return -EINVAL;
 
 	decoder_call(fh->dev, video, s_routing, i, 0, 0);
-- 
2.1.4

