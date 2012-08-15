Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56162 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2HOUfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 16:35:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id ED44B189F87
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 22:35:40 +0200 (CEST)
Date: Wed, 15 Aug 2012 22:35:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] soc-camera: 3.6 fixes
Message-ID: <Pine.LNX.4.64.1208152235260.4024@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Here go current soc-camera 3.6 fixes. We'll need them both in 3.6 and 3.7 
to make your codebase reorganisation possibly simple. Note, that the two 
patches from Fabio Estevam are already in 3.7, but are actually fixes and 
should also go into 3.6. They are also required for the patch from Javier 
Martin.

I'm still using my "old" git, I'll update it soon, if you'd prefer to 
wait, let me know, I'll regenerate with a newer version.

The following changes since commit ddf343f635fe4440cad528e12f96f28bd50aa099:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux (2012-08-14 07:58:59 +0300)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.6-rc1-fixes

Albert Wang (1):
      media: soc_camera: don't clear pix->sizeimage in JPEG mode

Alex Gershgorin (1):
      media: mx3_camera: buf_init() add buffer state check

Fabio Estevam (2):
      video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
      video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepare

Javier Martin (1):
      media: mx2_camera: Fix clock handling for i.MX27.

 drivers/media/video/mx1_camera.c   |    4 +-
 drivers/media/video/mx2_camera.c   |   47 +++++++++++++++++++++++------------
 drivers/media/video/mx3_camera.c   |   22 +++++-----------
 drivers/media/video/soc_camera.c   |    3 +-
 drivers/media/video/soc_mediabus.c |    6 ++++
 5 files changed, 48 insertions(+), 34 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
