Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14702 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1IVPNX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 11:13:23 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRX00BPRJM9BE@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 16:13:21 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRX0025TJM9K4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 16:13:21 +0100 (BST)
Date: Thu, 22 Sep 2011 17:13:11 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] Selection API and fixes for v3.2
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1316704391-13596-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

I've collected pending selection API patches together with pending
videobuf2 and Samsung driver fixes to a single git branch. Please pull
them to your media tree.

Best regards,
Marek Szyprowski
Samsung Poland R&D Center

The following changes since commit 699cc1962c85351689c27dd46e598e4204fdd105:

  [media] TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder (2011-09-21 17:06:56 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung for_mauro

Hatim Ali (1):
      s5p-tv: Add PM_RUNTIME dependency

Marek Szyprowski (1):
      staging: dt3155v4l: fix build break

Michael Olbrich (1):
      v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev

Scott Jiang (1):
      vb2: add vb2_get_unmapped_area in vb2 core

Sylwester Nawrocki (1):
      m5mols: Remove superfluous irq field from the platform data struct

Tomasz Stanislawski (6):
      v4l: add support for selection api
      v4l: add documentation for selection API
      v4l: emulate old crop API using extended crop/compose API
      v4l: s5p-tv: mixer: add support for selection API
      s5p-tv: hdmi: use DVI mode
      s5p-tv: fix mbus configuration

 Documentation/DocBook/media/constraints.png.b64    |  134 +
 Documentation/DocBook/media/selection.png.b64      | 2937 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/common.xml         |    4 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |  278 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-g-selection.xml       |  281 ++
 drivers/media/video/m5mols/m5mols_core.c           |    6 +-
 drivers/media/video/mem2mem_testdev.c              |   14 +
 drivers/media/video/s5p-tv/Kconfig                 |    2 +-
 drivers/media/video/s5p-tv/hdmi_drv.c              |   15 +-
 drivers/media/video/s5p-tv/mixer.h                 |   14 +-
 drivers/media/video/s5p-tv/mixer_grp_layer.c       |  157 +-
 drivers/media/video/s5p-tv/mixer_reg.c             |   11 +-
 drivers/media/video/s5p-tv/mixer_video.c           |  339 ++-
 drivers/media/video/s5p-tv/mixer_vp_layer.c        |  108 +-
 drivers/media/video/s5p-tv/regs-hdmi.h             |    4 +
 drivers/media/video/s5p-tv/regs-mixer.h            |    1 +
 drivers/media/video/s5p-tv/sdo_drv.c               |    1 +
 drivers/media/video/v4l2-compat-ioctl32.c          |    2 +
 drivers/media/video/v4l2-ioctl.c                   |  114 +-
 drivers/media/video/videobuf2-core.c               |   31 +
 drivers/staging/dt3155v4l/dt3155v4l.c              |    4 +-
 include/linux/videodev2.h                          |   46 +
 include/media/m5mols.h                             |    4 +-
 include/media/v4l2-ioctl.h                         |    4 +
 include/media/videobuf2-core.h                     |    7 +
 26 files changed, 4292 insertions(+), 227 deletions(-)
 create mode 100644 Documentation/DocBook/media/constraints.png.b64
 create mode 100644 Documentation/DocBook/media/selection.png.b64
 create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml
