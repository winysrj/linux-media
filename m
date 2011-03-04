Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34130 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759241Ab1CDKxM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 05:53:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Fri, 04 Mar 2011 11:53:09 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 2.6.39] s5p-fimc driver and videobuf2 fixes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-samsung-soc@vger.kernel.org
Message-id: <4D70C495.5000200@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

please pull the following change set, it's a couple of s5p-fimc driver
fixes and updates after conversion to videobuf2. There are also two small
corrections for the videobuf2 and documentation for NV12MT format.


The following changes since commit 548b491f5a3221e26c0b08dece18fdc62930fe5e:

  [media] media/radio/wl1273: fix build errors (2011-02-27 21:36:52 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p_fimc_for_mauro

Andrzej Pietrasiewicz (1):
      v4l2: vb2-dma-sg: fix memory leak

Kamil Debski (1):
      v4l: Documentation for the NV12MT format

Marek Szyprowski (1):
      v4l2: vb2: fix queue reallocation and REQBUFS(0) case

Sungchun Kang (1):
      s5p-fimc: fix ISR and buffer handling for fimc-capture

Sylwester Nawrocki (6):
      s5p-fimc: Prevent oops when i2c adapter is not available
      s5p-fimc: Prevent hanging on device close and fix the locking
      s5p-fimc: Allow defining number of sensors at runtime
      s5p-fimc: Add a platform data entry for MIPI-CSI data alignment
      s5p-fimc: Use dynamic debug
      s5p-fimc: Fix G_FMT ioctl handler

 Documentation/DocBook/media-entities.tmpl    |    1 +
 Documentation/DocBook/v4l/nv12mt.gif         |  Bin 0 -> 2108 bytes
 Documentation/DocBook/v4l/nv12mt_example.gif |  Bin 0 -> 6858 bytes
 Documentation/DocBook/v4l/pixfmt-nv12mt.xml  |   74 +++++++
 Documentation/DocBook/v4l/pixfmt.xml         |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c  |   99 ++++------
 drivers/media/video/s5p-fimc/fimc-core.c     |  266 ++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.h     |   50 ++++--
 drivers/media/video/s5p-fimc/fimc-reg.c      |    6 +-
 drivers/media/video/videobuf2-core.c         |    9 +-
 drivers/media/video/videobuf2-dma-sg.c       |    2 +
 include/media/s5p_fimc.h                     |    9 +-
 12 files changed, 307 insertions(+), 210 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/nv12mt.gif
 create mode 100644 Documentation/DocBook/v4l/nv12mt_example.gif
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12mt.xml

Regards,
Sylwester

-- 
Sylwester Nawrocki
Samsung Poland R&D Center
