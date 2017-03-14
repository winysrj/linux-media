Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:47141 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdCNTKJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:10:09 -0400
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
Subject: [PATCH 04/16] rcar-vin: fix standard in input enumeration
Date: Tue, 14 Mar 2017 19:59:45 +0100
Message-Id: <20170314185957.25253-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the subdevice supports dv_timings_cap the driver should not fill in
the standard.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 610f59e2a9142622..7be52c2036bb35fc 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -483,10 +483,14 @@ static int rvin_enum_input(struct file *file, void *priv,
 		return ret;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	i->std = vin->vdev.tvnorms;
 
-	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
+	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap)) {
 		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
+		i->std = 0;
+	} else {
+		i->capabilities = V4L2_IN_CAP_STD;
+		i->std = vin->vdev.tvnorms;
+	}
 
 	strlcpy(i->name, "Camera", sizeof(i->name));
 
-- 
2.12.0
