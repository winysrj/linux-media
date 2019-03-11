Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B52C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 492B32084F
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mOGHYdon"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbfCKPgS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:36:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40198 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfCKPgS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 11:36:18 -0400
Received: by mail-pf1-f194.google.com with SMTP id h1so3953320pfo.7
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2019 08:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=38Ct61JAwOp1T0/dv5d7Rwd4z9DTD4VC603kU20nOsw=;
        b=mOGHYdonDEAc3NS6Smty/R1/TAHsdAljLaiHWZN4pAYN5lb5zYUYR8m8UNTEj9+5x2
         sIb2tsgdeewDU1Q5u12jnb+0rJB2SUoqReQagZjbwmZ20eKpOCC8uLZh6LDzCSC8DCYe
         kEID7jgjXIo6XEwiDNoaYSWRQdrT0lfMPnJevxTvSL/ZUZfAwV+F1O3Rd2IHsN61T8ZT
         K5NP5HLUZmyoVy4pMQ8alfpGDbdOZwz+qAFCtJlcGZPSUTK9bGPP5I9YyXw+7ILv5yRm
         It0sriqeLlhqhxVVgrLPTnEG21lCy4iRNvD1OX+97soO8PXb1xVASBgpcyBjrMyUSuOd
         cpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=38Ct61JAwOp1T0/dv5d7Rwd4z9DTD4VC603kU20nOsw=;
        b=JVG5o3b/Q4TlH0+DHnnibCXxyt6ktXmYsJTQJMkgiR5kuqqAaJNhExFTwfQdoUOjyE
         w6LIqoNqH0DYzKgdxdPSTZAtE35/OfGksulAIk1f1He+izk06AAbLGTPTeKxHy7HLb3r
         mymwUo1bo2iwGJU1/qIjWQkFnW8eOCdoIcYBjFtfQ4DRnoz3nYhxlACNiHGpMRSRHdjC
         hcMHNxDaHuFqZkPmZqHStIQRQxonjgtOT1OX3ahOdfw/+2o/LT2+M6eXcOin/pLXf4fz
         HtErMoel0nEJ+mnRjgYPXiwvXBR2gUDOdCY1X+sez/+2EmTzjafkkA/2ib5Qq0KYOE2k
         66nQ==
X-Gm-Message-State: APjAAAVWo9r40K1iJ9TTzYKJiKbbPYxPLoLZFQwuoNOgCQlRakwIXZWu
        eOJA5sJdjm5ra/1irNSwv7P6nOzz
X-Google-Smtp-Source: APXvYqxpTSB1uZakwbTAY3KNQN/qUF3G1gdsQawE9Hkgvov4IOBS6XeSjwGQFDv3iI3Pi4FP5Hg3NQ==
X-Received: by 2002:a17:902:834b:: with SMTP id z11mr34852325pln.257.1552318577599;
        Mon, 11 Mar 2019 08:36:17 -0700 (PDT)
Received: from localhost.localdomain ([240f:34:212d:1:1b24:991b:df50:ea3f])
        by smtp.gmail.com with ESMTPSA id f28sm10428364pfh.178.2019.03.11.08.36.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Mar 2019 08:36:16 -0700 (PDT)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 0/2] media: ov7670: fix regressions caused by "hook s_power onto v4l2 core"
Date:   Tue, 12 Mar 2019 00:36:01 +0900
Message-Id: <1552318563-6685-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset fixes the problems introduced by recent change to ov7670.

Akinobu Mita (2):
  media: ov7670: restore default settings after power-up
  media: ov7670: don't access registers when the device is powered off

 drivers/media/i2c/ov7670.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4

