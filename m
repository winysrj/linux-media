Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35553 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbbHFU0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 16:26:25 -0400
Received: by ykcq64 with SMTP id q64so67583223ykc.2
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2015 13:26:24 -0700 (PDT)
From: Helen Fornazier <helen.fornazier@gmail.com>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Cc: Helen Fornazier <helen.fornazier@gmail.com>
Subject: [PATCH 0/7] vimc: Virtual Media Control VPU's
Date: Thu,  6 Aug 2015 17:26:07 -0300
Message-Id: <cover.1438891530.git.helen.fornazier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* This patch series add to the vimc driver video processing units ad a debayer and a scaler.
* The test pattern generator from vivid driver was exported as a module, as it is used by
  the vimc driver as well.
* The debayer transforms the bayer format image received in its sink pad to a bayer format
  by avaraging the pixels within a mean window
* The scaler only scales up the image for now.
* The ioctls to configure the format in the pads were implemented to allow testing the pipe
  from the user space


The patch series is based on 'vimc/review/video-pipe' branch, it goes on top of the patch
named "[media] vimc: Virtual Media Controller core, capture and sensor" and is available at
        https://github.com/helen-fornazier/opw-staging vimc/review/vpu

Helen Fornazier (7):
  [media] tpg: Export the tpg code from vivid as a module
  [media] vimc: sen: Integrate the tpg on the sensor
  [media] vimc: Add vimc_ent_sd_init/cleanup helper functions
  [media] vimc: Add vimc_pipeline_s_stream in the core
  [media] vimc: deb: Add debayer filter
  [media] vimc: sca: Add scaler subdevice
  [media] vimc: Implement set format in the nodes

 drivers/media/platform/Kconfig                  |    2 +
 drivers/media/platform/Makefile                 |    1 +
 drivers/media/platform/tpg/Kconfig              |    5 +
 drivers/media/platform/tpg/Makefile             |    3 +
 drivers/media/platform/tpg/tpg-colors.c         | 1181 ++++++++++++
 drivers/media/platform/tpg/tpg-core.c           | 2211 +++++++++++++++++++++++
 drivers/media/platform/vimc/Kconfig             |    1 +
 drivers/media/platform/vimc/Makefile            |    3 +-
 drivers/media/platform/vimc/vimc-capture.c      |   88 +-
 drivers/media/platform/vimc/vimc-core.c         |  196 +-
 drivers/media/platform/vimc/vimc-core.h         |   29 +
 drivers/media/platform/vimc/vimc-debayer.c      |  503 ++++++
 drivers/media/platform/vimc/vimc-debayer.h      |   28 +
 drivers/media/platform/vimc/vimc-scaler.c       |  362 ++++
 drivers/media/platform/vimc/vimc-scaler.h       |   28 +
 drivers/media/platform/vimc/vimc-sensor.c       |  175 +-
 drivers/media/platform/vivid/Kconfig            |    1 +
 drivers/media/platform/vivid/Makefile           |    2 +-
 drivers/media/platform/vivid/vivid-core.h       |    2 +-
 drivers/media/platform/vivid/vivid-tpg-colors.c | 1182 ------------
 drivers/media/platform/vivid/vivid-tpg-colors.h |   68 -
 drivers/media/platform/vivid/vivid-tpg.c        | 2191 ----------------------
 drivers/media/platform/vivid/vivid-tpg.h        |  596 ------
 include/media/tpg-colors.h                      |   68 +
 include/media/tpg.h                             |  595 ++++++
 25 files changed, 5345 insertions(+), 4176 deletions(-)
 create mode 100644 drivers/media/platform/tpg/Kconfig
 create mode 100644 drivers/media/platform/tpg/Makefile
 create mode 100644 drivers/media/platform/tpg/tpg-colors.c
 create mode 100644 drivers/media/platform/tpg/tpg-core.c
 create mode 100644 drivers/media/platform/vimc/vimc-debayer.c
 create mode 100644 drivers/media/platform/vimc/vimc-debayer.h
 create mode 100644 drivers/media/platform/vimc/vimc-scaler.c
 create mode 100644 drivers/media/platform/vimc/vimc-scaler.h
 delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.c
 delete mode 100644 drivers/media/platform/vivid/vivid-tpg-colors.h
 delete mode 100644 drivers/media/platform/vivid/vivid-tpg.c
 delete mode 100644 drivers/media/platform/vivid/vivid-tpg.h
 create mode 100644 include/media/tpg-colors.h
 create mode 100644 include/media/tpg.h

-- 
1.9.1

