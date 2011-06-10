Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17961 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756111Ab1FJME5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 08:04:57 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMK00J59PK73J@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Jun 2011 13:04:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMK0043LPK6H1@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Jun 2011 13:04:54 +0100 (BST)
Date: Fri, 10 Jun 2011 14:04:38 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: reset queued_count value during queue
 reinitialization
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
Message-id: <1307707479-16189-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

queued_count variable was left untouched during the queue reinitialization
in __vb2_queue_cancel, what might lead to mismatch between the real number
of queued buffers and queued_count variable.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/videobuf2-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..6be2f79 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -1196,6 +1196,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * has not already dequeued before initiating cancel.
 	 */
 	INIT_LIST_HEAD(&q->done_list);
+	atomic_set(&q->queued_count, 0);
 	wake_up_all(&q->done_wq);
 
 	/*
-- 
1.7.1.569.g6f426

