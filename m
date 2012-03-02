Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46838 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2CBKn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 05:43:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 07/10] mt9m032: Put HFLIP and VFLIP controls in a cluster
Date: Fri,  2 Mar 2012 11:44:04 +0100
Message-Id: <1330685047-12742-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1330685047-12742-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1330685047-12742-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HFLIP and VFLIP are often set together to rotate the image by 180°.
Putting the controls in a cluster makes sure they will always be applied
together, getting rid of a race condition that could result in one bad
frame.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9m032.c |   43 +++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index cfed53a..6bd4280 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -107,7 +107,12 @@ struct mt9m032 {
 	struct v4l2_subdev subdev;
 	struct media_pad pad;
 	struct mt9m032_platform_data *pdata;
+
 	struct v4l2_ctrl_handler ctrls;
+	struct {
+		struct v4l2_ctrl *hflip;
+		struct v4l2_ctrl *vflip;
+	};
 
 	bool streaming;
 
@@ -116,8 +121,6 @@ struct mt9m032 {
 	struct v4l2_mbus_framefmt format;	/* height and width always the same as in crop */
 	struct v4l2_rect crop;
 	struct v4l2_fract frame_interval;
-
-	struct v4l2_ctrl *hflip, *vflip;
 };
 
 #define to_mt9m032(sd)	container_of(sd, struct mt9m032, subdev)
@@ -503,23 +506,13 @@ static int update_read_mode2(struct mt9m032 *sensor, bool vflip, bool hflip)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
 	int reg_val = (!!vflip) << MT9M032_READ_MODE2_VFLIP_SHIFT
-		      | (!!hflip) << MT9M032_READ_MODE2_HFLIP_SHIFT
-		      | MT9M032_READ_MODE2_ROW_BLC
-		      | 0x0007;
+		    | (!!hflip) << MT9M032_READ_MODE2_HFLIP_SHIFT
+		    | MT9M032_READ_MODE2_ROW_BLC
+		    | 0x0007;
 
 	return mt9m032_write_reg(client, MT9M032_READ_MODE2, reg_val);
 }
 
-static int mt9m032_set_hflip(struct mt9m032 *sensor, s32 val)
-{
-	return update_read_mode2(sensor, sensor->vflip->cur.val, val);
-}
-
-static int mt9m032_set_vflip(struct mt9m032 *sensor, s32 val)
-{
-	return update_read_mode2(sensor, val, sensor->hflip->cur.val);
-}
-
 static int mt9m032_set_exposure(struct mt9m032 *sensor, s32 val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->subdev);
@@ -581,17 +574,17 @@ static int mt9m032_try_ctrl(struct v4l2_ctrl *ctrl)
 
 static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct mt9m032 *sensor = container_of(ctrl->handler, struct mt9m032, ctrls);
+	struct mt9m032 *sensor =
+		container_of(ctrl->handler, struct mt9m032, ctrls);
 
 	switch (ctrl->id) {
 	case V4L2_CID_GAIN:
 		return mt9m032_set_gain(sensor, ctrl->val);
 
 	case V4L2_CID_HFLIP:
-		return mt9m032_set_hflip(sensor, ctrl->val);
-
 	case V4L2_CID_VFLIP:
-		return mt9m032_set_vflip(sensor, ctrl->val);
+		return update_read_mode2(sensor, sensor->vflip->val,
+					 sensor->hflip->val);
 
 	case V4L2_CID_EXPOSURE:
 		return mt9m032_set_exposure(sensor, ctrl->val);
@@ -700,10 +693,14 @@ static int mt9m032_probe(struct i2c_client *client,
 	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
 			  V4L2_CID_GAIN, 0, 127, 1, 64);
 
-	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
-			  V4L2_CID_HFLIP, 0, 1, 1, 0);
-	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
-			  V4L2_CID_VFLIP, 0, 1, 1, 0);
+	sensor->hflip = v4l2_ctrl_new_std(&sensor->ctrls,
+					  &mt9m032_ctrl_ops,
+					  V4L2_CID_HFLIP, 0, 1, 1, 0);
+	sensor->vflip = v4l2_ctrl_new_std(&sensor->ctrls,
+					  &mt9m032_ctrl_ops,
+					  V4L2_CID_VFLIP, 0, 1, 1, 0);
+	v4l2_ctrl_cluster(2, &sensor->hflip);
+
 	v4l2_ctrl_new_std(&sensor->ctrls, &mt9m032_ctrl_ops,
 			  V4L2_CID_EXPOSURE, 0, 8000, 1, 1700);    /* 1.7ms */
 
-- 
1.7.3.4

