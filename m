Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39585 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1JIN05 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 09:26:57 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so5137571wyg.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 06:26:56 -0700 (PDT)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH v2 1/3] omap3isp: ccdc: Add interlaced field mode to platform data
Date: Sun,  9 Oct 2011 15:26:41 +0200
Message-Id: <1318166803-7392-2-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1318166803-7392-1-git-send-email-martinez.javier@gmail.com>
References: <1318166803-7392-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fldmode field from the CCDC_SYN_MODE register configure the ISP CCDC
between progresive and interlaced mode.

Adding this field to the platform data, allows boards to configure accordingly.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 include/media/omap3isp.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/media/omap3isp.h b/include/media/omap3isp.h
index 3b2d2b7..0f215de 100644
--- a/include/media/omap3isp.h
+++ b/include/media/omap3isp.h
@@ -61,6 +61,8 @@ enum {
  *		0 - Normal, 1 - One's complement
  * @bt656: ITU-R BT656 embedded synchronization
  *		0 - HS/VS sync, 1 - BT656 sync
+ * @fldmode: Field mode
+ *             0 - progressive, 1 - Interlaced
  */
 struct isp_parallel_platform_data {
 	unsigned int data_lane_shift:2;
@@ -69,6 +71,7 @@ struct isp_parallel_platform_data {
 	unsigned int vs_pol:1;
 	unsigned int data_pol:1;
 	unsigned int bt656:1;
+	unsigned int fldmode:1;
 };
 
 enum {
-- 
1.7.4.1

