Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:49861 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3CJOM4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 10:12:56 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so3020902lab.5
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 07:12:54 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 7/7] hverkuil/go7007: staging: media: go7007: Clean trivial
Date: Sun, 10 Mar 2013 18:04:46 +0400
Message-Id: <1362924286-23995-7-git-send-email-volokh84@gmail.com>
In-Reply-To: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
References: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-priv.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 36b271f..9ec5319 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -232,7 +232,6 @@ struct go7007 {
 		struct v4l2_ctrl *modet_clip_width;
 		struct v4l2_ctrl *modet_clip_height;
 		struct v4l2_ctrl *modet_region_number;
-		//struct v4l2_ctrl *mpeg_video_b_frames;
 	};
 	/* Video streaming */
 	struct mutex queue_lock;
-- 
1.7.7.6

