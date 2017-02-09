Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36421 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdBIRFn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 12:05:43 -0500
In-Reply-To: <39b0f075-6b94-45bf-76cd-e3050b501da2@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
From: Avraham Shukron <avraham.shukron@gmail.com>
Subject: [PATCH v4 2/2] staging: omap4iss: fix coding style issue
Message-ID: <20eb3a95-36ac-a2c6-b45c-547f61b281df@gmail.com>
Date: Thu, 9 Feb 2017 19:01:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Broke argument list so that it won't exceed 80 characters

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
