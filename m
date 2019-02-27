Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE9DC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 07:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE574218D9
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 07:08:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EhlJr7NF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfB0HIL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 02:08:11 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37306 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfB0HIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 02:08:11 -0500
Received: by mail-wr1-f67.google.com with SMTP id w6so13366609wrs.4
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 23:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=EhlJr7NFBn5NYhw9sXk7y9gLsYE/N76oNdPaPzHoy7z7pd3uKJm2TbhKz0/X9f1x40
         k9TnplimYW1ZG07LmBaDtSlxoYbp9e3eXwJvUuKN+3CIaA0mzr8Kp9ZFhkC7/G99Qa/X
         +JV70BNEYewtuYQNbsNS9+s8vAToaYluwz6qsuIrUET/iP2ANoO0ssMCunngXt0snLAL
         oRSHGzyN9+1q4JVuV1LZISKip+kBnA/JMZbJyWyvXyfDWR5fs7XZocV7s57hVifinIDB
         yhvgAlUDDgYWZEmuIDGhRTcbHJSca84ZEPMGysDFDndG8AT9/0n+1dKUxR6rL9mD5/1k
         ZnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=gH87nWK1hE3Dv6PeIywvLlDFG5os0wvofI69Vaw3GLZgVbllfgw6uWrWsA2EB2xpjx
         FXPxKrPar+nR684dyl26TcjetHQaHbAUMVokUGs0+jkwZC6cX0Qm8yzwLIRO7opeXRTn
         yqiJv6SEEV/U8OUZo1vj1rGWFnyrOB7qXomyif6JXnPefdqlRArM1sBefKKDk9Ko49FS
         ez2kA4kyKFdJG7u99lkRKf7kLyH6x7LozphVP5wmcr2o8jc78043IFQ1a2TAbYvGvBtI
         q+5YOVHRNVlioSVDImEiWTO9Wtg+NuFSSi+2fs7ti8oFbNZgPvykZMarWu46kPqHS+ZV
         BqZA==
X-Gm-Message-State: APjAAAVhOS5x7ZNqRrfYuxGBy7vDDgQenfwP/Qt8j6+Vjm7NYbs0SZu1
        nbGFWZ3QtkOU+3BIPk+WBMx9Kthm8Lg=
X-Google-Smtp-Source: APXvYqzTR+UGscSOcJ7iJw0T8qr4pZzA11UUs571i7uYU9HIrBXGqE6bb/7f82pBt81980gTxA3avw==
X-Received: by 2002:adf:dd12:: with SMTP id a18mr1075156wrm.4.1551251288724;
        Tue, 26 Feb 2019 23:08:08 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id i10sm41984852wrx.54.2019.02.26.23.08.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 23:08:08 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 1/3] v4l-utils: copy fwht-ctrls.h from kernel dir
Date:   Tue, 26 Feb 2019 23:07:55 -0800
Message-Id: <20190227070757.25092-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190227070757.25092-1-dafna3@gmail.com>
References: <20190227070757.25092-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

copy fwht-ctrls.h from the kernel dir when
running 'sync' and add typedef for u64
in codec-fwht.h

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 Makefile.am                   | 1 +
 utils/common/codec-fwht.patch | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index b0b8a098..8abe4f94 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -52,6 +52,7 @@ sync-with-kernel:
 	cp -a $(KERNEL_DIR)/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c $(top_srcdir)/utils/common
 	cp -a $(KERNEL_DIR)/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c $(top_srcdir)/utils/common
 	cp -a $(KERNEL_DIR)/include/media/tpg/v4l2-tpg* $(top_srcdir)/utils/common
+	cp -a $(KERNEL_DIR)/include/media/fwht-ctrls.h $(top_srcdir)/utils/common
 	patch -d $(top_srcdir) --no-backup-if-mismatch -p0 <$(top_srcdir)/utils/common/v4l2-tpg.patch
 	cp -a $(KERNEL_DIR)/drivers/media/platform/vicodec/codec-fwht.[ch] $(top_srcdir)/utils/common/
 	cp -a $(KERNEL_DIR)/drivers/media/platform/vicodec/codec-v4l2-fwht.[ch] $(top_srcdir)/utils/common/
diff --git a/utils/common/codec-fwht.patch b/utils/common/codec-fwht.patch
index 37ac4672..ad27b37a 100644
--- a/utils/common/codec-fwht.patch
+++ b/utils/common/codec-fwht.patch
@@ -1,6 +1,6 @@
---- a/utils/common/codec-fwht.h.old	2018-12-29 11:23:58.128328613 -0800
-+++ b/utils/common/codec-fwht.h	2018-12-29 11:24:16.099127560 -0800
-@@ -8,8 +8,26 @@
+--- a/utils/common/codec-fwht.h.old	2019-02-23 09:38:59.454065366 -0800
++++ b/utils/common/codec-fwht.h	2019-02-23 09:40:44.007803414 -0800
+@@ -8,8 +8,27 @@
  #define CODEC_FWHT_H
  
  #include <linux/types.h>
@@ -21,6 +21,7 @@
 +#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 +
 +
++typedef __u64 u64;
 +typedef __u32 u32;
 +typedef __u16 u16;
 +typedef __s16 s16;
-- 
2.17.1

