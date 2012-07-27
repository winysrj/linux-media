Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53406 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2G0KsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 06:48:11 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7T00LP3FD17320@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Jul 2012 11:48:37 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M7T00LWLFC8N540@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Jul 2012 11:48:09 +0100 (BST)
Message-id: <501271E8.9060406@samsung.com>
Date: Fri, 27 Jul 2012 12:48:08 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR 3.6] V4L2 mem-to-mem device capability flags
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 931efdf58bd83af8d0578a6cc53421675daf6d41:

  Merge branch 'v4l_for_linus' into staging/for_v3.6 (2012-07-14 15:45:44 -0300)

are available in the git repository at:


  git://git.infradead.org/users/kmpark/linux-samsung v4l_m2m_capabilities

for you to fetch changes up to 633157172d8c36482f2f88253ac9c49ddc267c8e:

  Feature removal: using capture and output capabilities for m2m devices (2012-07-26 14:30:50 +0200)

This is an addition of new V4L2 capability flags for mem-to-mem devices.

----------------------------------------------------------------
Sylwester Nawrocki (2):
      V4L: Add capability flags for memory-to-memory devices
      Feature removal: using capture and output capabilities for m2m devices

 Documentation/DocBook/media/v4l/compat.xml          |    9 +++++++++
 Documentation/DocBook/media/v4l/vidioc-querycap.xml |   13 +++++++++++++
 Documentation/feature-removal-schedule.txt          |   14 ++++++++++++++
 drivers/media/video/mem2mem_testdev.c               |    4 +---
 drivers/media/video/mx2_emmaprp.c                   |   10 +++++++---
 drivers/media/video/s5p-fimc/fimc-m2m.c             |    7 ++++++-
 drivers/media/video/s5p-g2d/g2d.c                   |    9 +++++++--
 drivers/media/video/s5p-jpeg/jpeg-core.c            |   10 +++++++---
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c           |   10 ++++++++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c           |   11 ++++++++---
 include/linux/videodev2.h                           |    4 ++++
 11 files changed, 84 insertions(+), 17 deletions(-)


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
