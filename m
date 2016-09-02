Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:46511 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754068AbcIBOJ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 10:09:59 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: corbet@lwn.net, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 0/2] v4l: vsp1: Add HGT support
Date: Fri,  2 Sep 2016 15:47:12 +0200
Message-Id: <20160902134714.12224-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series add support for the VSP1 2-D histogram engine HGT.

It's based on top of Laurent Pinchart tree at 
git://linuxtv.org/pinchartl/media.git hgo.

It is tested on Koelsch using a modified vsp-tests suite package, 
modifications can be found at https://git.ragnatech.se/vsp-tests hgt.

Niklas Söderlund (2):
  v4l: Define a pixel format for the R-Car VSP1 2-D histogram engine
  v4l: vsp1: Add HGT support

 Documentation/media/uapi/v4l/meta-formats.rst      |   1 +
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst        | 150 +++++++
 drivers/media/platform/vsp1/Makefile               |   2 +-
 drivers/media/platform/vsp1/vsp1.h                 |   3 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  32 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |  33 +-
 drivers/media/platform/vsp1/vsp1_entity.h          |   1 +
 drivers/media/platform/vsp1/vsp1_hgt.c             | 495 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgt.h             |  51 +++
 drivers/media/platform/vsp1/vsp1_pipe.c            |  16 +
 drivers/media/platform/vsp1/vsp1_pipe.h            |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h            |   9 +
 drivers/media/platform/vsp1/vsp1_video.c           |  10 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 include/uapi/linux/videodev2.h                     |   3 +-
 15 files changed, 792 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h

-- 
2.9.3

