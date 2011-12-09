Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19065 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab1LIPkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2011 10:40:06 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVY005300UQ6N70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Dec 2011 15:40:02 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVY00H3L0UQ5R@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 09 Dec 2011 15:40:02 +0000 (GMT)
Date: Fri, 09 Dec 2011 16:39:52 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-g2d: remove two unused variables from the G2D driver
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1323445192-16166-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-g2d/g2d-hw.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d-hw.c b/drivers/media/video/s5p-g2d/g2d-hw.c
index e5249f3..39937cf 100644
--- a/drivers/media/video/s5p-g2d/g2d-hw.c
+++ b/drivers/media/video/s5p-g2d/g2d-hw.c
@@ -27,7 +27,6 @@ void g2d_reset(struct g2d_dev *d)
 void g2d_set_src_size(struct g2d_dev *d, struct g2d_frame *f)
 {
 	u32 n;
-	u32 stride;
 
 	w(f->stride & 0xFFFF, SRC_STRIDE_REG);
 
@@ -52,7 +51,6 @@ void g2d_set_src_addr(struct g2d_dev *d, dma_addr_t a)
 void g2d_set_dst_size(struct g2d_dev *d, struct g2d_frame *f)
 {
 	u32 n;
-	u32 stride;
 
 	w(f->stride & 0xFFFF, DST_STRIDE_REG);
 
-- 
1.7.0.4

