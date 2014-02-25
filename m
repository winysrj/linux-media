Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3459 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBYKQ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 08/13] mem2mem_testdev: pick default format with try_fmt.
Date: Tue, 25 Feb 2014 11:15:58 +0100
Message-Id: <1393323363-30058-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This resolves an issue raised by v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 35b2327..886d475 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -540,7 +540,11 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
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
@@ -558,7 +562,11 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
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

