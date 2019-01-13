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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD455C43387
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70AE420873
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 23:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBUFW18+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfAMXip (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 13 Jan 2019 18:38:45 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:37733 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbfAMXio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Jan 2019 18:38:44 -0500
Received: by mail-io1-f68.google.com with SMTP id g8so16358787iok.4
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2019 15:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WKYZk2moHHxU3wNmmecPfcvtPcR+l1prYW/4kiSXrAs=;
        b=WBUFW18+2MTkUbqA//QdN+Smc2B16Be6QQseX62wTEUD/DbuIoImqOYljsdp4sEPUk
         I3VL+ir4JlW/i9YJBFcRrknkMoiL2Bb3n0iFPbpWi4Rql9+OSM9P3n6D0aUtitY0oapx
         yx7FekFruq/7mPqGQyjp4wPxuVSCHsmtXjsIWsGUNCQDkEqaV/3s7YMvAkDCKCqqnnWn
         /JoYSuqyS5RnYht56DRnsDl3k63qzFOwHmKK0WFOnp+gdl/T2vuZXo9AUirNCNtosEAl
         537lQR1WNQTc34qcgOcsPPhxq6IyFxUuF6BwDWnxi6KaM8sslAms4POMmPqRQbTG1cGS
         +s6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WKYZk2moHHxU3wNmmecPfcvtPcR+l1prYW/4kiSXrAs=;
        b=OLq2RGmVCZzmgcy3odnRTKileMzepezrFKDErNgyQRzdsvGxLuYYbhuBAUopr3gO+C
         Q77lmgBcz60PxZSB+FzPfF69KKu4ctMILkejV1sSajWNPWyGE8R6GMqV2UThvO1dLKqL
         wV03EdrSiQXUf+GkyFZyVet8TTkSwdg0VMwmn/I5t1l6+sw1OrRZplFlzZcmDN83pP7A
         wJpLPtgKt0ac1r8+0TUYF3V5XmssZAQLGwmXoAO+k9bJFFmK9BncFYE5sOg7FuhUvyyA
         ROsi86S5MLNG0HbtWdlDulGfdy2LooxEqgjMaPt5PyrYQ1/NENKSFqZQmbkZfOYEmASu
         UO9A==
X-Gm-Message-State: AJcUukcvUg8a4EIqbLnkgxRIH5NjqR1nv9a451xekEJBb5TJn+Aoxee0
        Lk1Afi7WkQAO0ZhySYZBEtA=
X-Google-Smtp-Source: ALg8bN6gOLTOX1Dmk9QqR6NyXtZrj0feNkxL1epBy4oaSEBR1ToOrA3S0HDSd0fHMJMoZ/qVh9vcbA==
X-Received: by 2002:a6b:b7ce:: with SMTP id h197mr3168985iof.274.1547422723735;
        Sun, 13 Jan 2019 15:38:43 -0800 (PST)
Received: from dragon.Home (71-218-4-112.hlrn.qwest.net. [71.218.4.112])
        by smtp.gmail.com with ESMTPSA id t70sm3132285ita.17.2019.01.13.15.38.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 13 Jan 2019 15:38:42 -0800 (PST)
From:   james.hilliard1@gmail.com
To:     mchehab+samsung@kernel.org
Cc:     linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        James Hilliard <james.hilliard1@gmail.com>
Subject: [PATCH zbar 1/5] Fix autoreconf by reducing the warning/error checking
Date:   Mon, 14 Jan 2019 07:38:25 +0800
Message-Id: <1547422709-7111-1-git-send-email-james.hilliard1@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index a03d10e..6476a20 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,7 +5,7 @@ m4_ifndef([AC_LANG_DEFINES_PROVIDED],
           [m4_define([AC_LANG_DEFINES_PROVIDED])])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
-AM_INIT_AUTOMAKE([1.13 -Werror foreign subdir-objects std-options dist-bzip2])
+AM_INIT_AUTOMAKE([1.13 foreign subdir-objects std-options dist-bzip2])
 m4_pattern_allow([AM_PROG_AR])
 AC_CONFIG_HEADERS([include/config.h])
 AC_CONFIG_SRCDIR(zbar/scanner.c)
-- 
2.7.4

