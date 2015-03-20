Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:33800 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbbCTGyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 02:54:43 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH 1/2] vivid: add CVT,GTF standards to vivid dv timings caps
Date: Fri, 20 Mar 2015 12:11:45 +0530
Message-Id: <1426833706-7839-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1426833706-7839-1-git-send-email-prladdha@cisco.com>
References: <1426833706-7839-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently vivid supports V4L2_DV_BT_STD_DMT and V4L2_DV_BT_STD_CEA861
discrete video standards. Extending the capability set to allow for
setting CVT and GTF standards. This change, along with adding the
support for calculating CVT, GTF timings in v4l2-ctl would extend
the number of resolutions supported by vivid to almost any custom
resolution.

Also extending the limits on min and max pixel clock to accomodate
pixel clock range provided by cvt/gtf for resolutions ranging from
640x360p50 to 4kx2Kp60.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 6bef1e6..cba095f 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -33,8 +33,9 @@ const struct v4l2_dv_timings_cap vivid_dv_timings_cap = {
 	.type = V4L2_DV_BT_656_1120,
 	/* keep this initialization for compatibility with GCC < 4.4.6 */
 	.reserved = { 0 },
-	V4L2_INIT_BT_TIMINGS(0, MAX_WIDTH, 0, MAX_HEIGHT, 25000000, 600000000,
-		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT,
+	V4L2_INIT_BT_TIMINGS(0, MAX_WIDTH, 0, MAX_HEIGHT, 14000000, 775000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+		V4L2_DV_BT_STD_CVT | V4L2_DV_BT_STD_GTF,
 		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_INTERLACED)
 };
 
-- 
1.9.1

