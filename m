Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BA2C31681
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E15720879
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 18:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="srBBe3lA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfAUS5W (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:57:22 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55799 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbfAUS5W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 13:57:22 -0500
Received: by mail-wm1-f68.google.com with SMTP id y139so11769412wmc.5
        for <linux-media@vger.kernel.org>; Mon, 21 Jan 2019 10:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j2Ro7FOdB8fUnLBTtNxgFEno/zfxzlxHXJY4sM0iMmE=;
        b=srBBe3lAHzoO9ZUQBGRT4GYOefJqK0vevHjaRh39KilA+gCxwdwBdZt0NDHCyO5dqp
         FQLWuiD8riTWw6u59c/lFrU1EmAnpNC/ug93qXXhB3bxs+2YdtT4jAomHnwyMqrv9kCq
         fO8Nywiq03JLRg48ReeM7vCHv6VxNFOeQMY8lYqsxUhHlFpY9SSS9PEy4llbjfmHv0M2
         z4LEJhLP3oE7LJfBzZei892A1oFvqDCzOwsTxVBl5TMEPQbW7GIsV22qWNmDIGku/HRG
         Ec/yoHJS8iAyfuKua3WmC0/OUuuBG3OZxU5Y62OsHH+6gN36EoQId0+x8RN+097u5W0d
         IPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j2Ro7FOdB8fUnLBTtNxgFEno/zfxzlxHXJY4sM0iMmE=;
        b=X+Seh/MRuLdffGGRf6/Mo0TkzKky7yvoeJxcREEVKjqvdUbVhZt56zmZ9oSS+U8zUO
         0YizwE142lNFigDqGEZ5nDxP5mkQm97UnU4hj4hC4UgIrqXBB7cfIW2GWgdV2bMWg5TZ
         VPMyYciUCvGbI2VyclFzD6KmSTGyMTLUMYgvSUvZzVvQMAylN3+6Fm8RHx/cJ2a+Skt7
         x0FRZZq8hxgMWwoDBUqI46IILwZq4eG3Eur15rTonQVQhoGhSM2siqDFS/eW7CVrdWtE
         GsAUDaxvEC5DTq5YfCs279Z5y/m22JRtsemNh0FA5gbQNI4gs0eF32K3ADYWJA2Gbd7n
         msxg==
X-Gm-Message-State: AJcUukdUZ+slFVnCqDjCoz43CHqEBoMa5GbYY9QuowqdCkSalUo1f827
        zC1RbAT3KuYDjTc8TU7DpdJ3oCXtdLc=
X-Google-Smtp-Source: ALg8bN5OwVhMU4W2/cql82+W6bF6bpev34M3EQ8AexE53fnx/byBvFHn+tr5POoIu8imFMQ9LVDr9w==
X-Received: by 2002:a1c:a6c2:: with SMTP id p185mr491517wme.133.1548097039775;
        Mon, 21 Jan 2019 10:57:19 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id 67sm145061521wra.37.2019.01.21.10.57.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 10:57:19 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v2 3/5] v4l2-ctl: Introduce capture_setup
Date:   Mon, 21 Jan 2019 10:56:49 -0800
Message-Id: <20190121185651.6229-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190121185651.6229-1-dafna3@gmail.com>
References: <20190121185651.6229-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add function capture_setup that implements the
capture setup sequence.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 46 ++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 1383c5f2..d74a6c0b 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1833,6 +1833,36 @@ enum stream_type {
 	OUT,
 };
 
+static int capture_setup(cv4l_fd &fd, cv4l_queue &in)
+{
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
@@ -1897,21 +1927,21 @@ static void streaming_set_m2m(cv4l_fd &fd)
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

