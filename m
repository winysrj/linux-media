Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16881 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab2DJNKy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:54 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2900LLSLWHV7@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:09:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900G9KLY1GU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:49 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:44 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 10/13] v4l: s5p-tv: mixer: support for dmabuf exporting
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-11-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-tv with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_video.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index 6b45d93..f08edbf 100644
--- a/drivers/media/video/s5p-tv/mixer_video.c
+++ b/drivers/media/video/s5p-tv/mixer_video.c
@@ -697,6 +697,15 @@ static int mxr_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	return vb2_dqbuf(&layer->vb_queue, p, file->f_flags & O_NONBLOCK);
 }
 
+static int mxr_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+
+	mxr_dbg(layer->mdev, "%s:%d\n", __func__, __LINE__);
+	return vb2_expbuf(&layer->vb_queue, eb);
+}
+
 static int mxr_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct mxr_layer *layer = video_drvdata(file);
@@ -724,6 +733,7 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
 	.vidioc_querybuf = mxr_querybuf,
 	.vidioc_qbuf = mxr_qbuf,
 	.vidioc_dqbuf = mxr_dqbuf,
+	.vidioc_expbuf = mxr_expbuf,
 	/* Streaming control */
 	.vidioc_streamon = mxr_streamon,
 	.vidioc_streamoff = mxr_streamoff,
-- 
1.7.5.4

