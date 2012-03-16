Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55652 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435Ab2CPNtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 09:49:35 -0400
Date: Fri, 16 Mar 2012 14:49:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera for 3.4 take 2
Message-ID: <Pine.LNX.4.64.1203161444470.13465@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

A couple more soc-camera patches for 3.4. See - I'm trying to comply: 
several smaller pull-requests;-)

The following changes since commit 632fba4d012458fd5fedc678fb9b0f8bc59ceda2:

  [media] cx25821: Add a card definition for "No brand" cards that have: subvendor = 0x0000 subdevice = 0x0000 (2012-03-08 12:42:28 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.4-set_2

Fabio Estevam (1):
      video: Kconfig: Select VIDEOBUF2_DMA_CONTIG for VIDEO_MX2

Guennadi Liakhovetski (2):
      V4L: soc-camera: call soc_camera_power_on() after adding the client to the host
      V4L: sh_mobile_ceu_camera: maximum image size depends on the hardware version

Philipp Zabel (1):
      V4L: pxa_camera: add clk_prepare/clk_unprepare calls

 drivers/media/video/Kconfig                |    2 +-
 drivers/media/video/pxa_camera.c           |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c |   35 +++++++++++++++++++++------
 drivers/media/video/soc_camera.c           |   32 ++++++++++++------------
 include/media/sh_mobile_ceu.h              |    2 +
 5 files changed, 48 insertions(+), 27 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
