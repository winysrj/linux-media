Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE430C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA8D20684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:18:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LV7KXQiY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfCFVSI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:18:08 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46394 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfCFVSH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:18:07 -0500
Received: by mail-wr1-f66.google.com with SMTP id i16so15023741wrs.13
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=LV7KXQiYbKJUqHzmlquFeujVFarqT/j0ox6Sluh/KNQBNZkfa1Z+vdkk2WNkx92RNx
         Tg+/2qo4k9K0JIKvkViIXu+up2hTHK8kw2HvVMASkP4LqOoW9NAqgWfXvrbCf+X+7AfD
         /7oJhcWtUBohe3mXiMGIH3+g6xvTKhI3oLFQdaC4Zed3KV6ULipf6c0tjCg45KLPhhVE
         ptPBp+8yR1D6905jXWf5iMQL1DM/HIStQbxXTRGxwfmC5LAGNAYXJzTRfzfpwvTNmtQc
         27NWTtyYmL2t+bsRFgO7NZnQmqFg8hGWFUR4B3CMW/rOKFSPMfEjERmnoamNQdgUEWlP
         138A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=CjLRrAK62efwjvmlKs4h0F5vfmtUTqHnRE61XXTV08UQt4neaiwErBH/nXRmeFc1LU
         ayOiwX38+XwXIZ9BtqClauqBtPBfA8W/OFnnEooCpFzBAxVPRrpe2zwcl8iQkSlyfhHT
         vYPufHrbFIyJFu3RqukzDs7necckBNj4G1sTrSXZNyfejoEYSVkbackk7fO+JEnkXDGp
         6M1i8++ZiLngJ5kZsrc4hhp/4w9AzFqyijvO1qLMcfPXH/1IAovPv2FpRMx2pwXcsjfs
         k5hIi+n08IfWC02a70XWRb649warnV6Ww9jFSYdP8XpHMo9xafXNh0IdeYv+4DDph4kU
         tzhg==
X-Gm-Message-State: APjAAAWrgYVcf2klqqV9lp4JEsb8lmdBsBMwMMqp6gKbPSbh5OZ3J2yF
        yR20std9AGcxt87CM+00A9H7wJnSDuw=
X-Google-Smtp-Source: APXvYqxv3iMwUITZTbvJEimtD30KQyeeFweblitIBAr32r9mbasojYa12+C8P42YC3ZIFoFVwvdkxQ==
X-Received: by 2002:a5d:4585:: with SMTP id p5mr4750831wrq.178.1551907085261;
        Wed, 06 Mar 2019 13:18:05 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id c2sm5252495wrt.93.2019.03.06.13.18.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:18:04 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v5 4/6] v4l-utils: copy fwht-ctrls.h from kernel dir
Date:   Wed,  6 Mar 2019 13:17:50 -0800
Message-Id: <20190306211752.15531-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211752.15531-1-dafna3@gmail.com>
References: <20190306211752.15531-1-dafna3@gmail.com>
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

