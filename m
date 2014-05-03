Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:60166 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaECKfI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 06:35:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 0735340BD9
	for <linux-media@vger.kernel.org>; Sat,  3 May 2014 12:35:06 +0200 (CEST)
Date: Sat, 3 May 2014 12:35:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] fixes for 3.15
Message-ID: <Pine.LNX.4.64.1405031232030.23253@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've collected these patches over some time, they contain real fixes for 
real problems :) Please, push to 3.15 before it enters a "critical 
life-or-world-rescuing if-not-be-prepared-to-be-fried" phase :)

The following changes since commit 6c6ca9c2a5b97ab37ffd1b091d15eb5cd3f1bf23:

  Merge tag 'pm+acpi-3.15-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2014-05-02 18:16:31 -0700)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git fixes-3.15-rc3

for you to fetch changes up to e35b8a5da7721b2a7b92d3b51812ab7d540c3e73:

  V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode (2014-05-03 11:56:19 +0200)

----------------------------------------------------------------
Guennadi Liakhovetski (2):
      V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
      V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Hans Verkuil (3):
      v4l2-subdev.h: add g_tvnorms video op
      tw9910: add g_tvnorms video op
      soc_camera: disable STD ioctls if no tvnorms are set.

 drivers/media/i2c/ov7670.c                     |  2 +-
 drivers/media/i2c/soc_camera/tw9910.c          |  7 +++++++
 drivers/media/platform/soc_camera/soc_camera.c |  8 ++++++++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c  | 12 +++++++-----
 include/media/v4l2-subdev.h                    |  8 ++++++--
 5 files changed, 29 insertions(+), 8 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
