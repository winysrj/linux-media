Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42470 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaCMLpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 07:45:14 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v4 03/14] v4l: ti-vpe: Use video_device_release_empty
Date: Thu, 13 Mar 2014 17:14:05 +0530
Message-ID: <1394711056-10878-4-git-send-email-archit@ti.com>
In-Reply-To: <1394711056-10878-1-git-send-email-archit@ti.com>
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video_device struct is currently embedded in the driver data struct vpe_dev.
A vpe_dev instance is allocated by the driver, and the memory for the vfd is a
part of this struct.

The v4l2 core, however, manages the removal of the vfd region, through the
video_device's .release() op, which currently is the helper
video_device_release. This causes memory corruption, and leads to issues when
we try to re-insert the vpe module.

Use the video_device_release_empty helper function instead.

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index f1eae67..0363df6 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2000,7 +2000,7 @@ static struct video_device vpe_videodev = {
 	.fops		= &vpe_fops,
 	.ioctl_ops	= &vpe_ioctl_ops,
 	.minor		= -1,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 	.vfl_dir	= VFL_DIR_M2M,
 };
 
-- 
1.8.3.2

