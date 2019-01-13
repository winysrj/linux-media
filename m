Return-Path: <SRS0=qapk=PV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA6EC43444
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B109720896
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="quhq32qw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfAMXis (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 13 Jan 2019 18:38:48 -0500
Received: from mail-it1-f171.google.com ([209.85.166.171]:37291 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbfAMXir (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Jan 2019 18:38:47 -0500
Received: by mail-it1-f171.google.com with SMTP id b5so10035189iti.2
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2019 15:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/uVFJQGsnmnDv8WLA4zhYIeTT5gK7EM24XblmbsRtOA=;
        b=quhq32qwqiD9qVY99Iva/cacbMNuvWJCTUlABaGINHrjeleJv2iPKRNW2X1xiQ8H5c
         AzwMcMv5OI/bXLwSvv0U/r/lg3qrJfQP5Rfrwn75RkVE5+BDLllsU589twPNqYMZLcqh
         rHuth1xyUPCw6imV9kpt2xqPDGYDDfuX4UR9WeX2S101psdHXuKhmil2fhSXEdS0tHSi
         RxcmAjBv405YUpaueS3goCPf/2KrOvdB89VYXjtNIr4qtR9qt1ekCg++R/8RmRcH4+lR
         bMYAGb3Fg18l8jp/bkvadQCc2aYRV7ibps+9sH4JkcBvkQZELu+znQqZq6qd7rjxU+m+
         ZGkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/uVFJQGsnmnDv8WLA4zhYIeTT5gK7EM24XblmbsRtOA=;
        b=ugj+7ZwmyfSVrtrwGSnQUnCmA2Lelk5OzNcb1fxlMa9bTJuqt0odSGacgtkjaHK1QS
         /gZGvm/nExXujZVBZnE1DII97AAzR+ULp32caFP3PQxgqpLiqPiqe07BC/iR7lvB5PeG
         Y2P/y/H//tYIJ6BXOlSVerjFPc96ePtKbgyKVPsylK5DInVCpkLWTLnlq1i5hHXaKRVh
         R3BeMEMdPHCrE6wPC/Pz+wn4HXcxiwioPAr1SNAlFckbzT+cWTs+GmKUgBAKhz97wTSP
         XodDtqsLE1scKig6zhFxOtWJts/9852AMpu2CpzWRecoTFOabpQLmi+k9K1Pf2luCxHx
         wbzg==
X-Gm-Message-State: AJcUukf0E+R+FK4FgQFvoeRPtwNeYHElqug/GlXlwFt/5xDyj55oAnON
        NDFTMIUju5SXy6uy4763MpQ=
X-Google-Smtp-Source: ALg8bN67+bGrwTEPUQa/qMLD+kL/cTZZlDvlylBIQ4HTbb+evhmhIaXOuGSYCbmgdQ66bZl32vh+mA==
X-Received: by 2002:a24:4cd2:: with SMTP id a201mr6345411itb.172.1547422726502;
        Sun, 13 Jan 2019 15:38:46 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id t70sm3132285ita.17.2019.01.13.15.38.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 13 Jan 2019 15:38:45 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 3/5] Add --disable-doc configure option to disable building docs
Date:   Mon, 14 Jan 2019 07:38:27 +0800
Message-Id: <1547422709-7111-3-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
References: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: James Hilliard <james.hilliard1@gmail.com>

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 Makefile.am  |  2 ++
 configure.ac | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/Makefile.am b/Makefile.am
index df3d79d..b4cae8a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -45,7 +45,9 @@ if HAVE_NPAPI
 include $(srcdir)/plugin/Makefile.am.inc
 endif
 include $(srcdir)/test/Makefile.am.inc
+if HAVE_DOC
 include $(srcdir)/doc/Makefile.am.inc
+endif
 
 EXTRA_DIST += zbar.ico zbar.nsi
 
diff --git a/configure.ac b/configure.ac
index 6476a20..afccc3a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -177,6 +177,15 @@ or configure --disable-pthread to skip threaded support.])])
    AC_DEFINE([__USE_UNIX98], [1], [used only for pthread debug attributes])
 ])
 
+dnl doc
+AC_ARG_ENABLE([doc],
+  [AS_HELP_STRING([--disable-doc],
+    [disable building docs])],
+  [],
+  [enable_doc="yes"])
+
+AM_CONDITIONAL([HAVE_DOC], [test "x$enable_doc" != "xno"])
+
 dnl video
 AC_ARG_ENABLE([video],
   [AS_HELP_STRING([--disable-video],
@@ -602,6 +611,7 @@ echo "please verify that the detected configuration matches your expectations:"
 echo "------------------------------------------------------------------------"
 echo "X                 --with-x=$have_x"
 echo "pthreads          --enable-pthread=$enable_pthread"
+echo "doc               --enable-doc=$enable_doc"
 echo "v4l               --enable-video=$enable_video"
 AS_IF([test "x$enable_video" != "xyes"],
   [echo "        => zbarcam video scanner will *NOT* be built"])
-- 
2.7.4

