Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:20706 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdGULf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 07:35:57 -0400
To: LMML <linux-media@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 4.14] Samsung SoC related updates
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-id: <bffa2f9f-0c6b-d4c4-f360-7e020870f049@samsung.com>
Date: Fri, 21 Jul 2017 13:35:51 +0200
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20170721113554epcas5p33038698354481532ac30e86ab1f83111@epcas5p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 6538b02d210f52ef2a2e67d59fcb58be98451fbd:

  media: Make parameter of media_entity_remote_pad() const (2017-07-20 16:54:04 -0400)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git for-v4.14/media/next

for you to fetch changes up to c7782331ca78c9b84485051365c1aaceac6c634c:

  exynos4-is: fimc-is-i2c: constify dev_pm_ops structures. (2017-07-21 13:22:40 +0200)

----------------------------------------------------------------
Arvind Yadav (1):
      exynos4-is: fimc-is-i2c: constify dev_pm_ops structures.

Gustavo A. R. Silva (1):
      s5k5baf: remove unnecessary static in s5k5baf_get_selection()

Thierry Escande (3):
      s5p-jpeg: Handle parsing error in s5p_jpeg_parse_hdr()
      s5p-jpeg: Don't use temporary structure in s5p_jpeg_buf_queue
      s5p-jpeg: Split s5p_jpeg_parse_hdr()

Tony K Nadackal (3):
      s5p-jpeg: Call jpeg_bound_align_image after qbuf
      s5p-jpeg: Correct WARN_ON statement for checking subsampling
      s5p-jpeg: Decode 4:1:1 chroma subsampling format

henryhsu (2):
      s5p-jpeg: Add support for resolution change event
      s5p-jpeg: Add stream error handling for Exynos5420

 drivers/media/i2c/s5k5baf.c                  |   2 +-
 .../media/platform/exynos4-is/fimc-is-i2c.c  |   2 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c  | 186 ++++++++++++----
 drivers/media/platform/s5p-jpeg/jpeg-core.h  |   7 +
 4 files changed, 150 insertions(+), 47 deletions(-)

-- 
Thanks,
Sylwester
