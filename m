Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:7377 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965345AbbFJQcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 12:32:55 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
	Fabian Frederick <fabf@skynet.be>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/1 linux-next] v4l2-dv-timings: use swap() in v4l2_calc_aspect_ratio()
Date: Wed, 10 Jun 2015 18:32:33 +0200
Message-Id: <1433953953-24164-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kernel.h macro definition.

Thanks to Julia Lawall for Coccinelle scripting support.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index 5792192..41a07d6 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -615,7 +615,6 @@ EXPORT_SYMBOL_GPL(v4l2_detect_gtf);
 struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
 {
 	struct v4l2_fract aspect = { 16, 9 };
-	u32 tmp;
 	u8 ratio;
 
 	/* Nothing filled in, fallback to 16:9 */
@@ -647,9 +646,7 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait)
 	if (hor_landscape)
 		return aspect;
 	/* The aspect ratio is for portrait, so swap numerator and denominator */
-	tmp = aspect.denominator;
-	aspect.denominator = aspect.numerator;
-	aspect.numerator = tmp;
+	swap(aspect.denominator, aspect.numerator);
 	return aspect;
 }
 EXPORT_SYMBOL_GPL(v4l2_calc_aspect_ratio);
-- 
2.4.2

