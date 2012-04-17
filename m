Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60154 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab2DQKKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:03 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M006T8C8L0I@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:09:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M00189C8MLM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:09:59 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 00/15] V4L camera control enhancements
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this is a second iteration of my camera control patches. Besides the 
previous ones, it also includes the scene mode and 3A lock controls.
The 3A lock bitmask control allows to lock/unlock automatic exposure, 
white balance and focus adjustments. It is useful for pre-focus 
for instance.

I had been a little hesitant about introducing the scene mode control, 
however it is really needed, since some sensors with more advanced ISPs
or the ISPs inside host processors running their own firmware support 
the scene modes through a single configuration register.

The controls included in this series have been successfully used in 
the Samsung Android kernels for several years now. I'd like to extend
the V4L2 API to include at least most of the basic functionality 
available there.

Changes since v1 (implicit):
 - the V4L2_CID_AUTO_FOCUS_FACE_PRIORITY control merged with
   V4L2_CID_AUTO_FOCUS_FACE_AREA,
 - many minor documentation corrections,
 - removed "08/23 V4L: camera control class..." patch, which got 
   accidentally added at v1,
 - added V4L2_CID_SCENE_MODE and V4L2_CID_3A_LOCK controls,
 - added vivi patch for testing.

Any comments are welcome. I'd like to get this patch set merged for v3.5.
Maybe except the 3 focus related patches, since I'm not entirely happy 
with those API additions. I'll try to seek some time to complete those 
too though.

The patches will be also available in few hours at:
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v4l-controls-s5c73m3


Regards,

Sylwester Nawrocki
Samsung Poland R&D Center 


Sylwester Nawrocki (15):
  V4L: Extend V4L2_CID_COLORFX with more image effects
  V4L: Add helper function for standard integer menu controls
  V4L: Add camera exposure bias control
  V4L: Add camera white balance preset control
  V4L: Add camera wide dynamic range control
  V4L: Add camera image stabilization control
  V4L: Add camera ISO sensitivity controls
  V4L: Add camera exposure metering control
  V4L: Add camera scene mode control
  V4L: Add camera 3A lock control
  V4L: Add auto focus targets to the selections API
  V4L: Add auto focus targets to the subdev selections API
  V4L: Add camera auto focus controls
  V4L: Add S5C73M3 sensor sub-device driver
  vivi: Add controls

 Documentation/DocBook/media/v4l/biblio.xml         |   11 +
 Documentation/DocBook/media/v4l/controls.xml       |  549 ++++++++-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   27 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |   33 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |   14 +-
 drivers/media/video/Kconfig                        |    8 +
 drivers/media/video/Makefile                       |    1 +
 drivers/media/video/s5c73m3/Makefile               |    3 +
 drivers/media/video/s5c73m3/s5c73m3-ctrls.c        |  702 +++++++++++
 drivers/media/video/s5c73m3/s5c73m3-spi.c          |  126 ++
 drivers/media/video/s5c73m3/s5c73m3.c              | 1235 ++++++++++++++++++++
 drivers/media/video/s5c73m3/s5c73m3.h              |  446 +++++++
 drivers/media/video/v4l2-ctrls.c                   |  118 +-
 drivers/media/video/vivi.c                         |  111 +-
 include/linux/v4l2-subdev.h                        |    4 +
 include/linux/videodev2.h                          |  104 +-
 include/media/s5c73m3.h                            |   62 +
 include/media/v4l2-ctrls.h                         |   17 +
 19 files changed, 3551 insertions(+), 31 deletions(-)
 create mode 100644 drivers/media/video/s5c73m3/Makefile
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3-ctrls.c
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3-spi.c
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3.c
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3.h
 create mode 100644 include/media/s5c73m3.h

-- 
1.7.10

