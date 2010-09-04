Return-path: <mchehab@localhost>
Received: from mailout-de.gmx.net ([213.165.64.22]:46983 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753096Ab0IDUEG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Sep 2010 16:04:06 -0400
Date: Sat, 4 Sep 2010 22:04:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] soc-camera 2.6.36 fixes
Message-ID: <Pine.LNX.4.64.1009042202470.24729@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hi Mauro

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.36

Baruch Siach (1):
      mx2_camera: fix a race causing NULL dereference

Ionut Gabriel Popescu (1):
      mt9v022.c: Fixed compilation warning

Michael Grzeschik (2):
      mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE
      mt9m111: added current colorspace at g_fmt

 drivers/media/video/mt9m111.c    |    8 +++++++-
 drivers/media/video/mt9v022.c    |    3 ---
 drivers/media/video/mx2_camera.c |    4 ++++
 3 files changed, 11 insertions(+), 4 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
