Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40006 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaCETWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 14:22:41 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 0/6] VSP1 Blend/ROP Unit and DT support 
Date: Wed,  5 Mar 2014 20:23:58 +0100
Message-Id: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series extends the VSP1 driver with support for the Blend/ROP Units
as well as DT bindings. Please see individual patches for details.

The driver patches (1 to 4) and platform patches (5 to 6) can be merged
independently once the DT bindings will be approved.

The series has been tested with the VSP1-DU0 instance on the Lager and Koelsch
boards.

Laurent Pinchart (6):
  v4l: vsp1: Support multi-input entities
  v4l: vsp1: Add BRU support
  v4l: vsp1: uds: Enable scaling of alpha layer
  v4l: vsp1: Add DT support
  ARM: shmobile: r8a7790: Add VSP1 devices to DT
  ARM: shmobile: r8a7791: Add VSP1 devices to DT

 .../devicetree/bindings/media/renesas,vsp1.txt     |  51 +++
 arch/arm/boot/dts/r8a7790.dtsi                     |  55 +++
 arch/arm/boot/dts/r8a7791.dtsi                     |  39 ++
 drivers/media/platform/vsp1/Makefile               |   2 +-
 drivers/media/platform/vsp1/vsp1.h                 |   2 +
 drivers/media/platform/vsp1/vsp1_bru.c             | 395 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_bru.h             |  39 ++
 drivers/media/platform/vsp1/vsp1_drv.c             |  61 +++-
 drivers/media/platform/vsp1/vsp1_entity.c          |  57 +--
 drivers/media/platform/vsp1/vsp1_entity.h          |  24 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            |   7 +-
 drivers/media/platform/vsp1/vsp1_lif.c             |   1 -
 drivers/media/platform/vsp1/vsp1_lut.c             |   1 -
 drivers/media/platform/vsp1/vsp1_regs.h            |  98 +++++
 drivers/media/platform/vsp1/vsp1_rpf.c             |   7 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   4 +
 drivers/media/platform/vsp1/vsp1_sru.c             |   1 -
 drivers/media/platform/vsp1/vsp1_uds.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  26 +-
 drivers/media/platform/vsp1/vsp1_video.h           |   1 +
 drivers/media/platform/vsp1/vsp1_wpf.c             |  13 +-
 21 files changed, 830 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,vsp1.txt
 create mode 100644 drivers/media/platform/vsp1/vsp1_bru.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_bru.h

-- 
Regards,

Laurent Pinchart

