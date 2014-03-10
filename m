Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1548 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbaCJN6r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 09:58:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, k.debski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 2/7] mem2mem_testdev: pick default format with try_fmt.
Date: Mon, 10 Mar 2014 14:58:24 +0100
Message-Id: <1394459909-36497-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
References: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This resolves an issue raised by v4l2-compliance: if the given format does
not exist, then pick a default format.

While there is an exception regarding this for TV capture drivers, this
m2m driver should do the right thing.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 5c6067d..104d863 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -543,7 +543,11 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
-	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
+	if (!fmt) {
+		f->fmt.pix.pixelformat = formats[0].fourcc;
+		fmt = find_format(f);
+	}
+	if (!(fmt->types & MEM2MEM_CAPTURE)) {
 		v4l2_err(&ctx->dev->v4l2_dev,
 			 "Fourcc format (0x%08x) invalid.\n",
 			 f->fmt.pix.pixelformat);
@@ -561,7 +565,11 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 	struct m2mtest_ctx *ctx = file2ctx(file);
 
 	fmt = find_format(f);
-	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
+	if (!fmt) {
+		f->fmt.pix.pixelformat = formats[0].fourcc;
+		fmt = find_format(f);
+	}
+	if (!(fmt->types & MEM2MEM_OUTPUT)) {
 		v4l2_err(&ctx->dev->v4l2_dev,
 			 "Fourcc format (0x%08x) invalid.\n",
 			 f->fmt.pix.pixelformat);
-- 
1.9.0

