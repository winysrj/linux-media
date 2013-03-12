Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3CLOPB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 10:15:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 0516840BB3
	for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 15:15:00 +0100 (CET)
Date: Tue, 12 Mar 2013 15:14:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] 3.10 minor updates
Message-ID: <Pine.LNX.4.64.1303121513240.680@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Here go a couple of minor updates for 3.10, just to get them upstream out 
of my mailbox :)

The following changes since commit 84c73929c71764075cbe6f7f39fbe746fcd25d99:

  Add linux-next specific files for 20130312 (2013-03-12 15:45:33 +1100)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.10-1

Paul Bolle (1):
      soc_camera: remove two outdated selects

Sachin Kamat (7):
      soc_camera/sh_mobile_ceu_camera: Convert to devm_ioremap_resource()
      soc_camera/sh_mobile_csi2: Convert to devm_ioremap_resource()
      soc_camera/pxa_camera: Convert to devm_ioremap_resource()
      sh_veu.c: Convert to devm_ioremap_resource()
      soc_camera/mx1_camera: Use module_platform_driver_probe macro
      sh_veu: Use module_platform_driver_probe macro
      sh_vou: Use module_platform_driver_probe macro

 drivers/media/i2c/soc_camera/Kconfig               |    2 --
 drivers/media/platform/sh_veu.c                    |   20 +++++---------------
 drivers/media/platform/sh_vou.c                    |   13 +------------
 drivers/media/platform/soc_camera/mx1_camera.c     |   13 +------------
 drivers/media/platform/soc_camera/pxa_camera.c     |    8 +++++---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    9 ++++-----
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |    9 ++++-----
 7 files changed, 20 insertions(+), 54 deletions(-)

pwclient -u 'accepted' 17083
pwclient -u 'accepted' 17084
pwclient -u 'accepted' 17111
pwclient -u 'accepted' 17082
pwclient -u 'accepted' 17339
pwclient -u 'accepted' 17081
pwclient -u 'accepted' 17109
pwclient -u 'accepted' 17110

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
