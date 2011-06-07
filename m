Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:34620 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab1FGOsD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 10:48:03 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p57Em3H8004844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:48:03 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep35.itg.ti.com (8.13.7/8.13.8) with ESMTP id p57Em3Cu013491
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 09:48:03 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: <hvaibhav@ti.com>, <sumit.semwal@ti.com>,
	Amber Jain <amber@ti.com>, Samreen <samreen@ti.com>
Subject: [PATCH 6/6] V4l2: OMAP: VOUT: Minor Cleanup, removing the unnecessary code.
Date: Tue, 7 Jun 2011 20:17:38 +0530
Message-ID: <1307458058-29030-7-git-send-email-amber@ti.com>
In-Reply-To: <1307458058-29030-1-git-send-email-amber@ti.com>
References: <1307458058-29030-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Minor changes to remove the unused code from omap_vout driver.

Signed-off-by: Amber Jain <amber@ti.com>
Signed-off-by: Samreen <samreen@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 25025a1..4aeea06 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1090,10 +1090,7 @@ static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *fh,
 			struct v4l2_fmtdesc *fmt)
 {
 	int index = fmt->index;
-	enum v4l2_buf_type type = fmt->type;
 
-	fmt->index = index;
-	fmt->type = type;
 	if (index >= NUM_OUTPUT_FORMATS)
 		return -EINVAL;
 
@@ -1268,10 +1265,7 @@ static int vidioc_enum_fmt_vid_overlay(struct file *file, void *fh,
 			struct v4l2_fmtdesc *fmt)
 {
 	int index = fmt->index;
-	enum v4l2_buf_type type = fmt->type;
 
-	fmt->index = index;
-	fmt->type = type;
 	if (index >= NUM_OUTPUT_FORMATS)
 		return -EINVAL;
 
-- 
1.7.1

