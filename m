Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9784BC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 654B62145D
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 17:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ReoPWDS4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbeL2RHv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 12:07:51 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36551 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeL2RHv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 12:07:51 -0500
Received: by mail-pf1-f196.google.com with SMTP id b85so11711451pfc.3
        for <linux-media@vger.kernel.org>; Sat, 29 Dec 2018 09:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jSivt9rb/rJbHI8PKqca6YSng+kzoETzFHdaoOnZub4=;
        b=ReoPWDS459F1qT8aBTc+oQLpC69QiZKEv3guTyrxkZW8t1SZmtjtcYYreokYbZQfkB
         nRmXi5aFbA1EJEokfaC/jayZTMStoOluQtEApNL1VlYcAVjCGoCLpmEwd0t0vd32JVyR
         uYh2ATxvv9tjyMXuY40KSjpyRwenhgoVPCZ0p57UpRtI2LJtfb5khTaNT2DSiWBFCs+h
         pydxACmqBppQguo6WqQP+J4ZHw7oCKN5iV5PmTBupk8cpMaHvBJWwqOabqo+6h/d4qbi
         hZEkRL3vdsz7z95ZW8tKDHwwcvYk8TxO70+JHG4OSNNukO4NEVwMjbQDLrNzEK/rhiL6
         iLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jSivt9rb/rJbHI8PKqca6YSng+kzoETzFHdaoOnZub4=;
        b=n+sxB8AgMb+o0H2p7hnfIhGBSAD8FwlavAmnmlJMaB6CNJ9/s7nfB4o1O5r0o4Ia/I
         kmvqgGRB8ZKOTsAMyGLOhLDiznwThhCJ7o6gGScxKVR03BywzGzZSoPCKF5+6tlqTqFk
         BqoeOyTuhqDY7w9i+KMSL7UK79aB3Xu/hIuF15WACIXaf+yDpWceJhW4RduI7Rsftoa8
         wPPBH7slN/gEZejJ04BLT1G9oXqu8uYOVH5YjXuaR8GrFLT8R9bcJdg0plBg8eDh/dQy
         +9LomFgWiZnhXoUp1C5YxlKLcelYtMFVaF6sUop4WtsuU8tMJxfZH77/gqI4hPnJeqMh
         AouQ==
X-Gm-Message-State: AJcUukfF+8/owZeBk2xRi5+/f2jU5kFyHHAETTjCXbSjJ/OLiaXm3wns
        VLB/iTmbt31prLvpumLQ1iy/MueD27M=
X-Google-Smtp-Source: ALg8bN4XbWDf0EYaBQ6eif3Qc9U8cj2wqWXj3b0Xm7ua7ZEPKRaH0mXsXCbotdo3OIRGzCqEaxc8ug==
X-Received: by 2002:a65:534b:: with SMTP id w11mr2201454pgr.125.1546103270863;
        Sat, 29 Dec 2018 09:07:50 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:d91e:35b2:75a8:1394])
        by smtp.gmail.com with ESMTPSA id h134sm86856276pfe.27.2018.12.29.09.07.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 29 Dec 2018 09:07:50 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 0/4] media: bugfixes for mt9m111 driver
Date:   Sun, 30 Dec 2018 02:07:34 +0900
Message-Id: <1546103258-29025-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series contains four bugfixes for mt9m111 driver.  The first
patch fixes the recent change for v4.21.

Akinobu Mita (4):
  media: mt9m111: fix setting pixclk polarity
  media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work with
    V4L2_SUBDEV_FORMAT_TRY
  media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
  media: mt9m111: set initial frame size other than 0x0

 drivers/media/i2c/mt9m111.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
-- 
2.7.4

