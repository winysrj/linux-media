Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9E9C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3FBB2063F
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 23:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="stXQGQYU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfBTXxk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 18:53:40 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35903 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfBTXxk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 18:53:40 -0500
Received: by mail-pg1-f194.google.com with SMTP id r124so12748211pgr.3
        for <linux-media@vger.kernel.org>; Wed, 20 Feb 2019 15:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ur4wYPpJ1zk/Fr8RVPBVz+/pvvNU8GXUBVknjIi/v7I=;
        b=stXQGQYULieauKVB+aAOu+ArTyJIXMOJyBxRK2TBgAncu1og2n6vbP7EdWEAtNUM+M
         yPBWRUSQ2slSYAiRMPRfl9Qj7Q6ALvEFEo22/s4Bb9gcBPdfG4Yd7A7Rsi0603hpwO9a
         8RHK54OAuVOF3dX0ckktHrRDx53/UfRW8v/PHZd+2UKUqO5Ws2R9BxohM3gjqTVg2mL1
         RJr5L400ZAlmvDyACw8IbqTS0NR3d+/+7edIG/vmRU9i7669RigKk5ZH9V9PNEnUjb8g
         qNwLWa2Xmnd/WMsWZw+8tdouNECU1YgL1ZXcy720kSQjR4xVM+UWroYHevvu0NY6chOC
         mN6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ur4wYPpJ1zk/Fr8RVPBVz+/pvvNU8GXUBVknjIi/v7I=;
        b=rvzw5D6kbFmilv9pSfHvTPurIKvpiEj0AwZydQejvGjLjb5w9p3W6UbcmnTBZom60P
         EQ0O9k9kUMv/7Yeefl9CrwUqrpYAEls1ildVyiiSykDni/I6ruaJVgzjjl1mQL5YpnuZ
         OmBJgTrm/u8fS9NVys1CpA+C74sdTfkqu3r0jtRoLDoAe3TqJFPr/joDkKUcTxeMHsCX
         622kaA23J1+ltOiak2Hwqfao1mAe/Pcd5QEKuFRSnEV855h3xP1sRFKaFj3LpRCMpUvI
         ZezVcvoKXXF1lQicPhUky9Ui89moaUgptJGsknj1ck0bQGsvP4TXOdJ5jwoTUhZeU5w1
         xGGQ==
X-Gm-Message-State: AHQUAubHSWv8p7tL7+jKulfGHyAOn1o1/DRPltOcOGI0amckZqq9rV6I
        fDscVL6XPP7GJMdx0DNVEFayQDUR
X-Google-Smtp-Source: AHgI3Iap1nqAEEVz6/3OMzyInPX9pDu9gqc5x0deBThZjA4NNuw/i65I6NsNOWVYNOnCZNt9BOFEww==
X-Received: by 2002:a63:cc03:: with SMTP id x3mr9222697pgf.121.1550706818938;
        Wed, 20 Feb 2019 15:53:38 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id v15sm25530158pgf.75.2019.02.20.15.53.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Feb 2019 15:53:37 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v2 0/4] media: imx: Various fixes for i.MX5 support
Date:   Wed, 20 Feb 2019 15:53:28 -0800
Message-Id: <20190220235332.15984-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Some fixes and improvements to support video capture on i.MX5.

History:
v2:
- Rebased with merge of imx7 capture patches.

Steve Longerbeam (4):
  media: imx: csi: Allow unknown nearest upstream entities
  media: imx: Clear fwnode link struct for each endpoint iteration
  media: imx: Rename functions that add IPU-internal subdevs
  media: imx: Don't register IPU subdevs/links if CSI port missing

 drivers/staging/media/imx/imx-ic-common.c     |  2 +-
 drivers/staging/media/imx/imx-media-csi.c     | 18 ++++-
 drivers/staging/media/imx/imx-media-dev.c     | 11 +--
 .../staging/media/imx/imx-media-internal-sd.c | 32 +++-----
 drivers/staging/media/imx/imx-media-of.c      | 73 ++++++++++++-------
 drivers/staging/media/imx/imx-media-vdic.c    |  2 +-
 drivers/staging/media/imx/imx-media.h         |  7 +-
 drivers/staging/media/imx/imx7-media-csi.c    |  2 +-
 8 files changed, 80 insertions(+), 67 deletions(-)

-- 
2.17.1

