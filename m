Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19427 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758722Ab2DJNKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 09:10:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M290051MLYALQ70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:58 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900F19LY35Q@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 14:10:52 +0100 (BST)
Date: Tue, 10 Apr 2012 15:10:47 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 13/13] v4l: vivi: support for dmabuf exporting
In-reply-to: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334063447-16824-14-git-send-email-t.stanislaws@samsung.com>
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch enhances vivi driver with a support for DMABUF exporting via
VIDIOC_EXPBUF ioctl.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/vivi.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 489d685..e34aa70 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -947,6 +947,14 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 	return vb2_dqbuf(&dev->vb_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
+static int vidioc_expbuf(struct file *file, void *priv,
+	struct v4l2_exportbuffer *eb)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	return vb2_expbuf(&dev->vb_vidq, eb);
+}
+
+
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct vivi_dev *dev = video_drvdata(file);
@@ -1185,6 +1193,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_querybuf      = vidioc_querybuf,
 	.vidioc_qbuf          = vidioc_qbuf,
 	.vidioc_dqbuf         = vidioc_dqbuf,
+	.vidioc_expbuf        = vidioc_expbuf,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
-- 
1.7.5.4

