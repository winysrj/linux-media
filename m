Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47686 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754777AbdKKAjE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Nov 2017 19:39:04 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v7 05/25] rcar-vin: change name of video device
Date: Sat, 11 Nov 2017 01:38:15 +0100
Message-Id: <20171111003835.4909-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
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
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 76c0b8fa8602d08d..f501da9df48c288b 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -878,7 +878,8 @@ int rvin_v4l2_register(struct rvin_dev *vin)
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
2.15.0
