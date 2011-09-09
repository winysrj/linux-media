Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459Ab1IIRRU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 13:17:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 0371918B03B
	for <linux-media@vger.kernel.org>; Fri,  9 Sep 2011 19:17:18 +0200 (CEST)
Date: Fri, 9 Sep 2011 19:17:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: add .g_std() core V4L2 subdevice operation
Message-ID: <Pine.LNX.4.64.1109091916480.915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_G_STD can return the current TV-norm to the user in one of two ways:
if an .vidioc_g_std() ioctl operation is provided by the driver, it is
called, otherwise the value ot the .current_norm field of struct
video_device is returned. Since subdevice drivers currently have no access
to struct video_device objects, the only way to provide this information to
the user is by implementing a .g_std() method.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/v4l2-subdev.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 6e958df..84a61b2 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -158,6 +158,7 @@ struct v4l2_subdev_core_ops {
 	int (*s_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
 	int (*try_ext_ctrls)(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls);
 	int (*querymenu)(struct v4l2_subdev *sd, struct v4l2_querymenu *qm);
+	int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
 	int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
 	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-- 
1.7.2.5

