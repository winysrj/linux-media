Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35874 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbeFOTIA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:08:00 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 06/17] s5p-g2d: Implement wait_prepare and wait_finish
Date: Fri, 15 Jun 2018 16:07:26 -0300
Message-Id: <20180615190737.24139-7-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is currently specifying a vb2_queue lock,
which means it straightforward to implement wait_prepare
and wait_finish.

Having these callbacks releases the queue lock while blocking,
which improves latency by allowing for example streamoff
or qbuf operations while waiting in dqbuf.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/s5p-g2d/g2d.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 66aa8cf1d048..ce4280730835 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -142,6 +142,8 @@ static const struct vb2_ops g2d_qops = {
 	.queue_setup	= g2d_queue_setup,
 	.buf_prepare	= g2d_buf_prepare,
 	.buf_queue	= g2d_buf_queue,
+	.wait_prepare	= vb2_ops_wait_prepare,
+	.wait_finish	= vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
-- 
2.17.1
