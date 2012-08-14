Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62932 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab2HNPiR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:38:17 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R0051T4RRDSF0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:38:17 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:38:16 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 24/26] v4l: s5p-fimc: support for dmabuf exporting
Date: Tue, 14 Aug 2012 17:34:54 +0200
Message-id: <1344958496-9373-25-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
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
index 3fcaf7d..bdd2de5 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1129,6 +1129,14 @@ static int fimc_cap_qbuf(struct file *file, void *priv,
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
@@ -1253,6 +1261,7 @@ static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 
 	.vidioc_qbuf			= fimc_cap_qbuf,
 	.vidioc_dqbuf			= fimc_cap_dqbuf,
+	.vidioc_expbuf			= fimc_cap_expbuf,
 
 	.vidioc_prepare_buf		= fimc_cap_prepare_buf,
 	.vidioc_create_bufs		= fimc_cap_create_bufs,
-- 
1.7.9.5

