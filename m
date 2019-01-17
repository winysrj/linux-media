Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F3DC43612
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B342F20652
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfAQQSG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:18:06 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59995 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728675AbfAQQSG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:18:06 -0500
Received: from marune.fritz.box ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kAMkgeAhPNR5ykAMmgTv0a; Thu, 17 Jan 2019 17:18:04 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 0/8] Remove obsolete soc_camera drivers
Date:   Thu, 17 Jan 2019 17:17:54 +0100
Message-Id: <20190117161802.5740-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAj7Vph+p/WN4HD1aH2v1x0kbsWz65Vm9ESFKzx0epK4Pfdn+7R5AaBRZ/rtFrnE22p74xgUuFgTwuVmPHYZa35WyZoxqQwtMX3LLeO8XkYM6zF5Re17
 gNwKaL/cvTv8pD5t0NjcxDS9xUqnF8qI+MPmKmn2L823HSytpNQst6s/MIT9ANCspQRzsYuIiD8CkxmC0vMWQViYbXVWfCYluf/bf2v+D/NX/8MLKRZR/M8Y
 Tc9PjNNDTHDMo6yDqN37aS/PchVfWCHfUvVGK2znokfLDSnkpG5k7WN5Wup+TMsG4EcjnMoTXaiwgvjQoCroaWJnXUre1WK/eyH3x8l3Jlg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The soc_mt9t112, soc_ov772x and soc_tw9910 drivers now have
non-soc-camera replacements, so those three drivers can be
removed.

The soc_camera sh_mobile_ceu_camera platform driver also has
a non-soc-camera replacement, so remove this driver as well.

This driver was also the last driver that used soc_scale_crop,
so remove that too. Finally remove the test soc_camera_platform
driver. There will be no more soc_camera platform drivers, so this
platform template driver serves no purpose anymore.

Regards,

	Hans

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

 drivers/media/i2c/soc_camera/Kconfig          |   18 -
 drivers/media/i2c/soc_camera/Makefile         |    3 -
 drivers/media/i2c/soc_camera/soc_mt9t112.c    | 1157 -----------
 drivers/media/i2c/soc_camera/soc_ov772x.c     | 1123 ----------
 drivers/media/i2c/soc_camera/soc_tw9910.c     |  999 ---------
 drivers/media/i2c/tw9910.c                    |    2 +-
 drivers/media/platform/soc_camera/Kconfig     |   18 -
 drivers/media/platform/soc_camera/Makefile    |    8 -
 .../soc_camera/sh_mobile_ceu_camera.c         | 1810 -----------------
 .../platform/soc_camera/soc_camera_platform.c |  188 --
 .../platform/soc_camera/soc_scale_crop.c      |  426 ----
 .../platform/soc_camera/soc_scale_crop.h      |   47 -
 .../platform_data/media/soc_camera_platform.h |   83 -
 include/media/drv-intf/sh_mobile_ceu.h        |   29 -
 include/media/i2c/tw9910.h                    |    2 -
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

-- 
2.20.1

