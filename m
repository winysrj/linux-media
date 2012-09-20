Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2417 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2ITMHY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 02/14] vpif_display: remove unused data structures.
Date: Thu, 20 Sep 2012 14:06:21 +0200
Message-Id: <de85e0fb7ef65ef0b18937c9a0ac04d0a3412090.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/davinci/vpif_display.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 19c7976..8654002 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -65,12 +65,6 @@ struct video_obj {
 	u32 output_id;			/* Current output id */
 };
 
-struct vbi_obj {
-	int num_services;
-	struct vpif_vbi_params vbiparams;	/* vpif parameters for the raw
-						 * vbi data */
-};
-
 struct vpif_disp_buffer {
 	struct vb2_buffer vb;
 	struct list_head list;
@@ -136,7 +130,6 @@ struct channel_obj {
 	struct vpif_params vpifparams;
 	struct common_obj common[VPIF_NUMOBJECTS];
 	struct video_obj video;
-	struct vbi_obj vbi;
 };
 
 /* File handle structure */
@@ -168,12 +161,4 @@ struct config_vpif_params {
 	u8 min_numbuffers;
 };
 
-/* Struct which keeps track of the line numbers for the sliced vbi service */
-struct vpif_service_line {
-	u16 service_id;
-	u16 service_line[2];
-	u16 enc_service_id;
-	u8 bytestowrite;
-};
-
 #endif				/* DAVINCIHD_DISPLAY_H */
-- 
1.7.10.4

