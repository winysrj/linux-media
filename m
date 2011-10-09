Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49678 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1JIN1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 09:27:00 -0400
Received: by wwf22 with SMTP id 22so7969974wwf.1
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 06:26:59 -0700 (PDT)
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: [PATCH v2 2/3]  omap3isp: ccdc: Add interlaced count field to isp_ccdc_device
Date: Sun,  9 Oct 2011 15:26:42 +0200
Message-Id: <1318166803-7392-3-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1318166803-7392-1-git-send-email-martinez.javier@gmail.com>
References: <1318166803-7392-1-git-send-email-martinez.javier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When configured in interlaced field mode, the ISP CCDC has to know which
sub-frame of the current frame is processing.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/media/video/omap3isp/ispccdc.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispccdc.h b/drivers/media/video/omap3isp/ispccdc.h
index 54811ce..8863eea 100644
--- a/drivers/media/video/omap3isp/ispccdc.h
+++ b/drivers/media/video/omap3isp/ispccdc.h
@@ -134,6 +134,7 @@ struct ispccdc_lsc {
  * @wait: Wait queue used to stop the module
  * @stopping: Stopping state
  * @ioctl_lock: Serializes ioctl calls and LSC requests freeing
+ * @interlaced_cnt: Sub-frame count for an interlaced video frame
  */
 struct isp_ccdc_device {
 	struct v4l2_subdev subdev;
@@ -164,6 +165,7 @@ struct isp_ccdc_device {
 	wait_queue_head_t wait;
 	unsigned int stopping;
 	struct mutex ioctl_lock;
+	unsigned int interlaced_cnt;
 };
 
 struct isp_device;
-- 
1.7.4.1

