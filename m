Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17477 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaG2Nhw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 09:37:52 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9H004B376JBE50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Jul 2014 14:37:31 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0N9H002O9771EC20@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 29 Jul 2014 14:37:49 +0100 (BST)
Message-id: <53D7A3A8.1020804@samsung.com>
Date: Tue, 29 Jul 2014 15:37:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] s5p-jpeg/s5p-mfc updates
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7f196789b3ffee243b681d3e7dab8890038db856:

  si2135: Declare the structs even if frontend is not enabled (2014-07-28
10:37:08 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.17

for you to fetch changes up to 42bb855f82fc4f8ddbae8d614c2c187e1d824ba8:

  s5p-mfc: remove unnecessary calling to function video_devdata() (2014-07-29
15:29:14 +0200)

I assume patch "s5p-jpeg: Document sclk-jpeg clock for Exynos3250 SoC"
is correct, since I didn't get any more DT mainainer's review comments.

----------------------------------------------------------------
Jacek Anaszewski (8):
      [media] s5p-jpeg: Document sclk-jpeg clock for Exynos3250 SoC
      s5p-jpeg: Add support for Exynos3250 SoC
      s5p-jpeg: return error immediately after get_byte fails
      s5p-jpeg: Adjust jpeg_bound_align_image to Exynos3250 needs
      s5p-jpeg: fix g_selection op
      s5p-jpeg: Assure proper crop rectangle initialization
      s5p-jpeg: Prevent erroneous downscaling for Exynos3250 SoC
      s5p-jpeg: add chroma subsampling adjustment for Exynos3250

Zhaowei Yuan (1):
      s5p-mfc: remove unnecessary calling to function video_devdata()

 .../bindings/media/exynos-jpeg-codec.txt           |   12 +-
 drivers/media/platform/Kconfig                     |    5 +-
 drivers/media/platform/s5p-jpeg/Makefile           |    2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |  660 ++++++++++++++++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.h        |   32 +-
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.c   |  487 +++++++++++++++
 .../media/platform/s5p-jpeg/jpeg-hw-exynos3250.h   |   60 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h        |  247 +++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |    2 +-
 9 files changed, 1447 insertions(+), 60 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos3250.h

--
Regards,
Sylwester
