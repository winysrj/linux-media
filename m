Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33621 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965873AbcKLNNy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:54 -0500
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
Subject: [PATCHv2 29/32] media: rcar-vin: attach to CSI2 group when the video device is opened
Date: Sat, 12 Nov 2016 14:12:13 +0100
Message-Id: <20161112131216.22635-30-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Attempt to attach to the subdevices pointed out by the routing from the
CSI2 group when the video device is opened. This is the last piece
missing to enable CSI2 groups on Gen3.

If the current CSI2 routing for the group points ta a set of subdevices
which are not present (not all routings are available on all boards) the
open fall will fail with a -EBUSY error. The VIN instance will be
unavailable with this error until the group routing is changed to one
which provides it with a available set of subdevices.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index d363531..1801c6e 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -846,6 +846,7 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
 static int rvin_open(struct file *file)
 {
 	struct rvin_dev *vin = video_drvdata(file);
+	struct v4l2_subdev *source, *bridge;
 	int ret;
 
 	mutex_lock(&vin->lock);
@@ -857,12 +858,28 @@ static int rvin_open(struct file *file)
 		goto err_out;
 
 	/* If there is no subdevice there is not much we can do */
-	if (!vin_to_source(vin)) {
+	source = vin_to_source(vin);
+	if (!source) {
 		ret = -EBUSY;
 		goto err_open;
 	}
 
 	if (v4l2_fh_is_singular_file(file)) {
+		if (vin_have_bridge(vin)) {
+
+			/* If there are no bridge not much we can do */
+			bridge = vin_to_bridge(vin);
+			if (!bridge) {
+				ret = -EBUSY;
+				goto err_open;
+			}
+
+			v4l2_pipeline_pm_use(&vin->vdev.entity, 1);
+
+			vin_dbg(vin, "Group source: %s bridge: %s\n",
+				source->name,
+				bridge->name);
+		}
 		pm_runtime_get_sync(vin->dev);
 		ret = rvin_attach_subdevices(vin);
 		if (ret) {
@@ -876,6 +893,8 @@ static int rvin_open(struct file *file)
 	return 0;
 err_power:
 	pm_runtime_put(vin->dev);
+	if (vin_have_bridge(vin))
+		v4l2_pipeline_pm_use(&vin->vdev.entity, 0);
 err_open:
 	v4l2_fh_release(file);
 err_out:
@@ -904,6 +923,8 @@ static int rvin_release(struct file *file)
 	if (fh_singular) {
 		rvin_detach_subdevices(vin);
 		pm_runtime_put(vin->dev);
+		if (vin_have_bridge(vin))
+			v4l2_pipeline_pm_use(&vin->vdev.entity, 0);
 	}
 
 	mutex_unlock(&vin->lock);
-- 
2.10.2

