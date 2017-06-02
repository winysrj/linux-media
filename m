Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57952 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdFBQDO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 12:03:14 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] [media] s5p-jpeg: Various fixes and improvements
Date: Fri,  2 Jun 2017 18:02:47 +0200
Message-Id: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series contains various fixes and improvements for the Samsung
s5p-jpeg driver. All these patches come from the Chromium v3.8 kernel
tree.

Regards,
 Thierry

Abhilash Kesavan (1):
  [media] s5p-jpeg: Reset the Codec before doing a soft reset

Ricky Liang (1):
  [media] s5p-jpeg: Add support for multi-planar APIs

Tony K Nadackal (4):
  [media] s5p-jpeg: Call jpeg_bound_align_image after qbuf
  [media] s5p-jpeg: Correct WARN_ON statement for checking subsampling
  [media] s5p-jpeg: Decode 4:1:1 chroma subsampling format
  [media] s5p-jpeg: Add IOMMU support

henryhsu (3):
  [media] s5p-jpeg: Add support for resolution change event
  [media] s5p-jpeg: Change sclk_jpeg to 166MHz for Exynos5250
  [media] s5p-jpeg: Add stream error handling for Exynos5420

 drivers/media/platform/s5p-jpeg/jpeg-core.c       | 387 ++++++++++++++++++++--
 drivers/media/platform/s5p-jpeg/jpeg-core.h       |   9 +
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |   4 +
 3 files changed, 368 insertions(+), 32 deletions(-)

-- 
2.7.4
