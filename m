Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41208 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3ABNZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 08:25:11 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so7964917pad.26
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 05:25:11 -0800 (PST)
From: Vikas C Sajjan <vikas.sajjan@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: inki.dae@samsung.com, laurent.pinchart@ideasonboard.com,
	tomi.valkeinen@ti.com, jesse.barker@linaro.org,
	aditya.ps@samsung.com
Subject: [PATCH 2/2] [RFC] video: display: Adding frame related ops to MIPI DSI video source struct
Date: Wed,  2 Jan 2013 18:47:22 +0530
Message-Id: <1357132642-24588-3-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org>
References: <1357132642-24588-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vikas Sajjan <vikas.sajjan@linaro.org>

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 include/video/display.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/video/display.h b/include/video/display.h
index b639fd0..fb2f437 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -117,6 +117,12 @@ struct dsi_video_source_ops {
 
 	void (*enable_hs)(struct video_source *src, bool enable);
 
+	/* frame related */
+	int (*get_frame_done)(struct video_source *src);
+	int (*clear_frame_done)(struct video_source *src);
+	int (*set_early_blank_mode)(struct video_source *src, int power);
+	int (*set_blank_mode)(struct video_source *src, int power);
+
 	/* data transfer */
 	int (*dcs_write)(struct video_source *src, int channel,
 			u8 *data, size_t len);
-- 
1.7.9.5

