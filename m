Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84819C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E8092087E
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 09:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfARJGo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 04:06:44 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:50055 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbfARJGo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 04:06:44 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud9.xs4all.net with ESMTPA
        id kQ6rgc1L3axzfkQ6sgofbI; Fri, 18 Jan 2019 10:06:42 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Remove obsolete soc_camera drivers
Message-ID: <c825872f-1261-fadd-843c-27d7e461d5e8@xs4all.nl>
Date:   Fri, 18 Jan 2019 10:06:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNyZ5tNl6pQDpNuYeyYQzkzmPbNTzLRT7E6p118l9sG82e2OjymacQryNv43ioELjE3vo70zz4DQIhadD9OKA6OJAa45EmMU331n23r/NKoO8y5wv6ib
 ukmOBTwgrIYCqL1L2EmLIXIkvulPdlW81PtrmIZTOgwnv+ZkvXa5aj0M5PFtEnerNSemqNpuni3R3K6X5hqwl9Qjs2/ZwPpz4xgNLt9+XHnnqmQu1jXFIwdv
 Ct+gF9qfG0RbnFjU82dUkmXr4VH0Mcfy+RKJCPbyWHUrL47rsQ0yLrv9xpA6LBvTGr32lwRw8nffb9PcmZdSzA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit e8f9b16d72631870e30a3d8e4ee9f1c097bc7ba0:

  media: remove soc_camera ov9640 (2019-01-17 09:01:11 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-rmsensors3

for you to fetch changes up to 8ae3463355f534129814cbefb8bde3a0a3302dd9:

  soc_camera_platform: remove obsolete soc_camera test driver (2019-01-18 10:04:45 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (7):
      soc_mt9t112: remove obsolete sensor driver
      soc_ov772x: remove obsolete sensor driver
      tw9910.h: remove obsolete soc_camera.h include.
      soc_tw9910: remove obsolete sensor driver
      sh_mobile_ceu_camera: remove obsolete soc_camera driver
      soc_camera/soc_scale_crop: drop this unused code
      soc_camera_platform: remove obsolete soc_camera test driver

Jacopo Mondi (1):
      media: tw9910: Unregister subdevice with v4l2-async

 drivers/media/i2c/soc_camera/Kconfig                     |   18 -
 drivers/media/i2c/soc_camera/Makefile                    |    3 -
 drivers/media/i2c/soc_camera/soc_mt9t112.c               | 1157 -----------------------------
 drivers/media/i2c/soc_camera/soc_ov772x.c                | 1123 ----------------------------
 drivers/media/i2c/soc_camera/soc_tw9910.c                |  999 -------------------------
 drivers/media/i2c/tw9910.c                               |    2 +-
 drivers/media/platform/soc_camera/Kconfig                |   18 -
 drivers/media/platform/soc_camera/Makefile               |    8 -
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 1810 ---------------------------------------------
 drivers/media/platform/soc_camera/soc_camera_platform.c  |  188 -----
 drivers/media/platform/soc_camera/soc_scale_crop.c       |  426 -----------
 drivers/media/platform/soc_camera/soc_scale_crop.h       |   47 --
 include/linux/platform_data/media/soc_camera_platform.h  |   83 ---
 include/media/drv-intf/sh_mobile_ceu.h                   |   29 -
 include/media/i2c/tw9910.h                               |    2 -
 15 files changed, 1 insertion(+), 5912 deletions(-)
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9t112.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_ov772x.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_tw9910.c
 delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_camera_platform.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.c
 delete mode 100644 drivers/media/platform/soc_camera/soc_scale_crop.h
 delete mode 100644 include/linux/platform_data/media/soc_camera_platform.h
 delete mode 100644 include/media/drv-intf/sh_mobile_ceu.h
