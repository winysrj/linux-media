Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672Ab1IIRnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 13:43:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 5438518B03B
	for <linux-media@vger.kernel.org>; Fri,  9 Sep 2011 19:43:31 +0200 (CEST)
Date: Fri, 9 Sep 2011 19:43:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] V4L: mt9m001, mt9v022: use internally cached pixel code
In-Reply-To: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109091921310.915@axis700.grange>
References: <Pine.LNX.4.64.1109091917260.915@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the internally cached pixel code, instead of the one, provided by
the soc-camera, removes one more use of struct soc_camera_device in these
drivers. Also remove the no longer needed soc_camera_from_i2c() inline
function.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c |   10 ++--------
 drivers/media/video/mt9v022.c |   14 ++------------
 include/media/soc_camera.h    |    5 -----
 3 files changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 58cdced..63ae5c6 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -601,15 +601,9 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 				const struct v4l2_mbus_config *cfg)
 {
 	const struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = soc_camera_from_i2c(client);
 	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
-	/*
-	 * Cannot use icd->current_fmt->host_fmt->bits_per_sample, because that
-	 * is the number of bits, that the host has to sample, not the number of
-	 * bits, that we have to send. See mx3_camera.c for an example of 10-bit
-	 * formats being truncated to 8 bits by the host.
-	 */
-	unsigned int bps = soc_mbus_get_fmtdesc(icd->current_fmt->code)->bits_per_sample;
+	struct mt9m001 *mt9m001 = to_mt9m001(client);
+	unsigned int bps = soc_mbus_get_fmtdesc(mt9m001->fmt->code)->bits_per_sample;
 
 	if (icl->set_bus_param)
 		return icl->set_bus_param(icl, 1 << (bps - 1));
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 72b179b..b6a29f7 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -700,23 +700,13 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 				 const struct v4l2_mbus_config *cfg)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct soc_camera_device *icd = client->dev.platform_data;
-	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
-	/*
-	 * Cannot use icd->current_fmt->host_fmt->bits_per_sample, because that
-	 * is the number of bits, that the host has to sample, not the number of
-	 * bits, that we have to send. See mx3_camera.c for an example of 10-bit
-	 * formats being truncated to 8 bits by the host.
-	 */
-	unsigned int bps = soc_mbus_get_fmtdesc(icd->current_fmt->code)->bits_per_sample;
+	unsigned int bps = soc_mbus_get_fmtdesc(mt9v022->fmt->code)->bits_per_sample;
 	int ret;
 	u16 pixclk = 0;
 
-	dev_dbg(icd->pdev, "set %d: %s, %dbps\n", icd->current_fmt->code,
-		icd->current_fmt->host_fmt->name, bps);
-
 	if (icl->set_bus_param) {
 		ret = icl->set_bus_param(icl, 1 << (bps - 1));
 		if (ret)
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 67a52c7..dac5759 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -269,11 +269,6 @@ static inline struct v4l2_subdev *soc_camera_vdev_to_subdev(const struct video_d
 	return soc_camera_to_subdev(icd);
 }
 
-static inline struct soc_camera_device *soc_camera_from_i2c(const struct i2c_client *client)
-{
-	return client->dev.platform_data;
-}
-
 static inline struct soc_camera_device *soc_camera_from_vb2q(const struct vb2_queue *vq)
 {
 	return container_of(vq, struct soc_camera_device, vb2_vidq);
-- 
1.7.2.5

