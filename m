Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3D4C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04A892080A
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfBGLty (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:49:54 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34405 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727078AbfBGLtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 06:49:53 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id riBggvrMUNR5yriBig1Jmd; Thu, 07 Feb 2019 12:49:50 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [RFC PATCH 5/8] v4l2-mem2mem: fix epoll() by calling poll_wait first
Date:   Thu,  7 Feb 2019 12:49:45 +0100
Message-Id: <20190207114948.37750-6-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207114948.37750-1-hverkuil-cisco@xs4all.nl>
References: <20190207114948.37750-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfEiePhVJVg4gVkpx4rn8cwFm9GXweq0Bm9PHG20cjJAVw0PWeTWNnvjElmt11l3ppcqMSDvl6rAYAVgBF3rIFLu5WmNWi3wi1tfVmlMtYnc5wl/zUAhb
 aJTstGC/JGSgamc+4L7VZ6tH+lvxsFSgGMohx6qQ+brcB5NnA1iI884d+/tT8Zu51Zzf6s8HDUuZT0ZiA1GCGzNhXWO6tb4enCgAYpNOBXuD9OgWvzKhSKEd
 XxFnITfM5ssyZzKJugmXmN/KISHpN4ZrDUm0BfHYNsVsT8MP/mRX2HdYYq/Kg5fuDMV1sptWDDPjQ1pTM5VPL/GrtL6n6ldb3YdOmQhuzVo=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The epoll function expects that whenever the poll file op is
called, the poll_wait function is also called. That didn't
always happen in v4l2_m2m_poll(). Fix this, otherwise
epoll() would timeout when it shouldn't.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 631f4e2aa942..d97781b8ff88 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -617,20 +617,22 @@ __poll_t v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	__poll_t rc = 0;
 	unsigned long flags;
 
+	src_q = v4l2_m2m_get_src_vq(m2m_ctx);
+	dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
+
+	poll_wait(file, &src_q->done_wq, wait);
+	poll_wait(file, &dst_q->done_wq, wait);
+
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
 		struct v4l2_fh *fh = file->private_data;
 
+		poll_wait(file, &fh->wait, wait);
 		if (v4l2_event_pending(fh))
 			rc = EPOLLPRI;
-		else if (req_events & EPOLLPRI)
-			poll_wait(file, &fh->wait, wait);
 		if (!(req_events & (EPOLLOUT | EPOLLWRNORM | EPOLLIN | EPOLLRDNORM)))
 			return rc;
 	}
 
-	src_q = v4l2_m2m_get_src_vq(m2m_ctx);
-	dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
-
 	/*
 	 * There has to be at least one buffer queued on each queued_list, which
 	 * means either in driver already or waiting for driver to claim it
@@ -642,11 +644,6 @@ __poll_t v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		goto end;
 	}
 
-	spin_lock_irqsave(&src_q->done_lock, flags);
-	if (list_empty(&src_q->done_list))
-		poll_wait(file, &src_q->done_wq, wait);
-	spin_unlock_irqrestore(&src_q->done_lock, flags);
-
 	spin_lock_irqsave(&dst_q->done_lock, flags);
 	if (list_empty(&dst_q->done_list)) {
 		/*
@@ -657,8 +654,6 @@ __poll_t v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			spin_unlock_irqrestore(&dst_q->done_lock, flags);
 			return rc | EPOLLIN | EPOLLRDNORM;
 		}
-
-		poll_wait(file, &dst_q->done_wq, wait);
 	}
 	spin_unlock_irqrestore(&dst_q->done_lock, flags);
 
-- 
2.20.1

