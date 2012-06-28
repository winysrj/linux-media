Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24893 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab2F1Q3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 12:29:05 -0400
Received: from eusync1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6C0032X5T8V1A0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Jun 2012 17:29:32 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M6C00C215SEGD00@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 28 Jun 2012 17:29:02 +0100 (BST)
Message-id: <4FEC864D.5040608@samsung.com>
Date: Thu, 28 Jun 2012 18:29:01 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [GIT PULL FOR v3.5] S5P driver fixes
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 433002d69888238b16f8ea9434447feaa1fc9bf0:

  Merge remote-tracking branch 'party-public/v4l-fimc-fixes' into v4l-fixes
(2012-06-27 16:28:08 +0200)

are available in the git repository at:


  git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes

for you to fetch changes up to f8a623efac978987be818a0a9d2d407791a066e4:

  Revert "[media] V4L: JPEG class documentation corrections" (2012-06-27
16:31:20 +0200)

----------------------------------------------------------------
Kamil Debski (1):
      s5p-mfc: Fixed setup of custom controls in decoder and encoder

Sylwester Nawrocki (2):
      s5p-fimc: Add missing FIMC-LITE file operations locking

This patch depends on my previous pull request:
http://patchwork.linuxtv.org/patch/11503

      Revert "[media] V4L: JPEG class documentation corrections"

 Documentation/DocBook/media/v4l/controls.xml           |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |    7 -------
 drivers/media/video/s5p-fimc/fimc-lite.c               |   61
++++++++++++++++++++++++++++++++++++++++++++-----------------
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c              |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c              |    1 +
 5 files changed, 47 insertions(+), 25 deletions(-)


Regards,
-- 
Sylwester Nawrocki
