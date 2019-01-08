Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD910C43444
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAB312089F
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 08:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfAHI6m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 03:58:42 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33926 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728022AbfAHI6m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 03:58:42 -0500
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1002])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E6BEC634C85;
        Tue,  8 Jan 2019 10:57:27 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 3/3] videobuf2-core.h: Document the alloc memop size argument as page aligned
Date:   Tue,  8 Jan 2019 10:58:36 +0200
Message-Id: <20190108085836.9376-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The size argument of the alloc memop, which allocates buffer memory, is
page aligned. Document it as such in the only caller as well as ops
documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 1 +
 include/media/videobuf2-core.h                  | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 0234ddbfa4de..64ecb9a65a47 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -205,6 +205,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	 * NOTE: mmapped areas should be page aligned
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
+		/* Memops alloc requires size to be page aligned. */
 		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
 
 		/* Did it wrap around? */
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index e86981d615ae..68b9fe660e4f 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -54,7 +54,8 @@ struct vb2_threadio_data;
  *		will then be passed as @buf_priv argument to other ops in this
  *		structure. Additional gfp_flags to use when allocating the
  *		are also passed to this operation. These flags are from the
- *		gfp_flags field of vb2_queue.
+ *		gfp_flags field of vb2_queue. The size argument to this function
+ *		shall be *page aligned*.
  * @put:	inform the allocator that the buffer will no longer be used;
  *		usually will result in the allocator freeing the buffer (if
  *		no other users of this buffer are present); the @buf_priv
-- 
2.11.0

