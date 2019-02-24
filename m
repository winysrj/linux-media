Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C19AC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F08322083E
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 08:41:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVa8n2Jk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfBXIlx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 03:41:53 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39158 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728004AbfBXIlx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 03:41:53 -0500
Received: by mail-wm1-f66.google.com with SMTP id z84so5382953wmg.4
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 00:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=pVa8n2JkrJDhd3mKrTEqaDYfUFQ4mLR8mJrsRnmeqNmIhA/FXmGDw9x4pLXDMTWuAq
         vKvkkwLqMkaS2V3wA4e4cwVBWcJQAX16y32GxD+bNrkPH2NTET2XaOIjoFFS+hA1U2eu
         rd3RbnHLMTSP6SMApSXU9HVvgwOsmKIjtG6KKXFTIkWN8IO6/PzePfAqYh+upA3Ifn6V
         M5ChFuegGAqmwbCYA4YiDVcZhWWyh+t0Nf6aNSfgAGciUtPywNm0GIscmEDmrDjCaSwm
         uIedAUz+3OVlgiJ33FrTx2Xf5F43dVXm+OGDDKDdVi/ngWHxZJIcw03TrtxUerziFCuI
         4l0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NJuDvYOzvxWLj4xiAF59Sw+NAvCcwJCWwv5LqJCSCFI=;
        b=ACabNd/T1g26f0W8FpS7FGdw5QHEL1+W948+RZqjEuweXiPH/c4Qnog4+726xs+dcK
         zIr4IV7NdgnLKfb7KaR5tuW0VY5otTAu08heezxH+qLtXuG2KfQBS/brVUzJP8qKW4m/
         1BDaCnbLVPJxggazK0FWYSKgbFrcAEBKV4iVjMN3g0wk0MN4Z4vnBUFHtIMKNzbQsWZy
         OxICjtX3ViopwO/8kcnLUWnvLa6tgcN68Fmy6dIOzX/H/1UEWUXZ42GsatRSsJCdOK4q
         NrkABQvcu5K3tfMhxP1fLr4ohmcFgKJDuuw0MtVXjCcSrOcjA6uT+JXK/3bnEdr5PKpn
         mNkQ==
X-Gm-Message-State: AHQUAubM4siQcU6/yGczJu+3E1YQXuXykpVLZe0PsDaUpyzDmBpmpVxs
        QqlhUJC3J+oo1VD2buByJWBL3uOSxqg=
X-Google-Smtp-Source: AHgI3IbVBFjddJCulfAjZx80+UH5H9R/mKyZisqhJyI/cA5YBDmtO3Xy33yryU2bI5KormhkpFwUfA==
X-Received: by 2002:a1c:6a18:: with SMTP id f24mr2257721wmc.115.1550997710791;
        Sun, 24 Feb 2019 00:41:50 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id x24sm6837465wmi.5.2019.02.24.00.41.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 00:41:50 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [v4l-utils PATCH v3 6/8] v4l-utils: copy fwht-ctrls.h from kernel dir
Date:   Sun, 24 Feb 2019 00:41:24 -0800
Message-Id: <20190224084126.19412-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224084126.19412-1-dafna3@gmail.com>
References: <20190224084126.19412-1-dafna3@gmail.com>
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

