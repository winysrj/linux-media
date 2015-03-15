Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52033 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbbCOSuV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 14:50:21 -0400
Received: from axis700.grange ([84.44.140.95]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MXqV1-1Z18f73kzH-00Wpui for
 <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 19:50:18 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 8ED0440BD9
	for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 19:50:17 +0100 (CET)
Date: Sun, 15 Mar 2015 19:50:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: first 4.1 patch set
Message-ID: <Pine.LNX.4.64.1503151915070.13027@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please, pull a bunch of soc-camera patches and my two v4l2_clk patches.

The following changes since commit 48b777c0833bc7392679405539bb5d3ed0900828:

  Merge branch 'patchwork' into to_next (2015-02-10 21:42:33 -0200)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.1-1

for you to fetch changes up to ca1613ec1a022fe2a3091fc1c0fbbe0661f1b2a6:

  rcar-vin: Don't implement empty optional clock operations (2015-03-15 18:58:43 +0100)

----------------------------------------------------------------
Guennadi Liakhovetski (2):
      V4L: remove clock name from v4l2_clk API
      V4L: add CCF support to the v4l2_clk API

Josh Wu (4):
      media: soc-camera: use icd->control instead of icd->pdev for reset()
      media: ov2640: add async probe function
      media: ov2640: dt: add the device tree binding document
      media: ov2640: add primary dt support

Laurent Pinchart (3):
      soc-camera: Unregister v4l2 clock in the OF bind error path
      soc-camera: Make clock_start and clock_stop operations optional
      rcar-vin: Don't implement empty optional clock operations

 .../devicetree/bindings/media/i2c/ov2640.txt       |  46 ++++++++
 drivers/media/i2c/soc_camera/ov2640.c              | 124 +++++++++++++++++----
 drivers/media/platform/soc_camera/rcar_vin.c       |  15 ---
 drivers/media/platform/soc_camera/soc_camera.c     |  78 +++++++------
 drivers/media/usb/em28xx/em28xx-camera.c           |   2 +-
 drivers/media/v4l2-core/v4l2-clk.c                 |  81 ++++++++++----
 include/media/v4l2-clk.h                           |  10 +-
 7 files changed, 257 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2640.txt

Thanks
Guennadi
