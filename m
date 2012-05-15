Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41585 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2EOJs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 05:48:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4200A905WC0W40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 May 2012 10:48:12 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4200J0U5XEY3@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 May 2012 10:48:55 +0100 (BST)
Date: Tue, 15 May 2012 11:48:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 3.5] Samsung media driver updates
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4FB22680.6050109@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit e89fca923f32de26b69bf4cd604f7b960b161551:

  [media] gspca - ov534: Add Hue control (2012-05-14 09:48:00 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l_samsung_for_v3.5

for you to fetch changes up to 5aeade300821356695046a814c86bd1ebfeb5bde:

  s5p-mfc: Use devm_* functions in s5p_mfc.c file (2012-05-14 18:33:44 +0200)

This are updates for s5p-tv driver and other various fixes and improvements
for drivers/media/video/s5p-*.

----------------------------------------------------------------
Marek Szyprowski (1):
      v4l: s5p-tv: fix plane size calculation

Sachin Kamat (10):
      v4l: s5p-tv: Fix section mismatch warning in mixer_video.c
      s5p-mfc: Fix NULL pointer warnings
      s5p-mfc: Add missing static storage class to silence warnings
      s5p-g2d: Fix NULL pointer warnings in g2d.c file
      s5p-g2d: Add missing static storage class in g2d.c file
      s5p-jpeg: Make s5p_jpeg_g_selection function static
      s5p-mfc: Add missing static storage class in s5p_mfc_enc.c file
      s5p-g2d: Use devm_* functions in g2d.c file
      s5p-jpeg: Use devm_* functions in jpeg-core.c file
      s5p-mfc: Use devm_* functions in s5p_mfc.c file

Tomasz Stanislawski (5):
      v4l: s5p-tv: mixer: fix compilation warning
      v4l: s5p-tv: hdmiphy: add support for per-platform variants
      v4l: s5p-tv: hdmi: parametrize DV timings
      v4l: s5p-tv: hdmi: fix mode synchronization
      v4l: s5p-tv: mixer: fix handling of interlaced modes

 drivers/media/video/s5p-g2d/g2d.c            |   65 +++++---------
 drivers/media/video/s5p-g2d/g2d.h            |    1 -
 drivers/media/video/s5p-jpeg/jpeg-core.c     |   60 +++----------
 drivers/media/video/s5p-jpeg/jpeg-core.h     |    2 -
 drivers/media/video/s5p-mfc/s5p_mfc.c        |   75 +++++-----------
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |    2 -
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |   16 ++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |   28 +++---
 drivers/media/video/s5p-tv/hdmi_drv.c        |  480
++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------
 drivers/media/video/s5p-tv/hdmiphy_drv.c     |  225
++++++++++++++++++++++++++++++++++++++--------
 drivers/media/video/s5p-tv/mixer.h           |    3 +-
 drivers/media/video/s5p-tv/mixer_reg.c       |   15 ++--
 drivers/media/video/s5p-tv/mixer_video.c     |    6 +-
 drivers/media/video/s5p-tv/regs-hdmi.h       |    1 +
 15 files changed, 503 insertions(+), 482 deletions(-)
---

Thank you,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
