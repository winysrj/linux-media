Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2K2LSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 06:18:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 6401A40B98
	for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 12:18:08 +0100 (CET)
Date: Thu, 29 Nov 2012 12:18:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] 3.7 soc-camera fixes
Message-ID: <Pine.LNX.4.64.1211291212370.11210@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Please, push these 3 fixes for 3.7.

The following changes since commit e9296e89b85604862bd9ec2d54dc43edad775c0d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-11-28 21:54:07 -0800)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git 3.7-rc7-fixes

Anatolij Gustschin (1):
      soc_camera: fix VIDIOC_S_CROP ioctl

Cyril Roelandt (1):
      mx2_camera: use GFP_ATOMIC under spin lock.

Guennadi Liakhovetski (1):
      media: sh-vou: fix compiler warnings

 drivers/media/platform/sh_vou.c                |    7 ++++---
 drivers/media/platform/soc_camera/mx2_camera.c |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c |    2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
