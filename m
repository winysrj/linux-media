Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53479 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbbITRKq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2015 13:10:46 -0400
Received: from axis700.grange ([87.79.255.48]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0ME33j-1ZMv1f1WRz-00HOCT for
 <linux-media@vger.kernel.org>; Sun, 20 Sep 2015 19:10:44 +0200
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 4021840BD9
	for <linux-media@vger.kernel.org>; Sun, 20 Sep 2015 19:10:42 +0200 (CEST)
Date: Sun, 20 Sep 2015 19:10:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 4.4 batch #1
Message-ID: <Pine.LNX.4.64.1509201853320.30819@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I missed the 4.3 cycle completely, so, this should clean up my backlog. 
There are still PXA patches outstanding, but Robert wanted to work a bit 
more on them.

The following changes since commit 9ddf9071ea17b83954358b2dac42b34e5857a9af:

  Merge tag 'v4.3-rc1' into patchwork (2015-09-13 11:10:12 -0300)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.4-1

for you to fetch changes up to 8cf27580b31fd81031e8cd3b54008236dc7193c1:

  atmel-isi: parse the DT parameters for vsync/hsync/pixclock polarity (2015-09-20 18:30:28 +0200)

----------------------------------------------------------------
Geert Uytterhoeven (2):
      rcar_vin: Remove obsolete r8a779x-vin platform_device_id entries
      atmel-isi: Protect PM-only functions to kill warning

Josh Wu (6):
      soc-camera: increase the length of clk_name on soc_of_bind()
      atmel-isi: increase timeout to disable/enable isi
      atmel-isi: setup the ISI_CFG2 register directly
      atmel-isi: move configure_geometry() to start_streaming()
      atmel-isi: add sanity check for supported formats in try/set_fmt()
      atmel-isi: parse the DT parameters for vsync/hsync/pixclock polarity

Laurent Pinchart (3):
      v4l: atmel-isi: Simplify error handling during DT parsing
      v4l: atmel-isi: Remove support for platform data
      v4l: atmel-isi: Remove unused platform data fields

Sergei Shtylyov (2):
      rcar_vin: propagate querystd() error upstream
      rcar_vin: call g_std() instead of querystd()

 drivers/media/platform/soc_camera/atmel-isi.c      | 125 +++++++++++----------
 .../media/platform/soc_camera}/atmel-isi.h         |   7 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |  20 ++--
 drivers/media/platform/soc_camera/soc_camera.c     |   2 +-
 4 files changed, 79 insertions(+), 75 deletions(-)
 rename {include/media => drivers/media/platform/soc_camera}/atmel-isi.h (95%)

Thanks
Guennadi
