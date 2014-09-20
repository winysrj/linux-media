Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2127 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaITKgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 06:36:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: matrandg@cisco.com, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/2] v4l2-dv-timings: only check standards if non-zero
Date: Sat, 20 Sep 2014 12:36:38 +0200
Message-Id: <1411209399-24478-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411209399-24478-1-git-send-email-hverkuil@xs4all.nl>
References: <1411209399-24478-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If one or both of the timings being compared have the standards field
with value 0, then accept that. Only check for matching standards if
both timings have actually filled in that field.

Otherwise no match will ever be found since when timings are detected
the standards field will typically be set to 0 by the driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index ce1c9f5..b1d8dbb 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -164,7 +164,8 @@ bool v4l2_valid_dv_timings(const struct v4l2_dv_timings *t,
 	    bt->width > cap->max_width ||
 	    bt->pixelclock < cap->min_pixelclock ||
 	    bt->pixelclock > cap->max_pixelclock ||
-	    (cap->standards && !(bt->standards & cap->standards)) ||
+	    (cap->standards && bt->standards &&
+	     !(bt->standards & cap->standards)) ||
 	    (bt->interlaced && !(caps & V4L2_DV_BT_CAP_INTERLACED)) ||
 	    (!bt->interlaced && !(caps & V4L2_DV_BT_CAP_PROGRESSIVE)))
 		return false;
-- 
2.1.0

