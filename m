Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61864 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab1G2K5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:04 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 67C3918B04F
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkX-0007og-Ao
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:01 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 35/59] V4L: mt9m001, mt9v022: add a clarifying comment
Date: Fri, 29 Jul 2011 12:56:35 +0200
Message-Id: <1311937019-29914-36-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m001.c |    6 ++++++
 drivers/media/video/mt9v022.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 7618b3c..750ce60 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -734,6 +734,12 @@ static int mt9m001_s_mbus_config(struct v4l2_subdev *sd,
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct soc_camera_device *icd = client->dev.platform_data;
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
+	/*
+	 * Cannot use icd->current_fmt->host_fmt->bits_per_sample, because that
+	 * is the number of bits, that the host has to sample, not the number of
+	 * bits, that we have to send. See mx3_camera.c for an example of 10-bit
+	 * formats being truncated to 8 bits by the host.
+	 */
 	unsigned int bps = soc_mbus_get_fmtdesc(icd->current_fmt->code)->bits_per_sample;
 
 	if (icl->set_bus_param)
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 2fc6ca2..ddc11d0 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -875,6 +875,12 @@ static int mt9v022_s_mbus_config(struct v4l2_subdev *sd,
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct mt9v022 *mt9v022 = to_mt9v022(client);
 	unsigned long flags = soc_camera_apply_board_flags(icl, cfg);
+	/*
+	 * Cannot use icd->current_fmt->host_fmt->bits_per_sample, because that
+	 * is the number of bits, that the host has to sample, not the number of
+	 * bits, that we have to send. See mx3_camera.c for an example of 10-bit
+	 * formats being truncated to 8 bits by the host.
+	 */
 	unsigned int bps = soc_mbus_get_fmtdesc(icd->current_fmt->code)->bits_per_sample;
 	int ret;
 	u16 pixclk = 0;
-- 
1.7.2.5

