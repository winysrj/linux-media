Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63290 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932899AbcKNSPF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 13:15:05 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGN00G6H9D1V330@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Nov 2016 18:15:01 +0000 (GMT)
Received: from eusmges3.samsung.com (unknown [203.254.199.242])
 by     eucas1p2.samsung.com (KnoxPortal)
 with ESMTP id  20161114181501eucas1p2abe5c000bcd992fb880ea43e1560907b~G-KIvXtzn0168401684eucas1p25
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2016 18:15:01 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180])
 by     eucas1p2.samsung.com (KnoxPortal)
 with ESMTP id  20161114181500eucas1p2f4bc902fe54c96803440410b6325d237~G-KIBs8wR0170001700eucas1p2q
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2016 18:15:00 +0000 (GMT)
Received: from [106.116.147.40] by eusync4.samsung.com
 (Oracle        Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with   ESMTPA id <0OGN00F8A9CZ7E00@eusync4.samsung.com> for
        linux-media@vger.kernel.org; Mon, 14 Nov 2016 18:14:59 +0000 (GMT)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung SoC driver updates for 4.10
To: LMML <linux-media@vger.kernel.org>
Message-id: <6bdd1466-d678-fd11-0275-e7cbd0815f4d@samsung.com>
Date: Mon, 14 Nov 2016 19:14:58 +0100
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <CGME20161114181500eucas1p2f4bc902fe54c96803440410b6325d237@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This includes mostly clean up and fixes of the s5p-mfc and exynos-gsc
drivers. Support for the Exynos5433 (64-bit ARM) SoC is added to the
exynos-gsc driver.

The following changes since commit 669c6141ea78dff885b5bf025456c7dffb669a61:

  [media] mtk-mdp: fix double mutex_unlock (2016-10-21 12:09:53 -0200)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.10/media/next

for you to fetch changes up to 37269235bfaab6ad0b801190dc8a8c7397476b5b:

  s5p-mfc: Fix clock management in s5p_mfc_release() function (2016-11-14 16:04:15 +0100)

----------------------------------------------------------------
Andrzej Hajda (1):
      s5p-mfc: Correct scratch buffer size of H.263 decoder

Donghwa Lee (1):
      s5p-mfc: Skip incomplete frame

Ingi Kim (1):
      s5p-mfc: Fix MFC context buffer size

Javier Martinez Canillas (7):
      exynos-gsc: change spamming try_fmt log message to debug
      exynos-gsc: don't clear format when freeing buffers with REQBUFS(0)
      exynos-gsc: fix supported RGB pixel format
      exynos-gsc: do proper bytesperline and sizeimage calculation
      exynos-gsc: don't release a non-dynamically allocated video_device
      exynos-gsc: unregister video device node on driver removal
      exynos-gsc: cleanup m2m src and dst vb2 queues on STREAMOFF

Marek Szyprowski (8):
      exynos-gsc: Simplify system PM even more
      exynos-gsc: Remove unused lclk_freqency entry
      exynos-gsc: Add missing newline char in debug messages
      exynos-gsc: Use of_device_get_match_data() helper
      exynos-gsc: Enable driver on ARCH_EXYNOS
      exynos-gsc: Add support for Exynos5433 specific version
      s5p-mfc: Use clock gating only on MFC v5 hardware
      s5p-mfc: Fix clock management in s5p_mfc_release() function

Nicolas Dufresne (1):
      exynos4-is: fimc: Roundup imagesize to row size for tiled formats

Shuah Khan (2):
      s5p-mfc: Collapse two error message into one
      s5p-mfc: include buffer size in error message

Ulf Hansson (7):
      exynos-gsc: Simplify clock management
      exynos-gsc: Convert gsc_m2m_resume() from int to void
      exynos-gsc: Make driver functional when CONFIG_PM is unset
      exynos-gsc: Make PM callbacks available conditionally
      exynos-gsc: Fixup clock management at ->remove()
      exynos-gsc: Do full clock gating at runtime PM suspend
      exynos-gsc: Simplify system PM

 .../bindings/media/exynos5-gsc.txt       |   3 +-
 drivers/media/platform/Kconfig           |   2 +-
 .../media/platform/exynos-gsc/gsc-core.c | 279 +++++++--------
 .../media/platform/exynos-gsc/gsc-core.h |  11 +-
 .../media/platform/exynos-gsc/gsc-m2m.c  |  38 +-
 .../platform/exynos4-is/fimc-core.c      |  13 +-
 .../media/platform/s5p-mfc/regs-mfc-v6.h |   3 +-
 .../media/platform/s5p-mfc/regs-mfc-v8.h |   2 +-
 .../media/platform/s5p-mfc/regs-mfc.h    |   3 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c |  15 +-
 .../platform/s5p-mfc/s5p_mfc_common.h    |   2 +
 .../media/platform/s5p-mfc/s5p_mfc_opr.c |   6 +-
 .../media/platform/s5p-mfc/s5p_mfc_pm.c  |  17 +-
 13 files changed, 209 insertions(+), 185 deletions(-)

-- 
Thanks,
Sylwester
