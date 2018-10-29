Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:54783 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbeJ3CWP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 22:22:15 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: set min width/height to a value > 0
Message-ID: <cfff85eb-ac5b-df3f-61e6-ddb79b88bd67@xs4all.nl>
Date: Mon, 29 Oct 2018 18:32:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The capture DV timings capabilities allowed for a minimum width and height of 0.
So passing a timings struct with 0 values is allowed and will later cause a division
by zero.

Ensure that the width and height must be >= 16 to avoid this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: syzbot+57c3d83d71187054d56f@syzkaller.appspotmail.com
---
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 27a0000a5973..e108e9befb77 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -21,7 +21,7 @@ const struct v4l2_dv_timings_cap vivid_dv_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, MAX_WIDTH, 0, MAX_HEIGHT, 14000000, 775000000,
+	V4L2_INIT_BT_TIMINGS(16, MAX_WIDTH, 16, MAX_HEIGHT, 14000000, 775000000,
 		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 		V4L2_DV_BT_STD_CVT | V4L2_DV_BT_STD_GTF,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_INTERLACED)
