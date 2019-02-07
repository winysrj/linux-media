Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED7AC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18DEB2080A
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 11:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfBGLty (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 06:49:54 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34605 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727083AbfBGLtx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 06:49:53 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud8.xs4all.net with ESMTPA
        id riBggvrMUNR5yriBig1Jmv; Thu, 07 Feb 2019 12:49:50 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Michael Ira Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [RFC PATCH 8/8] dvb-core: fix epoll() by calling poll_wait first
Date:   Thu,  7 Feb 2019 12:49:48 +0100
Message-Id: <20190207114948.37750-9-hverkuil-cisco@xs4all.nl>
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
always happen in dvb_demux_poll(), dvb_dvr_poll() and
dvb_ca_en50221_io_poll(). Fix this, otherwise epoll()
can timeout when it shouldn't.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/dvb-core/dmxdev.c         | 8 ++++----
 drivers/media/dvb-core/dvb_ca_en50221.c | 5 ++---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 1544e8cef564..f14a872d1268 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1195,13 +1195,13 @@ static __poll_t dvb_demux_poll(struct file *file, poll_table *wait)
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
 	__poll_t mask = 0;
 
+	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
+
 	if ((!dmxdevfilter) || dmxdevfilter->dev->exit)
 		return EPOLLERR;
 	if (dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx))
 		return dvb_vb2_poll(&dmxdevfilter->vb2_ctx, file, wait);
 
-	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
-
 	if (dmxdevfilter->state != DMXDEV_STATE_GO &&
 	    dmxdevfilter->state != DMXDEV_STATE_DONE &&
 	    dmxdevfilter->state != DMXDEV_STATE_TIMEDOUT)
@@ -1346,13 +1346,13 @@ static __poll_t dvb_dvr_poll(struct file *file, poll_table *wait)
 
 	dprintk("%s\n", __func__);
 
+	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
+
 	if (dmxdev->exit)
 		return EPOLLERR;
 	if (dvb_vb2_is_streaming(&dmxdev->dvr_vb2_ctx))
 		return dvb_vb2_poll(&dmxdev->dvr_vb2_ctx, file, wait);
 
-	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
-
 	if (((file->f_flags & O_ACCMODE) == O_RDONLY) ||
 	    dmxdev->may_do_mmap) {
 		if (dmxdev->dvr_buffer.error)
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 4d371cea0d5d..ebf1e3b03819 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1797,6 +1797,8 @@ static __poll_t dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 
 	dprintk("%s\n", __func__);
 
+	poll_wait(file, &ca->wait_queue, wait);
+
 	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
 		mask |= EPOLLIN;
 
@@ -1804,9 +1806,6 @@ static __poll_t dvb_ca_en50221_io_poll(struct file *file, poll_table *wait)
 	if (mask)
 		return mask;
 
-	/* wait for something to happen */
-	poll_wait(file, &ca->wait_queue, wait);
-
 	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1)
 		mask |= EPOLLIN;
 
-- 
2.20.1

