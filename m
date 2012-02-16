Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39417 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab2BPRWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 12:22:13 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZH00GTXXKYQL@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZH00JOXXKY1U@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Date: Thu, 16 Feb 2012 18:22:03 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/6] s5p-fimc: Add support for VIDIOC_PREPARE_BUF/CREATE_BUFS
 ioctls
In-reply-to: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329412925-5872-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add VIDIOC_PREPARE_BUF and VIDIOC_CREATE_BUFS ioctl handlers to enable
support for multi-size buffer queue.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index a9e9653..b2fc0b5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1019,6 +1019,22 @@ static int fimc_cap_dqbuf(struct file *file, void *priv,
 	return vb2_dqbuf(&fimc->vid_cap.vbq, buf, file->f_flags & O_NONBLOCK);
 }
 
+static int fimc_cap_create_bufs(struct file *file, void *priv,
+				struct v4l2_create_buffers *create)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	return vb2_create_bufs(&fimc->vid_cap.vbq, create);
+}
+
+static int fimc_cap_prepare_buf(struct file *file, void *priv,
+				struct v4l2_buffer *b)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	return vb2_prepare_buf(&fimc->vid_cap.vbq, b);
+}
+
 static int fimc_cap_cropcap(struct file *file, void *fh,
 			    struct v4l2_cropcap *cr)
 {
@@ -1082,6 +1098,9 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_qbuf			= fimc_cap_qbuf,
 	.vidioc_dqbuf			= fimc_cap_dqbuf,
 
+	.vidioc_prepare_buf		= fimc_cap_prepare_buf,
+	.vidioc_create_bufs		= fimc_cap_create_bufs,
+
 	.vidioc_streamon		= fimc_cap_streamon,
 	.vidioc_streamoff		= fimc_cap_streamoff,
 
-- 
1.7.9

