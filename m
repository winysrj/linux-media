Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45206 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaDJStL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 14:49:11 -0400
Received: from avalon.localnet (123.11-200-80.adsl-dyn.isp.belgacom.be [80.200.11.123])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id DA716359FA
	for <linux-media@vger.kernel.org>; Thu, 10 Apr 2014 20:47:15 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.16] VSP1 fixes and features
Date: Thu, 10 Apr 2014 20:49:07 +0200
Message-ID: <8418669.oTIsAxPqfT@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:

  [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 08:02:16 
-0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1/next

for you to fetch changes up to 3d9b1cabc31b86f01e396a9de036398e140270e0:

  v4l: vsp1: Add DT support (2014-04-08 18:43:03 +0200)

Given that the DT bindings are simple, that they have been acked by Sylwester 
and that the DT bindings maintainers have been largely unresponsive, I believe 
this can go in as-is.

----------------------------------------------------------------
Laurent Pinchart (6):
      v4l: vsp1: Remove unexisting rt clocks
      v4l: vsp1: uds: Enable scaling of alpha layer
      v4l: vsp1: Support multi-input entities
      v4l: vsp1: Add BRU support
      v4l: vsp1: Add DT bindings documentation
      v4l: vsp1: Add DT support

 .../devicetree/bindings/media/renesas,vsp1.txt          |  43 +++
 drivers/media/platform/vsp1/Makefile                    |   2 +-
 drivers/media/platform/vsp1/vsp1.h                      |   3 +-
 drivers/media/platform/vsp1/vsp1_bru.c                  | 395 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_bru.h                  |  39 +++
 drivers/media/platform/vsp1/vsp1_drv.c                  | 101 +++---
 drivers/media/platform/vsp1/vsp1_entity.c               |  57 ++--
 drivers/media/platform/vsp1/vsp1_entity.h               |  24 +-
 drivers/media/platform/vsp1/vsp1_hsit.c                 |   7 +-
 drivers/media/platform/vsp1/vsp1_lif.c                  |   1 -
 drivers/media/platform/vsp1/vsp1_lut.c                  |   1 -
 drivers/media/platform/vsp1/vsp1_regs.h                 |  98 ++++++
 drivers/media/platform/vsp1/vsp1_rpf.c                  |   7 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h                 |   4 +
 drivers/media/platform/vsp1/vsp1_sru.c                  |   1 -
 drivers/media/platform/vsp1/vsp1_uds.c                  |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c                |  26 +-
 drivers/media/platform/vsp1/vsp1_video.h                |   1 +
 drivers/media/platform/vsp1/vsp1_wpf.c                  |  13 +-
 19 files changed, 733 insertions(+), 94 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,vsp1.txt
 create mode 100644 drivers/media/platform/vsp1/vsp1_bru.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_bru.h

-- 
Regards,

Laurent Pinchart
