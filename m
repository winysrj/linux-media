Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38F83C43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21592075C
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 08:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pf5WSknr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729607AbfAIIqh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 03:46:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37104 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729284AbfAIIqh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 03:46:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id g67so7203251wmd.2
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 00:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=duINZFYm4BQK256p5i3sepQxzQSlAA8VGGfP4dywyRs=;
        b=Pf5WSknrLeQPt83sGybaf+20HVvbzirwrlDARJaT3Cl5UN1CUGsprnyFGibLu6HY8g
         3VHxZeTqkY1ginOpg61but2kw1lNpzhiLNSIuFidXXdXq+CyK+rldb6ok8GYcLDWJ+ix
         pElRNljfzR/IPj/7MMvkE/ujoBGOX/LKKoT+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=duINZFYm4BQK256p5i3sepQxzQSlAA8VGGfP4dywyRs=;
        b=RHCGxpve+lhdE06cKAkfIZhb02Cna3l6zC88uLUXhNxaGAJ2QFcvVLneUWyAdjAeie
         S064mjPYQ2z59He+aEefacTJ+MzjXO7+7EbtxOmwKY+A3coeWrZYm1UCBugagQIZU2k3
         Ktb3fGKZPhYS0gbjUk5kjxVCisKUeQZ9mlnsc7nFUtKi4IdB0qaRwB/juDP5UtOAu4pG
         1/Q3NDVQna349rKPmaxQuBqcxG5gPBHb2YnHM/s6IJ3CQD9x3MTx83ta+0hoVUXa/Abg
         gxBguvKVBHqi+YFlIL0ggTAt52ENUy+aAdgMBPc8ool6qAEeGFZ8FfrqogMoZmpmsrbS
         oo/g==
X-Gm-Message-State: AJcUukdaJ6mNkV9vpCl1oviqQ3FJZY+qSGFQiqL0kgKSfma3JHKOONTl
        7UNFVLp6I8jdzkFqgSMkeFi5DmOJz2A=
X-Google-Smtp-Source: ALg8bN43qmz9Hriur53NkTCfftE0zrLMmd0cV2gIklZpEcjbd3VxJmgdnKX0+T8rEmobp7R3c6RsEg==
X-Received: by 2002:a1c:16c5:: with SMTP id 188mr4788677wmw.69.1547023595292;
        Wed, 09 Jan 2019 00:46:35 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id n82sm12776455wma.42.2019.01.09.00.46.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 00:46:34 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 0/4] Venus various fixes
Date:   Wed,  9 Jan 2019 10:46:12 +0200
Message-Id: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

Here are four various fixes for venus driver.

Comments are welcome!

regards,
Stan

Stanimir Varbanov (4):
  venus: firmware: check fw size against DT memory region size
  venus: core: corect maximum hardware load for sdm845
  venus: core: correct frequency table for sdm845
  venus: helpers: drop setting of timestap invalid flag

 drivers/media/platform/qcom/venus/core.c     | 12 +++--
 drivers/media/platform/qcom/venus/core.h     |  1 +
 drivers/media/platform/qcom/venus/firmware.c | 54 +++++++++++---------
 drivers/media/platform/qcom/venus/helpers.c  |  3 --
 4 files changed, 38 insertions(+), 32 deletions(-)

-- 
2.17.1

