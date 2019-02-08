Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D11FC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 11:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75D4221916
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 11:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfBHLfn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 06:35:43 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45506 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726081AbfBHLfn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 06:35:43 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E7EC9634C7B
        for <linux-media@vger.kernel.org>; Fri,  8 Feb 2019 13:35:29 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gs4RN-0000ns-OT
        for linux-media@vger.kernel.org; Fri, 08 Feb 2019 13:35:29 +0200
Date:   Fri, 8 Feb 2019 13:35:29 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.1] Move SoC camera to staging, mark as BROKEN
Message-ID: <20190208113529.d6bhv6blhmfwdfma@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

This set moves the SoC camera framework to staging and makes it depend on
BROKEN, as previously agreed.

Please pull.


The following changes since commit 6fd369dd1cb65a032f1ab9227033ecb7b759656d:

  media: vimc: fill in bus_info in media_device_info (2019-02-07 12:38:59 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/no-soc-camera-2-sign-2

for you to fetch changes up to 4dd43216eb946352306695b987cd514d8587116b:

  soc_camera: Depend on BROKEN (2019-02-08 13:33:34 +0200)

----------------------------------------------------------------
no SoC camera

----------------------------------------------------------------
Sakari Ailus (6):
      soc_camera: Remove the mt9m001 SoC camera sensor driver
      soc_camera: Remove the rj45n1 SoC camera sensor driver
      soc_camera: Move to the staging tree
      soc_camera: Move the imx074 under soc_camera directory
      soc_camera: Move the mt9t031 under soc_camera directory
      soc_camera: Depend on BROKEN

 drivers/media/i2c/Kconfig                          |    8 -
 drivers/media/i2c/Makefile                         |    1 -
 drivers/media/i2c/soc_camera/soc_mt9m001.c         |  757 -----------
 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c      | 1415 --------------------
 drivers/media/platform/Kconfig                     |    1 -
 drivers/media/platform/Makefile                    |    2 -
 drivers/media/platform/soc_camera/Kconfig          |    8 -
 drivers/media/platform/soc_camera/Makefile         |    1 -
 drivers/staging/media/Kconfig                      |    6 +-
 drivers/staging/media/Makefile                     |    3 +-
 drivers/staging/media/imx074/Kconfig               |    5 -
 drivers/staging/media/imx074/Makefile              |    1 -
 drivers/staging/media/imx074/TODO                  |    5 -
 .../i2c => staging/media}/soc_camera/Kconfig       |   28 +-
 .../i2c => staging/media}/soc_camera/Makefile      |    5 +-
 .../staging/media/{imx074 => soc_camera}/imx074.c  |    0
 .../media/{mt9t031 => soc_camera}/mt9t031.c        |    0
 .../media}/soc_camera/soc_camera.c                 |    0
 .../media}/soc_camera/soc_mediabus.c               |    0
 .../i2c => staging/media}/soc_camera/soc_mt9v022.c |    0
 .../i2c => staging/media}/soc_camera/soc_ov5642.c  |    0
 .../i2c => staging/media}/soc_camera/soc_ov9740.c  |    0
 22 files changed, 24 insertions(+), 2222 deletions(-)
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9m001.c
 delete mode 100644 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
 delete mode 100644 drivers/media/platform/soc_camera/Kconfig
 delete mode 100644 drivers/media/platform/soc_camera/Makefile
 delete mode 100644 drivers/staging/media/imx074/Kconfig
 delete mode 100644 drivers/staging/media/imx074/Makefile
 delete mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/{media/i2c => staging/media}/soc_camera/Kconfig (62%)
 rename drivers/{media/i2c => staging/media}/soc_camera/Makefile (55%)
 rename drivers/staging/media/{imx074 => soc_camera}/imx074.c (100%)
 rename drivers/staging/media/{mt9t031 => soc_camera}/mt9t031.c (100%)
 rename drivers/{media/platform => staging/media}/soc_camera/soc_camera.c (100%)
 rename drivers/{media/platform => staging/media}/soc_camera/soc_mediabus.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_mt9v022.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov5642.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov9740.c (100%)

-- 
Sakari Ailus
