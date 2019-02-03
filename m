Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1D9C169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A98921773
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 19:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwKDaySV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbfBCTr7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 14:47:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35091 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfBCTr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2019 14:47:59 -0500
Received: by mail-pg1-f195.google.com with SMTP id s198so5335715pgs.2
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2019 11:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5l9h91c3FeeImyLPDyKSYqqP0V/m71nKkhGIJHId6Qc=;
        b=iwKDaySVbcZ1wEw9mXYg3z2IkLfKyat+V0UoDunQtJMXbcv+agIeU79D7mwsn+V0wf
         q7V3rUnOf5I8JjeQdt/l+ghKR+w6Ow5OF+QdV1+jbVcCIfMWSm3PrrAzRlCInMtc50k2
         WWsqAYefLur2ssKM9270N+UsvWTuj0rcbXWoBy5fGHpmuZddvtWSZIY/cTAf5Kg8dTgn
         5GCdzTJmTBh59SppYgxWWt2qj3b+0joMa7dKkLD/e7j1HCSU6wbGg9TLeNUzrCNBogRc
         sSroKBUW7gxY+AlYpMsbXxOvvYlDCPTeOaxYZV+mDYLOywDtOpjtu3JeaGITlIOXOZbA
         Mqdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5l9h91c3FeeImyLPDyKSYqqP0V/m71nKkhGIJHId6Qc=;
        b=iEVaI402SsBg1Y3alN+HPN+bFP986lcjxCIczKcLdzowg/FDPKMc6t3/TkOK9Sf5oQ
         ybU87+DW89cx3CQEoITroFs+EKfeZI8bcNxHqh72K/K5N+DPnEtbYxroNNgNyvUAyjwL
         qtIVLovxf5zifE15UoUXVWewK4n4SkdqtWvgiSP7clPjwMuT5enRJrrqlp/1x+91Mb/o
         j24qXmahiHmf0OFvNOrcLZoU61Zp3+1RYfBGJcsayVPwkvsb1Sv8YuQ0I9lgG75q11Wd
         gtsKT8rL2CFOWh+k+BvxgS8OP37ETfE7ZVw90y+slMaaMC5jQzkUnFZYO830qt/jvMJ2
         D72g==
X-Gm-Message-State: AHQUAuZXkxOqLgE4PpADJ/4t62wa9LLmN3cUQ5gG+WWZS4oGuMKm11Aj
        oCeVNrPV4DN+91dZa8rCJ23yGETn
X-Google-Smtp-Source: AHgI3Ib1BJOrxAooCyTW4TsefeGuEa0HH09ZkN5r4vEZtD4t18DdKucz1MGLN9F30Z46/h/P3RAkyQ==
X-Received: by 2002:a63:d84b:: with SMTP id k11mr2287941pgj.142.1549223277960;
        Sun, 03 Feb 2019 11:47:57 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id f67sm23487724pff.29.2019.02.03.11.47.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 11:47:57 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 0/3] media: imx: Add support for BT.709 encoding
Date:   Sun,  3 Feb 2019 11:47:41 -0800
Message-Id: <20190203194744.11546-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset adds support for the BT.709 encoding and inverse encoding
matrices to the ipu_ic task init functions. The imx-media driver can
now support both BT.601 and BT.709 encoding.

Steve Longerbeam (3):
  gpu: ipu-v3: ipu-ic: Rename yuv2rgb encoding matrices
  gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
  media: imx: Allow BT.709 encoding for IC routes

 drivers/gpu/ipu-v3/ipu-ic.c                 | 75 ++++++++++++++++++---
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
 drivers/staging/media/imx/imx-media-utils.c |  4 +-
 include/video/imx-ipu-v3.h                  |  5 +-
 5 files changed, 76 insertions(+), 13 deletions(-)

-- 
2.17.1

