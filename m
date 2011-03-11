Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56462 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1CKKIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2011 05:08:39 -0500
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LHW001BJ1ICPD@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 10:08:37 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LHW00GMW1IB8A@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Mar 2011 10:08:35 +0000 (GMT)
Date: Fri, 11 Mar 2011 11:08:35 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 2.6.39] videobuf2 and s5p fimc driver fixes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4D79F4A3.5090900@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

please pull from
	git://git.infradead.org/users/kmpark/linux-2.6-samsung for-mauro

for a couple of videobuf2 and s5p fimc driver fixes and updates.
Included is also the missing Docbook documentation for NV12MT format.


The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:

  [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung for-mauro

Andrzej Pietrasiewicz (2):
      v4l2: vb2-dma-sg: fix memory leak
      v4l2: vb2-dma-sg: fix potential security hole

Kamil Debski (1):
      v4l: Documentation for the NV12MT format

Marek Szyprowski (3):
      v4l2: vb2: fix queue reallocation and REQBUFS(0) case
      v4l2: vb2: one more fix for REQBUFS()
      v4l2: vb2: simplify __vb2_queue_free function

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
 drivers/media/video/s5p-fimc/fimc-capture.c  |  104 ++++------
 drivers/media/video/s5p-fimc/fimc-core.c     |  279 ++++++++++++++------------
 drivers/media/video/s5p-fimc/fimc-core.h     |   50 ++++--
 drivers/media/video/s5p-fimc/fimc-reg.c      |    6 +-
 drivers/media/video/videobuf2-core.c         |   24 ++-
 drivers/media/video/videobuf2-dma-sg.c       |    4 +-
 include/media/s5p_fimc.h                     |    9 +-
 12 files changed, 329 insertions(+), 223 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/nv12mt.gif
 create mode 100644 Documentation/DocBook/v4l/nv12mt_example.gif
 create mode 100644 Documentation/DocBook/v4l/pixfmt-nv12mt.xml

Best regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
