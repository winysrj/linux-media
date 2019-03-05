Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D40C00319
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16D45206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 09:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfCEJ67 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 04:58:59 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56433 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727546AbfCEJ64 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 04:58:56 -0500
Received: from test-no.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 16qVhtdVBLMwI16qchrcuQ; Tue, 05 Mar 2019 10:58:54 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 9/9] vimc: use new release op
Date:   Tue,  5 Mar 2019 10:58:47 +0100
Message-Id: <20190305095847.21428-10-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfKVX3gACdRf/H/ST8JLEPelAcdC+P/a1kXaZDRh709ooSttdKupVjUrGW83aPMrUmJDq1us7oos0lQ0USg7BmP/PiDZBLoNxazat71NQP7BWRX+z/o8V
 jZyU3McWMybCSayz7l7c1P1YuMPFMBBLRo+/g5qWsMRPB39GwgS7LIF19Ox4dRtFTh/+JLlxSL6Q0iSbiObZpnkIk/r8g8PHQx9MCqgWjj/Hd83dLSQOiQDR
 hQiKotbBRK9bn3s28QGwydIu++sp2Yi+Yg0TVR4XDmReYupa1Vl2wyE8Ew+6gdGtL+soiu9KFzXmAWZINr7w3A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Use the new v4l2_subdev_internal_ops release op to free the
subdev memory only once the last user closed the file handle.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vimc/vimc-common.c  |  2 ++
 drivers/media/platform/vimc/vimc-common.h  |  2 ++
 drivers/media/platform/vimc/vimc-debayer.c | 15 +++++++++++++--
 drivers/media/platform/vimc/vimc-scaler.c  | 15 +++++++++++++--
 drivers/media/platform/vimc/vimc-sensor.c  | 19 +++++++++++++++----
 5 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index c1a74bb2df58..0adbfd8fd26d 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -380,6 +380,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 			 u32 function,
 			 u16 num_pads,
 			 const unsigned long *pads_flag,
+			 const struct v4l2_subdev_internal_ops *sd_int_ops,
 			 const struct v4l2_subdev_ops *sd_ops)
 {
 	int ret;
@@ -394,6 +395,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 
 	/* Initialize the subdev */
 	v4l2_subdev_init(sd, sd_ops);
+	sd->internal_ops = sd_int_ops;
 	sd->entity.function = function;
 	sd->entity.ops = &vimc_ent_sd_mops;
 	sd->owner = THIS_MODULE;
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 84539430b5e7..07987eab988f 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -187,6 +187,7 @@ const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);
  * @function:	media entity function defined by MEDIA_ENT_F_* macros
  * @num_pads:	number of pads to initialize
  * @pads_flag:	flags to use in each pad
+ * @sd_int_ops:	pointer to &struct v4l2_subdev_internal_ops.
  * @sd_ops:	pointer to &struct v4l2_subdev_ops.
  *
  * Helper function initialize and register the struct vimc_ent_device and struct
@@ -199,6 +200,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 			 u32 function,
 			 u16 num_pads,
 			 const unsigned long *pads_flag,
+			 const struct v4l2_subdev_internal_ops *sd_int_ops,
 			 const struct v4l2_subdev_ops *sd_ops);
 
 /**
diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index 7d77c63b99d2..eaed4233ad1b 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -489,6 +489,18 @@ static void *vimc_deb_process_frame(struct vimc_ent_device *ved,
 
 }
 
+static void vimc_deb_release(struct v4l2_subdev *sd)
+{
+	struct vimc_deb_device *vdeb =
+				container_of(sd, struct vimc_deb_device, sd);
+
+	kfree(vdeb);
+}
+
+static const struct v4l2_subdev_internal_ops vimc_deb_int_ops = {
+	.release = vimc_deb_release,
+};
+
 static void vimc_deb_comp_unbind(struct device *comp, struct device *master,
 				 void *master_data)
 {
@@ -497,7 +509,6 @@ static void vimc_deb_comp_unbind(struct device *comp, struct device *master,
 						    ved);
 
 	vimc_ent_sd_unregister(ved, &vdeb->sd);
-	kfree(vdeb);
 }
 
 static int vimc_deb_comp_bind(struct device *comp, struct device *master,
@@ -519,7 +530,7 @@ static int vimc_deb_comp_bind(struct device *comp, struct device *master,
 				   MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV, 2,
 				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
 				   MEDIA_PAD_FL_SOURCE},
-				   &vimc_deb_ops);
+				   &vimc_deb_int_ops, &vimc_deb_ops);
 	if (ret) {
 		kfree(vdeb);
 		return ret;
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
index 39b2a73dfcc1..2028afa4ef7a 100644
--- a/drivers/media/platform/vimc/vimc-scaler.c
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -348,6 +348,18 @@ static void *vimc_sca_process_frame(struct vimc_ent_device *ved,
 	return vsca->src_frame;
 };
 
+static void vimc_sca_release(struct v4l2_subdev *sd)
+{
+	struct vimc_sca_device *vsca =
+				container_of(sd, struct vimc_sca_device, sd);
+
+	kfree(vsca);
+}
+
+static const struct v4l2_subdev_internal_ops vimc_sca_int_ops = {
+	.release = vimc_sca_release,
+};
+
 static void vimc_sca_comp_unbind(struct device *comp, struct device *master,
 				 void *master_data)
 {
@@ -356,7 +368,6 @@ static void vimc_sca_comp_unbind(struct device *comp, struct device *master,
 						    ved);
 
 	vimc_ent_sd_unregister(ved, &vsca->sd);
-	kfree(vsca);
 }
 
 
@@ -379,7 +390,7 @@ static int vimc_sca_comp_bind(struct device *comp, struct device *master,
 				   MEDIA_ENT_F_PROC_VIDEO_SCALER, 2,
 				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
 				   MEDIA_PAD_FL_SOURCE},
-				   &vimc_sca_ops);
+				   &vimc_sca_int_ops, &vimc_sca_ops);
 	if (ret) {
 		kfree(vsca);
 		return ret;
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 59195f262623..d7891d3bbeaa 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -301,6 +301,20 @@ static const struct v4l2_ctrl_ops vimc_sen_ctrl_ops = {
 	.s_ctrl = vimc_sen_s_ctrl,
 };
 
+static void vimc_sen_release(struct v4l2_subdev *sd)
+{
+	struct vimc_sen_device *vsen =
+				container_of(sd, struct vimc_sen_device, sd);
+
+	v4l2_ctrl_handler_free(&vsen->hdl);
+	tpg_free(&vsen->tpg);
+	kfree(vsen);
+}
+
+static const struct v4l2_subdev_internal_ops vimc_sen_int_ops = {
+	.release = vimc_sen_release,
+};
+
 static void vimc_sen_comp_unbind(struct device *comp, struct device *master,
 				 void *master_data)
 {
@@ -309,9 +323,6 @@ static void vimc_sen_comp_unbind(struct device *comp, struct device *master,
 				container_of(ved, struct vimc_sen_device, ved);
 
 	vimc_ent_sd_unregister(ved, &vsen->sd);
-	v4l2_ctrl_handler_free(&vsen->hdl);
-	tpg_free(&vsen->tpg);
-	kfree(vsen);
 }
 
 /* Image Processing Controls */
@@ -371,7 +382,7 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
 				   pdata->entity_name,
 				   MEDIA_ENT_F_CAM_SENSOR, 1,
 				   (const unsigned long[1]) {MEDIA_PAD_FL_SOURCE},
-				   &vimc_sen_ops);
+				   &vimc_sen_int_ops, &vimc_sen_ops);
 	if (ret)
 		goto err_free_hdl;
 
-- 
2.20.1

