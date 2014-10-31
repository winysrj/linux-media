Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51647 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394AbaJaNyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:54:51 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id B0711217D1
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 14:52:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 01/11] v4l2: get/set prio using video_dev prio structure
Date: Fri, 31 Oct 2014 15:54:47 +0200
Message-Id: <1414763697-21166-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_device structure embed a v4l2_prio_state structure used by
default for priority handling, but drivers can override that default by
setting the video_dev prio pointer to a different v4l2_prio_state
instance.

However, the VIDIO_G_PRIORITY and VIDIOC_S_PRIORITY implementations use
the prio state embedded in v4l2_device unconditionally, breaking drivers
that need to override the default. Fix them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 9ccb19a..1bf84a5 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1040,7 +1040,7 @@ static int v4l_g_priority(const struct v4l2_ioctl_ops *ops,
 	if (ops->vidioc_g_priority)
 		return ops->vidioc_g_priority(file, fh, arg);
 	vfd = video_devdata(file);
-	*p = v4l2_prio_max(&vfd->v4l2_dev->prio);
+	*p = v4l2_prio_max(vfd->prio);
 	return 0;
 }
 
@@ -1055,7 +1055,7 @@ static int v4l_s_priority(const struct v4l2_ioctl_ops *ops,
 		return ops->vidioc_s_priority(file, fh, *p);
 	vfd = video_devdata(file);
 	vfh = file->private_data;
-	return v4l2_prio_change(&vfd->v4l2_dev->prio, &vfh->prio, *p);
+	return v4l2_prio_change(vfd->prio, &vfh->prio, *p);
 }
 
 static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
-- 
2.0.4

