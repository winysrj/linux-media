Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:58929 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755656AbcH2R4J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 13:56:09 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jiri Kosina <trivial@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 00/13] pxa_camera transition to v4l2 standalone device
Date: Mon, 29 Aug 2016 19:55:45 +0200
Message-Id: <1472493358-24618-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no change between v4 and v5, ie. the global diff is empty, only one
line was shifted to prevent breaking bisectablility.

All the text in https://lkml.org/lkml/2016/8/15/609 is still applicable.

Cheers.

--
Robert

Robert Jarzmik (13):
  media: mt9m111: make a standalone v4l2 subdevice
  media: mt9m111: use only the SRGB colorspace
  media: mt9m111: move mt9m111 out of soc_camera
  media: platform: pxa_camera: convert to vb2
  media: platform: pxa_camera: trivial move of functions
  media: platform: pxa_camera: introduce sensor_call
  media: platform: pxa_camera: make printk consistent
  media: platform: pxa_camera: add buffer sequencing
  media: platform: pxa_camera: remove set_crop
  media: platform: pxa_camera: make a standalone v4l2 device
  media: platform: pxa_camera: add debug register access
  media: platform: pxa_camera: change stop_streaming semantics
  media: platform: pxa_camera: move pxa_camera out of soc_camera

 drivers/media/i2c/Kconfig                      |    7 +
 drivers/media/i2c/Makefile                     |    1 +
 drivers/media/i2c/mt9m111.c                    | 1033 ++++++++++++
 drivers/media/i2c/soc_camera/Kconfig           |    7 +-
 drivers/media/i2c/soc_camera/Makefile          |    1 -
 drivers/media/i2c/soc_camera/mt9m111.c         | 1054 ------------
 drivers/media/platform/Kconfig                 |    8 +
 drivers/media/platform/Makefile                |    1 +
 drivers/media/platform/pxa_camera.c            | 2096 ++++++++++++++++++++++++
 drivers/media/platform/soc_camera/Kconfig      |    8 -
 drivers/media/platform/soc_camera/Makefile     |    1 -
 drivers/media/platform/soc_camera/pxa_camera.c | 1866 ---------------------
 include/linux/platform_data/media/camera-pxa.h |    2 +
 13 files changed, 3153 insertions(+), 2932 deletions(-)
 create mode 100644 drivers/media/i2c/mt9m111.c
 delete mode 100644 drivers/media/i2c/soc_camera/mt9m111.c
 create mode 100644 drivers/media/platform/pxa_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/pxa_camera.c

-- 
2.1.4

