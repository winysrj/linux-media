Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5CCC43387
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C662146F
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 12:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbfAKMH2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 07:07:28 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50706 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726201AbfAKMH2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 07:07:28 -0500
Received: from [IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a] ([IPv6:2001:983:e9a7:1:b51b:802b:6c83:309a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id hvavgsdE7NR5yhvawgA7NC; Fri, 11 Jan 2019 13:07:26 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v5.0] vim2m: only cancel work if it is for right context
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c4f132b1-4f27-562c-8189-573bbff904fd@xs4all.nl>
Date:   Fri, 11 Jan 2019 13:07:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCOQEY+y4ykq49Y3PRykPjEuy3xZTsjz11ZeCh6fjZ10g5t+HgHQXApNabIgNZ3UW7E0IordbMAklE7dmRfZqCRL+kZ6cfPw/Opj7btO2w8HQ86gkjV8
 UOgTPkJX54n9rOoUeHpQ9wihdtFmdSPLtFQHxCYA/+oiONybVO/aqbqEjqxaasK3pbW8f7h9QGRnzEYblAyzJV+z5urwbQYoazjk/m6QBfc9C/wRqbYN9B5X
 pyBpAGGwtRQ27n+uOsvYfWkeFZSfRHt0hyrL5TmW04Y=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

cancel_delayed_work_sync() was called for any queue, but it should only
be called for the queue that is associated with the currently running job.

Otherwise, if two filehandles are streaming at the same time, then closing the
first will cancel the work which might still be running for a job from the
second filehandle. As a result the second filehandle will never be able to
finish the job and an attempt to stop streaming on that second filehandle will
stall.

Fixes: 52117be68b82 ("media: vim2m: use cancel_delayed_work_sync instead of flush_schedule_work")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v4.20 and up
---
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 33397d4a1402..2d066a3567d4 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -797,7 +797,9 @@ static void vim2m_stop_streaming(struct vb2_queue *q)
 	struct vb2_v4l2_buffer *vbuf;
 	unsigned long flags;

-	cancel_delayed_work_sync(&dev->work_run);
+	if (v4l2_m2m_get_curr_priv(dev->m2m_dev) == ctx)
+		cancel_delayed_work_sync(&dev->work_run);
+
 	for (;;) {
 		if (V4L2_TYPE_IS_OUTPUT(q->type))
 			vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
