Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:46092 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaAWJvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 04:51:10 -0500
From: Martin Bugge <marbugge@cisco.com>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] v4l2-dv-timings: fix GTF calculation
Date: Thu, 23 Jan 2014 10:40:00 +0100
Message-Id: <1390470000-9072-1-git-send-email-marbugge@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Round off image width to nearest 8 (GTF_CELL_GRAN)

A source sending a GTF (Generalized Timing Formula) format have no means of
signalling image width. The assumed aspect ratio may result in an odd image
width but according to the standard image width should be in multiple of 8.

Cc: Mats Randgaard <matrandg@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Martin Bugge <marbugge@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dv-timings.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
index ee52b9f4..f7902fe 100644
--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -515,6 +515,7 @@ bool v4l2_detect_gtf(unsigned frame_height,
 		aspect.denominator = 9;
 	}
 	image_width = ((image_height * aspect.numerator) / aspect.denominator);
+	image_width = (image_width + GTF_CELL_GRAN/2) & ~(GTF_CELL_GRAN - 1);
 
 	/* Horizontal */
 	if (default_gtf)
-- 
1.8.1.4

