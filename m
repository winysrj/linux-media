Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F18C282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCB79218A2
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbfAXIrz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:47:55 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:60949 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727363AbfAXIry (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:47:54 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id maftgVzPcNR5ymafwgov0L; Thu, 24 Jan 2019 09:47:53 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] vb2: vb2_find_timestamp: drop restriction on buffer state
Message-ID: <3bc5f149-895d-468d-81ee-1c7c4cbae8d8@xs4all.nl>
Date:   Thu, 24 Jan 2019 09:47:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEtvytydieLR4u00VhY4oFJXqcCUbYuvkaHkKvSKrp07EmkR45bs3G2ONmWik54UkeQzQV93e2gRCrOBTBTRT6askFpeyVK9S+cd9hgQAOcL0zyb3H3N
 FIb2yx7kuLCdJfNUNVg9FNdSdhySr1vqMwCzcEZfCfwfMAM3EN6OIrRfL/fwhFKCEftuuE9z1rXGsSZeCVxN6/3UMiDRQ0syz451Z46W8yU/bYwToDKDSE6A
 lhenzPWZUt8CvFl50VEHBuEa3n6ce65J5oHknR1GxvHRJpz0Z2X930ddt+aIsPUn
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There really is no reason why vb2_find_timestamp can't just find
buffers in any state. Drop that part of the test.

This also means that vb->timestamp should only be set to 0 when
the driver doesn't copy timestamps.

This change allows for more efficient pipelining (i.e. you can use
a buffer for a reference frame even when it is queued).

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Changes since v1: set timestamp to 0 unless copy_timestamp is set instead of also
checking whether it is an output queue.
---
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 75ea90e795d8..2a093bff0bf5 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -567,7 +567,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned int plane;

-	if (!vb->vb2_queue->is_output || !vb->vb2_queue->copy_timestamp)
+	if (!vb->vb2_queue->copy_timestamp)
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
