Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46A0C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78953214C6
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 14:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfAJOhP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:37:15 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60764 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728120AbfAJOhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 09:37:14 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 78B82634C7E
        for <linux-media@vger.kernel.org>; Thu, 10 Jan 2019 16:35:51 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ghbR0-0002gA-Sd
        for linux-media@vger.kernel.org; Thu, 10 Jan 2019 16:35:50 +0200
Date:   Thu, 10 Jan 2019 16:35:50 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.1] Sensor driver patches
Message-ID: <20190110143550.q5jpdyqugzjf6ohn@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here's the usual set of sensor driver patches for 5.1. Most notably,
there's a driver for ov9640 (originally using SoC camera framework) as well
as fixes for a number of other drivers.

Please pull.


The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-5.1-1-sign

for you to fetch changes up to 5008af8f2733a998819f2143caa9be9556bb3d06:

  ipu3-cio2, dw9714: Remove Jian Xu's e-mail (2019-01-10 00:25:56 +0200)

----------------------------------------------------------------
sensor driver stuff for 5.1

----------------------------------------------------------------
Akinobu Mita (3):
      media: ov2640: set default window and format code at probe time
      media: ov2640: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
      media: ov2640: set all mbus format field when G_FMT and S_FMT ioctls

Chen-Yu Tsai (2):
      media: dt-bindings: media: sun6i: Separate H3 compatible from A31
      media: sun6i: Add H3 compatible

Jacopo Mondi (1):
      v4l2: i2c: ov7670: Fix PLL bypass register values

Loic Poulain (1):
      media: ov5640: Add RAW bayer format support

Luca Ceresoli (1):
      media: imx274: fix wrong order in test pattern menus

Manivannan Sadhasivam (2):
      dt-bindings: media: i2c: Fix external clock frequency for OV5645
      dt-bindings: media: i2c: Fix i2c address for OV5645 camera sensor

Petr Cvek (8):
      media: soc_camera: ov9640: move ov9640 out of soc_camera
      media: i2c: ov9640: drop soc_camera code and switch to v4l2_async
      MAINTAINERS: add Petr Cvek as a maintainer for the ov9640 driver
      media: i2c: ov9640: add missing SPDX identifiers
      media: i2c: ov9640: change array index or length variables to unsigned
      media: i2c: ov9640: add space before return for better clarity
      media: i2c: ov9640: make array of supported formats constant
      media: i2c: ov9640: fix missing error handling in probe

Sakari Ailus (4):
      ipu3-cio2: Allow probe to succeed if there are no sensors connected
      ov9640: Wrap long and unwrap short lines, align wrapped lines correctly
      MAINTAINERS: Update reviewers for ipu3-cio2
      ipu3-cio2, dw9714: Remove Jian Xu's e-mail

 .../devicetree/bindings/media/i2c/ov5645.txt       |   6 +-
 .../devicetree/bindings/media/sun6i-csi.txt        |   2 +-
 MAINTAINERS                                        |   7 +-
 drivers/media/i2c/Kconfig                          |   7 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/dw9714.c                         |   2 +-
 drivers/media/i2c/imx274.c                         |   2 +-
 drivers/media/i2c/ov2640.c                         |  45 +-
 drivers/media/i2c/ov5640.c                         |  58 +-
 drivers/media/i2c/ov7670.c                         |  16 +-
 drivers/media/i2c/ov9640.c                         | 777 +++++++++++++++++++++
 drivers/media/i2c/ov9640.h                         | 207 ++++++
 drivers/media/i2c/soc_camera/Kconfig               |   6 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   5 +-
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c |   1 +
 15 files changed, 1103 insertions(+), 39 deletions(-)
 create mode 100644 drivers/media/i2c/ov9640.c
 create mode 100644 drivers/media/i2c/ov9640.h

-- 
Sakari Ailus
