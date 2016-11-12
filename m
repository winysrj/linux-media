Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33429 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965548AbcKLNNl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:41 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 06/32] media: rcar-vin: fix standard in input enumeration
Date: Sat, 12 Nov 2016 14:11:50 +0100
Message-Id: <20161112131216.22635-7-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the subdevice supports dv_timings_cap the driver should not fill in
the standard. Also don't use the standard from probe time ask the
subdevice each time, this is done in preparation for Gen3 support where
the source subdevice might change during runtime.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 610f59e..f9218f2 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -483,10 +483,16 @@ static int rvin_enum_input(struct file *file, void *priv,
 		return ret;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	i->std = vin->vdev.tvnorms;
 
-	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
+	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap)) {
 		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+		i->std = 0;
+	} else {
+		i->capabilities = V4L2_IN_CAP_STD;
+		ret = v4l2_subdev_call(sd, video, g_tvnorms, &i->std);
+		if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
+			return ret;
+	}
 
 	strlcpy(i->name, "Camera", sizeof(i->name));
 
-- 
2.10.2

