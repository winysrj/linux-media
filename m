Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33392 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbcAMLhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 06:37:25 -0500
Date: Wed, 13 Jan 2016 17:07:08 +0530
From: Saatvik Arya <aryasaatvik@gmail.com>
To: gregkh@linuxfoundation.org
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: staging: media: davinci_vpfe: dm365_resizer: fixed
 some spelling mistakes
Message-ID: <20160113113708.GA31610@sinister>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fixed spelling mistakes which referred to OUTPUT as OUPUT

Signed-off-by: Saatvik Arya <aryasaatvik@gmail.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 22 +++++++++++-----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index acb293e..10f51f4 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -495,7 +495,7 @@ resizer_configure_in_continious_mode(struct vpfe_resizer_device *resizer)
 	int line_len;
 	int ret;
 
-	if (resizer->resizer_a.output != RESIZER_OUPUT_MEMORY) {
+	if (resizer->resizer_a.output != RESIZER_OUTPUT_MEMORY) {
 		dev_err(dev, "enable resizer - Resizer-A\n");
 		return -EINVAL;
 	}
@@ -507,7 +507,7 @@ resizer_configure_in_continious_mode(struct vpfe_resizer_device *resizer)
 	param->rsz_en[RSZ_B] = DISABLE;
 	param->oper_mode = RESIZER_MODE_CONTINIOUS;
 
-	if (resizer->resizer_b.output == RESIZER_OUPUT_MEMORY) {
+	if (resizer->resizer_b.output == RESIZER_OUTPUT_MEMORY) {
 		struct v4l2_mbus_framefmt *outformat2;
 
 		param->rsz_en[RSZ_B] = ENABLE;
@@ -1048,13 +1048,13 @@ static void resizer_ss_isr(struct vpfe_resizer_device *resizer)
 	if (ipipeif_sink != IPIPEIF_INPUT_MEMORY)
 		return;
 
-	if (resizer->resizer_a.output == RESIZER_OUPUT_MEMORY) {
+	if (resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY) {
 		val = vpss_dma_complete_interrupt();
 		if (val != 0 && val != 2)
 			return;
 	}
 
-	if (resizer->resizer_a.output == RESIZER_OUPUT_MEMORY) {
+	if (resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY) {
 		spin_lock(&video_out->dma_queue_lock);
 		vpfe_video_process_buffer_complete(video_out);
 		video_out->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
@@ -1064,7 +1064,7 @@ static void resizer_ss_isr(struct vpfe_resizer_device *resizer)
 
 	/* If resizer B is enabled */
 	if (pipe->output_num > 1 && resizer->resizer_b.output ==
-	    RESIZER_OUPUT_MEMORY) {
+	    RESIZER_OUTPUT_MEMORY) {
 		spin_lock(&video_out->dma_queue_lock);
 		vpfe_video_process_buffer_complete(video_out2);
 		video_out2->state = VPFE_VIDEO_BUFFER_NOT_QUEUED;
@@ -1074,7 +1074,7 @@ static void resizer_ss_isr(struct vpfe_resizer_device *resizer)
 
 	/* start HW if buffers are queued */
 	if (vpfe_video_is_pipe_ready(pipe) &&
-	    resizer->resizer_a.output == RESIZER_OUPUT_MEMORY) {
+	    resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY) {
 		resizer_enable(resizer, 1);
 		vpfe_ipipe_enable(vpfe_dev, 1);
 		vpfe_ipipeif_enable(vpfe_dev);
@@ -1242,8 +1242,8 @@ static int resizer_do_hw_setup(struct vpfe_resizer_device *resizer)
 	struct resizer_params *param = &resizer->config;
 	int ret = 0;
 
-	if (resizer->resizer_a.output == RESIZER_OUPUT_MEMORY ||
-	    resizer->resizer_b.output == RESIZER_OUPUT_MEMORY) {
+	if (resizer->resizer_a.output == RESIZER_OUTPUT_MEMORY ||
+	    resizer->resizer_b.output == RESIZER_OUTPUT_MEMORY) {
 		if (ipipeif_sink == IPIPEIF_INPUT_MEMORY &&
 		    ipipeif_source == IPIPEIF_OUTPUT_RESIZER)
 			ret = resizer_configure_in_single_shot_mode(resizer);
@@ -1268,7 +1268,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 	if (&resizer->crop_resizer.subdev != sd)
 		return 0;
 
-	if (resizer->resizer_a.output != RESIZER_OUPUT_MEMORY)
+	if (resizer->resizer_a.output != RESIZER_OUTPUT_MEMORY)
 		return 0;
 
 	switch (enable) {
@@ -1722,7 +1722,7 @@ static int resizer_link_setup(struct media_entity *entity,
 			}
 			if (resizer->resizer_a.output != RESIZER_OUTPUT_NONE)
 				return -EBUSY;
-			resizer->resizer_a.output = RESIZER_OUPUT_MEMORY;
+			resizer->resizer_a.output = RESIZER_OUTPUT_MEMORY;
 			break;
 
 		default:
@@ -1747,7 +1747,7 @@ static int resizer_link_setup(struct media_entity *entity,
 			}
 			if (resizer->resizer_b.output != RESIZER_OUTPUT_NONE)
 				return -EBUSY;
-			resizer->resizer_b.output = RESIZER_OUPUT_MEMORY;
+			resizer->resizer_b.output = RESIZER_OUTPUT_MEMORY;
 			break;
 
 		default:
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.h b/drivers/staging/media/davinci_vpfe/dm365_resizer.h
index 93b0f44..00e64b0 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.h
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.h
@@ -210,7 +210,7 @@ enum resizer_input_entity {
 
 enum resizer_output_entity {
 	RESIZER_OUTPUT_NONE = 0,
-	RESIZER_OUPUT_MEMORY = 1,
+	RESIZER_OUTPUT_MEMORY = 1,
 };
 
 struct dm365_resizer_device {
-- 
2.5.0

