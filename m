Return-Path: <SRS0=mDsK=O7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCB8C43387
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E38C21A48
	for <linux-media@archiver.kernel.org>; Sat, 22 Dec 2018 17:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SL0gCXSK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbeLVRNJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:13:09 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:47084 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731640AbeLVRNI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Dec 2018 12:13:08 -0500
Received: by mail-pg1-f194.google.com with SMTP id w7so3892055pgp.13;
        Sat, 22 Dec 2018 09:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xJPcU1yj3Uk8XxxcPgthNU71H3yhSYTiBywpiL1BYe4=;
        b=SL0gCXSKknc4OJc+6ZMM7Y/lkaJOZjXiJXfqZjjuxpez4S4WQx1cPbnSl+WMYmFTUO
         Jmg9N9XEFiscWJ7j0XOHqCuPbXfslZOswAKz4T6055unbHUZo+PJmlsmFaUw9rxKAy6J
         nVzgk06GPGjv9642mIjMtNYAV9J75+TjzdtlneZ81hD/b2FgRxZb+DlwtKC2hycUASn5
         hUlAOiajot0JqiYJNinZynb5fXDqPc83Gmlh0cIbKFeUMxXtCs+YVcY4Ye2b8HWTeXvf
         /Wt43h9HAI5mg/L8YY5LkPhFIMLgchxd6OqaxU8q5dRBrKHeP2QWh446tTm9ypH+7Zlc
         L5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xJPcU1yj3Uk8XxxcPgthNU71H3yhSYTiBywpiL1BYe4=;
        b=b0qAPC45Q8ccsLF8FeKhMMpNvfEgHZPBDrxJUgiYMpEF77H5awfLDLADVYhSwvDROi
         j5eD9nZalc1lL1eIlUp5y9dFva3bwH/pfoTmdUonM8+temIAlnFiXHCD3ecHjSRks6jN
         5jKSQYLMVJ6sRSBbD/S8PbS6WJEsf/RzSZwU9AUJdpZhx2DHqCx8Aby/hnlgshgTioLQ
         QoBZGA9PyA+Aeq7WgFI0ddPRl7wb9Dh8vqudJdkuOagKtep13xMlHsSKMY4Im5b8pC2E
         WOcGJBmi9xRvU5ygOyW/XXH7pB0sAO6S934SMGWZ49DIABFexF0RgwvViv0CQs7j/m9s
         S3Zg==
X-Gm-Message-State: AJcUukepqC26ywjzJ1zJSCBKnq1bsLT1H995k5dH25QhPWbBSRjowp7Y
        sj/KhIRI1XRKhXpilVC+mi3AWNrE4JY=
X-Google-Smtp-Source: ALg8bN7FJPgrzJhIhcqR+4cRBVQBvq7ZBgVWxF+QCbLBVDWM3Yq/xmcVOdZsDiphkXGB/klz0N/WUg==
X-Received: by 2002:a63:1321:: with SMTP id i33mr6889960pgl.380.1545498786395;
        Sat, 22 Dec 2018 09:13:06 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:966:8499:7122:52f6])
        by smtp.gmail.com with ESMTPSA id w11sm33322025pgk.16.2018.12.22.09.13.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 22 Dec 2018 09:13:05 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 00/12] media: mt9m001: switch soc_mt9m001 to a standard subdev sensor driver
Date:   Sun, 23 Dec 2018 02:12:42 +0900
Message-Id: <1545498774-11754-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset converts soc_camera mt9m001 driver to a standard subdev
sensor driver.

Akinobu Mita (12):
  media: i2c: mt9m001: copy mt9m001 soc_camera sensor driver
  media: i2c: mt9m001: dt: add binding for mt9m001
  media: mt9m001: convert to SPDX license identifer
  media: mt9m001: add of_match_table
  media: mt9m001: introduce multi_reg_write()
  media: mt9m001: switch s_power callback to runtime PM
  media: mt9m001: remove remaining soc_camera specific code
  media: mt9m001: add media controller support
  media: mt9m001: register to V4L2 asynchronous subdevice framework
  media: mt9m001: support log_status ioctl and event interface
  media: mt9m001: make VIDIOC_SUBDEV_G_FMT ioctl work with
    V4L2_SUBDEV_FORMAT_TRY
  media: mt9m001: set all mbus format field when G_FMT and S_FMT ioctls

 .../devicetree/bindings/media/i2c/mt9m001.txt      |  37 +
 drivers/media/i2c/Kconfig                          |   9 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/mt9m001.c                        | 900 +++++++++++++++++++++
 4 files changed, 947 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt
 create mode 100644 drivers/media/i2c/mt9m001.c

Cc: Rob Herring <robh@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
2.7.4

