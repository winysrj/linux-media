Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23194 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab1LHRwT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 12:52:19 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVW00IPFCB57V@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Dec 2011 17:52:17 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVW00M0BCB5XO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Dec 2011 17:52:17 +0000 (GMT)
Date: Thu, 08 Dec 2011 18:52:13 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-fimc: Fix camera input configuration in subdev operations
To: linux-media@vger.kernel.org
Cc: riverful.kim@samsung.com, sw0312.kim@samsung.com,
	m.szyprowski@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323366733-27643-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When using only subdev user-space operations the camera
interface input was not configured properly. Fix this by
updating the corresponding data structure in set_fmt
operation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 48b2592..bd9c034 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1303,6 +1303,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 
 	mutex_lock(&fimc->lock);
 	set_frame_bounds(ff, mf->width, mf->height);
+	fimc->vid_cap.mf = *mf;
 	ff->fmt = ffmt;
 
 	/* Reset the crop rectangle if required. */
-- 
1.7.8

