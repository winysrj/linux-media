Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62420 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479Ab2IKJJB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 05:09:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id C91E2189AF7
	for <linux-media@vger.kernel.org>; Tue, 11 Sep 2012 11:08:58 +0200 (CEST)
Date: Tue, 11 Sep 2012 11:08:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] soc-camera 3.7 set 2
Message-ID: <Pine.LNX.4.64.1209111107340.22084@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

The following changes since commit 79e8c7bebb467bbc3f2514d75bba669a3f354324:

  Merge tag 'v3.6-rc3' into staging/for_v3.7 (2012-08-24 11:25:10 -0300)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.7-set_2

Javier Martin (1):
      media: mx2_camera: Don't modify non volatile parameters in try_fmt.

Sachin Kamat (2):
      soc_camera: Use module_platform_driver macro
      soc_camera: Use devm_kzalloc function

Sylwester Nawrocki (1):
      soc-camera: Use new selection target definitions

 drivers/media/platform/soc_camera/mx2_camera.c |    6 ++--
 drivers/media/platform/soc_camera/soc_camera.c |   37 ++++-------------------
 2 files changed, 10 insertions(+), 33 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
