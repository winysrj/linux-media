Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46742 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765675AbdEXARA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:17:00 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 04/17] rcar-vin: fix standard in input enumeration
Date: Wed, 24 May 2017 02:15:27 +0200
Message-Id: <20170524001540.13613-5-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

The driver supports a single input only, which can be either analog or
digital. If the subdevice supports dv_timings_cap the input is digital
and the driver should not fill in the standard.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
2.13.0
