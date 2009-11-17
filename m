Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38431 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbZKQO22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 09:28:28 -0500
From: "Y, Kishore" <kishore.y@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 17 Nov 2009 20:01:01 +0530
Subject: [RFC] [PATCH] omap_vout: Change allocated buffer to only needed size
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940254299E21@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is dependent on the patch
[PATCH 4/4] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2

>From eb4302232f15e0af075604a9cf24fcaa9688e8a5 Mon Sep 17 00:00:00 2001
From: Kishore Y <kishore.y@ti.com>
Date: Tue, 10 Nov 2009 21:44:10 +0530
Subject: [PATCH] omap_vout: Change allocated buffer to only needed size
 This patch change allocation size of IO buffers to allocate
 only needed size depending on pix.width, pix.height and bytes
 per pixel. The buffer size is rounded to allocate always a PAGE_SIZE multiple

Signed-off-by:  Kishore Y <kishore.y@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index a13f65e..8064c2d 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -855,6 +855,8 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 
 	/* Now allocated the V4L2 buffers */
 	*size = vout->buffer_size;
+	*size = vout->pix.width * vout->pix.height * vout->bpp;
+	*size = PAGE_ALIGN(*size);
 	startindex = (vout->vid == OMAP_VIDEO1) ?
 		video1_numbuffers : video2_numbuffers;
 	for (i = startindex; i < *count; i++) {
-- 
1.5.4.3


Regards,
Kishore Y
Ph:- +918039813085

