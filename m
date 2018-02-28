Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:41487 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935297AbeB1WZD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 17:25:03 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/3] media: vb2-core: vb2_ops: document non-interrupt-cantext calling
Date: Wed, 28 Feb 2018 23:24:47 +0100
Message-Id: <1519856687-5568-3-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1519856687-5568-1-git-send-email-luca@lucaceresoli.net>
References: <1519856687-5568-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver writers can benefit in knowing if/when callbacks are called in
interrupt context. But it is not completely obvious here, so document it.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
---
 include/media/videobuf2-core.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f20000887d3c..f6818f732f34 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -296,6 +296,9 @@ struct vb2_buffer {
 /**
  * struct vb2_ops - driver-specific callbacks.
  *
+ * These operations are not called from interrupt context except where
+ * mentioned specifically.
+ *
  * @queue_setup:	called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
  *			handlers before memory allocation. It can be called
  *			twice: if the original number of requested buffers
-- 
2.7.4
