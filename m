Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3462 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbaBOME4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 07:04:56 -0500
Message-ID: <52FF57C3.60200@xs4all.nl>
Date: Sat, 15 Feb 2014 13:04:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [REVIEWv2 PATCH 38/34] solo/go7007: drop elem_size: now set by control
 framework
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The control framework will fill in elem_size for the standard types
the framework knows about, so no longer set these explicitly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c         | 1 -
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 4cf78d2..ad41483 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1038,7 +1038,6 @@ static const struct v4l2_ctrl_config go7007_mb_regions_ctrl = {
 	.id = V4L2_CID_DETECT_MD_REGION_GRID,
 	.rows = 576 / 16,
 	.cols = 720 / 16,
-	.elem_size = 1,
 	.max = 3,
 	.step = 1,
 };
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 3b994d7..ccdf0f3 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1237,7 +1237,6 @@ static const struct v4l2_ctrl_config solo_md_thresholds = {
 	.rows = SOLO_MOTION_SZ,
 	.cols = SOLO_MOTION_SZ,
 	.def = SOLO_DEF_MOT_THRESH,
-	.elem_size = 2,
 	.max = 65535,
 	.step = 1,
 };
-- 
1.8.5.2

