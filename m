Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:53707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3G3MZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:40 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id CB29940BC3
	for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 14:25:38 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1V48zh-0003v8-K9
	for linux-media@vger.kernel.org; Tue, 30 Jul 2013 14:25:37 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/6] V4L2: soc-camera: more asynchronous probing work
Date: Tue, 30 Jul 2013 14:25:31 +0200
Message-Id: <1375187137-15045-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A bunch of patches to extend asynchronous subdevice probing in soc-camera. 
They refresh the mx3-camera driver a bit by converting it to managed 
resource allocation and adding asynchronous probing support. mt9m111 is
also ported to support both types of probing. Also regulator handling
is fixed in soc-camera to support both probing types.

Guennadi Liakhovetski (6):
  V4L2: soc-camera: fix requesting regulators in synchronous case
  V4L2: mx3_camera: convert to managed resource allocation
  V4L2: mx3_camera: print V4L2_MBUS_FMT_* codes in hexadecimal format
  V4L2: mx3_camera: add support for asynchronous subdevice registration
  V4L2: mt9t031: don't Oops if asynchronous probing is attempted
  V4L2: mt9m111: switch to asynchronous subdevice probing

 drivers/media/i2c/soc_camera/mt9m111.c         |   38 +++++++++----
 drivers/media/i2c/soc_camera/mt9t031.c         |    7 ++-
 drivers/media/platform/soc_camera/mx3_camera.c |   67 +++++++++---------------
 drivers/media/platform/soc_camera/soc_camera.c |   33 ++++++++++--
 include/linux/platform_data/camera-mx3.h       |    4 ++
 5 files changed, 87 insertions(+), 62 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
