Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26942 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab3FQMi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 08:38:57 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MOJ00JOPEVTWQ10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jun 2013 13:38:55 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MOJ00LVBF4VUF40@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jun 2013 13:38:55 +0100 (BST)
Message-id: <51BF035C.4090902@samsung.com>
Date: Mon, 17 Jun 2013 14:38:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.10] exynos4-is driver BUG fix
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Only one patch in this pull request, but it fixes pretty serious bug,
that took me long time to debug. Please queue for 3.10, if possible.

The following changes since commit af44ad5edd1eb6ca92ed5be48e0004e1f04bf219:

  [media] soc_camera: error dev remove and v4l2 call (2013-06-08 21:51:06 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git v3.10-fixes-3

for you to fetch changes up to 21c62485ee61398eadc27b4fbab66a832860c008:

  exynos4-is: Fix FIMC-IS clocks initialization (2013-06-17 14:27:28 +0200)

----------------------------------------------------------------
Sylwester Nawrocki (1):
      exynos4-is: Fix FIMC-IS clocks initialization

 drivers/media/platform/exynos4-is/fimc-is.c |   26 ++++++++------------------
 drivers/media/platform/exynos4-is/fimc-is.h |    1 -
 2 files changed, 8 insertions(+), 19 deletions(-)

Thanks,
Sylwester
