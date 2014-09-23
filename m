Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51795 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312AbaIWVkG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 17:40:06 -0400
Received: from axis700.grange ([213.168.119.128]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0LyVpm-1YKNEY2Bmw-015mwg for
 <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 23:40:04 +0200
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 3CC5240BD9
	for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 23:40:03 +0200 (CEST)
Date: Tue, 23 Sep 2014 23:40:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera for 3.18
Message-ID: <Pine.LNX.4.64.1409232338330.25286@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please, pull the following three patches:

The following changes since commit 4db4327f32bc3757355abff261c979408c85c771:

  Merge branch 'topic/devel-3.17-rc6' into to_next (2014-09-22 21:24:28 -0300)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.18-1

for you to fetch changes up to 0c87b375d25fa05bb9686f28eb3d720df0428866:

  soc_camera: Support VIDIOC_EXPBUF ioctl (2014-09-23 23:22:08 +0200)

----------------------------------------------------------------
Dan Carpenter (1):
      mx2-camera: potential negative underflow bug

Kazunori Kobayashi (1):
      soc_camera: Support VIDIOC_EXPBUF ioctl

Sergei Shtylyov (1):
      rcar_vin: fix error message in rcar_vin_get_formats()

 drivers/media/platform/soc_camera/mx2_camera.c |  2 +-
 drivers/media/platform/soc_camera/rcar_vin.c   |  2 +-
 drivers/media/platform/soc_camera/soc_camera.c | 17 +++++++++++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

Thanks
Guennadi
