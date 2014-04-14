Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20852 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbaDNQsp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 12:48:45 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4100FWI5CXZT90@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Apr 2014 17:48:33 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0N4100JQS5D6SG00@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Apr 2014 17:48:42 +0100 (BST)
Message-id: <534C1169.3020903@samsung.com>
Date: Mon, 14 Apr 2014 18:48:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL] Fixes for v3.15
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes a compilation error fix for s5c73m3 driver related to
recently merged patch series moving the v4l2-of code and a memory
allocation bug fix for the Exynos FIMC driver.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  ssh://linuxtv.org/git/snawrocki/samsung.git v3.15-fixes

for you to fetch changes up to 45621f3b45650e98c704d598a4004355bc2cffb4:

  s5p-fimc: Fix YUV422P depth (2014-04-14 17:06:11 +0200)

----------------------------------------------------------------
Nicolas Dufresne (1):
      s5p-fimc: Fix YUV422P depth

Sylwester Nawrocki (1):
      s5c73m3: Add missing rename of v4l2_of_get_next_endpoint() function

 drivers/media/i2c/s5c73m3/s5c73m3-core.c      |    2 +-
 drivers/media/platform/exynos4-is/fimc-core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--
Regards,
Sylwester
