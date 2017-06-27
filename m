Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58430 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbdF0QJI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 12:09:08 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/8] [media] s5p-jpeg: Various fixes and improvements
Date: Tue, 27 Jun 2017 18:08:46 +0200
Message-Id: <1498579734-1594-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This series contains various fixes and improvements for the Samsung
s5p-jpeg driver. Most of these patches come from the Chromium v3.8
kernel tree.

In this v3:
- Remove codec reset patch (Not needed based on documentation and no
  use case described in original patch commit message).
- Check for Exynos5420 variant in stream error handling patch.
- Add use case for resolution change event support in commit message.
- Move subsampling value decoding in a separate function.
- Check Exynos variant for 4:1:1 subsampling support.

v2:
- Remove IOMMU support patch (mapping now created automatically for
  single JPEG CODEC device).
- Remove "Change sclk_jpeg to 166MHz" patch (can be set through DT
  properties).
- Remove support for multi-planar APIs (Not needed).
- Add comment regarding call to jpeg_bound_align_image() after qbuf.
- Remove unrelated code from resolution change event support patch.

Thierry Escande (3):
  [media] s5p-jpeg: Handle parsing error in s5p_jpeg_parse_hdr()
  [media] s5p-jpeg: Don't use temporary structure in s5p_jpeg_buf_queue
  [media] s5p-jpeg: Split s5p_jpeg_parse_hdr()

Tony K Nadackal (3):
  [media] s5p-jpeg: Call jpeg_bound_align_image after qbuf
  [media] s5p-jpeg: Correct WARN_ON statement for checking subsampling
  [media] s5p-jpeg: Decode 4:1:1 chroma subsampling format

henryhsu (2):
  [media] s5p-jpeg: Add support for resolution change event
  [media] s5p-jpeg: Add stream error handling for Exynos5420

 drivers/media/platform/s5p-jpeg/jpeg-core.c | 186 +++++++++++++++++++++-------
 drivers/media/platform/s5p-jpeg/jpeg-core.h |   7 ++
 2 files changed, 148 insertions(+), 45 deletions(-)

-- 
2.7.4
