Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E1EC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 08:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC800217F5
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 08:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfAWIa5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 03:30:57 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58170 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726291AbfAWIa4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 03:30:56 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id mDvvg0smIBDyImDvygXwTM; Wed, 23 Jan 2019 09:30:54 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vb2: vb2_find_timestamp: drop restriction on buffer state
Message-ID: <c29a6f08-a450-73aa-c79d-93cdcbf416ae@xs4all.nl>
Date:   Wed, 23 Jan 2019 09:30:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFiGY3wAh69K1b6hGwOaTZPM8tGthl7Vah2hxF5mHHp6mce+GZGW5ovsHpmwpCr2EIhtN8oOgXwbKCI1L5LSeWoRhdlEGuK5RkAU4EDQKW/2y2f6Z0Q7
 ttF4oDIseY8Kbj/KpsT1H5ohO8U9vGwC/Ie3YzmQHPGhiE1pXoYPXhDI3lp8zhI9TEiwLcrlsVS/3kDwtwgXPJWF36aBGfXGc3WgxWuc/FMkVjLDMoCMQXh1
 Kp5odzKtYynpRvw1mxfxQZV4tD3q/32F3SuQpg3wKBJYJcMCU4H6fjvlyNiwseQq
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There really is no reason why vb2_find_timestamp can't just find
buffers in any state. Drop that part of the test.

This also means that vb->timestamp should only be set to 0 when a
capture buffer is queued AND when the driver doesn't copy timestamps.

This change allows for more efficient pipelining (i.e. you can use
a buffer for a reference frame even when it is queued).

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 75ea90e795d8..2a093bff0bf5 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -567,7 +567,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned int plane;

-	if (!vb->vb2_queue->is_output || !vb->vb2_queue->copy_timestamp)
+	if (!vb->vb2_queue->is_output && !vb->vb2_queue->copy_timestamp)
 		vb->timestamp = 0;

 	for (plane = 0; plane < vb->num_planes; ++plane) {
@@ -594,14 +594,9 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
 {
 	unsigned int i;

-	for (i = start_idx; i < q->num_buffers; i++) {
-		struct vb2_buffer *vb = q->bufs[i];
-
-		if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
-		     vb->state == VB2_BUF_STATE_DONE) &&
-		    vb->timestamp == timestamp)
+	for (i = start_idx; i < q->num_buffers; i++)
+		if (q->bufs[i]->timestamp == timestamp)
 			return i;
-	}
 	return -1;
 }
 EXPORT_SYMBOL_GPL(vb2_find_timestamp);
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index a9961bc776dc..8a10889dc2fd 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -59,8 +59,7 @@ struct vb2_v4l2_buffer {
  * vb2_find_timestamp() - Find buffer with given timestamp in the queue
  *
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
- * @timestamp:	the timestamp to find. Only buffers in state DEQUEUED or DONE
- *		are considered.
+ * @timestamp:	the timestamp to find.
  * @start_idx:	the start index (usually 0) in the buffer array to start
  *		searching from. Note that there may be multiple buffers
  *		with the same timestamp value, so you can restart the search
