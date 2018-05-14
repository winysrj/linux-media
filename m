Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:49307 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753052AbeENL4N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 07:56:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mike Isely <isely@pobox.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [RFC PATCH 4/6] videobuf2-core: require q->lock
Date: Mon, 14 May 2018 13:56:00 +0200
Message-Id: <20180514115602.9791-5-hverkuil@xs4all.nl>
In-Reply-To: <20180514115602.9791-1-hverkuil@xs4all.nl>
References: <20180514115602.9791-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Refuse to initialize a vb2 queue if there is no lock specified.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index d3f7bb33a54d..3b89ec5e0b2f 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2002,6 +2002,7 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	if (WARN_ON(!q)			  ||
 	    WARN_ON(!q->ops)		  ||
 	    WARN_ON(!q->mem_ops)	  ||
+	    WARN_ON(!q->lock)		  ||
 	    WARN_ON(!q->type)		  ||
 	    WARN_ON(!q->io_modes)	  ||
 	    WARN_ON(!q->ops->queue_setup) ||
-- 
2.17.0
