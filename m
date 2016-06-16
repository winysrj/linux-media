Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35217 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbcFPRWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 13:22:11 -0400
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-omap@vger.kernel.org,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [RFC] [PATCH 0/3] media: an attempt to refresh omap1_camera driver
Date: Thu, 16 Jun 2016 19:21:31 +0200
Message-Id: <1466097694-8660-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As requested by media subsystem maintainers, here is an attempt to 
convert the omap1_camera driver to the vb2 framework. Also, conversion 
to the dmaengine framework, long awaited by ARM/OMAP maintainers, is 
done.

Next, I'm going to approach removal of soc-camera dependency. Please 
let me know how much time I have for that, i.e., when the soc-camera
framework is going to be depreciated.

Thanks,
Janusz


Janusz Krzysztofik (3):
  staging: media: omap1: drop videobuf-dma-sg mode
  staging: media: omap1: convert to videobuf2
  staging: media: omap1: use dmaengine

 drivers/staging/media/omap1/Kconfig              |   5 +-
 drivers/staging/media/omap1/omap1_camera.c       | 948 +++++------------------
 include/linux/platform_data/media/omap1_camera.h |   9 -
 3 files changed, 217 insertions(+), 745 deletions(-)

-- 
2.7.3

