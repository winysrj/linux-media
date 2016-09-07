Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:36083 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932785AbcIGMNn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 08:13:43 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: corbet@lwn.net, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv3 0/2] v4l: vsp1: Add HGT support
Date: Wed,  7 Sep 2016 14:09:36 +0200
Message-Id: <20160907120938.818-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series add support for the VSP1 2-D histogram engine HGT.

It's based on top of Laurent Pinchart tree at
git://linuxtv.org/pinchartl/media.git hgo. And depends on Laurents patch
'[PATCH] v4l: vsp1: Move subdev operations from HGO to common histogram
code'.

It is tested on Koelsch using a modified vsp-tests suite package,
modifications can be found at https://git.ragnatech.se/vsp-tests hgt.

* Changes since v2
- Add .try_ctrl() handling and return -EINVAL instead of trying to correct the 
  hue areas. Thanks Laurent for suggesting a solution to this.
- Fixed typo in pixel format documentation, thanks Laurent for spotting it.

* Changes since v1
- Rebased on top of Laurents patch which made all subdev operations
  common for HGO and HGT. This removed a lot of code that is now shared.
- Removed the Hue area configuration for the histogram pixel format.
  These values are set by userspace so it already knows them.
- Updated pixel format documentation after input from Laurent.
- Better aligned the code to the existing VSP code base.
- Simplify check that hue areas are valid for the hardware.
- Fixed spelling.

Niklas Söderlund (2):
  v4l: Define a pixel format for the R-Car VSP1 2-D histogram engine
  v4l: vsp1: Add HGT support

 Documentation/media/uapi/v4l/meta-formats.rst      |   1 +
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst        | 120 +++++++++++
 drivers/media/platform/vsp1/Makefile               |   2 +-
 drivers/media/platform/vsp1/vsp1.h                 |   3 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  33 ++-
 drivers/media/platform/vsp1/vsp1_entity.c          |  33 ++-
 drivers/media/platform/vsp1/vsp1_entity.h          |   1 +
 drivers/media/platform/vsp1/vsp1_hgt.c             | 221 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgt.h             |  42 ++++
 drivers/media/platform/vsp1/vsp1_pipe.c            |  16 ++
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h            |   9 +
 drivers/media/platform/vsp1/vsp1_video.c           |  10 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 include/uapi/linux/videodev2.h                     |   3 +-
 15 files changed, 480 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h

-- 
2.9.3

