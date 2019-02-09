Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB85C282CB
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 899FE218D2
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tgaO87+s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfBINyu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:54:50 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40651 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfBINyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 08:54:49 -0500
Received: by mail-wm1-f68.google.com with SMTP id q21so8291123wmc.5
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 05:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TlKFNkDS2fbLkZSLb0kMW0CriAnXfc9THTHiuvSZcqk=;
        b=tgaO87+skbDLQg6oGFUaYRMMXQRrw2BCegspj5z3tUI9eKBNcqR79JncdwyjO100/m
         w6krzIDx8lxwMc8DRxYfoeTWRQ4ZM3UHxtljpH/JgiXLqhH3S1dYN2Y+O8sOEPLu4c/f
         ANBE6t/SEEVHrylD5osX3mcpf8cSORRs2Eb+eTa9orbN855wupJdVK/N8hKyRxrKZ6tX
         Xk6myjZIIPOEZu4PULH3Z+/R8QE39nMuPfIx7LF/NqjakbNp8NaZMzjU1qEfs1dDcxMX
         1xRL9LXgOuP41XXNb8b9vWMZ3+qmmaAgJvnJ8RSi7cR3HXqlABIhndUr+xxnUaX6vMuc
         ujzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TlKFNkDS2fbLkZSLb0kMW0CriAnXfc9THTHiuvSZcqk=;
        b=CUGNHOTZEscCNW7O4+xO2fzAnPRIN6uJdH8e3HjXl6dsQP7d1nZPHXzikv7EXUPPS2
         u7w5cipAiqfgvpGYSqgC1X42FkLVLVYJ1VC9Bfa2z4K+rf7EPqHBJfxy+fORMQ759xky
         0UhsrodC8V+1E2LnpUFXFu/NZRgc4OK2T2icOZEUi7g7chqFQcmDfhsFCCoP1vPDTNeu
         MZK5lfQItLFBuukFi9F8C0Q2DBQjvy0qxhIPZXLOTmGMmqcqlflcLUuKH/CCDIk6JWqS
         p1T370iDasO1sL4oCYJpPLDLAyzAFX8KaSSmO7Ozbm2eeFOYf4knfJXAVRfuUDU4UISu
         Ur/w==
X-Gm-Message-State: AHQUAubOX2Y0Bx8MIgcuWNWDyLdpLhyjUwCXHDHEgz1krO2aGzuLyYGb
        bzRYHubRv6NTYiBfVQ+brPDa7d1Oans=
X-Google-Smtp-Source: AHgI3IYhDHGLocAzpLRcslJ6kHdEkSQDdOJrgfGnQrfJ33395yb20xFthu/0ymnKRDSmsNQXr7QwRw==
X-Received: by 2002:a5d:50c5:: with SMTP id f5mr19828790wrt.37.1549720487532;
        Sat, 09 Feb 2019 05:54:47 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id a15sm2864081wrx.58.2019.02.09.05.54.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:54:47 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 7/9] media: vb2: Add func that return buffer by timestamp
Date:   Sat,  9 Feb 2019 05:54:25 -0800
Message-Id: <20190209135427.20630-8-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209135427.20630-1-dafna3@gmail.com>
References: <20190209135427.20630-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the function 'vb2_find_timestamp_buf' that returns
the vb2 buffer that matches the given timestamp

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 14 ++++++++++++++
 include/media/videobuf2-v4l2.h                  |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 3aeaea3af42a..47c245a76561 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -598,6 +598,20 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
 	.copy_timestamp		= __copy_timestamp,
 };
 
+struct vb2_buffer *vb2_find_timestamp_buf(const struct vb2_queue *q,
+					  u64 timestamp,
+					  unsigned int start_idx)
+{
+	unsigned int i;
+
+	for (i = start_idx; i < q->num_buffers; i++) {
+		if (q->bufs[i]->timestamp == timestamp)
+			return q->bufs[i];
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vb2_find_timestamp_buf);
+
 int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
 		       unsigned int start_idx)
 {
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 8a10889dc2fd..7fc2a235064e 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -71,6 +71,9 @@ struct vb2_v4l2_buffer {
 int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
 		       unsigned int start_idx);
 
+struct vb2_buffer *vb2_find_timestamp_buf(const struct vb2_queue *q,
+					  u64 timestamp,
+					  unsigned int start_idx);
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 /**
-- 
2.17.1

