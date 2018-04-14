Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:64853 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750947AbeDNMCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Apr 2018 08:02:18 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v14 26/33] rcar-vin: change name of video device
Date: Sat, 14 Apr 2018 13:57:19 +0200
Message-Id: <20180414115726.5075-27-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180414115726.5075-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar-vin driver needs to be part of a media controller to support
Gen3. Give each VIN instance a unique name so it can be referenced from
userspace.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 2c28daf1c725e64c..09d584d8e839b868 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -991,7 +991,7 @@ int rvin_v4l2_register(struct rvin_dev *vin)
 	/* video node */
 	vdev->v4l2_dev = &vin->v4l2_dev;
 	vdev->queue = &vin->queue;
-	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
+	snprintf(vdev->name, sizeof(vdev->name), "VIN%u output", vin->id);
 	vdev->release = video_device_release_empty;
 	vdev->lock = &vin->lock;
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-- 
2.16.2
