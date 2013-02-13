Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:47251 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab3BMKB1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Feb 2013 05:01:27 -0500
Received: by mail-da0-f41.google.com with SMTP id e20so490425dak.0
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2013 02:01:26 -0800 (PST)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	inki.dae@samsung.com, l.krishna@samsung.com, joshi@samsung.com,
	aditya.ps@samsung.com, tom.gall@linaro.org, patches@linaro.org,
	linux-samsung-soc@vger.kernel.org, ragesh.r@linaro.org,
	jesse.barker@linaro.org, robdclark@gmail.com,
	sumit.semwal@linaro.org
Subject: [RFC v2 1/3] video: display: Adding frame related ops to MIPI DSI video source struct
Date: Wed, 13 Feb 2013 15:31:05 +0530
Message-Id: <1360749667-12028-2-git-send-email-vikas.sajjan@linaro.org>
In-Reply-To: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
References: <1360749667-12028-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the frame related ops to MIPI DSI video source struct

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

