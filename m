Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44BACC43612
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17B2D2089F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfAHI6m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 03:58:42 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33918 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727939AbfAHI6l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 03:58:41 -0500
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id AB851634C83;
        Tue,  8 Jan 2019 10:57:27 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 2/3] videobuf2-dma-sg: Prevent size from overflowing
Date:   Tue,  8 Jan 2019 10:58:35 +0200
Message-Id: <20190108085836.9376-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

buf->size is an unsigned long; casting that to int will lead to an
overflow if buf->size exceeds INT_MAX.

Fix this by changing the type to unsigned long instead. This is possible
as the buf->size is always aligned to PAGE_SIZE, and therefore the size
will never have values lesser than 0.

Note on backporting to stable: the file used to be under
drivers/media/v4l2-core, it was moved to the current location after 4.14.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-dma-sg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 015e737095cd..5fdb8d7051f6 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -59,7 +59,10 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
 		gfp_t gfp_flags)
 {
 	unsigned int last_page = 0;
-	int size = buf->size;
+	unsigned long size = buf->size;
+
+	if (WARN_ON(size & ~PAGE_MASK))
+		return -ENOMEM;
 
 	while (size > 0) {
 		struct page *pages;
-- 
2.11.0

