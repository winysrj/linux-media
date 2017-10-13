Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33168 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbdJMLdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 07:33:17 -0400
To: LMML <linux-media@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Exynos/S5P updates for 4.15
Message-id: <24a660f7-c3bf-0484-acbf-95ffd03b496b@samsung.com>
Date: Fri, 13 Oct 2017 13:33:11 +0200
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20171013113314epcas1p457aa6db29020300ffbea61e468752f24@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

The following changes since commit 8382e556b1a2f30c4bf866f021b33577a64f9ebf:

  Simplify major/minor non-dynamic logic (2017-10-11 15:32:11 -0400)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.15/media/next

for you to fetch changes up to e5fa99e5df93e815920e87e907e5cb61e765505b:

  s5p-mfc: Adjust a null pointer check in four functions (2017-10-13 13:17:49 +0200)

----------------------------------------------------------------
Hoegeun Kwon (2):
      exynos-gsc: Add compatible for Exynos 5250 and 5420 SoC version
      exynos-gsc: Add hardware rotation limits

Markus Elfring (3):
      s5p-mfc: Delete an error message for a failed memory allocation
      s5p-mfc: Improve a size determination in s5p_mfc_alloc_memdev()
      s5p-mfc: Adjust a null pointer check in four functions

 .../devicetree/bindings/media/exynos5-gsc.txt |   9 +-
 drivers/media/platform/exynos-gsc/gsc-core.c  | 127 ++++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |  14 +-
 3 files changed, 134 insertions(+), 16 deletions(-)


-- 
Regards,
Sylwester
