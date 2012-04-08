Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60418 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab2DHUb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2012 16:31:26 -0400
Date: Sun, 8 Apr 2012 22:31:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] V4L: mt9m032: fix two dead-locks
Message-ID: <Pine.LNX.4.64.1204082230360.808@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a copy-paste typo and a nested locking function call in mt9m032.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9m032.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mt9m032.c b/drivers/media/video/mt9m032.c
index 7636672..645973c 100644
--- a/drivers/media/video/mt9m032.c
+++ b/drivers/media/video/mt9m032.c
@@ -392,10 +392,11 @@ static int mt9m032_set_pad_format(struct v4l2_subdev *subdev,
 	}
 
 	/* Scaling is not supported, the format is thus fixed. */
-	ret = mt9m032_get_pad_format(subdev, fh, fmt);
+	fmt->format = *__mt9m032_get_pad_format(sensor, fh, fmt->which);
+	ret = 0;
 
 done:
-	mutex_lock(&sensor->lock);
+	mutex_unlock(&sensor->lock);
 	return ret;
 }
 
-- 
1.7.2.5

