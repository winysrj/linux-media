Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60241 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753741AbdFLRNd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 13:13:33 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] [media] s5p-jpeg: Various fixes and improvements
Date: Mon, 12 Jun 2017 19:13:19 +0200
Message-Id: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series contains various fixes and improvements for the Samsung
s5p-jpeg driver. All these patches come from the Chromium v3.8 kernel
tree.

In this v2:
- Remove IOMMU support patch (mapping now created automatically for
  single JPEG CODEC device).
- Remove "Change sclk_jpeg to 166MHz" patch (can be set through DT
  properties).
- Remove support for multi-planar APIs (Not needed).
- Add comment regarding call to jpeg_bound_align_image() after qbuf.
- Remove unrelated code from resolution change event support patch.

Regards,
 Thierry

Abhilash Kesavan (1):
  [media] s5p-jpeg: Reset the Codec before doing a soft reset

Tony K Nadackal (3):
  [media] s5p-jpeg: Call jpeg_bound_align_image after qbuf
  [media] s5p-jpeg: Correct WARN_ON statement for checking subsampling
  [media] s5p-jpeg: Decode 4:1:1 chroma subsampling format

henryhsu (2):
  [media] s5p-jpeg: Add support for resolution change event
  [media] s5p-jpeg: Add stream error handling for Exynos5420

 drivers/media/platform/s5p-jpeg/jpeg-core.c       | 140 +++++++++++++++++-----
 drivers/media/platform/s5p-jpeg/jpeg-core.h       |   7 ++
 drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c |   4 +
 3 files changed, 122 insertions(+), 29 deletions(-)

-- 
2.7.4
