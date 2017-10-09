Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48164 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751834AbdJIKTl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:41 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Benoit Parrot <bparrot@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pawel Osciak <pawel@osciak.com>, Pavel Machek <pavel@ucw.cz>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Helen Koike <helen.koike@collabora.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Sebastian Reichel <sre@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mike Isely <isely@pobox.com>,
        Hans Liljestrand <ishkamiel@gmail.com>
Subject: [PATCH 00/24] V4L2 kAPI cleanups and documentation improvements part 2
Date: Mon,  9 Oct 2017 07:19:06 -0300
Message-Id: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's the second part of my V4L2 kAPI documentation improvements.
It is meant to reduce the gap between the kAPI media headers
and documentation, at least with regards to kernel-doc markups.

We should likely write more things at the ReST files under Documentation/
to better describe some of those APIs (VB2 being likely the first candidate),
but at least let's be sure that all V4L2 bits have kernel-doc markups.

Mauro Carvalho Chehab (24):
  media: v4l2-dev.h: add kernel-doc to two macros
  media: v4l2-flash-led-class.h: add kernel-doc to two ancillary funcs
  media: v4l2-mediabus: use BIT() macro for flags
  media: v4l2-mediabus: convert flags to enums and document them
  media: v4l2-dev: convert VFL_TYPE_* into an enum
  media: i2c-addr.h: get rid of now unused defines
  media: get rid of i2c-addr.h
  media: v4l2-dev: document VFL_DIR_* direction defines
  media: v4l2-dev: document video_device flags
  media: v4l2-subdev: use kernel-doc markups to document subdev flags
  media: v4l2-subdev: create cross-references for ioctls
  media: v4l2-subdev: fix description of tuner.s_radio ops
  media: v4l2-subdev: better document IO pin configuration flags
  media: v4l2-subdev: convert frame description to enum
  media: v4l2-subdev: get rid of __V4L2_SUBDEV_MK_GET_TRY() macro
  media: v4l2-subdev: document remaining undocumented functions
  media: v4l2-subdev: fix a typo
  media: vb2-core: use bitops for bits
  media: vb2-core: Improve kernel-doc markups
  media: vb2-core: document remaining functions
  media: vb2-core: fix descriptions for VB2-only functions
  media: vb2: add cross references at memops and v4l2 kernel-doc markups
  media: v4l2-tpg*.h: move headers to include/media/tpg and merge them
  media: v4l2-tpg.h: rename color structs

 Documentation/media/kapi/v4l2-dev.rst              |  17 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c    |   8 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      |   2 +-
 drivers/media/i2c/adv7180.c                        |  10 +-
 drivers/media/i2c/ml86v7667.c                      |   5 +-
 drivers/media/i2c/mt9m111.c                        |   8 +-
 drivers/media/i2c/ov6650.c                         |  19 +-
 drivers/media/i2c/soc_camera/imx074.c              |   6 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |  10 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |  11 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |  11 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |  16 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   5 +-
 drivers/media/i2c/soc_camera/ov772x.c              |  10 +-
 drivers/media/i2c/soc_camera/ov9640.c              |  10 +-
 drivers/media/i2c/soc_camera/ov9740.c              |  10 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |  12 +-
 drivers/media/i2c/soc_camera/tw9910.c              |  13 +-
 drivers/media/i2c/tc358743.c                       |  10 +-
 drivers/media/i2c/tda7432.c                        |   1 -
 drivers/media/i2c/tvaudio.c                        |   2 -
 drivers/media/i2c/tvp5150.c                        |   6 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   7 +
 drivers/media/pci/bt8xx/bttv.h                     |   1 -
 drivers/media/pci/cx88/cx88-blackbird.c            |   3 +-
 drivers/media/pci/cx88/cx88-video.c                |  10 +-
 drivers/media/pci/cx88/cx88.h                      |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   2 +
 drivers/media/platform/pxa_camera.c                |   8 +-
 drivers/media/platform/rcar-vin/rcar-core.c        |   4 +-
 drivers/media/platform/rcar-vin/rcar-dma.c         |   4 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   3 +-
 .../platform/soc_camera/soc_camera_platform.c      |   2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
 drivers/media/platform/vimc/vimc-sensor.c          |   2 +-
 drivers/media/platform/vivid/vivid-core.h          |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   2 +
 drivers/media/usb/em28xx/em28xx-cards.c            |   1 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   2 +
 drivers/media/usb/tm6000/tm6000-cards.c            |   1 -
 drivers/media/usb/tm6000/tm6000-video.c            |   2 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  10 +-
 drivers/media/v4l2-core/v4l2-fwnode.c              |   5 +-
 include/media/i2c-addr.h                           |  42 --
 include/media/i2c/tvaudio.h                        |  17 +-
 include/media/{ => tpg}/v4l2-tpg.h                 |  45 +-
 include/media/v4l2-dev.h                           | 124 ++++--
 include/media/v4l2-flash-led-class.h               |  12 +
 include/media/v4l2-fwnode.h                        |   4 +-
 include/media/v4l2-mediabus.h                      | 176 ++++++--
 include/media/v4l2-subdev.h                        | 293 +++++++++----
 include/media/v4l2-tpg-colors.h                    |  68 ---
 include/media/videobuf2-core.h                     | 483 ++++++++++++---------
 include/media/videobuf2-memops.h                   |   8 +-
 include/media/videobuf2-v4l2.h                     | 112 ++---
 56 files changed, 1006 insertions(+), 659 deletions(-)
 delete mode 100644 include/media/i2c-addr.h
 rename include/media/{ => tpg}/v4l2-tpg.h (93%)
 delete mode 100644 include/media/v4l2-tpg-colors.h

-- 
2.13.6
