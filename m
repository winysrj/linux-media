Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62706 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbbKORyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 12:54:36 -0500
Received: from axis700.grange ([87.78.163.136]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0M8m7Q-1a5lHa1EWy-00C6nK for
 <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 18:54:34 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 6394140BD9
	for <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 18:54:31 +0100 (CET)
Date: Sun, 15 Nov 2015 18:54:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: first 4.5 batch
Message-ID: <Pine.LNX.4.64.1511151844390.15121@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've got 9 patches from Josh Wu for 4.5. Please, note, that patches 2-4 
also touch vore v4l2-clock files, so, maybe you or someone else want to 
look at them too.

The following changes since commit 79f5b6ae960d380c829fb67d5dadcd1d025d2775:

  [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK (2015-10-20 16:02:41 -0200)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.5-1

for you to fetch changes up to adffe7110d7b33262d063b2fc3419a579ec4ed15:

  atmel-isi: support RGB565 output when sensor output YUV formats (2015-11-15 18:51:45 +0100)

----------------------------------------------------------------
Josh Wu (9):
      soc_camera: get the clock name by using macro: v4l2_clk_name_i2c()
      v4l2-clk: add new macro for v4l2_clk_name_of()
      v4l2-clk: add new definition: V4L2_CLK_NAME_SIZE
      v4l2-clk: v4l2_clk_get() also need to find the of_fullname clock
      atmel-isi: correct yuv swap according to different sensor outputs
      atmel-isi: prepare for the support of preview path
      atmel-isi: add code to setup correct resolution for preview path
      atmel-isi: setup YCC_SWAP correctly when using preview path
      atmel-isi: support RGB565 output when sensor output YUV formats

 drivers/media/platform/soc_camera/atmel-isi.c  | 162 +++++++++++++++++++------
 drivers/media/platform/soc_camera/atmel-isi.h  |  10 ++
 drivers/media/platform/soc_camera/soc_camera.c |  23 ++--
 drivers/media/usb/em28xx/em28xx-camera.c       |   2 +-
 drivers/media/v4l2-core/v4l2-clk.c             |   9 ++
 include/media/v4l2-clk.h                       |   5 +
 6 files changed, 159 insertions(+), 52 deletions(-)

Thanks
Guennadi
