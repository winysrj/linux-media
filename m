Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15163 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2EWNHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 09:07:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4H00MXJ8FJYI60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:06:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4H00MGN8GW3Q@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 May 2012 14:07:45 +0100 (BST)
Date: Wed, 23 May 2012 15:07:31 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 08/12] v4l: s5p-tv: mixer: support for dmabuf exporting
In-reply-to: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Message-id: <1337778455-27912-9-git-send-email-t.stanislaws@samsung.com>
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances s5p-tv with support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-tv/mixer_video.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
index cff974a..d8def5b 100644
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
1.7.9.5

