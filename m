Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:36428 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753449AbeGEOin (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 10:38:43 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/2] media: imx274: cleanups, improvements and SELECTION API support
Date: Thu,  5 Jul 2018 16:38:07 +0200
Message-Id: <1530801489-29953-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patchset introduces cropping support for the Sony IMX274 sensor
using the SELECTION API.

Changes since v4:

 - remove most of the preliminary cleanup patches that are now on the
   linuxtv master branch
 - the V4L2_SEL_FLAG_GE and V4L2_SEL_FLAG_LE flags are not honored
 - the prepare_reg() helper function is gone, replaced by a simpler
   approach to write a multibyte register

Patch 1 introduces a helper to greatly simplify the code to write a
multibyte register.

Patch 2 implements the set_selection pad operation for cropping
(V4L2_SEL_TGT_CROP) and binning (V4L2_SEL_TGT_COMPOSE).

Usage examples:

 * Capture the entire 4K area, downscaled to 1080p with 2:1 binning:
   media-ctl -V '"IMX274":0[crop:(0,0)/3840x2160]'
   media-ctl -V '"IMX274":0[compose:(0,0)/1920x1080]'

 * Capture the central 1080p area (no binning):
   media-ctl -V '"IMX274":0[crop:(960,540)/1920x1080]'
   (this also sets the compose and fmt rects to 1920x1080)

Regards,
Luca


Luca Ceresoli (2):
  media: imx274: use regmap_bulk_write to write multybyte registers
  media: imx274: add cropping support via SELECTION API

 drivers/media/i2c/imx274.c | 567 +++++++++++++++++++++++++++++++++------------
 1 file changed, 413 insertions(+), 154 deletions(-)

-- 
2.7.4
