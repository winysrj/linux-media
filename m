Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695C9C282C4
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 415342080A
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfBGLt7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:49:59 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:48537 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727069AbfBGLtw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 06:49:52 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id riBggvrMUNR5yriBig1JmK; Thu, 07 Feb 2019 12:49:50 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Yi Qingliang <niqingliang2003@gmail.com>
Subject: [RFC PATCH 3/8] vb2: fix epoll() by calling poll_wait first
Date:   Thu,  7 Feb 2019 12:49:43 +0100
Message-Id: <20190207114948.37750-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207114948.37750-1-hverkuil-cisco@xs4all.nl>
References: <20190207114948.37750-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfEiePhVJVg4gVkpx4rn8cwFm9GXweq0Bm9PHG20cjJAVw0PWeTWNnvjElmt11l3ppcqMSDvl6rAYAVgBF3rIFLu5WmNWi3wi1tfVmlMtYnc5wl/zUAhb
 aJTstGC/JGSgagSDc4RyavjDNumcOQalchNWE6RgJu+S3x/UD/7+RgobF9r72kfJeJg93LbmjTZN2ylxSEdIch6wLxkuw9oFxDRu+giVfUPXpGrQg6qN4H/T
 vpl5c3Fb8RF68sLWy+TwN7cQIKwBRo9XBSMOS6Uv708wyZetvHuWik4Vv7JCWDE2xLlhWxOVVl2MMlmoAqGt6jywxL2Yc0C3j9dAuY8gto87oZMQwAJ4Iu4n
 e4XFeUIsX/80iDiRp8dCF4qoISP5Og==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The epoll function expects that whenever the poll file op is
called, the poll_wait function is also called. That didn't
always happen in vb2_core_poll() and vb2_poll(). Fix this,
otherwise epoll() would timeout when it shouldn't.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Yi Qingliang <niqingliang2003@gmail.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 4 ++--
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index e07b6bdb6982..b40e9f48a943 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2289,6 +2289,8 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
 	if (q->is_output && !(req_events & (EPOLLOUT | EPOLLWRNORM)))
 		return 0;
 
+	poll_wait(file, &q->done_wq, wait);
+
 	/*
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
@@ -2340,8 +2342,6 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
 		 */
 		if (q->last_buffer_dequeued)
 			return EPOLLIN | EPOLLRDNORM;
-
-		poll_wait(file, &q->done_wq, wait);
 	}
 
 	/*
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 3aeaea3af42a..101479768f91 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -867,16 +867,14 @@ EXPORT_SYMBOL_GPL(vb2_queue_release);
 __poll_t vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 {
 	struct video_device *vfd = video_devdata(file);
-	__poll_t req_events = poll_requested_events(wait);
 	__poll_t res = 0;
 
 	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
 		struct v4l2_fh *fh = file->private_data;
 
+		poll_wait(file, &fh->wait, wait);
 		if (v4l2_event_pending(fh))
 			res = EPOLLPRI;
-		else if (req_events & EPOLLPRI)
-			poll_wait(file, &fh->wait, wait);
 	}
 
 	return res | vb2_core_poll(q, file, wait);
-- 
2.20.1

