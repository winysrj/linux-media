Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:65353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3IQLV5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 07:21:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id D2D2640BB3
	for <linux-media@vger.kernel.org>; Tue, 17 Sep 2013 13:21:55 +0200 (CEST)
Date: Tue, 17 Sep 2013 13:21:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] 2 3.12 fixes: mx3-camera and VOU
Message-ID: <Pine.LNX.4.64.1309171314040.20367@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

I was postponing these two patch to push them together with potential 
em28xx fixes, but since we still cannot agree on those, I decided to push 
these ones out:

The following changes since commit 2a65ef5e5e5863af7848680909478fdc79e726d7:

  Add linux-next specific files for 20130917 (2013-09-17 13:07:03 +1000)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.12-rc1-fixes

Dan Carpenter (2):
      sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()
      mx3-camera: locking cleanup in mx3_videobuf_queue()

 drivers/media/platform/sh_vou.c                |    2 +-
 drivers/media/platform/soc_camera/mx3_camera.c |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
