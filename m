Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4764 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaA3OwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 09:52:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 9/9] v4l2-ioctl: check CREATE_BUFS format via TRY_FMT.
Date: Thu, 30 Jan 2014 15:51:31 +0100
Message-Id: <1391093491-23077-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl>
References: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The format passed to VIDIOC_CREATE_BUFS is completely unchecked at
the moment. So pass it to VIDIOC_TRY_FMT first.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 707aef7..7b9d59e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1443,9 +1443,15 @@ static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
 static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_create_buffers *create = arg;
 	int ret = check_fmt(file, create->format.type);
 
+	if (ret)
+		return ret;
+
+	if (!WARN_ON(!is_valid_ioctl(vfd, VIDIOC_TRY_FMT)))
+		ret = v4l_try_fmt(ops, file, fh, &create->format);
 	return ret ? ret : ops->vidioc_create_bufs(file, fh, create);
 }
 
-- 
1.8.5.2

