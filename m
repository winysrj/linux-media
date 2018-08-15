Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39614 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbeHOQWM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:22:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id h10-v6so1136053wre.6
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 06:30:00 -0700 (PDT)
From: petrcvekcz@gmail.com
To: hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v2 0/4] media: soc_camera: ov9640: switch driver to v4l2_async
Date: Wed, 15 Aug 2018 15:30:23 +0200
Message-Id: <cover.1534339750.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

This patch series transfer the ov9640 driver from the soc_camera subsystem
into a standalone v4l2 driver. There is no changes except the required
v4l2_async calls, GPIO allocation, deletion of now unused variables,
a change from mdelay() to msleep() and an addition of SPDX identifiers
(as suggested in the v1 version RFC).

The config symbol has been changed from CONFIG_SOC_CAMERA_OV9640 to
CONFIG_VIDEO_OV9640.

Also as the drivers of the soc_camera seems to be orphaned I'm volunteering
as a maintainer of the driver (I own the hardware).

I've found the ov9640 seems to be used at least in (the future) HTC
Magician and Palm Zire72. These will need to define power and reset GPIOs
and remove the soc_camera definitions. I'm debugging it on magician now
(ov9640 was unusable on them since the pxa_camera switched from
the soc_camera).

Petr Cvek (4):
  media: soc_camera: ov9640: move ov9640 out of soc_camera
  media: i2c: ov9640: drop soc_camera code and switch to v4l2_async
  media: i2c: ov9640: add missing SPDX identifiers
  MAINTAINERS: Add Petr Cvek as a maintainer for the ov9640 driver

 MAINTAINERS                          |   6 +
 drivers/media/i2c/Kconfig            |   7 +
 drivers/media/i2c/Makefile           |   1 +
 drivers/media/i2c/ov9640.c           | 766 +++++++++++++++++++++++++++
 drivers/media/i2c/ov9640.h           | 207 ++++++++
 drivers/media/i2c/soc_camera/Kconfig |   6 +-
 6 files changed, 991 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/i2c/ov9640.c
 create mode 100644 drivers/media/i2c/ov9640.h

--
2.18.0
