Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:18075 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3LCNOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 08:14:52 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX8008RMFGRZZD0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 22:14:51 +0900 (KST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>, lxr1234@hotmail.com,
	jtp.park@samsung.com, m.chehab@samsung.com,
	kyungmin.park@samsung.com
Subject: [PATCH] media: v4l2-dev: fix video device index assignment
Date: Tue, 03 Dec 2013 14:14:29 +0100
Message-id: <1386076469-26761-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The side effect of commit 1056e4388b045 ("v4l2-dev: Fix race condition on
__video_register_device") is the increased number of index value assigned
on video_device registration. Before that commit video_devices were
numbered from 0, after it, the indexes starts from 1, because get_index()
always count the device, which is being registered. Some device drivers
rely on video_device index number for internal purposes, i.e. s5p-mfc
driver stopped working after that patch. This patch restores the old method
of numbering the video_device indexes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
In my opinion this patch should be applied also to stable v3.12 series.
---
 drivers/media/v4l2-core/v4l2-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index b5aaaac427ad..0a30dbf3d05c 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -872,8 +872,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 
 	/* Should not happen since we thought this minor was free */
 	WARN_ON(video_device[vdev->minor] != NULL);
-	video_device[vdev->minor] = vdev;
 	vdev->index = get_index(vdev);
+	video_device[vdev->minor] = vdev;
 	mutex_unlock(&videodev_lock);
 
 	if (vdev->ioctl_ops)
-- 
1.7.9.5

