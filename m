Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0DEC61CE4
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0C2E20880
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lnB30w3h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbfATLPh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 06:15:37 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35067 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730485AbfATLPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 06:15:36 -0500
Received: by mail-wm1-f67.google.com with SMTP id t200so8309332wmt.0
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 03:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ptJ/fu0UHGNXsc6HRQMlWyiyrSUIjEymX1Wci7NkwwQ=;
        b=lnB30w3hsrmMpg+eH83nypqmzf5S+Bjgr2/uzLQ3h0XO9P+flPDzig/lvMjs6H5etR
         0SVeVw/jEgF++KEMnnv+NxM9mn7iX1aBSpyfpHCmqWeTffomS/fEOyCOdniKgFML8O1i
         DN8xWopCCCcBC2vAGR3dBr5MNkjC2HJSg+9Bza0R7w3nscD5t8LMydCyjhggxcXi5KW3
         yQ18LMgYtvkfRl9xTaP1Hd6ef+mE1kbW36aZA6W+s4j5lRY1rx10FJ9p+aY2ifGmHx8v
         P4Szp5mJoaAWvKTXHBOox8CAczw9rLHhfwJfI8e/OMj27XB/HRWFsEEp16vEEMGqWPwY
         Gpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ptJ/fu0UHGNXsc6HRQMlWyiyrSUIjEymX1Wci7NkwwQ=;
        b=a9YrbLwY4alktr6zfDqRA2EsLfN1Nh0XdJCKKhipVnGKcRjX5vtiMxIY5aXz82KkBR
         ggUaJzYIgwKZjgH625Gb0dTxA4TtNQQaeXb1PWk810JUXHfF8QOFluA3CSX8VuL0WtS7
         42e9IR5OnyjXFmO81DPJhknMSssUbzc2o6rIB2vFaUBBZtggfXekHkvoN5lmVQP2Gnh8
         lHgeBsSFbVBrwZCb0VEQ8HoElSwAVipPnOp9+O98JJpBbtIJTR2e6dSwaHw0Ap4VpebZ
         uKRntI8q9Ate9FaAObrP0CXtg/A+aRarPMOcsXMFkj8z0DcE+AdHMPvOv+BVKdd6pRwD
         q9vg==
X-Gm-Message-State: AJcUuke5BU+HOK+/+AuzAf/5M5kyT7Lf9MKefp4xdbNPuM+u9TRgy6RW
        wPnB9mAheXeSUJtlS1C+UyTv8DJiKWI=
X-Google-Smtp-Source: ALg8bN7dCiP6kIcpfj25mOJiM2+MuzbcEx9be2fa9c0WjOSBYim8jLM53HrlF7Zv/WTQDT0uUV9jiw==
X-Received: by 2002:a1c:b70a:: with SMTP id h10mr20524495wmf.125.1547982934275;
        Sun, 20 Jan 2019 03:15:34 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id n11sm28281796wrw.60.2019.01.20.03.15.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 03:15:33 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 4/6] v4l2-ctl: Introduce capture_setup
Date:   Sun, 20 Jan 2019 03:15:18 -0800
Message-Id: <20190120111520.114305-5-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190120111520.114305-1-dafna3@gmail.com>
References: <20190120111520.114305-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add function capture_setup that implements the
capture setup sequence.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 58 +++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index fc204304..cd20dec7 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1836,6 +1836,48 @@ enum stream_type {
 	OUT,
 };
 
+static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
+{
+	struct v4l2_fmtdesc fmt_desc;
+	cv4l_fmt fmt;
+
+	if (fd.streamoff(in.g_type())) {
+		fprintf(stderr, "%s: fd.streamoff error\n", __func__);
+		return -1;
+	}
+	get_cap_compose_rect(fd);
+
+	/* release any buffer allocated */
+	if (in.reqbufs(&fd)) {
+		fprintf(stderr, "%s: in.reqbufs 0 error\n", __func__);
+		return -1;
+	}
+
+	if (fd.enum_fmt(fmt_desc, true, 0, in.g_type())) {
+		fprintf(stderr, "%s: fd.enum_fmt error\n", __func__);
+		return -1;
+	}
+
+	fd.g_fmt(fmt, in.g_type());
+	fmt.s_pixelformat(fmt_desc.pixelformat);
+	fd.s_fmt(fmt, in.g_type());
+
+	if (in.reqbufs(&fd, reqbufs_count_cap)) {
+		fprintf(stderr, "%s: in.reqbufs %u error\n", __func__,
+			reqbufs_count_cap);
+		return -1;
+	}
+	if (in.obtain_bufs(&fd) || in.queue_all(&fd)) {
+		fprintf(stderr, "%s: in.obtain_bufs error\n", __func__);
+		return -1;
+	}
+	if (fd.streamon(in.g_type())) {
+		fprintf(stderr, "%s: fd.streamon error\n", __func__);
+		return -1;
+	}
+	return 0;
+}
+
 static void streaming_set_m2m(cv4l_fd &fd)
 {
 	int fd_flags = fcntl(fd.g_fd(), F_GETFL);
@@ -1900,21 +1942,21 @@ static void streaming_set_m2m(cv4l_fd &fd)
 		}
 	}
 
-	if (in.reqbufs(&fd, reqbufs_count_cap) ||
-	    out.reqbufs(&fd, reqbufs_count_out))
+	if (out.reqbufs(&fd, reqbufs_count_out))
 		goto done;
 
-	if (in.obtain_bufs(&fd) ||
-	    in.queue_all(&fd) ||
-	    do_setup_out_buffers(fd, out, file[OUT], true))
+	if (do_setup_out_buffers(fd, out, file[OUT], true))
 		goto done;
 
-	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
-	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
+	if (fd.streamon(out.g_type()))
+		goto done;
 
-	if (fd.streamon(in.g_type()) || fd.streamon(out.g_type()))
+	if (capture_setup(fd, in))
 		goto done;
 
+	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
+	fps_ts[OUT].determine_field(fd.g_fd(), out.g_type());
+
 	while (stream_sleep == 0)
 		sleep(100);
 
-- 
2.17.1

