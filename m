Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54744 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbbBATiW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Feb 2015 14:38:22 -0500
Received: from axis700.grange ([87.78.204.142]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0Le64S-1XsdHM0k8K-00ptAn for
 <linux-media@vger.kernel.org>; Sun, 01 Feb 2015 20:38:20 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id CCA4140BD9
	for <linux-media@vger.kernel.org>; Sun,  1 Feb 2015 20:38:18 +0100 (CET)
Date: Sun, 1 Feb 2015 20:38:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera for 3.20 #1
Message-ID: <Pine.LNX.4.64.1502012035590.18447@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are the simpler patches for soc-camera of those, recently submitted. 
A few more are in work, don't know how many of them will be reworked 
quickly enough for 3.20.

The following changes since commit 7640c108d5912b5da0a9c795aa5b98bbf2a12118:

  Merge branch 'patchwork' into to_next (2015-01-29 19:25:59 -0200)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.20-1

for you to fetch changes up to 9955c8587391e346d7e5fc51160a1a84685085c2:

  rcar_vin: move buffer management to .stop_streaming handler (2015-02-01 19:32:37 +0100)

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      soc-camera: remove redundant code

Ian Molton (1):
      rcar_vin: helper function for streaming stop

Josh Wu (1):
      ov2640: use the v4l2 size definitions

Lad, Prabhakar (1):
      soc_camera: use vb2_ops_wait_prepare/finish helper

William Towle (1):
      rcar_vin: move buffer management to .stop_streaming handler

 drivers/media/i2c/soc_camera/ov2640.c              | 82 +++++++------------
 drivers/media/platform/soc_camera/atmel-isi.c      |  7 +-
 drivers/media/platform/soc_camera/mx3_camera.c     |  7 +-
 drivers/media/platform/soc_camera/rcar_vin.c       | 94 +++++++++-------------
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  7 +-
 drivers/media/platform/soc_camera/soc_camera.c     | 18 -----
 6 files changed, 82 insertions(+), 133 deletions(-)

Thanks
Guennadi
