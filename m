Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49599C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A67206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 14:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W7gHk4BD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfAHOwG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 09:52:06 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37003 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfAHOwG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 09:52:06 -0500
Received: by mail-pl1-f193.google.com with SMTP id b5so2009864plr.4;
        Tue, 08 Jan 2019 06:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2xGOpoV8/y2Xfwg6B9Pj9MDHO6NbZ1h3to9ybhghmWM=;
        b=W7gHk4BDEkQeq8B+EMnbWfGYbhEkkwxUrRAg6PjnjykFKg2YnyZRVG2NlrHRX1MnLt
         k1Z1RoPCrWWM3POSrmNXMI07Fv1FV3LYtUC0+F3cjH8AlXMHkZdbvejj6MgCai358/Ai
         9mcTYgBYGXUjS6oeeKPbaEeOiza9o4KEPDTACdUDZ0RpYmrQ9wEhw8T7kBbGTqXhjNn9
         o0hzJT2CXKqbzs6BgEhlYFoSlOD+QdgHK46jY71jlLEJH1BTWRBg4nq5vBVxbuyAtAN5
         N0Ou+umQOlP80Qt+tZZbUMvl3HxCQq79JR5OFvxnuB57a9V7DqubTY/fSEfibl+uf3gw
         4yCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2xGOpoV8/y2Xfwg6B9Pj9MDHO6NbZ1h3to9ybhghmWM=;
        b=NJ7+ysKbk6oMnMDM2uN7hp02ir5u3S1+qX+mdR5tCGo5ZAUM9K0KEwyAOKxybArtl1
         PH9fnMCftOziN80rdSLosE/8UV5tk0qfY2wD6sjx26dl/ZCLLd9E+BCTM9V/+1Eyi5rY
         489i3W8qBWXHDcsTQXS0GfBr799+mlUqKeJ/UJ0zeLFGWKx5OLF9ouqqwsvO4P6NewRe
         irNdSEIJvjAF1Wp0i5M+9g7kTNUDZLjXXAQSdvL0jP2193EhZfQZfcLevnaO7wd5uZTU
         lcl7v9DwbBxXOFbmSBjcKusFnmCrQh6lZXj9W84pigfMO4rWnKJ6VT5TAc7jQLttc17j
         Daaw==
X-Gm-Message-State: AJcUukew18fK72SsOnSeqlb3zeDrl65Mo7Yx3J6s6uKDz7NHwa1O1u2K
        zBWnzKcbqcbnwNuKJXlOKjYBTrJ7
X-Google-Smtp-Source: ALg8bN7FEVkYUYzz9CBNJ1AvoRnClBvBdCPXhKqNS6iWpXEbj21LZtlzkRUll51Smvjcah5cIKWlzw==
X-Received: by 2002:a17:902:b090:: with SMTP id p16mr2084561plr.190.1546959124661;
        Tue, 08 Jan 2019 06:52:04 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:5cb2:2bb:ff67:c70d])
        by smtp.gmail.com with ESMTPSA id n78sm53546990pfk.19.2019.01.08.06.52.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 08 Jan 2019 06:52:03 -0800 (PST)
From:   Akinobu Mita <akinobu.mita@gmail.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 00/13] media: mt9m001: switch soc_mt9m001 to a standard subdev sensor driver
Date:   Tue,  8 Jan 2019 23:51:37 +0900
Message-Id: <1546959110-19445-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patchset converts soc_camera mt9m001 driver to a standard subdev
sensor driver.

* v2
- Update binding doc suggested by Rob Herring.
- Fix MODULE_LICENSE() masmatch.
- Sort headers alphabetically.
- Add new label for error handling in s_stream() callback.
- Replace pm_runtime_get_noresume() + pm_runtime_put_sync() with a
  single pm_runtime_idle() call in probe() function.
- Change the argument of mt9m001_power_o{n,ff} to struct device, and
  use them for runtime PM callbacks directly.
- Remove redundant Kconfig dependency
- Preserve subdev flags set by v4l2_i2c_subdev_init().
- Set initial try format with default configuration instead of
  current one.

Akinobu Mita (13):
  media: i2c: mt9m001: copy mt9m001 soc_camera sensor driver
  media: i2c: mt9m001: dt: add binding for mt9m001
  media: mt9m001: convert to SPDX license identifer
  media: mt9m001: sort headers alphabetically
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

 .../devicetree/bindings/media/i2c/mt9m001.txt      |  38 +
 drivers/media/i2c/Kconfig                          |   8 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/mt9m001.c                        | 884 +++++++++++++++++++++
 4 files changed, 931 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt
 create mode 100644 drivers/media/i2c/mt9m001.c

Cc: Rob Herring <robh@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.7.4

