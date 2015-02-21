Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:32871 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbbBUSkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:45 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 10/15] media: blackfin: bfin_capture: return -ENODATA for *std calls
Date: Sat, 21 Feb 2015 18:39:56 +0000
Message-Id: <1424544001-19045-11-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch adds supports to return -ENODATA to *_std calls
if the selected output does not support it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 3311d59..e7afba9 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -436,6 +436,11 @@ static irqreturn_t bcap_isr(int irq, void *dev_id)
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
@@ -443,6 +448,11 @@ static int bcap_querystd(struct file *file, void *priv, v4l2_std_id *std)
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
@@ -451,8 +461,13 @@ static int bcap_g_std(struct file *file, void *priv, v4l2_std_id *std)
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

