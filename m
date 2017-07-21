Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47237 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751611AbdGUK5K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 06:57:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/5] media-device: set driver_version directly
Date: Fri, 21 Jul 2017 12:57:02 +0200
Message-Id: <20170721105706.40703-2-hverkuil@xs4all.nl>
In-Reply-To: <20170721105706.40703-1-hverkuil@xs4all.nl>
References: <20170721105706.40703-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Don't use driver_version from struct media_device, just return
LINUX_VERSION_CODE as the other media subsystems do.

The driver_version field in struct media_device will be removed
in the following patches.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index fce91b543c14..7ff8e2d5bb07 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -71,7 +71,7 @@ static int media_device_get_info(struct media_device *dev,
 
 	info->media_version = MEDIA_API_VERSION;
 	info->hw_revision = dev->hw_revision;
-	info->driver_version = dev->driver_version;
+	info->driver_version = LINUX_VERSION_CODE;
 
 	return 0;
 }
-- 
2.13.2
