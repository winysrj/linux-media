Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43299 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2AIQvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 11:51:10 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LXJ004VLIT3MJ80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jan 2012 16:51:03 +0000 (GMT)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LXJ00LX4IT2PB@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jan 2012 16:51:03 +0000 (GMT)
Date: Mon, 09 Jan 2012 17:51:01 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [GIT PULL FOR 3.3] Selection API and fixes for v3.3
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4F0B1AF5.3080009@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The selection API has been tested for compatibility with compat32.
The test was successful. I kindly ask for merging info 3.3.

Regards,
Tomasz Stanislawski

The following changes since commit e9eb0dadba932940f721f9d27544a7818b2fa1c5:

   [media] V4L menu: add submenu for platform devices (2011-11-08 
12:09:52 -0200)

are available in the git repository at:
   git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l-selection

Tomasz Stanislawski (7):
       v4l: add support for selection api
       doc: v4l: add binary images for selection API
       doc: v4l: add documentation for selection API
       v4l: emulate old crop API using extended crop/compose API
       v4l: s5p-tv: mixer: add support for selection API
       v4l: s5p-tv: mixer: fix setup of VP scaling
       doc: v4l: selection: choose pixels as units for selection rectangles

  Documentation/DocBook/media/constraints.png.b64    |   59 ++++
  Documentation/DocBook/media/selection.png.b64      |  206 ++++++++++++
  Documentation/DocBook/media/v4l/common.xml         |    2 +
  Documentation/DocBook/media/v4l/compat.xml         |    9 +
  Documentation/DocBook/media/v4l/selection-api.xml  |  321 
++++++++++++++++++
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
  15 files changed, 1489 insertions(+), 202 deletions(-)
  create mode 100644 Documentation/DocBook/media/constraints.png.b64
  create mode 100644 Documentation/DocBook/media/selection.png.b64
  create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
  create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml

