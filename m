Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B410C282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 13:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F6522184B
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 13:54:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="XeaGD+a8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfAWNyP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:54:15 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:36028 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfAWNyP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 08:54:15 -0500
Received: by mail-wm1-f46.google.com with SMTP id p6so2028448wmc.1
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 05:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id;
        bh=GhDqppQc5f0PfqmoSyRDghuogC8GAuelh46+WQtN4vQ=;
        b=XeaGD+a8qhxeOyNzxMxqDqz6hUrWFndfw0NDLoyWrzRn2jB5d6G26rH3k+CkkzqYnI
         NYM9vobULdPgQInBhFrE2SvB60MOxyDRG1neJUJMQm2iMcgiuaopvanToa1VHW/ENIl2
         E/wuautNSLu1f4uO3ttUXbUyLH2TDch1Mz9qo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=GhDqppQc5f0PfqmoSyRDghuogC8GAuelh46+WQtN4vQ=;
        b=q+dx2Let3Fwymb+wvALusoRs/UhDD0nalUdY9z2JTGZ8ac11l3WSTfqzJ7PuRhEAhD
         ybnD/bYZB31U7MJre7OQQOsMi8eLRm0XCgLEhQogiKkxxcHLzXEtmxeejuJ41UOxqvzG
         YKOWuljlKnM09iVlkmgSTWBf5br2ndTu6KktkHIicgiUbm5NytyS6+rDCLJlX+ErEi1o
         dUF2oicxLJ13Q4QWTtNz/VKtBHisVobjXndUXXnDF0IAQ4Vy4D9X+L0+BoA0DjFFU2ZD
         9fo28/cMxZ5SDl/xjE5XyGSXc+LdsUfTlSNlXwOD1YXzkB4fMBsBdpyAdKYr4CvxVEX3
         MUqg==
X-Gm-Message-State: AJcUukdHo3RVpxpg4WWU547Zj862ZDF80GG1Vkqs2DQbnzcWYh1MXY8h
        vcnoxONUspU8dFJqMJ0QO8DdQ7UpnrA=
X-Google-Smtp-Source: ALg8bN4vtv4O2FoTGErKYu1Ukm5qSRORqX2y5SrJ2qKbTQ3K7SCI8+D20SgUDp1w0pDpoZok0YAeXQ==
X-Received: by 2002:a1c:8484:: with SMTP id g126mr2924446wmd.117.1548251653639;
        Wed, 23 Jan 2019 05:54:13 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v6sm84001016wrd.88.2019.01.23.05.54.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 05:54:12 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for v5.1] Venus various fixes
Date:   Wed, 23 Jan 2019 15:54:07 +0200
Message-Id: <20190123135407.7385-1-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Please pull these Venus fixes.

regards,
Stan

The following changes since commit 337e90ed028643c7acdfd0d31e3224d05ca03d66:

  media: imx-csi: Input connections to CSI should be optional (2019-01-21 16:46:02 -0200)

are available in the Git repository at:

  git://linuxtv.org/svarbanov/media_tree.git venus-fixes

for you to fetch changes up to 3394284578dc961bbf14cb9393b6ccf2dd733d03:

  venus: helpers: drop setting of timestamp invalid flag (2019-01-23 12:25:02 +0200)

----------------------------------------------------------------
Stanimir Varbanov (4):
      venus: firmware: check fw size against DT memory region size
      venus: core: correct maximum hardware load for sdm845
      venus: core: correct frequency table for sdm845
      venus: helpers: drop setting of timestamp invalid flag

 drivers/media/platform/qcom/venus/core.c     | 12 ++++---
 drivers/media/platform/qcom/venus/core.h     |  1 +
 drivers/media/platform/qcom/venus/firmware.c | 53 ++++++++++++++++------------
 drivers/media/platform/qcom/venus/helpers.c  |  3 --
 4 files changed, 38 insertions(+), 31 deletions(-)
