Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29300 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1LHHRM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 02:17:12 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LVV00IQ6IWLAZ@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Dec 2011 07:17:09 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVV0069PIWLNY@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Dec 2011 07:17:09 +0000 (GMT)
Date: Thu, 08 Dec 2011 08:17:00 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PATCHES FOR 3.3] v4l: add s5p-jpeg driver
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1323328620-20522-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

It looks that the review process for s5p-jpeg driver has been finally
finished and all the suggestions have been applied to the driver.
I would ask You to pull the code to the for-v3.3 kernel tree. This driver
depends on the selection api extension, which merge has been requested
in '[GIT PATCHES FOR 3.3] v4l: introduce selection API' thread.

Best regards,
Marek Szyprowski


The following changes since commit 2a887d27708a4f9f3b5ad8258f9e19a150b58f03:

  [media] tm6000: fix OOPS at tm6000_ir_int_stop() and tm6000_ir_int_start() (2011-11-30 16:49:45 -0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung s5p-jpeg

Andrzej Pietrasiewicz (1):
      Exynos4 JPEG codec v4l2 driver

 drivers/media/video/Kconfig              |    8 +
 drivers/media/video/Makefile             |    1 +
 drivers/media/video/s5p-jpeg/Makefile    |    2 +
 drivers/media/video/s5p-jpeg/jpeg-core.c | 1481 ++++++++++++++++++++++++++++++
 drivers/media/video/s5p-jpeg/jpeg-core.h |  143 +++
 drivers/media/video/s5p-jpeg/jpeg-hw.h   |  353 +++++++
 drivers/media/video/s5p-jpeg/jpeg-regs.h |  170 ++++
 7 files changed, 2158 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-jpeg/Makefile
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.c
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw.h
 create mode 100644 drivers/media/video/s5p-jpeg/jpeg-regs.h
