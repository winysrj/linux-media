Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4460 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaGNM7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/12] v4l2-dev: streamon/off is only a valid ioctl for video, vbi and sdr
Date: Mon, 14 Jul 2014 14:59:10 +0200
Message-Id: <1405342752-46998-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
References: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The VIDIOC_STREAMON/OFF ioctls are not valid for radio devices, just
like the other streaming I/O ioctls. Add the streamon/off ioctls
to the other streaming I/O ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 72bea04..661d57a 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -567,8 +567,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		set_bit(_IOC_NR(VIDIOC_G_PRIORITY), valid_ioctls);
 	if (ops->vidioc_s_priority)
 		set_bit(_IOC_NR(VIDIOC_S_PRIORITY), valid_ioctls);
-	SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
-	SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
 	/* Note: the control handler can also be passed through the filehandle,
 	   and that can't be tested here. If the bit for these control ioctls
 	   is set, then the ioctl is valid. But if it is 0, then it can still
@@ -682,6 +680,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
 		SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
 		SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
+		SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
+		SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
 	}
 
 	if (is_vid || is_vbi) {
-- 
2.0.1

