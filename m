Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15163 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2EWNHr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H00MXJ8FJYI60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:06:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H0015L8GWJF@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:45 +0100 (BST)
Date: Wed, 23 May 2012 15:07:30 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 07/12] v4l: s5p-fimc: support for dmabuf exporting
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-8-git-send-email-t.stanislaws@samsung.com>
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-fimc with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index cd27e33..52c9b36 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1101,6 +1101,14 @@ static int fimc_cap_qbuf(struct file *file, void *priv,
 	return vb2_qbuf(&fimc->vid_cap.vbq, buf);
 }
 
+static int fimc_cap_expbuf(struct file *file, void *priv,
+			  struct v4l2_exportbuffer *eb)
+{
+	struct fimc_dev *fimc = video_drvdata(file);
+
+	return vb2_expbuf(&fimc->vid_cap.vbq, eb);
+}
+
 static int fimc_cap_dqbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
@@ -1225,6 +1233,7 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 
 	.vidioc_qbuf			= fimc_cap_qbuf,
 	.vidioc_dqbuf			= fimc_cap_dqbuf,
+	.vidioc_expbuf			= fimc_cap_expbuf,
 
 	.vidioc_prepare_buf		= fimc_cap_prepare_buf,
 	.vidioc_create_bufs		= fimc_cap_create_bufs,
-- 
1.7.9.5

