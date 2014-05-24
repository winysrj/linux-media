Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63239 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEXLbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 May 2014 07:31:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 2EAB640BDD
	for <linux-media@vger.kernel.org>; Sat, 24 May 2014 13:31:37 +0200 (CEST)
Date: Sat, 24 May 2014 13:31:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL 3.16] soc-camera for 3.16: one driver removal, a fix and
 more
Message-ID: <Pine.LNX.4.64.1405241326250.1624@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I was waiting for DT patches for soc-camera, but they're not yet ready. 
So, here go 5 patches, including one driver removal, one error-path fix 
from myself, and a couple more clean up and enhancement patches.

BTW, the "git request-pull" command issued a warning:

warn: No match for commit 66635afdc4e26f89fd7bc631f452ada84d6e4f3f found at git://linuxtv.org/gliakhovetski/v4l-dvb.git
warn: Are you sure you pushed 'HEAD' there?

I hope, the result is still ok...

The following changes since commit b5c8d48bf8f4273a9fe680bd834f991005c8ab59:

  Add linux-next specific files for 20140502 (2014-05-02 17:01:07 +1000)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 

for you to fetch changes up to 66635afdc4e26f89fd7bc631f452ada84d6e4f3f:

  media: mx2_camera: Change Kconfig dependency (2014-05-24 13:08:53 +0200)

----------------------------------------------------------------
Alexander Shiyan (2):
      media: mx1_camera: Remove driver
      media: mx2_camera: Change Kconfig dependency

Ben Dooks (1):
      rcar_vin: copy flags from pdata

Guennadi Liakhovetski (1):
      V4L: soc-camera: explicitly free allocated managed memory on error

Jean Delvare (1):
      V4L2: soc_camera: add run-time dependencies to R-Car VIN driver

 drivers/media/platform/soc_camera/Kconfig      |  16 +-
 drivers/media/platform/soc_camera/Makefile     |   1 -
 drivers/media/platform/soc_camera/mx1_camera.c | 866 -------------------------
 drivers/media/platform/soc_camera/rcar_vin.c   |  12 +-
 drivers/media/platform/soc_camera/soc_camera.c |  12 +-
 5 files changed, 16 insertions(+), 891 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/mx1_camera.c

Thanks
Guennadi
