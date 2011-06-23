Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:61888 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1FWJNL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 05:13:11 -0400
Date: Thu, 23 Jun 2011 11:13:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] a 3.0 fix
Message-ID: <Pine.LNX.4.64.1106231111220.2863@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

Please, pull one bug-fix for your next 3.0 update round:

The following changes since commit 215c52702775556f4caf5872cc84fa8810e6fc7d:

  [media] V4L/videobuf2-memops: use pr_debug for debug messages (2011-06-01 18:20:34 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.0-rc4-fixes

Andre Bartke (1):
      V4L: mx1-camera: fix uninitialized variable

 drivers/media/video/mx1_camera.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
