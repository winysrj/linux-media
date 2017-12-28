Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35730 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdL1Q3o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 11:29:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hirokazu Honda <hiroh@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/5] media: vb2: Enforce VB2_MAX_FRAME in vb2_core_reqbufs better
Date: Thu, 28 Dec 2017 14:29:36 -0200
Message-Id: <d7b7db68183db2655f9883368e836a45b1070171.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The check for the number of buffers requested against the maximum,
VB2_MAX_FRAME, was performed before checking queue's minimum number of
buffers. Reverse the order, thus ensuring that under no circumstances
num_buffers exceeds VB2_MAX_FRAME here.

Also add a warning of the condition.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/videobuf/videobuf2-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
index 1793bdb1fe54..ba04103f2f32 100644
--- a/drivers/media/common/videobuf/videobuf2-core.c
+++ b/drivers/media/common/videobuf/videobuf2-core.c
@@ -700,8 +700,9 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	/*
 	 * Make sure the requested values and current defaults are sane.
 	 */
-	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
-	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
+	WARN_ON(q->min_buffers_needed > VB2_MAX_FRAME);
+	num_buffers = max_t(unsigned int, *count, q->min_buffers_needed);
+	num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
 	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 	q->memory = memory;
 
-- 
2.14.3
