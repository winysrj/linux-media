Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10DAEC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 13:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D19E521A4A
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 13:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AL6qIFJn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfBQNmY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 08:42:24 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41280 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727462AbfBQNmX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 08:42:23 -0500
Received: by mail-wr1-f67.google.com with SMTP id n2so3176744wrw.8
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2019 05:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2Kz4T0TAMia1m8zxthVlaxPb1YjonSLkcRZLcMO9ol4=;
        b=AL6qIFJnnCENQivTZrpSDk7isP21INSs8n+DLBE0lpqOBiHBfAoOMZgXLGbgiaS0Nn
         +vRr0yr+HXzqW5sujplbcA+30j+xgsKlT2ZBxaFrcM58vH2epO7zOv20clA/4iu3CtYH
         7t8SnTuuR5fI9VoAq0DVwyzhP3MqbVxeEDeA4GWlkvq89jAwzzFI8hYFsi8UuZnS/dE5
         XK/FE8mdsAhMsaLwoxuH5SEmYIULMNFoN0JpfXvKCqgRBwEjRF2HsqAvfZpbmmK4v5ec
         yOneyJOv4jvpjy3vkGZVbXscM3QMpoSyk8yZbuZ4EjAQS55XqprUXv1Y++Wd+13uausL
         sYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2Kz4T0TAMia1m8zxthVlaxPb1YjonSLkcRZLcMO9ol4=;
        b=t1cO8FIFNO+ZYtwR1c7UCvMplv+h4QKwtJV982pMyqoh8yY5EnzvpAQbZGVtFVF1BE
         phDIEbRs5Vy86LxIBskg52XKaulzrhOIq3nOiCzbfQEVbqlOUW5B7P/5FIBzOhpwN+Dd
         B39z86pUaRjai8LduiFYoD+UvSX0+4dlQLmE3Khgc6JrbiXj9/hR2dElxX+QnG9XyMq/
         LQ+ZbIQwxbOaKLVs8HP+/YQ83nWoqBhHt9ISjjjUcw/WRnABs++PO+6CMmqxh4MJc3Fl
         ag+tMB3lm4k3NGNJ2d7tNeuSDLs9Shyry8j5kf4BRzgJen0w1Ddvtz0iKRE9CrfSzNXM
         0tYA==
X-Gm-Message-State: AHQUAubQXZjjNBnoeniUFqhUUs9eXHv//lNmrJeOuEKVdyaHq1IsLg8L
        hsThXwQ8CMkpAhZcl/RYwei9jPRorMs=
X-Google-Smtp-Source: AHgI3IbK7fGfcGZlQpc0IYimceF0T4lW2bioljpvjza4ac4WRwa7aL86QY1Z2MwH9Jn4E1DidkqqUQ==
X-Received: by 2002:adf:e30f:: with SMTP id b15mr13122706wrj.0.1550410941396;
        Sun, 17 Feb 2019 05:42:21 -0800 (PST)
Received: from localhost.localdomain ([87.71.54.246])
        by smtp.gmail.com with ESMTPSA id o5sm39200711wrh.34.2019.02.17.05.42.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 05:42:20 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 2/4] (c)v4l-helpers.h: Add support for the request api
Date:   Sun, 17 Feb 2019 05:42:07 -0800
Message-Id: <20190217134209.84066-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190217134209.84066-1-dafna3@gmail.com>
References: <20190217134209.84066-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add an array of request file descriptors to v4l_queue
and add methods to allocate and get them.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/common/cv4l-helpers.h |  5 +++++
 utils/common/v4l-helpers.h  | 22 ++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/utils/common/cv4l-helpers.h b/utils/common/cv4l-helpers.h
index 1cd2b6b2..551d4673 100644
--- a/utils/common/cv4l-helpers.h
+++ b/utils/common/cv4l-helpers.h
@@ -745,6 +745,7 @@ public:
 	unsigned g_capabilities() const { return v4l_queue_g_capabilities(this); }
 	unsigned g_length(unsigned plane) const { return v4l_queue_g_length(this, plane); }
 	unsigned g_mem_offset(unsigned index, unsigned plane) const { return v4l_queue_g_mem_offset(this, index, plane); }
+	unsigned g_req_fd(unsigned index) const { return v4l_queue_g_req_fd(this, index); }
 	void *g_mmapping(unsigned index, unsigned plane) const { return v4l_queue_g_mmapping(this, index, plane); }
 	void s_mmapping(unsigned index, unsigned plane, void *m) { v4l_queue_s_mmapping(this, index, plane, m); }
 	void *g_userptr(unsigned index, unsigned plane) const { return v4l_queue_g_userptr(this, index, plane); }
@@ -797,6 +798,10 @@ public:
 	{
 		return v4l_queue_export_bufs(fd->g_v4l_fd(), this, exp_type);
 	}
+	int alloc_req(int media_fd, unsigned index)
+	{
+		return v4l_queue_alloc_req(this, media_fd, index);
+	}
 	void close_exported_fds()
 	{
 		v4l_queue_close_exported_fds(this);
diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
index 59d8566a..daa49a1f 100644
--- a/utils/common/v4l-helpers.h
+++ b/utils/common/v4l-helpers.h
@@ -10,6 +10,7 @@
 #define _V4L_HELPERS_H_
 
 #include <linux/videodev2.h>
+#include <linux/media.h>
 #include <string.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -1414,6 +1415,7 @@ struct v4l_queue {
 	void *mmappings[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
 	unsigned long userptrs[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
 	int fds[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
+	int req_fds[VIDEO_MAX_FRAME];
 };
 
 static inline void v4l_queue_init(struct v4l_queue *q,
@@ -1445,6 +1447,11 @@ static inline __u32 v4l_queue_g_mem_offset(const struct v4l_queue *q, unsigned i
 	return q->mem_offsets[index][plane];
 }
 
+static inline unsigned v4l_queue_g_req_fd(const struct v4l_queue *q, unsigned index)
+{
+	return q->req_fds[index];
+}
+
 static inline void v4l_queue_s_mmapping(struct v4l_queue *q, unsigned index, unsigned plane, void *m)
 {
 	q->mmappings[index][plane] = m;
@@ -1701,6 +1708,21 @@ static inline int v4l_queue_export_bufs(struct v4l_fd *f, struct v4l_queue *q,
 	return 0;
 }
 
+static inline int v4l_queue_alloc_req(struct v4l_queue *q, int media_fd, unsigned index)
+{
+	int rc = 0;
+
+	rc = ioctl(media_fd, MEDIA_IOC_REQUEST_ALLOC, &q->req_fds[index]);
+	if (rc < 0) {
+		fprintf(stderr, "Unable to allocate media request: %s\n",
+			strerror(errno));
+		return rc;
+	}
+
+	return 0;
+}
+
+
 static inline void v4l_queue_close_exported_fds(struct v4l_queue *q)
 {
 	unsigned b, p;
-- 
2.17.1

