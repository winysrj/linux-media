Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:54512 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab1CWUve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 16:51:34 -0400
Date: Wed, 23 Mar 2011 21:51:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera: one more patch
Message-ID: <Pine.LNX.4.64.1103232149360.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

Sorry, would be nice if we could manage to push one more patch for 2.6.39:

The following changes since commit f772f016e15a0b93b5aa9680203107ab8cb9bdc6:

  [media] media-devnode: don't depend on BKL stuff (2011-03-22 19:43:01 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.39

Guennadi Liakhovetski (1):
      V4L: soc_camera_platform: add helper functions to manage device instances

 include/media/soc_camera_platform.h |   50 +++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
