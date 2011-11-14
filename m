Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17787 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1KNQIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 11:08:13 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LUN00INZRHNRB@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Nov 2011 16:08:11 +0000 (GMT)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LUN007VQRHNJ6@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Nov 2011 16:08:11 +0000 (GMT)
Date: Mon, 14 Nov 2011 17:08:10 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [GIT PATCHES FOR 3.3] v4l: introduce selection API
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4EC13CEA.4020705@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the second 'pull-requested' version of the selection API. The 
patch-set introduces new ioctls to V4L2 API for the configuration of the 
selection rectangles like crop and compose areas.

Changelog:

- changed naming of constraints flags to form V4L2_SEL_FLAG_*
- changed naming of selection target to form V4L2_SEL_TGT_*
- size of PNG files in the documentation is greatly reduced
- fixes to handling of output queues for old cropping emulation
- VIDIOC_{S/G}_SELECTION for s5p-mixer accepts single- and multiplane 
buffers as VIDIOC_{S/G}_CROP did

Best regards,
Tomasz Stanislawski

The following changes since commit e9eb0dadba932940f721f9d27544a7818b2fa1c5:

   [media] V4L menu: add submenu for platform devices (2011-11-08 
12:09:52 -0200)

are available in the git repository at:
   git://git.infradead.org/users/kmpark/linux-samsung v4l-selection

Tomasz Stanislawski (5):
       v4l: add support for selection api
       doc: v4l: add binary images for selection API
       doc: v4l: add documentation for selection API
       v4l: emulate old crop API using extended crop/compose API
       v4l: s5p-tv: mixer: add support for selection API

  Documentation/DocBook/media/constraints.png.b64    |   59 ++++
  Documentation/DocBook/media/selection.png.b64      |  206 ++++++++++++
  Documentation/DocBook/media/v4l/common.xml         |    2 +
  Documentation/DocBook/media/v4l/compat.xml         |    9 +
  Documentation/DocBook/media/v4l/selection-api.xml  |  327 
+++++++++++++++++++
  Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
  .../DocBook/media/v4l/vidioc-g-selection.xml       |  304 
+++++++++++++++++
  drivers/media/video/s5p-tv/mixer.h                 |   14 +-
  drivers/media/video/s5p-tv/mixer_grp_layer.c       |  157 +++++++--
  drivers/media/video/s5p-tv/mixer_video.c           |  342 
+++++++++++++-------
  drivers/media/video/s5p-tv/mixer_vp_layer.c        |  108 ++++---
  drivers/media/video/v4l2-compat-ioctl32.c          |    2 +
  drivers/media/video/v4l2-ioctl.c                   |  116 +++++++-
  include/linux/videodev2.h                          |   46 +++
  include/media/v4l2-ioctl.h                         |    4 +
  15 files changed, 1495 insertions(+), 202 deletions(-)
  create mode 100644 Documentation/DocBook/media/constraints.png.b64
  create mode 100644 Documentation/DocBook/media/selection.png.b64
  create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
  create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml

