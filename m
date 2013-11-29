Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43065 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3K2Wu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 17:50:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 0/6] Miscellaneous VSP1 patches
Date: Fri, 29 Nov 2013 23:50:46 +0100
Message-Id: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here are a couple of patches for the Renesas VSP1 driver. The first patch
fixes a bug in the driver, while the remaining patches add new features
(cropping at the inputs and outputs, and HST, HSI, SRU and LUT blocks).

The HST and HSI blocks convert RGB to/from HSV and thus require a new HSV
media bus format, introduced in patch 3/6.

Laurent Pinchart (6):
  v4l: vsp1: Supply frames to the DU continuously
  v4l: vsp1: Add cropping support
  v4l: Add media format codes for AHSV8888 on 32-bit busses
  v4l: vsp1: Add HST and HSI support
  v4l: vsp1: Add SRU support
  v4l: vsp1: Add LUT support

 Documentation/DocBook/media/v4l/subdev-formats.xml | 157 +++++++++
 drivers/media/platform/vsp1/Makefile               |   3 +-
 drivers/media/platform/vsp1/vsp1.h                 |   7 +
 drivers/media/platform/vsp1/vsp1_drv.c             |  39 +++
 drivers/media/platform/vsp1/vsp1_entity.c          |   7 +
 drivers/media/platform/vsp1/vsp1_entity.h          |   4 +
 drivers/media/platform/vsp1/vsp1_hsit.c            | 222 +++++++++++++
 drivers/media/platform/vsp1/vsp1_hsit.h            |  38 +++
 drivers/media/platform/vsp1/vsp1_lut.c             | 252 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_lut.h             |  38 +++
 drivers/media/platform/vsp1/vsp1_regs.h            |  16 +
 drivers/media/platform/vsp1/vsp1_rpf.c             |  34 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  96 ++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h            |  10 +
 drivers/media/platform/vsp1/vsp1_sru.c             | 356 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_sru.h             |  41 +++
 drivers/media/platform/vsp1/vsp1_video.c           |  13 +
 drivers/media/platform/vsp1/vsp1_wpf.c             |  17 +-
 include/linux/platform_data/vsp1.h                 |   2 +
 include/uapi/linux/v4l2-mediabus.h                 |   3 +
 include/uapi/linux/vsp1.h                          |  34 ++
 21 files changed, 1372 insertions(+), 17 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.h
 create mode 100644 include/uapi/linux/vsp1.h

-- 
Regards,

Laurent Pinchart

