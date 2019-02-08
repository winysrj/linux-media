Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECD2C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB642075C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 14:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aVht4BIA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfBHOxA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 09:53:00 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41868 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfBHOxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 09:53:00 -0500
Received: by mail-pl1-f196.google.com with SMTP id k15so1789444pls.8
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 06:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HalsbAv+eRYwz/YYOFFYD3cr/l/1PIkrYBL1XnVAZ74=;
        b=aVht4BIA4GGBXS0TQ5UDk+hw2AE8j9cPRvJjFfXYmVu4GeYWGZnDqNvypsJa30VKpU
         LJUnCl1B3ItrEK//iTvz6rwhMqJsN6kiIaFcg4ArhdIxMSVuTDSSmm5g2dWDc+K4K9YV
         5VA6U0NswiUSDVLwfONgPrOq4NIJ7kaBIAUbjZlvpKlQcO+zcDV//UoELHmy8kCVyDBv
         4uo6gzh7M799lPmsciVODRfbBn1qZpuoNDZOC/7imePk+kvn7ZEC0z/o+cGELQi+5mNL
         aRAgg4rOEPuhfrio/8ZfjmdCXVGBa4Ql4kBNgfXUjsMK7kFng/IhtOfeapuS/siQbnQ6
         fRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HalsbAv+eRYwz/YYOFFYD3cr/l/1PIkrYBL1XnVAZ74=;
        b=am75l++T6gD34hr3ONAk9Xj2hNI94pT/O1b02BVBQQRCh3UMSY6lf7IiWvbh02iJHh
         WC9aZb9b36tKPnfiXttfg/2wX5ZqD89UWcR31I5xRAWvBM5mXGdrS+WPOksk5rXrGzPR
         TKX6qcgL8bBxTmafevFVUgK07se8VqE0G3rOCoiF9zJGXi1u6rDHgMXyiVq9OTQq9ZcJ
         NePC24hyWhJ8ciOgJ0ORy6onWayl933c5vQn5/4VQH0cpyZA0OIKxNqXxuDWrphqmdo2
         wQNtBX5dUYv2MJmfnIb7dY6pDX5LXCQwac38WOyWpog6BHxOwkqOtpGJ+5zdbWmAckV8
         cfbQ==
X-Gm-Message-State: AHQUAub6KHMdBF5k7gtRkqMxwAD/DU4/kSGPiv4mYjFnaVDOBN0z5C+W
        nhJNTLEajGp03qIpsoq3IeGVGcTXFIw=
X-Google-Smtp-Source: AHgI3IblnvulgX36CjjpJD2cfLxrhQpdDkqSmmVGpU2df6TY6ONtruSrWFX4Pb9AvqZOLSlxiHBETQ==
X-Received: by 2002:a17:902:a03:: with SMTP id 3mr23310199plo.112.1549637579831;
        Fri, 08 Feb 2019 06:52:59 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:9dad:5819:2ad0:da6f])
        by smtp.gmail.com with ESMTPSA id s79sm3425216pgs.50.2019.02.08.06.52.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Feb 2019 06:52:58 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 0/4] media: i2c: tweak Kconfig dependencies
Date:   Fri,  8 Feb 2019 23:52:41 +0900
Message-Id: <1549637565-32096-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series improves Kconfig dependencies for some camera sensor
drivers.

Akinobu Mita (4):
  media: ov2640: add VIDEO_V4L2_SUBDEV_API dependency
  media: mt9m111: add VIDEO_V4L2_SUBDEV_API dependency
  media: i2c: add missing MEDIA_CAMERA_SUPPORT
  media: i2c: remove redundant MEDIA_CONTROLLER dependency

 drivers/media/i2c/Kconfig        | 18 +++++++++---------
 drivers/media/i2c/et8ek8/Kconfig |  1 +
 drivers/media/i2c/mt9m111.c      | 13 +------------
 drivers/media/i2c/ov2640.c       | 12 ++----------
 4 files changed, 13 insertions(+), 31 deletions(-)

Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4

