Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41134 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbCHOlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:14 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 10/17] media: blackfin: bfin_capture: return -ENODATA for *std calls
Date: Sun,  8 Mar 2015 14:40:46 +0000
Message-Id: <1425825653-14768-11-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds supports to return -ENODATA to *_std calls
if the selected output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
Tested-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index f2b1a23..f97d94d 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -440,6 +440,11 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
 static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_STD))
+		return -ENODATA;
 
 	return v4l2_subdev_call(bcap_dev->sd, video, querystd, std);
 }
@@ -447,6 +452,11 @@ static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
 static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
+
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_STD))
+		return -ENODATA;
 
 	*std = bcap_dev->std;
 	return 0;
@@ -455,8 +465,13 @@ static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
 static int bcap_s_std(struct file *file, void *priv, v4l2_std_id std)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
+	struct v4l2_input input;
 	int ret;
 
+	input = bcap_dev->cfg->inputs[bcap_dev->cur_input];
+	if (!(input.capabilities & V4L2_IN_CAP_STD))
+		return -ENODATA;
+
 	if (vb2_is_busy(&bcap_dev->buffer_queue))
 		return -EBUSY;
 
-- 
2.1.0

