Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61991 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaK1WPg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 17:15:36 -0500
Received: from axis700.grange ([87.79.214.157]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MSIf1-1XScFa3oBH-00TUJC for
 <linux-media@vger.kernel.org>; Fri, 28 Nov 2014 23:15:33 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 7890C40BD9
	for <linux-media@vger.kernel.org>; Fri, 28 Nov 2014 23:15:32 +0100 (CET)
Date: Fri, 28 Nov 2014 23:15:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 1st set for 3.19
Message-ID: <Pine.LNX.4.64.1411282307180.15467@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

IIUC, this coming Sunday might be the last -rc, so, postponing pull 
requests to subsystem maintainers even further isn't a good idea, so, here 
goes an soc-camera request. I know it isn't complete, there are a few more 
patches waiting to be pushed upstream, but I won't have time this coming 
weekend and next two weeks I'm traveling, which won't simplify things 
either. Some more patches are being reworked, if they arrive soon and we 
do get another -rc, I might try to push them too, but I don't want to 
postpone these ones, while waiting. One of these patches has also been 
modified by me and hasn't been tested yet. But changes weren't too 
complex. If however I did break something, we'll have to fix it in an 
incremental patch.

The following changes since commit d298a59791fad3a707c1dadbef0935ee2664a10e:

  Merge branch 'patchwork' into to_next (2014-11-21 17:01:46 -0200)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.19-1

for you to fetch changes up to d8f5c144e57d99d2a7325bf8877812bf560e22dd:

  rcar_vin: Fix interrupt enable in progressive (2014-11-23 12:08:19 +0100)

----------------------------------------------------------------
Koji Matsuoka (4):
      rcar_vin: Add YUYV capture format support
      rcar_vin: Add scaling support
      rcar_vin: Enable VSYNC field toggle mode
      rcar_vin: Fix interrupt enable in progressive

Yoshihiro Kaneko (1):
      rcar_vin: Add DT support for r8a7793 and r8a7794 SoCs

 .../devicetree/bindings/media/rcar_vin.txt         |   2 +
 drivers/media/platform/soc_camera/rcar_vin.c       | 466 ++++++++++++++++++++-
 2 files changed, 457 insertions(+), 11 deletions(-)

Thanks
Guennadi
