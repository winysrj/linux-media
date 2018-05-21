Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44320 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753255AbeEURBp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:01:45 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 04/16] omap3isp: group device capabilities
Date: Mon, 21 May 2018 13:59:34 -0300
Message-Id: <20180521165946.11778-5-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Instead of putting V4L2_CAP_STREAMING everywhere, set device_caps
earlier with this value.

v2: move cap->capabilities assignment down (Hans Verkuil)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a751c89a3ea8..db9aae222134 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -658,13 +658,15 @@ isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	strlcpy(cap->card, video->video.name, sizeof(cap->card));
 	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
 
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
-		| V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
+	cap->device_caps = V4L2_CAP_STREAMING;
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+		cap->device_caps |= V4L2_CAP_VIDEO_CAPTURE;
 	else
-		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
+		cap->device_caps |= V4L2_CAP_VIDEO_OUTPUT;
+
+	cap->capabilities = cap->device_caps | V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
-- 
2.16.3
