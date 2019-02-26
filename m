Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8AEC4360F
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D56021850
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJ+4RM/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfBZRFd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37672 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfBZRFc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id w6so11537837wrs.4
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MAunhPLiQsMAY05okqvSKPPo8Hd0S9bQIXD1NW17kLg=;
        b=FJ+4RM/UlpROLj7YHFGMLCfYalAsmMo3G31wZ9e4uoOomknF3k/GsESkexXkRzw+Rv
         guocfZ7OaD2D6vhF4ERH2uiFO7LchhD/HYDdPmz9s0ngqAc4WE8ul9PUccbaS2oKOsYq
         rNZHh8LZwrz+QqGk8FmZgIo7FlzKGx2uNLlcqQ3Tdfvi6F7H8XMr2o49hnyqM4IwKMWH
         bP9JVEjreAXBpQkPG/SUxUDewf2rL7o37uD9FmnAJWtEfnwS0hPXO5RizPPPOlrQ5Lkm
         UDbfQqCB/k/eBFGn1ExF1683eNKTaI511a6/hNbRH1XTm46wDwJnUOm4K9priG+UguyK
         O5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MAunhPLiQsMAY05okqvSKPPo8Hd0S9bQIXD1NW17kLg=;
        b=spxII2ZsIkfDm4QcsdfWSlrjTsrpFPrLSgaVKDn2FDFQNSijAXPeE7dEcFQPgNQb9Y
         wdeHlcrfXMGkaFwa/kh5VEVBmuBfI2anYrsPE4X9xLG1w9s7bD/BlBa7GnqUWy7YxTL9
         pyWdsicdTa4rdbL5B6QZoLTjAoL8mX8eepOHoFfNnuEHnSGOfDl2suZ0+jt05xgvlf/n
         +Qv+GaNGxhjDqnW5x3RRmEhszfhNhM9cX55htll3NgA1jgYggToqSXegQjoAwfHNpy4x
         62n2ahOiST/iDGUlhuPpSTz6IguyMcZPqPqCoq6eNjsqYbJjjHyx7A5ggprMlphl9qRu
         WQOQ==
X-Gm-Message-State: AHQUAuZBK6OJZNxreBrKC7D3ZNZT57mc2d9H9hxmnD6cIuf62DO8A7Nr
        IDLqNPOAF5DmYeLRS02Ny+7Suo4OOO0=
X-Google-Smtp-Source: AHgI3IYASzPWyqSM6wul1wyxMVaAZ9pncGNnWlu4vtdxib7slRt6iRBk4W/U3WXpU8843e3/jWzGDQ==
X-Received: by 2002:adf:f103:: with SMTP id r3mr18823148wro.50.1551200730173;
        Tue, 26 Feb 2019 09:05:30 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:29 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v5 01/21] vb2: add requires_requests bit for stateless codecs
Date:   Tue, 26 Feb 2019 09:04:54 -0800
Message-Id: <20190226170514.86127-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Stateless codecs require the use of the Request API as opposed of it
being optional.

So add a bit to indicate this and let vb2 check for this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 5 ++++-
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 6 ++++++
 include/media/videobuf2-core.h                  | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 15b6b9c0a2e4..d8cf9d3ec54d 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1518,7 +1518,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 
 	if ((req && q->uses_qbuf) ||
 	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
-	     q->uses_requests)) {
+	     (q->uses_requests || q->requires_requests))) {
 		dprintk(1, "queue in wrong mode (qbuf vs requests)\n");
 		return -EBUSY;
 	}
@@ -2247,6 +2247,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	    WARN_ON(!q->ops->buf_queue))
 		return -EINVAL;
 
+	if (WARN_ON(q->requires_requests && !q->supports_requests))
+		return -EINVAL;
+
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index d09dee20e421..4dc4855056f1 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -385,6 +385,10 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 			dprintk(1, "%s: queue uses requests\n", opname);
 			return -EBUSY;
 		}
+		if (q->requires_requests) {
+			dprintk(1, "%s: queue requires requests\n", opname);
+			return -EACCES;
+		}
 		return 0;
 	} else if (!q->supports_requests) {
 		dprintk(1, "%s: queue does not support requests\n", opname);
@@ -658,6 +662,8 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
 #ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
 	if (q->supports_requests)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
+	if (q->requires_requests)
+		*caps |= V4L2_BUF_CAP_REQUIRES_REQUESTS;
 #endif
 }
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a844abcae71e..bf50090af859 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -484,6 +484,8 @@ struct vb2_buf_ops {
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
  * @supports_requests: this queue supports the Request API.
+ * @requires_requests: this queue requires the Request API. If this is set to 1,
+ *		then supports_requests must be set to 1 as well.
  * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
  *		time this is called. Set to 0 when the queue is canceled.
  *		If this is 1, then you cannot queue buffers from a request.
@@ -558,6 +560,7 @@ struct vb2_queue {
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
 	unsigned			supports_requests:1;
+	unsigned			requires_requests:1;
 	unsigned			uses_qbuf:1;
 	unsigned			uses_requests:1;
 
-- 
2.17.1

