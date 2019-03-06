Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C537C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 281B120661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kjzKhUb5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfCFVSD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:18:03 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34178 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfCFVSD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:18:03 -0500
Received: by mail-wm1-f65.google.com with SMTP id o10so5312580wmc.1
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QlpOK6oJV8oeAwbvelcizyRnTulOUmA1Vc7OVMdeGbw=;
        b=kjzKhUb5ArxHajVcLgPkvtV85ISXItpsuZI97q94i+NS4TMHQKSyg2Z+0B8V7hhlH9
         br5icVmjkg/tRFDG0t0Xc2ZD4pST4jcpVQrRLpP8lC1C8S1gw+I2SRlhLJm3BOEQeFIz
         /ROvLRoP1Hm0R4W04QbcRcC68jUBjyFtqmUyEune0YUfRdQimCDQK7vWvbo4TP2ZQzUY
         EzNYm+eKpNUEGi5Cr9Cg5XcQL1Y+FoML3yV6glY4xYlqed/Fnsoyb0kIt6fFyUU9F7c0
         vSmbbgBCsZzn/pyzRHoac5b14ToReOxdA2SV5+swTJV9Jqm3D3gE/rq0ttSNDkB+7egz
         S41Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QlpOK6oJV8oeAwbvelcizyRnTulOUmA1Vc7OVMdeGbw=;
        b=PxmLH7EET0gWl4qUnvOenJ6j1RrprvVgbIOoK/M+jyT4J+4DaMhwdVmvpFE63zw9ZQ
         feGcaFDYcJ9Wd4rOMv1Zk3guLgSwrRLo/ZaMRt1NjVjxUAkWFrq58Q3/S6g86vMxvQd4
         hFpA1NtgYNs+4DSpiXbPKgv8t2M52q+Z1C8EkYEhGmIB8fNT2NSOPuMgiudINsOSTe4y
         hz8ddToP2g7/tzYNF3mC8OuNqSnyDRxhaDenBC2gOBMFMGZQo8U7y/nJm2gx9exCAoEO
         GOzLtZ76/F4m8zO1z88gkbp/5tCo0jXXMemooHBPbPAr63tx6fSbHGHyx7vuYu/mg0FK
         0aMQ==
X-Gm-Message-State: APjAAAVRdOw1jlV8YDCNDVSDGhY9mwohn5tbCuIAKCNb2s2Zr/mh6+Lr
        likzMx/GFT+chqRP6itwA7UPORa56/k=
X-Google-Smtp-Source: APXvYqykJnkx87TNkSRpWM8n2GOtqRF7lKVCThMYNqo9HdkVhH9ZyXzz1y0331sz1ozPJ4bV7LuzCQ==
X-Received: by 2002:a1c:b40b:: with SMTP id d11mr3848796wmf.80.1551907080604;
        Wed, 06 Mar 2019 13:18:00 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id c2sm5252495wrt.93.2019.03.06.13.17.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:18:00 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 1/6] v4l2-ctl: in streaming_set_m2m, close file pointers upon error
Date:   Wed,  6 Mar 2019 13:17:47 -0800
Message-Id: <20190306211752.15531-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In streaming_set_m2m, make sure to close all file pointers
and file descriptors before returning.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 0eda8449..ee84abbe 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -2141,18 +2141,19 @@ static void streaming_set_m2m(cv4l_fd &fd, cv4l_fd &exp_fd)
 
 	if (options[OptStreamDmaBuf]) {
 		if (exp_q.reqbufs(&exp_fd, reqbufs_count_cap))
-			return;
+			goto done;
 		exp_fd_p = &exp_fd;
 	}
 
 	if (options[OptStreamOutDmaBuf]) {
 		if (exp_q.reqbufs(&exp_fd, reqbufs_count_out))
-			return;
+			goto done;
 		if (out.export_bufs(&exp_fd, exp_fd.g_type()))
-			return;
+			goto done;
 	}
 	stateful_m2m(fd, in, out, file[CAP], file[OUT], exp_fd_p);
 
+done:
 	if (options[OptStreamDmaBuf] || options[OptStreamOutDmaBuf])
 		exp_q.close_exported_fds();
 
-- 
2.17.1

