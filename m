Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56447 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab2HOUis (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 16:38:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 11F01189F87
	for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 22:38:47 +0200 (CEST)
Date: Wed, 15 Aug 2012 22:38:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] soc-camera: 3.7 additional patches
Message-ID: <Pine.LNX.4.64.1208152235480.4024@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Now, it's getting complicated, sorry. This goes on top of my previous pull 
request from my for-3.6 branch, that I've sent a couple of hours ago. And 
it also includes some patches from my 3.6-rc1-fixes branch, because, 
obviously, they have to be included here too. Hopefully, git will 
magically handle it all. To make it explicit: patches

"media: soc_camera: don't clear pix->sizeimage in JPEG mode"
"media: mx3_camera: buf_init() add buffer state check"
"media: mx2_camera: Fix clock handling for i.MX27."

are also in 3.6-rc1-fixes. I also had to base this branch on top of the 18 
patches, from the for-3.6 branch, that I pushed earlier today.

To all submitters: this should cover all patches that I so far collected 
for 3.7. There is one more patch with no Sob, I'll push it later, as soon 
as I get an update. And there's also a i.MX25 deprecation patch, which 
I'll handle a bit later too. If I'm missing something else - please shout!

The following changes since commit a98af564b2fe19edceba73de1be7130d0a5d796e:

  V4L: soc-camera: add selection API host operations (2012-08-15 16:33:04 +0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.7

Albert Wang (1):
      media: soc_camera: don't clear pix->sizeimage in JPEG mode

Alex Gershgorin (2):
      media: mx3_camera: buf_init() add buffer state check
      mt9v022: Add support for mt9v024

Javier Martin (1):
      media: mx2_camera: Fix clock handling for i.MX27.

Liu Ying (1):
      media: mx3_camera: Improve data bus width check code for probe

 drivers/media/video/Kconfig        |    2 +-
 drivers/media/video/mt9v022.c      |   36 ++++++++++++++++++++++++++----
 drivers/media/video/mx2_camera.c   |   43 ++++++++++++++++++++++++-----------
 drivers/media/video/mx3_camera.c   |   26 ++++++---------------
 drivers/media/video/soc_camera.c   |    3 +-
 drivers/media/video/soc_mediabus.c |    6 +++++
 6 files changed, 77 insertions(+), 39 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
