Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:8274 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963Ab2IRKx3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:29 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 01/11] vpif_capture: remove unused data structure.
Date: Tue, 18 Sep 2012 12:53:03 +0200
Message-Id: <bd383d11cd06a8f66571cf1dccb42fd89760ecdb.1347965140.git.hans.verkuil@cisco.com>
In-Reply-To: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
References: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/davinci/vpif_capture.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index aa6d3da..de19c80 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -160,10 +160,6 @@ struct vpif_config_params {
 	u32 video_limit[VPIF_CAPTURE_NUM_CHANNELS];
 	u8 max_device_type;
 };
-/* Struct which keeps track of the line numbers for the sliced vbi service */
-struct vpif_service_line {
-	u16 service_id;
-	u16 service_line[2];
-};
+
 #endif				/* End of __KERNEL__ */
 #endif				/* VPIF_CAPTURE_H */
-- 
1.7.10.4

