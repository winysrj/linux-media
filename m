Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42651 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab2FOMVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 08:21:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5N00KU3RNWJBM0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jun 2012 21:21:32 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M5N008WHRNEUE50@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jun 2012 21:21:29 +0900 (KST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: =?UTF-8?q?=5BGIT=20PULL=5D=20Samsung=20fixes=20for=20v3=2E5?=
Date: Fri, 15 Jun 2012 14:21:03 +0200
Message-id: <1339762863-27308-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Please pull various fixes for V4L drivers for v3.5 kernel series.

Best regards,
Marek Szyprowski
Samsung Poland R&D Center


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes

Andrzej Hajda (2):
      v4l/s5p-mfc: corrected encoder v4l control definitions
      v4l/s5p-mfc: added image size align in VIDIOC_TRY_FMT

Kamil Debski (2):
      s5p-mfc: Bug fix of timestamp/timecode copy mechanism
      s5p-mfc: Fix setting controls

Tomasz Moń (1):
      v4l: mem2mem_testdev: Fix race conditions in driver.

 drivers/media/video/mem2mem_testdev.c     |   50 +++++++++++++++--------------
 drivers/media/video/s5p-mfc/regs-mfc.h    |    5 +++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |   12 ++-----
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h |    4 ++-
 5 files changed, 40 insertions(+), 35 deletions(-)
