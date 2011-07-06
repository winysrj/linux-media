Return-path: <mchehab@localhost>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28797 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1GFP3e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 11:29:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNX00KS24D82290@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 16:29:32 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNX00D4P4D75W@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Jul 2011 16:29:31 +0100 (BST)
Date: Wed, 06 Jul 2011 17:29:20 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [GIT PULL FOR 3.1] MFC Driver and necessary v4l2 framework changes
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Message-id: <1309966160-13940-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Mauro,

Recently I have send the MFC 5.1 driver v10 with necessary v4l2 patches.


The following changes since commit df6aabbeb2b8799d97f3886fc994c318bc6a6843:

  [media] v4l2-ctrls.c: add support for V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK (2011-07-01 20:54:51 -0300)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung mfc-for-Mauro

Kamil Debski (4):
      v4l: add fourcc definitions for compressed formats.
      v4l: add control definitions for codec devices.
      v4l2-ctrl: add codec controls support to the control framework
      MFC: Add MFC 5.1 V4L2 driver

 Documentation/DocBook/media/v4l/controls.xml |  976 ++++++++++++++-
 Documentation/DocBook/media/v4l/pixfmt.xml   |   47 +-
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-mfc/Makefile         |    5 +
 drivers/media/video/s5p-mfc/regs-mfc.h       |  413 ++++++
 drivers/media/video/s5p-mfc/s5p_mfc.c        | 1274 ++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |  120 ++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   30 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  572 ++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  343 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |   29 +
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   48 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    | 1036 +++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    | 1829 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   92 ++
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1397 ++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   91 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |  117 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.h     |   24 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   91 ++
 drivers/media/video/v4l2-ctrls.c             |  197 +++-
 include/linux/videodev2.h                    |  186 +++-
 27 files changed, 9032 insertions(+), 13 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/Makefile
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h

Thanks,

Kamil Debski
