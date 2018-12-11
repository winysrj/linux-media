Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE10C5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0BAE2084E
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 15:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=konsulko.com header.i=@konsulko.com header.b="LvG2kL3T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0BAE2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbeLKPRp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:17:45 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45371 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbeLKPRo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 10:17:44 -0500
Received: by mail-lf1-f65.google.com with SMTP id b20so11019786lfa.12
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2018 07:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6g/mWBO+BUxUXnXI+Us3ZTHbMx6kxdtN4EeeB2eSewk=;
        b=LvG2kL3TBWvBLfvMJBfU27U0JT+1kP/xJa2gxuknVttz0gsAl7Wswz2LP87gxtViec
         4HRxrrbi+rYQ4G5ggygTXvD7DaEJy5f1m+rQIb4CWx4kP2Iv6PAz1hFNzZnwS4XlH3ZF
         Sy0pWt8PKP9/0E/ghUUUprBvDJrkB+I7+hyuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6g/mWBO+BUxUXnXI+Us3ZTHbMx6kxdtN4EeeB2eSewk=;
        b=diuDMLwn+eAhZb1AngsdElrtPg7BQbhdu4ldNFRnpYHtm9LZgcLQ78OL+r6+xbqWnM
         fm6pWmAIgDfvy7RVDobT6CVQYVNjvZ1ANWM8QD0+wrCj6Z6/p01CrS5795rUs3Orsuxo
         PurJPVvtn2zH3EVWNPbLZGSK1R/guElTRG0CQ8FvYhqjI6buMPqBzJmdLNAHQCuIEiVY
         att3+A6mYqveEvBXCKjowrEkm8maNliWLgTsnDSzD2cb/YufwV+6JAxCHW9o3TTCnBcR
         GSOKrAKHPUqTeQt4SK6D4pL9XlxLpoNgSjhNjRtqNpNFUlgSVfEBcA4Ja/GULafx4o+k
         EiWg==
X-Gm-Message-State: AA+aEWYnOATK2KRhVCAbcV+nkbCeCFJP6zQLcwwAr2To8LAkgqKQH0Eb
        gqAX3AP1qFLsZg+H2Fk8w/e4AAtGVmw=
X-Google-Smtp-Source: AFSGD/UC/whhkDblcjiQvlJlAZdryQ2USmic8vSW4gZ+MQBSfU48Imk8zlqgouPbrTIW3C8T26SmDg==
X-Received: by 2002:a19:4e59:: with SMTP id c86mr10100528lfb.132.1544541461282;
        Tue, 11 Dec 2018 07:17:41 -0800 (PST)
Received: from virtualbox.ipredator.se (anon-49-167.vpn.ipredator.se. [46.246.49.167])
        by smtp.gmail.com with ESMTPSA id g12-v6sm2712158lja.74.2018.12.11.07.17.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Dec 2018 07:17:40 -0800 (PST)
From:   Matt Ranostay <matt.ranostay@konsulko.com>
To:     linux-media@vger.kernel.org
Cc:     Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH v4 0/2] media: video-i2c: add Melexis MLX90640 thermal camera support
Date:   Tue, 11 Dec 2018 07:16:59 -0800
Message-Id: <20181211151701.10002-1-matt.ranostay@konsulko.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add initial support for Melexis line of thermal cameras. This is the first part of
processing pipeline in which the real processing is done in userspace using the
V4L2 camera data.

Changes from v1:

* add melexis,mlx90640.txt documentation

Changes from v2:
* power patchset was submitted in its own patch

Changes from v3:
* split devicetree binding docs into its own patch

Matt Ranostay (2):
  media: video-i2c: check if chip struct has set_power function
    media: video-i2c: add Melexis MLX90640 thermal camera support

Matt Ranostay (2):
  media: dt-bindings: media: video-i2c: add melexis mlx90640
    documentation
  media: video-i2c: add Melexis MLX90640 thermal camera

 .../bindings/media/i2c/melexis,mlx90640.txt   |  20 ++++
 drivers/media/i2c/Kconfig                     |   1 +
 drivers/media/i2c/video-i2c.c                 | 110 +++++++++++++++++-
 3 files changed, 130 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt

-- 
2.17.1

