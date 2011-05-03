Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:63479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1ECHJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 03:09:09 -0400
Date: Tue, 3 May 2011 09:09:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera: regression fix
Message-ID: <Pine.LNX.4.64.1105030908120.15004@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

The following changes since commit 94c8a984ae2adbd9a9626fb42e0f2faf3e36e86f:

  Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6 (2011-04-08 11:47:35 -0700)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 2.6.39-rc5-fixes

Sergio Aguirre (1):
      V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c

 drivers/media/video/soc_camera.c |   48 +++++++++++++++++++++++++++++++++----
 1 files changed, 42 insertions(+), 6 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
