Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB087C282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 21:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9195421019
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 21:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbfAVVIq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 16:08:46 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49370 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725913AbfAVVIq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 16:08:46 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 408C9634C94
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 23:08:20 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gm3HR-0000w6-AT
        for linux-media@vger.kernel.org; Tue, 22 Jan 2019 23:08:21 +0200
Date:   Tue, 22 Jan 2019 23:08:21 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     linux-media@vger.kernel.org
Subject: [GIT PULL for 5.1] Yet more sensor driver patches
Message-ID: <20190122210821.4nt27kpg6y7cbsiq@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

Here's the regular set of sensor driver patches. This time is noteworthy,
because there's nothing else. New drivers for mt9m001 (converted from SoC
camera; the corresponding old SoC camera driver to be removed after this
set) and ov8856 are included.

Please pull.


The following changes since commit 337e90ed028643c7acdfd0d31e3224d05ca03d66:

  media: imx-csi: Input connections to CSI should be optional (2019-01-21 16:46:02 -0200)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-5.1-2-sign

for you to fetch changes up to 72a16f66761793d9d7bb5b55b68cb99562f7c229:

  media: ov2640: fix initial try format (2019-01-22 18:29:16 +0200)

----------------------------------------------------------------
More sensor patches for 5.1

----------------------------------------------------------------
Akinobu Mita (17):
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
      media: mt9m001: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
      media: mt9m001: set all mbus format field when G_FMT and S_FMT ioctls
      media: mt9m111: make VIDIOC_SUBDEV_G_FMT ioctl work with V4L2_SUBDEV_FORMAT_TRY
      media: mt9m111: set all mbus format field when G_FMT and S_FMT ioctls
      media: mt9m111: set initial frame size other than 0x0
      media: ov2640: fix initial try format

Ben Kao (2):
      media: ov8856: Add support for OV8856 sensor
      media: ov8856: Modify ov8856 register reading function to be simplified

Dan Carpenter (1):
      media: s5k4ecgx: delete a bogus error message

Lubomir Rintel (4):
      media: ov7670: split register setting from set_fmt() logic
      media: ov7670: split register setting from set_framerate() logic
      media: ov7670: hook s_power onto v4l2 core
      media: ov7670: control clock along with power

Luca Ceresoli (1):
      media: imx274: remote unused function imx274_read_reg

Sakari Ailus (1):
      ov7670: Remove useless use of a ret variable

 .../devicetree/bindings/media/i2c/mt9m001.txt      |   38 +
 MAINTAINERS                                        |    7 +
 drivers/media/i2c/Kconfig                          |   20 +
 drivers/media/i2c/Makefile                         |    2 +
 drivers/media/i2c/imx274.c                         |   18 -
 drivers/media/i2c/mt9m001.c                        |  884 ++++++++++++++
 drivers/media/i2c/mt9m111.c                        |   39 +
 drivers/media/i2c/ov2640.c                         |   10 +-
 drivers/media/i2c/ov7670.c                         |  187 +--
 drivers/media/i2c/ov8856.c                         | 1268 ++++++++++++++++++++
 drivers/media/i2c/s5k4ecgx.c                       |    2 -
 11 files changed, 2380 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m001.txt
 create mode 100644 drivers/media/i2c/mt9m001.c
 create mode 100644 drivers/media/i2c/ov8856.c

-- 
Sakari Ailus
