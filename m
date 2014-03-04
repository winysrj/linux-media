Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:52830 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756507AbaCDIuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Mar 2014 03:50:20 -0500
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<hverkuil@xs4all.nl>, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 3/7] v4l: ti-vpe: Use video_device_release_empty
Date: Tue, 4 Mar 2014 14:19:21 +0530
Message-ID: <1393922965-15967-4-git-send-email-archit@ti.com>
In-Reply-To: <1393922965-15967-1-git-send-email-archit@ti.com>
References: <1393832008-22174-1-git-send-email-archit@ti.com>
 <1393922965-15967-1-git-send-email-archit@ti.com>
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

Use the video_device_release_empty helper function instead

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4243687..bb275f4 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1998,7 +1998,7 @@ static struct video_device vpe_videodev = {
 	.fops		= &vpe_fops,
 	.ioctl_ops	= &vpe_ioctl_ops,
 	.minor		= -1,
-	.release	= video_device_release,
+	.release	= video_device_release_empty,
 	.vfl_dir	= VFL_DIR_M2M,
 };
 
-- 
1.8.3.2

