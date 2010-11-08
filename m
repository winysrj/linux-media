Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:45670 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755135Ab0KHVRU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Nov 2010 16:17:20 -0500
Date: Mon, 8 Nov 2010 22:17:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL v2] soc-camera fixes for 2.6.37
In-Reply-To: <Pine.LNX.4.64.1011060032210.28289@axis700.grange>
Message-ID: <Pine.LNX.4.64.1011082215080.29934@axis700.grange>
References: <Pine.LNX.4.64.1011060032210.28289@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro, since you haven't pulled soc-camera -rc1 fixes yet, I've updated 
the branch with one more compile-breakage fix, so, here's an updated 
request:

The following changes since commit 7655e594945289b418af39f6669fea4666a7b520:

  [media] af9015: Fix max I2C message size when used with tda18271 (2010-10-27 15:02:35 -0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git 2.6.37-rc1-fixes

Janusz Krzysztofik (4):
      SoC Camera: OMAP1: update for recent framework changes
      SoC Camera: OMAP1: update for recent videobuf changes
      SOC Camera: OMAP1: typo fix
      SoC Camera: ov6650: minor cleanups

Sascha Hauer (2):
      ARM mx3_camera: check for DMA engine type
      soc-camera: Compile fixes for mx2-camera

 drivers/media/video/mx2_camera.c   |   13 +++++--------
 drivers/media/video/mx3_camera.c   |    4 ++++
 drivers/media/video/omap1_camera.c |   16 ++++++++--------
 drivers/media/video/ov6650.c       |    4 +---
 4 files changed, 18 insertions(+), 19 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
