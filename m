Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45325 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbKIVvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 16:51:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Nate Weibley <nweibley@gmail.com>
Subject: [PATCH] omap4iss: Fix overlapping luma/chroma planes
Date: Mon,  9 Nov 2015 23:51:47 +0200
Message-Id: <1447105907-16508-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nate Weibley <nweibley@gmail.com>

The chroma data base address for NV12 formatted data should begin offset
rows*bytes_per_row from the base address for luminance data. We were OBO
causing a stripe of green pixels at the bottom of the frame.

Signed-off-by: Nate Weibley <nweibley@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_resizer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Nate, I've split your original patch
(https://patchwork.linuxtv.org/patch/21816/) in two as the second part still
needs investigation. I'll push this patch to mainline for v4.5.

diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 5030cf3cd34c..b7f9f622385c 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -158,8 +158,8 @@ static void resizer_set_outaddr(struct iss_resizer_device *resizer, u32 addr)
 	/* Program UV buffer address... Hardcoded to be contiguous! */
 	if ((informat->code == MEDIA_BUS_FMT_UYVY8_1X16) &&
 	    (outformat->code == MEDIA_BUS_FMT_YUYV8_1_5X8)) {
-		u32 c_addr = addr + (resizer->video_out.bpl_value *
-				     (outformat->height - 1));
+		u32 c_addr = addr + resizer->video_out.bpl_value
+			   * outformat->height;
 
 		/* Ensure Y_BAD_L[6:0] = C_BAD_L[6:0]*/
 		if ((c_addr ^ addr) & 0x7f) {
-- 
Regards,

Laurent Pinchart

