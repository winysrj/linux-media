Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C887BC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973D9206BA
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HgamxFEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfBXIlt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42120 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbfBXIls (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id r5so6619742wrg.9
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cfjeHo1iFRc8mnM48I4Vxv7KgBP6gIHg/llP/xNtlhY=;
        b=HgamxFEopJwRq/A7AAU2OSpato/E13ls40XEr7yduf8J63/h370yaic83vhdZWxOod
         lJ/GAeNn3JQpwjMVptDnzDsI4Y802wOsHc/mgX8VSP5Js3f0mkyxa/GA8BdBVmzzjV4S
         LUUJZ4MiVDcsN4CWKJhruJ01A1FG++Vea591GhqWrJHwYtH0rR2zAM6ewMyMhz7gZfRM
         rX9Si3if0B6XGQfbAL+xUNf6Q4VhfQoWC0LmS5X6miEtuhCLTMqzpmDOS1p2acbHwOpl
         wfNbozolsMAP4Vvv1FFu1SBfYf+9zhAQZJSZP+eaULh/eauj3HO4YrAKsmtiai7h8WGw
         crCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cfjeHo1iFRc8mnM48I4Vxv7KgBP6gIHg/llP/xNtlhY=;
        b=AVafTKS2iC3qXMoAzGTsoMyXyf2D2NlyclQUK/kfZuRGJP7FgCpyplpkwNMVvtldvu
         IriFdKTvFGs89kFeADomgy186ZzVP5fdFsmXEg81sZUu6LOcIujL2hrj7bB862O00daI
         Wjm4AYNrFr2R9j/09ycjSWH82M3vnInlu9VONJQQs2L3tztFl3a3DR20AiQTA2ZbaivU
         hTUQe6QIdVUtkPidt1ouQOQ8kZufFYs2WiAnpMpESR/TJpA1aQjnivTPzW8y63UL8LCP
         rch54FUeUXhynnAsxeAIrtG4z/cmHSoc+6Cdw6JmduTojMT4KEdG6Mfen4gqgkccnstZ
         IUXA==
X-Gm-Message-State: AHQUAuaDnmU/KQhtdrDKvIsLlTEwzs5W73n7c8hxvosVmcsEkVT+Nhe8
        eLoy7ghUIVjeeId1efGOqTtJYqGJI3A=
X-Google-Smtp-Source: AHgI3IbdY1ZG8XzepZWJOxlUBzHcVh2RgUvwh2f52A3UC463sAy23KTHmkhMUM5+XPE92lWWhBdxvw==
X-Received: by 2002:a5d:4a8a:: with SMTP id o10mr8678666wrq.189.1550997706742;
        Sun, 24 Feb 2019 00:41:46 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:46 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 3/8] v4l2-ctl: test if do_setup_out_buffers returns -1 instead of non zero
Date:   Sun, 24 Feb 2019 00:41:21 -0800
Message-Id: <20190224084126.19412-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If 'do_setup_out_buffers' returns -2 it means that
it finished queuing all output stream buffers and
the program should not terminate in that case.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 6f4317bf..d023aa12 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1823,7 +1823,7 @@ static void streaming_set_out(cv4l_fd &fd, cv4l_fd &exp_fd)
 	if (q.obtain_bufs(&fd))
 		goto done;
 
-	if (do_setup_out_buffers(fd, q, fin, true))
+	if (do_setup_out_buffers(fd, q, fin, true) == -1)
 		goto done;
 
 	fps_ts.determine_field(fd.g_fd(), type);
@@ -2013,7 +2013,7 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 			goto done;
 	}
 
-	if (do_setup_out_buffers(fd, out, file[OUT], true))
+	if (do_setup_out_buffers(fd, out, file[OUT], true) == -1)
 		goto done;
 
 	if (fd.streamon(out.g_type()))
@@ -2250,7 +2250,7 @@ static void streaming_set_cap2out(cv4l_fd &fd, cv4l_fd &out_fd)
 
 	if (in.obtain_bufs(&fd) ||
 	    in.queue_all(&fd) ||
-	    do_setup_out_buffers(out_fd, out, file[OUT], false))
+	    do_setup_out_buffers(out_fd, out, file[OUT], false) == -1)
 		goto done;
 
 	fps_ts[CAP].determine_field(fd.g_fd(), in.g_type());
-- 
2.17.1

