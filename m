Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:47176 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab2IRKx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:28 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 02/11] vpif_display: remove unused data structures.
Date: Tue, 18 Sep 2012 12:53:04 +0200
Message-Id: <92bc0d5c269f169770818cb1399439dc1ca72263.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
References: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_display.h |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index 1263de6..ad22c70 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -66,12 +66,6 @@ struct video_obj {
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
@@ -137,7 +131,6 @@ struct channel_obj {
 	struct vpif_params vpifparams;
 	struct common_obj common[VPIF_NUMOBJECTS];
 	struct video_obj video;
-	struct vbi_obj vbi;
 };
 
 /* File handle structure */
@@ -169,12 +162,4 @@ struct vpif_config_params {
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

