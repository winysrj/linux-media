Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54556 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726199AbeKZWBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 17:01:18 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: ioctl: Allow drivers to fill in the format description
Date: Mon, 26 Nov 2018 13:07:29 +0200
Message-Id: <20181126110729.8717-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l_fill_fmtdesc() function does a good job in filling in pixelformat
description. While generally all drivers should depend on this function
doing the job, staging drivers that use their own formats may not.

Allow staging drivers to fill in their own formats by checking whether the
description begins with a non-nil character before issuing the warning.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 402b6505502a..7473883ab509 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1345,9 +1345,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_MT21C:	descr = "Mediatek Compressed Format"; break;
 		case V4L2_PIX_FMT_SUNXI_TILED_NV12: descr = "Sunxi Tiled NV12 Format"; break;
 		default:
-			WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
 			if (fmt->description[0])
 				return;
+			WARN(1, "Unknown pixelformat 0x%08x\n", fmt->pixelformat);
 			flags = 0;
 			snprintf(fmt->description, sz, "%c%c%c%c%s",
 					(char)(fmt->pixelformat & 0x7f),
-- 
2.11.0
