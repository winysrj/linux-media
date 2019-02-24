Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092B1C00319
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7C12083E
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKZoKSyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfBXIlw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32993 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfBXIlv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:51 -0500
Received: by mail-wr1-f66.google.com with SMTP id i12so6666498wrw.0
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2Kz4T0TAMia1m8zxthVlaxPb1YjonSLkcRZLcMO9ol4=;
        b=KKZoKSyj6SmSby+07MvtXXNwppFj1n6hQdObGavxCBCK44Wu40O+P6DwVMHFUZie4y
         fW08vsJrlOUwRhnOzV3EWq4m/qNbUgsVlhxVsoh5j2XW/mo8McAeAD/PfLS2IwBPSw7g
         pRmTgT9i79JQ0YiG9LlQ7gmMLHU2yUQ+8qp9cIC2hAUPa68fz8v9x1f9abWSNrbAbbWa
         Fy1Fu46qnnIBlRgoeT2ooWYAI/SA8lbCdnHwXUlyPy/be1f1APJat9Q6KT4MBWubuvsO
         MtPW8IVcXJtEK4AnLI1JyLz+MhcUHBbRDYOgwKIwfuNgT88m/YXXfnNh+kbvQTwvQXLY
         hxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2Kz4T0TAMia1m8zxthVlaxPb1YjonSLkcRZLcMO9ol4=;
        b=tujBNHeASlI4AYAqDW435nlNqr8gY2rRsLxaRS72r7ZFrH+9hCfI3+E987l7jIu5sA
         dzwZjNHEvhOp8SYWfbLwaBTJgHiwJ4kS38F8L05LXdx4n55pMw06m/32bg0V23BF9f8N
         efn9WcwclPskt8xtge8Yu+a/SENkj/P58Ip+d1iGL7Z8j4XRLgt4H6KF1AGWdIWtSgO9
         tYycnx8KZZfCrwe80d0m6bLCRKg9vvU4lcgzwZJGaO53QHTSiyiarybaX5FdIPAV61WB
         ozguv8A2qJAHh2fPlZD8M4Nkv5S1kpkdmzbIvDXUEn1TD0ITGvz8lN7T8RGX/2f3UR1b
         dzvg==
X-Gm-Message-State: AHQUAua0g+wvGuy8ohepSF9pnVlYlNpZzjyB/FNp+HXRNw+6sJYdNtGG
        M3dKN6tyWxHOc1ve95r+BZm3g3MIjH8=
X-Google-Smtp-Source: AHgI3IYzP9zL3VHA3nqF1vltQceamy8YlhKze4P3Jsk7bPY5ZPSOBDyNYSa6Fw3TGCJ3IYYjMuftZw==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr8477794wrx.43.1550997709462;
        Sun, 24 Feb 2019 00:41:49 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:48 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 5/8] (c)v4l-helpers.h: Add support for the request api
Date:   Sun, 24 Feb 2019 00:41:23 -0800
Message-Id: <20190224084126.19412-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
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

