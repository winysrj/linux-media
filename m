Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2687 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030381Ab3FTU2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 16:28:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [REVIEW PATCH 2/3] bfin_capture: fix compiler warning
Date: Thu, 20 Jun 2013 22:28:15 +0200
Message-Id: <1371760096-19256-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371760096-19256-1-git-send-email-hverkuil@xs4all.nl>
References: <1371760096-19256-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

media-git/drivers/media/platform/blackfin/bfin_capture.c: In function ‘bcap_probe’:
media-git/drivers/media/platform/blackfin/bfin_capture.c:1007:16: warning: ignoring return value of ‘vb2_queue_init’, declared with attribute warn_unused_result [-Wunused-result]
  vb2_queue_init(q);
                  ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 6652e71..7f838c6 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -1004,7 +1004,9 @@ static int bcap_probe(struct platform_device *pdev)
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 
-	vb2_queue_init(q);
+	ret = vb2_queue_init(q);
+	if (ret)
+		goto err_free_handler;
 
 	mutex_init(&bcap_dev->mutex);
 	init_completion(&bcap_dev->comp);
-- 
1.8.3.1

