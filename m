Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:52260 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932894AbeFKLgH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 07:36:07 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/8] media: imx274: cleanups, improvements and SELECTION API support
Date: Mon, 11 Jun 2018 13:35:31 +0200
Message-Id: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patchset introduces cropping support for the Sony IMX274 sensor
using the SELECTION API.

With respect to v3, this version uses the SELECTION API with taget
V4L2_SEL_TGT_COMPOSE to change the output resolution. This is the
recommended API for cropping + downscaling. However for backward
compatibility the set_format callback is still supported and is
equivalent to setting the compose rect as far as resolutions are
concerned.

Patches 1-5 are overall improvements and restructuring, mostly useful
to implement the SELECTION API in a clean way.

Patch 6 introduces a helper to allow setting many registers computed
at runtime in a straightforward way. This would not have been very
useful before because all long register write sequences came from
const tables, but it's definitely a must for the cropping code where
several register values are computed at runtime.

Patch 7 is new in this series, it's a trivial typo fix that can be
applied independently.

Patch 8 implements the set_selection pad operation for cropping
(V4L2_SEL_TGT_CROP) and binning (V4L2_SEL_TGT_COMPOSE). The most
tricky part was respecting all the device constraints on the
horizontal crop.

Usage examples:

 * Capture the entire 4K area, downscaled to 1080p with 2:1 binning:
   media-ctl -V '"IMX274":0[crop:(0,0)/3840x2160]'
   media-ctl -V '"IMX274":0[compose:(0,0)/1920x1080]'

 * Capture the central 1080p area (no binning):
   media-ctl -V '"IMX274":0[crop:(960,540)/1920x1080]'
   (this also sets the compose and fmt rects to 1920x1080)

Regards,
Luca


Luca Ceresoli (8):
  media: imx274: initialize format before v4l2 controls
  media: imx274: consolidate per-mode data in imx274_frmfmt
  media: imx274: get rid of mode_index
  media: imx274: actually use IMX274_DEFAULT_MODE
  media: imx274: simplify imx274_write_table()
  media: imx274: add helper function to fill a reg_8 table chunk
  media: imx274: fix typo
  media: imx274: add SELECTION support for cropping

 drivers/media/i2c/imx274.c | 686 ++++++++++++++++++++++++++++++---------------
 1 file changed, 461 insertions(+), 225 deletions(-)

-- 
2.7.4
