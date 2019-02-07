Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737B5C282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44B4A2080A
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfBGLty (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:49:54 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:33932 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbfBGLtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 06:49:53 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id riBggvrMUNR5yriBig1JmA; Thu, 07 Feb 2019 12:49:50 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [RFC PATCH 1/8] cec: fix epoll() by calling poll_wait first
Date:   Thu,  7 Feb 2019 12:49:41 +0100
Message-Id: <20190207114948.37750-2-hverkuil-cisco@xs4all.nl>
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
always happen in cec_poll(). Fix this, otherwise epoll()
would timeout when it shouldn't.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/cec/cec-api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 391b6fd483e1..156a0d76ab2a 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -38,6 +38,7 @@ static __poll_t cec_poll(struct file *filp,
 	struct cec_adapter *adap = fh->adap;
 	__poll_t res = 0;
 
+	poll_wait(filp, &fh->wait, poll);
 	if (!cec_is_registered(adap))
 		return EPOLLERR | EPOLLHUP;
 	mutex_lock(&adap->lock);
@@ -48,7 +49,6 @@ static __poll_t cec_poll(struct file *filp,
 		res |= EPOLLIN | EPOLLRDNORM;
 	if (fh->total_queued_events)
 		res |= EPOLLPRI;
-	poll_wait(filp, &fh->wait, poll);
 	mutex_unlock(&adap->lock);
 	return res;
 }
-- 
2.20.1

