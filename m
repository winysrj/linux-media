Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46130 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbKJKUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2015 05:20:13 -0500
Received: from avalon.bb.dnainternet.fi (85-23-193-79.bb.dnainternet.fi [85.23.193.79])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 171FF21C55
	for <linux-media@vger.kernel.org>; Tue, 10 Nov 2015 11:19:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: omap_vout: Don't free buffers if they haven't been allocated
Date: Tue, 10 Nov 2015 12:20:19 +0200
Message-Id: <1447150819-20565-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VRFB buffers are freed when the device is closed even if they
haven't been allocated by a call to VIDIOC_REQBUFS, resulting in a
crash. Fix it by not trying to free buffers that are not allocated.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap/omap_vout_vrfb.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index c6e252760c62..b8638e4e1627 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -79,10 +79,12 @@ void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout)
 	int j;
 
 	for (j = 0; j < VRFB_NUM_BUFS; j++) {
-		omap_vout_free_buffer(vout->smsshado_virt_addr[j],
-				vout->smsshado_size);
-		vout->smsshado_virt_addr[j] = 0;
-		vout->smsshado_phy_addr[j] = 0;
+		if (vout->smsshado_virt_addr[j]) {
+			omap_vout_free_buffer(vout->smsshado_virt_addr[j],
+					      vout->smsshado_size);
+			vout->smsshado_virt_addr[j] = 0;
+			vout->smsshado_phy_addr[j] = 0;
+		}
 	}
 }
 
-- 
Regards,

Laurent Pinchart

