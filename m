Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54908 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbbKPEql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 23:46:41 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 0/4] VSP1: Add support for lookup tables
Date: Mon, 16 Nov 2015 06:46:41 +0200
Message-Id: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

The VSP1 includes two lookup table modules, a 1D LUT and a 3D cubic lookup
table (CLU). This patch series fixes the LUT implementation and adds support
for the CLU.

The patches are based on top of

	git://linuxtv.org/media_tree.git master

and have been tested on a Koelsch board.

Laurent Pinchart (4):
  v4l: vsp1: Fix LUT format setting
  v4l: vsp1: Add Cubic Look Up Table (CLU) support
  ARM: Renesas: r8a7790: Enable CLU support in VSPS
  ARM: Renesas: r8a7791: Enable CLU support in VSPS

 .../devicetree/bindings/media/renesas,vsp1.txt     |   3 +
 arch/arm/boot/dts/r8a7790.dtsi                     |   1 +
 arch/arm/boot/dts/r8a7791.dtsi                     |   1 +
 drivers/media/platform/vsp1/Makefile               |   3 +-
 drivers/media/platform/vsp1/vsp1.h                 |   3 +
 drivers/media/platform/vsp1/vsp1_clu.c             | 288 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_clu.h             |  38 +++
 drivers/media/platform/vsp1/vsp1_drv.c             |  13 +
 drivers/media/platform/vsp1/vsp1_entity.c          |   1 +
 drivers/media/platform/vsp1/vsp1_entity.h          |   1 +
 drivers/media/platform/vsp1/vsp1_lut.c             |   1 +
 drivers/media/platform/vsp1/vsp1_regs.h            |   9 +
 include/uapi/linux/vsp1.h                          |  25 ++
 13 files changed, 386 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.h

-- 
Regards,

Laurent Pinchart

