Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46017 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010AbcDUGu0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 02:50:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ezequiel@vanguardiasur.com.ar,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] tw686x: fix sparse warning
Date: Thu, 21 Apr 2016 08:50:19 +0200
Message-Id: <1461221420-45403-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

tw686x-video.c: In function 'tw686x_video_init':
tw686x-video.c:65:543: warning: array subscript is above array bounds [-Warray-bounds]

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/tw686x/tw686x-video.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 118e9fa..9a31de9 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -60,10 +60,11 @@ static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
 		0, 1, 1, 1, 2,  2,  3,  3,  4,  4,  5,  5,  6,  6, 7, 7,
 		   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
 	};
+	unsigned int max_fps = (std & V4L2_STD_525_60) ? 30 : 25;
+	unsigned int i;
 
-	unsigned int i =
-		(std & V4L2_STD_625_50) ? std_625_50[fps] : std_525_60[fps];
-
+	fps = fps > max_fps ? max_fps : fps;
+	i = (std & V4L2_STD_525_60) ? std_625_50[fps] : std_525_60[fps];
 	return map[i];
 }
 
-- 
2.8.0.rc3

