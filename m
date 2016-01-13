Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52764 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbcAMNlJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 08:41:09 -0500
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 23BE3180921
	for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 14:41:04 +0100 (CET)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-dv-timings: skip standards check for
 V4L2_DV_BT_CAP_CUSTOM
Message-ID: <569654C9.9000306@xs4all.nl>
Date: Wed, 13 Jan 2016 14:44:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Skip validating the standards field in v4l2_valid_dv_timings() if the
V4L2_DV_BT_CAP_CUSTOM capability is set, since that implies that
non-standard timings are allowed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index ec258b7..889de0a 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -165,7 +165,8 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	    bt->width > cap->max_width ||
 	    bt->pixelclock < cap->min_pixelclock ||
 	    bt->pixelclock > cap->max_pixelclock ||
-	    (cap->standards && bt->standards &&
+	    (!(caps & V4L2_DV_BT_CAP_CUSTOM) &&
+	     cap->standards && bt->standards &&
 	     !(bt->standards & cap->standards)) ||
 	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
 	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
-- 
2.7.0.rc3

