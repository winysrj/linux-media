Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55295 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeHIEBv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 00:01:51 -0400
Received: by mail-wm0-f67.google.com with SMTP id c14-v6so4640787wmb.4
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 18:39:32 -0700 (PDT)
From: petrcvekcz@gmail.com
To: marek.vasut@gmail.com, mchehab@kernel.org
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v1 0/5] [media] soc_camera: ov9640 switch to v4l2_async
Date: Thu,  9 Aug 2018 03:39:44 +0200
Message-Id: <cover.1533774451.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

This patch series transfer the ov9640 driver from the soc_camera subsystem
into a standalone v4l2 driver. There is no changes except the required
v4l2_async calls, GPIO allocation and a deleting of now unused variables.

The config symbol has been changed from CONFIG_SOC_CAMERA_OV9640 to
VIDEO_OV9640.

Also as the drivers of the soc_camera seems to be orphaned I'm volunteering
to maintain the driver (I own the hardware).

I've found the ov9640 seems to be used at least in magician and Palm Zire72.
These need to define power and reset GPIOs and remove the soc_camera
definitions. I'm debugging it on magician now (the camera was unusable
on them since the pxa_camera switched from the soc_camera).

Petr Cvek (5):
  [media] soc_camera: ov9640: move ov9640 out of soc_camera
  [media] i2c: soc_camera: remove ov9640 Kconfig and Makefile options
  [media] i2c: add ov9640 config option as a standalone v4l2 sensor
  [media] i2c: drop soc_camera code from ov9640 and switch to v4l2_async
  MAINTAINERS: Add Petr Cvek as a maintainer for the ov9640 driver

 MAINTAINERS                                 |  6 ++
 drivers/media/i2c/Kconfig                   |  7 ++
 drivers/media/i2c/Makefile                  |  1 +
 drivers/media/i2c/{soc_camera => }/ov9640.c | 76 ++++++++++++++-------
 drivers/media/i2c/{soc_camera => }/ov9640.h |  2 +
 drivers/media/i2c/soc_camera/Kconfig        |  6 --
 drivers/media/i2c/soc_camera/Makefile       |  1 -
 7 files changed, 69 insertions(+), 30 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/ov9640.c (93%)
 rename drivers/media/i2c/{soc_camera => }/ov9640.h (98%)

--
2.18.0
