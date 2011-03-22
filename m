Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:61881 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab1CVWJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 18:09:45 -0400
Date: Tue, 22 Mar 2011 23:09:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] soc-camera: 4 more feature-commits for 2.6.39
Message-ID: <Pine.LNX.4.64.1103222304580.29576@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

The following changes since commit c002e112822c2fe152e55feb5db036c642681b1a:

  [media] stv0367: typo in function parameter (2011-03-22 07:00:39 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.39

Guennadi Liakhovetski (1):
      V4L: soc-camera: explicitly require V4L2_BUF_TYPE_VIDEO_CAPTURE

Pawel Osciak (2):
      sh_mobile_ceu_camera: Do not call vb2's mem_ops directly
      videobuf2-dma-contig: make cookie() return a pointer to dma_addr_t

Sergio Aguirre (1):
      v4l: soc-camera: Store negotiated buffer settings

 drivers/media/video/sh_mobile_ceu_camera.c |    4 +---
 drivers/media/video/soc_camera.c           |   25 ++++++++++++++++---------
 drivers/media/video/videobuf2-dma-contig.c |    2 +-
 include/media/soc_camera.h                 |    2 ++
 include/media/videobuf2-dma-contig.h       |    9 ++++++---
 5 files changed, 26 insertions(+), 16 deletions(-)

As I mentioned earlier today on the IRC, I've got a few more fixes, that I 
will be posting and pushing a bit later, they can also go in after -rc1.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
