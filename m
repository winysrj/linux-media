Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2J0UmH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:07 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKg7gB004770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:07 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 55/68] [media] v4l2-common: h_bp var is unused at v4l2_detect_gtf()
Date: Sat, 27 Oct 2012 18:41:13 -0200
Message-Id: <1351370486-29040-56-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index f995dd3..380ddd8 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -837,7 +837,7 @@ bool v4l2_detect_gtf(unsigned frame_height,
 		struct v4l2_dv_timings *fmt)
 {
 	int pix_clk;
-	int  v_fp, v_bp, h_fp, h_bp, hsync;
+	int  v_fp, v_bp, h_fp, hsync;
 	int frame_width, image_height, image_width;
 	bool default_gtf;
 	int h_blank;
@@ -885,7 +885,6 @@ bool v4l2_detect_gtf(unsigned frame_height,
 	hsync = hsync - hsync % GTF_CELL_GRAN;
 
 	h_fp = h_blank / 2 - hsync;
-	h_bp = h_blank / 2;
 
 	fmt->bt.polarities = polarities;
 	fmt->bt.width = image_width;
-- 
1.7.11.7

