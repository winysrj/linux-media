Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B55C282D7
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 183BB2080A
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfBGLty (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:49:54 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44755 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727081AbfBGLtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 06:49:53 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id riBggvrMUNR5yriBig1Jmk; Thu, 07 Feb 2019 12:49:50 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [RFC PATCH 6/8] v4l2-mem2mem: add q->error check to v4l2_m2m_poll()
Date:   Thu,  7 Feb 2019 12:49:46 +0100
Message-Id: <20190207114948.37750-7-hverkuil-cisco@xs4all.nl>
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

The v4l2_m2m_poll function didn't check whether q->error
was set for either of the two queues. Add support for this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index d97781b8ff88..d2da5249b61b 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -638,8 +638,10 @@ __poll_t v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	 * means either in driver already or waiting for driver to claim it
 	 * and start processing.
 	 */
-	if ((!src_q->streaming || list_empty(&src_q->queued_list))
-		&& (!dst_q->streaming || list_empty(&dst_q->queued_list))) {
+	if ((!src_q->streaming || src_q->error ||
+	     list_empty(&src_q->queued_list)) &&
+	    (!dst_q->streaming || dst_q->error ||
+	     list_empty(&dst_q->queued_list))) {
 		rc |= EPOLLERR;
 		goto end;
 	}
-- 
2.20.1

