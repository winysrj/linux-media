Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C64C636A1
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93F5020880
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 11:15:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IFgmdMED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfATLPf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 06:15:35 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46379 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfATLPf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 06:15:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id l9so20003193wrt.13
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 03:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o1d4iX6rbOMXHfqtnOjgesiwaMW6UYez6BTKR1fazd4=;
        b=IFgmdMEDXUoEAumLOthHtAwponONbStPXlIvjwaRDkkgkyAx+mHnhVCZErP92bz+K1
         0S5g6CY+9NtH7AgDLxD2zSfN5VN/bMskveVMfBvoIyS3popb9Acwfajl5Dc51oad6ZT/
         ANzqS+yyYJQLQa8h3PwNoGlFtXWtkl5vASPzIpbGtia1IImc4UTHcHAtMfHcU4G7rowu
         3uVDgcn7sPyHRqHHcgB+8yFX5eypDwmgX0atsJSDUASj3XNNv6Ot+aAwCcMR++WuWCgA
         d6EeapORSwj0nocI9k6TVDr8J8zuQ3FYWtRdDYpI4QAxMRTXbik4n83abmgbuX+AlMUV
         wGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o1d4iX6rbOMXHfqtnOjgesiwaMW6UYez6BTKR1fazd4=;
        b=fk6gVPZW06ncT4XTjqoU13ILtGZlq9w2TAFH+kGSKwSMIwao5LITlMaRTh/zuMG+tq
         uAnCa2H+K8xA05ixoockZt7D2F4vWlBJq8cjegv+hAxhZG2180imyzQET8c6r2h989qZ
         Y9BUDV91k27hteXamV8DNSjbuMPby6wXMacNB4Stq1DJz5LbxbIiWhOikVgVVEWLFuo/
         O7Qm3EnyjXChvOuc8ZjnrH9eX9UMTYdV44dXtBtjCmQboXbPnpItqafT/P94DqQtKqXF
         KTDTvqKrVuC2lt11Cbp+HAWjNKStwFqkOpTMMQyr1rX6Uqm6TXeNl20ksdeb7RCz+Q86
         q8vg==
X-Gm-Message-State: AJcUukcDyjPU+V9TimjQk4RPN88teOT168AQNxNbyXF2l77YGGZv3LL4
        PVP0qOfT45xOQ9GfPuommbFmW+ErtLM=
X-Google-Smtp-Source: ALg8bN4Fl+is4uBrd62wyMgbGh8eX6qM1LABmnTrrRr5ff+CPEPRxpCAlpl+z0tTl2suERGfhXvKQw==
X-Received: by 2002:adf:8342:: with SMTP id 60mr22329895wrd.212.1547982933105;
        Sun, 20 Jan 2019 03:15:33 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id n11sm28281796wrw.60.2019.01.20.03.15.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 03:15:32 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH 3/6] v4l2-ctl: test the excpetion fds first in streaming_set_m2m
Date:   Sun, 20 Jan 2019 03:15:17 -0800
Message-Id: <20190120111520.114305-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190120111520.114305-1-dafna3@gmail.com>
References: <20190120111520.114305-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

test the excpetion fds first in the select loop
in streaming_set_m2m. This is needed in the next patch
in order to dequeue a source change event before its
coresponding last buffer.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 3e81fdfc..fc204304 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -1953,6 +1953,19 @@ static void streaming_set_m2m(cv4l_fd &fd)
 			goto done;
 		}
 
+		if (ex_fds && FD_ISSET(fd.g_fd(), ex_fds)) {
+			struct v4l2_event ev;
+
+			while (!fd.dqevent(ev)) {
+				if (ev.type != V4L2_EVENT_EOS)
+					continue;
+				wr_fds = NULL;
+				fprintf(stderr, "EOS");
+				fflush(stderr);
+				break;
+			}
+		}
+
 		if (rd_fds && FD_ISSET(fd.g_fd(), rd_fds)) {
 			r = do_handle_cap(fd, in, file[CAP], NULL,
 					  count[CAP], fps_ts[CAP]);
@@ -1990,19 +2003,6 @@ static void streaming_set_m2m(cv4l_fd &fd)
 				}
 			}
 		}
-
-		if (ex_fds && FD_ISSET(fd.g_fd(), ex_fds)) {
-			struct v4l2_event ev;
-
-			while (!fd.dqevent(ev)) {
-				if (ev.type != V4L2_EVENT_EOS)
-					continue;
-				wr_fds = NULL;
-				fprintf(stderr, "EOS");
-				fflush(stderr);
-				break;
-			}
-		}
 	}
 
 	fcntl(fd.g_fd(), F_SETFL, fd_flags);
-- 
2.17.1

