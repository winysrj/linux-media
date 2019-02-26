Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6C3C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 19:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9B0B2186A
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 19:29:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nl9R7iKk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfBZT32 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 14:29:28 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34773 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfBZT32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 14:29:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id o10so2835664wmc.1
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 11:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=Nl9R7iKkh4kKFhQ6wTQMfCeBd5ZTiw/RKYvRY6Lsb2m5iq3N5gNBBdoOqrWdInNeUW
         pT/JW2aDlEP+ns7qh/vZCMNA8spsdteFxSWjtG9sKMiacXonVzWlfKOZ+7awPjXVuVfP
         NHRUZJBjVVs2sTjHLk3l6ACLbUJQIPsomid0koGvukZCsAvC23IScj3V5j2lu2co0RrR
         Rj798UYiaI5mrv8U5Teea+dVynYtuG771zPp4p8uffAWegnNY9+A01yi0s3At9mkF1tT
         3cy11VFVLvdGDAAVzQjxctkE7pNCROh6Jyq91QAqPO0qmOywVl/TcEnzMOU9+/ah+V3w
         UNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=QFbnWlMUYM0GUIncqOYSO/g00Px4xn2H7yq2z1qtVJ5qoVaE8giwWpqW9OyuCzIkES
         W4CMJyg9iEu/Gm6iE8xdqgDNVrZC4cmApoxdEA+U7B9K0QC2BL1jzGoLW8j9Gq6uRIlF
         7bE1dZ7P6H8w5Gs/EBhZfHA5+JXiAyhIKi/+rvbZ2Ryy5A4qlUkNhnDvkxLxZa4QqqW0
         zQI4Fd/eSlosFjpouDu61KyOMaSUy21hyX4KpUjxFQhSjNmggt0wWU16V8J7BCiIz8bU
         gnt0Y7+M4RRn3jRjg3MVAkX3Qg2YYmpYRLzjNVKq40TY9PGZ6PwN35PSsAP/FA2XCQAq
         IE8A==
X-Gm-Message-State: AHQUAublzXuiHZvmD86h5EfZZLb6nofh7A+vclV52TXzt5xVtl/cSFcE
        pehMxizSDOExQrEDVcndKg4xQ7voPGE=
X-Google-Smtp-Source: AHgI3IafdGov7HG5nj72kztn1i99HEyYMnFmXO5xa+XA8WOtGXCI5RC9t7XuFuhgs1SzM0D/poX7AQ==
X-Received: by 2002:a1c:cf43:: with SMTP id f64mr3464542wmg.61.1551209365502;
        Tue, 26 Feb 2019 11:29:25 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d21sm40176202wrc.44.2019.02.26.11.29.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 11:29:23 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v4 1/3] v4l-utils: copy fwht-ctrls.h from kernel dir
Date:   Tue, 26 Feb 2019 11:28:58 -0800
Message-Id: <20190226192900.86461-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
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

