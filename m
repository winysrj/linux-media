Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34950 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752836AbdBGPnI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 10:43:08 -0500
From: Avraham Shukron <avraham.shukron@gmail.com>
To: laurent.pinchart@ideasonboard.com, mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] staging: omap4iss: fix coding style issue
Date: Tue,  7 Feb 2017 17:40:58 +0200
Message-Id: <272f05631d8685953f0d6b21aced57a01aab9286.1486413695.git.avraham.shukron@gmail.com>
In-Reply-To: <1e46dc3f0630eae3b531ae3a03bc65bebf5bbfc0.1486413695.git.avraham.shukron@gmail.com>
References: <1e46dc3f0630eae3b531ae3a03bc65bebf5bbfc0.1486413695.git.avraham.shukron@gmail.com>
In-Reply-To: <1e46dc3f0630eae3b531ae3a03bc65bebf5bbfc0.1486413695.git.avraham.shukron@gmail.com>
References: <1e46dc3f0630eae3b531ae3a03bc65bebf5bbfc0.1486413695.git.avraham.shukron@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Avraham Shukron <avraham.shukron@gmail.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index e21811a..0bac582 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -301,7 +301,8 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
 
 static int iss_video_queue_setup(struct vb2_queue *vq,
 				 unsigned int *count, unsigned int *num_planes,
-				 unsigned int sizes[], struct device *alloc_devs[])
+				 unsigned int sizes[],
+				 struct device *alloc_devs[])
 {
 	struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
 	struct iss_video *video = vfh->video;
-- 
2.7.4

