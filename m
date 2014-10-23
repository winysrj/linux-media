Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43412 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJWQma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Oct 2014 12:42:30 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDW00A9KP7JCL20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Oct 2014 17:45:19 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0NDW00198P2RSXC0@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Oct 2014 17:42:27 +0100 (BST)
Message-id: <54492FE5.2050000@samsung.com>
Date: Thu, 23 Oct 2014 18:42:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] Exynos driver fixes for 3.18
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I've collected the Exynos driver fixes in this pull request, it's mostly
non-critical compiler warning fixes, except the PLAT_S5P patch.

The following changes since commit 9f93c52783faa24c5c6fca216acf0765ad5d8dd6:

  [media] hackrf: harmless off by one in debug code (2014-10-21 08:56:52 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v3.18-fixes

for you to fetch changes up to 802b0e2921315b9b18430002f58e802e545a2149:

  s5p-jpeg: Avoid -Wuninitialized warning in s5p_jpeg_parse_hdr (2014-10-23
17:59:07 +0200)

----------------------------------------------------------------
Jacek Anaszewski (1):
      s5p-jpeg: Avoid -Wuninitialized warning in s5p_jpeg_parse_hdr

Sylwester Nawrocki (1):
      [media] Remove references to non-existent PLAT_S5P symbol

Thierry Reding (2):
      s5p-jpeg: Only build suspend/resume for PM
      s5p-fimc: Only build suspend/resume for PM

 drivers/media/platform/Kconfig                |    6 +++---
 drivers/media/platform/exynos4-is/Kconfig     |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c |    2 ++
 drivers/media/platform/s5p-jpeg/jpeg-core.c   |    6 +++++-
 drivers/media/platform/s5p-tv/Kconfig         |    2 +-
 5 files changed, 12 insertions(+), 6 deletions(-)

--
Regards,
Sylwester
