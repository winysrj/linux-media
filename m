Return-path: <mchehab@localhost>
Received: from devils.ext.ti.com ([198.47.26.153]:52290 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1GGMVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 08:21:33 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p67CLWF0029975
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:32 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep33.itg.ti.com (8.13.7/8.13.8) with ESMTP id p67CLW7E006868
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:32 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p67CLW8r007650
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2011 07:21:32 -0500 (CDT)
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: hvaibhav@ti.com, Amber Jain <amber@ti.com>,
	Samreen <samreen@ti.com>
Subject: [PATCH v2 3/3] V4l2: OMAP: VOUT: Minor Cleanup, removing the unnecessary code.
Date: Thu, 7 Jul 2011 17:51:18 +0530
Message-ID: <1310041278-8810-4-git-send-email-amber@ti.com>
In-Reply-To: <1310041278-8810-1-git-send-email-amber@ti.com>
References: <1310041278-8810-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Minor changes to remove the unused code from omap_vout driver.

Signed-off-by: Amber Jain <amber@ti.com>
Signed-off-by: Samreen <samreen@ti.com>
---
Changes from v1:
- None.

 drivers/media/video/omap/omap_vout.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 7d3410a..548f4cd 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1041,10 +1041,7 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
 			struct v4l2_fmtdesc *fmt)
 {
 	int index = fmt->index;
-	enum v4l2_buf_type type = fmt->type;
 
-	fmt->index = index;
-	fmt->type = type;
 	if (index >= NUM_OUTPUT_FORMATS)
 		return -EINVAL;
 
@@ -1213,10 +1210,7 @@ static int vidioc_enum_fmt_vid_overlay(struct file *file, void *fh,
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

