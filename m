Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54613 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbcIPNdk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 09:33:40 -0400
To: LMML <linux-media@vger.kernel.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung fixes for 4.8
Message-id: <8001c83d-0e3a-61cb-bf53-8c2b497bd0ed@samsung.com>
Date: Fri, 16 Sep 2016 15:33:33 +0200
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <CGME20160916133335eucas1p2417ec5672f250c3eaca8e424293ce783@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 7892a1f64a447b6f65fe2888688883b7c26d81d3:

  [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0 on success (2016-09-15 09:02:16 -0300)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.9/media/fixes

for you to fetch changes up to 8beaa9d0595aa2ae1f63be364c80189e53cbfe15:

  exynos4-is: Clear I2C_ISP adapter's power.ignore_children flag (2016-09-16 15:25:55 +0200)

----------------------------------------------------------------
Marek Szyprowski (1):
      s5p-mfc: fix failure path of s5p_mfc_alloc_memdev()

Sylwester Nawrocki (1):
      exynos4-is: Clear I2C_ISP adapter's power.ignore_children flag

 drivers/media/platform/exynos4-is/fimc-is-i2c.c | 25 ++++++++++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  1 +
 2 files changed, 19 insertions(+), 7 deletions(-)

--
Thanks, 
Sylwester
