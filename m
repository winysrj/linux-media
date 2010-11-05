Return-path: <mchehab@gaivota>
Received: from mailout-de.gmx.net ([213.165.64.22]:58693 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755054Ab0KEXmn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Nov 2010 19:42:43 -0400
Date: Sat, 6 Nov 2010 00:42:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera fixes for 2.6.37
Message-ID: <Pine.LNX.4.64.1011060032210.28289@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro

Please, pull a couple of fixes for 2.6.37. TBH, two of them are not very 
critical, of which one ("SOC Camera: OMAP1: typo fix") is purely 
cosmetical - it fixes a typo in a comment. But at least it's trivial, 
since it cannot cause any regressions. And the other non-critical one 
("SoC Camera: ov6650: minor cleanups") does change handling of an 
impossible switch case from silently ignoring to erroring out, which is an 
improvement!

The following changes since commit 7655e594945289b418af39f6669fea4666a7b520:

  [media] af9015: Fix max I2C message size when used with tda18271 (2010-10-27 15:02:35 -0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git 2.6.37-rc1-fixes

Janusz Krzysztofik (4):
      SoC Camera: OMAP1: update for recent framework changes
      SoC Camera: OMAP1: update for recent videobuf changes
      SOC Camera: OMAP1: typo fix
      SoC Camera: ov6650: minor cleanups

Sascha Hauer (1):
      ARM mx3_camera: check for DMA engine type

 drivers/media/video/mx3_camera.c   |    4 ++++
 drivers/media/video/omap1_camera.c |   16 ++++++++--------
 drivers/media/video/ov6650.c       |    4 +---
 3 files changed, 13 insertions(+), 11 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

