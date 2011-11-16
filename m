Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55311 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1KPUGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 15:06:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 4/4] omap3isp: Clarify the clk_pol field in platform data
Date: Wed, 16 Nov 2011 21:06:46 +0100
Message-Id: <1321474006-24589-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field is used to select the polarity of the pixel clock signal.
"Inverted" and "non inverted" are bad descriptions, specify instead on
which clock edge the signals are sampled.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/omap3isp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index e917b1d..042849a 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -58,7 +58,7 @@ enum {
  *		ISP_LANE_SHIFT_4 - CAMEXT[13:4] -> CAM[9:0]
  *		ISP_LANE_SHIFT_6 - CAMEXT[13:6] -> CAM[7:0]
  * @clk_pol: Pixel clock polarity
- *		0 - Non Inverted, 1 - Inverted
+ *		0 - Sample on rising edge, 1 - Sample on falling edge
  * @hs_pol: Horizontal synchronization polarity
  *		0 - Active high, 1 - Active low
  * @vs_pol: Vertical synchronization polarity
-- 
1.7.3.4

