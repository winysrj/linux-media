Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:55996 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752767AbdHVX2m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:42 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 05/25] rcar-vin: change name of video device
Date: Wed, 23 Aug 2017 01:26:20 +0200
Message-Id: <20170822232640.26147-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar-vin driver needs to be part of a media controller to support
Gen3. Give each VIN instance a unique name so it can be referenced from
userspace.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 3c4dd08261a0d3f5..ba88774bd5379a98 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -878,7 +878,8 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
 	vdev->fops = &rvin_fops;
 	vdev->v4l2_dev = &vin->v4l2_dev;
 	vdev->queue = &vin->queue;
-	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
+	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
+		 dev_name(vin->dev));
 	vdev->release = video_device_release_empty;
 	vdev->ioctl_ops = &rvin_ioctl_ops;
 	vdev->lock = &vin->lock;
-- 
2.14.0
