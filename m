Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43957 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752090AbdFVOhi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 10:37:38 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Helen Koike <helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] vimc: Virtual Media Control VPU's
Message-ID: <14200459-ec9c-5700-901e-b2dcc9580193@xs4all.nl>
Date: Thu, 22 Jun 2017 16:37:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This will make vimc a lot more interesting as a test driver. Time to get
this merged.

Helen, reviewing your API proposal on configuring the topology: once this is
merged I plan to look at that next.

Regards,

	Hans

The following changes since commit 76724b30f222067faf00874dc277f6c99d03d800:

   [media] media: venus: enable building with COMPILE_TEST (2017-06-20 10:57:08 -0300)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git vimc

for you to fetch changes up to 571f6e3044b55ccbd892872750e3acf4d9c8e64d:

   vimc: sen: Declare vimc_sen_video_ops as static (2017-06-22 16:20:44 +0200)

----------------------------------------------------------------
Helen Fornazier (12):
       vimc: sen: Integrate the tpg on the sensor
       vimc: Move common code from the core
       vimc: common: Add vimc_ent_sd_* helper
       vimc: common: Add vimc_pipeline_s_stream helper
       vimc: common: Add vimc_link_validate
       vimc: common: Add vimc_colorimetry_clamp
       vimc: sen: Support several image formats
       vimc: cap: Support several image formats
       vimc: Subdevices as modules
       vimc: deb: Add debayer filter
       vimc: sca: Add scaler
       vimc: sen: Declare vimc_sen_video_ops as static

  drivers/media/platform/vimc/Kconfig        |   1 +
  drivers/media/platform/vimc/Makefile       |  10 +-
  drivers/media/platform/vimc/vimc-capture.c | 321 +++++++++++++++++-------------
  drivers/media/platform/vimc/vimc-capture.h |  28 ---
  drivers/media/platform/vimc/vimc-common.c  | 473 ++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/platform/vimc/vimc-common.h  | 229 ++++++++++++++++++++++
  drivers/media/platform/vimc/vimc-core.c    | 610 +++++++++++++++------------------------------------------
  drivers/media/platform/vimc/vimc-core.h    | 112 -----------
  drivers/media/platform/vimc/vimc-debayer.c | 601 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/media/platform/vimc/vimc-scaler.c  | 455 ++++++++++++++++++++++++++++++++++++++++++
  drivers/media/platform/vimc/vimc-sensor.c  | 321 ++++++++++++++++++++----------
  drivers/media/platform/vimc/vimc-sensor.h  |  28 ---
  12 files changed, 2325 insertions(+), 864 deletions(-)
  delete mode 100644 drivers/media/platform/vimc/vimc-capture.h
  create mode 100644 drivers/media/platform/vimc/vimc-common.c
  create mode 100644 drivers/media/platform/vimc/vimc-common.h
  delete mode 100644 drivers/media/platform/vimc/vimc-core.h
  create mode 100644 drivers/media/platform/vimc/vimc-debayer.c
  create mode 100644 drivers/media/platform/vimc/vimc-scaler.c
  delete mode 100644 drivers/media/platform/vimc/vimc-sensor.h
