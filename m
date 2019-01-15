Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0775EC43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA8C92086D
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1VtPZz7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbfAOOF4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:05:56 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46022 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbfAOOF4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:05:56 -0500
Received: by mail-pl1-f193.google.com with SMTP id a14so1326265plm.12
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 06:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0kYCcCZ8a2c15uw06JRZ01TQeADd/yRuk5aFpBQ97LQ=;
        b=A1VtPZz761K69DJOLtuTpdCgtiAhZBvzw8MQe5Uoalz5FhIE5889QAjafEeafgUJ84
         2PAOYuHsYw0Rxu+uCjv/926s5MomWE1MdyYdhigfHie7y9H1k//utbsvOLtQw22xbOX9
         732nXlub+t/E60U+2TM7iRSoX+82AZiLl6CdJl8tVIIGAhi+yC/UJbhl5MjM23Z+IPKJ
         rOMMsAn7BNEVl8n4gln6fB1JGOLaU/ZKGj58zXqv0TOz/kE004iyw2pjJMtb+O61ORVl
         0UXeymgxqD6I8Vq694SwSQyrT4gBp6tuN3VPBZyeHUYkvqoW1usjgcnh26dMHpLTx4M5
         xbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0kYCcCZ8a2c15uw06JRZ01TQeADd/yRuk5aFpBQ97LQ=;
        b=JIsJlJoCs86CK+9Lq+paG2yKl/zI0mG1dfFmOPHDBP2u5ZOG1w8vsG/BuIQ3cr6fNR
         rLhjhY2Tbz5krrYmK4/8Wc+PpNlCqCapfy8oTCdzYZ4sgpkCN1amctsaPewi7ZxUy/E/
         rRDdM2obh1ejIvSpyDCOe6DhNt3iWEnIbs1OOKLK1vMCnaQCRVSKJ6gXGEMDIXDa2vs5
         AzMjDIxPGw0U6nH6JpikxVA5p4Os33ig5nOxi6ABrQoxwflgSER3k8ErgE0lql+DOwPS
         mtWQ3oKzIx6WPuQRgLRfWLhAm7uzDt96uO+FyS4VkNgAKwG8gnDC3pv7LzPJyQC+h1C6
         cIPA==
X-Gm-Message-State: AJcUukcHUGm0auLNRxeCqpsKxHdRV7P2t6UQsrqrUbimTrHOLM+lXCBP
        VUYkeb6XMStzMrUBPuoSHGyid8TL
X-Google-Smtp-Source: ALg8bN78FIrCj/AjlOrkyvavl/1Fc57dpdZk2EkXFP7/0cvf5lE3gYwjt3c4MU8yK4wBJT9rsGoM3Q==
X-Received: by 2002:a17:902:7882:: with SMTP id q2mr4362660pll.305.1547561154923;
        Tue, 15 Jan 2019 06:05:54 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5894:91d7:f206:dece])
        by smtp.gmail.com with ESMTPSA id c72sm5394125pfb.107.2019.01.15.06.05.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 15 Jan 2019 06:05:54 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Enrico Scholz <enrico.scholz@sigma-chemnitz.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 0/3] media: bugfixes for mt9m111 driver
Date:   Tue, 15 Jan 2019 23:05:38 +0900
Message-Id: <1547561141-13504-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series contains four bugfixes for mt9m111 driver.

* v3
- Set initial try format with default configuration instead of
  current one.

* v2
- Drop patch 1/4 in v1 ("fix setting pixclk polarit") since it was wrong.
- Use format->pad for the argument of v4l2_subdev_get_try_format().

Akinobu Mita (3):
  media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work with
    V4L2_SUBDEV_FORMAT_TRY
  media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
  media: mt9m111: set initial frame size other than 0x0

 drivers/media/i2c/mt9m111.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4

