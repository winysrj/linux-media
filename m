Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48196 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1I3QKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 12:10:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LSC00FYSFM0Y150@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Sep 2011 17:10:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSC00KRAFM0GF@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Sep 2011 17:10:48 +0100 (BST)
Date: Fri, 30 Sep 2011 18:10:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.2] S5K6AAFX sensor driver and a videobuf2 update
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4E85EA07.7060606@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

please pull from
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx

for S5K6AAFX sensor subdev driver, a videbuf2 enhancement for non-MMU systems
and minor s5p-mfc amendment changing the firmware name to something more
generic as the driver supports multiple SoC versions.


The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:

  [media] media: DocBook: Fix trivial typo in Sub-device Interface (2011-09-27
09:14:58 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5k6aafx

Sachin Kamat (1):
      MFC: Change MFC firmware binary name

Scott Jiang (1):
      vb2: add vb2_get_unmapped_area in vb2 core

Sylwester Nawrocki (2):
      v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY control
      v4l: Add v4l2 subdev driver for S5K6AAFX sensor

 Documentation/DocBook/media/v4l/controls.xml |    5 +-
 drivers/media/video/Kconfig                  |    7 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5k6aa.c                 | 1688 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |    4 +-
 drivers/media/video/v4l2-ctrls.c             |    1 +
 drivers/media/video/videobuf2-core.c         |   31 +
 include/linux/videodev2.h                    |    1 +
 include/media/s5k6aa.h                       |   51 +
 include/media/videobuf2-core.h               |    7 +
 10 files changed, 1792 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/video/s5k6aa.c
 create mode 100644 include/media/s5k6aa.h


Regards
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
