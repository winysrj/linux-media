Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D533C10F00
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29BF820684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eehGWflS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfCFVOE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:04 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39023 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbfCFVOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id f18so118371wrp.6
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+XVAZJOxveIBEpqMOzg445AwTWOSlgHE2VoHEdkdCZM=;
        b=eehGWflS6vflOPuY+RttkHLsh4dtlXoI5BZ4faN/HsdkJy82HowlYZE/5UtLwJlGeO
         3Pv8jz9L6lLJb73od9x0ePBgg/QACHJn4Dl3k/k4wkUPy2DQ7Sfdl7OdwasJoT6Q1ra3
         NSEahx5d2sORxbjvX6UUeGvTaAauCOxNHjIfcnWIH6HUARXfM9Xzvny+CEWpbHjaSus0
         hyQxg8U+C7CjOUibQ99GahonjXtC+3SsWzructcVgnwVCeFTRNZDrFdqjnX+kvQdTKZg
         vtmHhiIjuKDcWHUA4ekOif7RgCuGWdWDT61V4X66LNhGpdHLgA/y3hfrhavLRGBDEidp
         FKiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+XVAZJOxveIBEpqMOzg445AwTWOSlgHE2VoHEdkdCZM=;
        b=T+wE5oRSoN5VXt8xTtDaoQN1gWKxC3YMjM8ZNkdBQecREDBM38O3ivUL/AA1/QfWW4
         l5aq8yNrlPAdqBTUmI0liXHOBOHCDzrV5yDwCxJYzcNJqyCUXsSVB0m7EDYPZJrz4yzZ
         z1ZF+Bx5Vjfr9qgWHLL7o3a/y6LJ6zwaqRgT/F8/6Zedt/aZx0yf1UIAlHDtqVTrIaFU
         m/qFPHviZkTdPVKNSU0j5Bk5oUQ9Jg8Z8XWEizY26sZoUSwt6gkbZ9K2to8YIo/dJxhI
         WaMUdfToYMQlNqm2lCf105m95yEN2r3fnndRjg1YZ8h47N3Znbd0BTX+1wsR0K73tgcN
         FUnA==
X-Gm-Message-State: APjAAAX4JfwgtfMAOwZUkvNXXSn957p2QpmyJcvqIV6Ih2pv2vZcGN1E
        XtlHyTU4+vB8kN14a8hgQehOteo5iTM=
X-Google-Smtp-Source: APXvYqzJ+ln2iS0mBxqo/8wotbzZPs+eUNzpWL3pZsDfHT7DD+8pScXID+LFIW6kmu1PqHmlR8LXIA==
X-Received: by 2002:adf:afe3:: with SMTP id y35mr4297314wrd.318.1551906841436;
        Wed, 06 Mar 2019 13:14:01 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.13.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:00 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v5 01/23] vb2: add requires_requests bit for stateless codecs
Date:   Wed,  6 Mar 2019 13:13:21 -0800
Message-Id: <20190306211343.15302-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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
index 910f3d469005..fbf8dbbcbc09 100644
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

