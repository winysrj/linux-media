Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33462 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbeERSyO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:54:14 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 17/20] videobuf2-core: require q->lock
Date: Fri, 18 May 2018 15:52:05 -0300
Message-Id: <20180518185208.17722-18-ezequiel@collabora.com>
In-Reply-To: <20180518185208.17722-1-ezequiel@collabora.com>
References: <20180518185208.17722-1-ezequiel@collabora.com>
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
2.16.3
