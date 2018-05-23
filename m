Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:57831 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932217AbeEWKFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 06:05:42 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] media: imx274: cleanups, improvements and SELECTION API support
Date: Wed, 23 May 2018 12:05:13 +0200
Message-Id: <1527069921-21084-1-git-send-email-luca@lucaceresoli.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this patchset introduces cropping support for the Sony IMX274 sensor
using the SELECTION API. 

v3 has a few minor improvements over v2. It also removes the first 6
patches, already applied on the media_tree master branch.

After v2 there has been a short discussion with Sakari Ailus on how
cropping should be configured from userspace [0]. That discussion has
gone stale before I could understand the idea behind the changes
suggested by Sakari, so I'm sending the most up-to-date version of the
old implementation to give it a new spin. I'll be glad to rework my
patch when things are clearer.

Patches 1-5 are overall improvements and restructuring, mostly useful
to implement the SELECTION API in a clean way.

Patch 6 introduces a helper to allow setting many registers computed
at runtime in a straightforward way. This would not have been very
useful before because all long register write sequences came from
const tables, but it's definitely a must for the cropping code where
several register values are computed at runtime.

Patch 7 implements cropping in the set_selection pad operation. On the
v4l2 side there is nothing special. The most tricky part was
respecting all the device constraints on the horizontal crop.

Usage examples:
    
 * Capture the entire 4K area, downscaled to 1080p with 2:1 binning:
   media-ctl -V '"IMX274":0[crop:(0,0)/3840x2160]'
   media-ctl -V '"IMX274":0[fmt:SRGGB8_1X8/1920x1080 field:none]'

 * Capture the central 1080p area (no binning):
   media-ctl -V '"IMX274":0[crop:(960,540)/1920x1080]'
   (this also sets the fmt to 1920x1080)              

Regards,
Luca

[0] https://www.spinics.net/lists/kernel/msg2787725.html


Luca Ceresoli (7):
  media: imx274: initialize format before v4l2 controls
  media: imx274: consolidate per-mode data in imx274_frmfmt
  media: imx274: get rid of mode_index
  media: imx274: actually use IMX274_DEFAULT_MODE
  media: imx274: simplify imx274_write_table()
  media: imx274: add helper function to fill a reg_8 table chunk
  media: imx274: add SELECTION support for cropping

 drivers/media/i2c/imx274.c | 552 +++++++++++++++++++++++++++------------------
 1 file changed, 332 insertions(+), 220 deletions(-)

-- 
2.7.4
