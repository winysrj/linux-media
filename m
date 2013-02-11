Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62172 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3BKIi4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Feb 2013 03:38:56 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 725AB40B98
	for <linux-media@vger.kernel.org>; Mon, 11 Feb 2013 09:38:54 +0100 (CET)
Date: Mon, 11 Feb 2013 09:38:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera 3.8 / 3.9 fixes
Message-ID: <Pine.LNX.4.64.1302110937220.30282@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

I guess, these are too late for 3.8, so, let's push them for 3.9 too.

The following changes since commit 2e51b231a8d716ea5aacde0bd95ac789cea195b0:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-01-30 12:02:26 +1100)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.8-set_3

Guennadi Liakhovetski (2):
      sh-mobile-ceu-camera: fix SHARPNESS control default
      mt9t112: mt9t111 format set up differs from mt9t112

 drivers/media/i2c/soc_camera/mt9t112.c             |   18 +++++++++++++-----
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 2 files changed, 14 insertions(+), 6 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
