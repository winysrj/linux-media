Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab1IHIoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2011 04:44:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH/RFC 00/13 v3] Converting soc_camera to the control framework
Date: Thu,  8 Sep 2011 10:43:53 +0200
Message-Id: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a re-send of the patch-series by Hans Verkuil, partially modified 
and tested by me. The original patch-series can be found at

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/soc2

Significant changes has been applied to patches 1 and 2. Unfortunately, 
Hans didn't address my comments to his original submission, so, those 
issues had to be fixed here too. This (almost) applies to the same base, 
as the above tree. I pushed all my for-3.2 and Hans' relevant patches to

git://linuxtv.org/gliakhovetski/v4l-dvb.git rc1-for-3.2

History:
v3: my changes
v2: above git-tree by Hans
v1: Hans' original posts of 12.01.2011

Hans Verkuil (13):
  soc_camera: add control handler support
  sh_mobile_ceu_camera: implement the control handler.
  ov9640: convert to the control framework.
  ov772x: convert to the control framework.
  rj54n1cb0c: convert to the control framework.
  mt9v022: convert to the control framework.
  ov2640: convert to the control framework.
  ov6650: convert to the control framework.
  ov9740: convert to the control framework.
  mt9m001: convert to the control framework.
  mt9m111: convert to the control framework.
  mt9t031: convert to the control framework.
  soc_camera: remove the now obsolete struct soc_camera_ops

 drivers/media/video/imx074.c               |    1 -
 drivers/media/video/mt9m001.c              |  218 ++++++----------
 drivers/media/video/mt9m111.c              |  203 ++++-----------
 drivers/media/video/mt9t031.c              |  252 +++++++------------
 drivers/media/video/mt9t112.c              |    2 -
 drivers/media/video/mt9v022.c              |  265 ++++++++------------
 drivers/media/video/ov2640.c               |   90 ++-----
 drivers/media/video/ov6650.c               |  381 +++++++++-------------------
 drivers/media/video/ov772x.c               |  114 +++------
 drivers/media/video/ov9640.c               |  119 +++------
 drivers/media/video/ov9640.h               |    4 +-
 drivers/media/video/ov9740.c               |   83 ++----
 drivers/media/video/rj54n1cb0c.c           |  141 +++--------
 drivers/media/video/sh_mobile_ceu_camera.c |   91 +++----
 drivers/media/video/soc_camera.c           |   94 ++------
 drivers/media/video/soc_camera_platform.c  |    2 -
 drivers/media/video/tw9910.c               |    1 -
 include/media/soc_camera.h                 |   24 +--
 18 files changed, 659 insertions(+), 1426 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
