Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:50434 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdCCKSN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 05:18:13 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v2 00/11] Add MFC v10.10 support
Date: Fri, 03 Mar 2017 14:37:05 +0530
Message-id: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
References: <CGME20170303090429epcas5p3c057f653b6a6b6299ad2392490925fd9@epcas5p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds MFC v10.10 support. MFC v10.10 is used in some
of Exynos7 variants.

This adds support for following:

* Add support for HEVC encoder and decoder
* Add support for VP9 decoder
* Update Documentation for control id definitions
* Update computation of min scratch buffer size requirement for V8 onwards

Changes since v1:
 - Addressed review comments by Andrzej Hajda.
 - Addressed review comment by Rob Herring.
 - Rebased on latest krzk/for-next tree.
 - This patches are tested on top of Marek's patch v2 [1]
 - Applied acked-by and r-o-b from Andrzej on respective patches. 

[1]: http://www.mail-archive.com/linux-media@vger.kernel.org/msg108520.html

Smitha T Murthy (11):
  s5p-mfc: Rename IS_MFCV8 macro
  s5p-mfc: Adding initial support for MFC v10.10
  s5p-mfc: Use min scratch buffer size as provided by F/W
  s5p-mfc: Support MFCv10.10 buffer requirements
  videodev2.h: Add v4l2 definition for HEVC
  s5p-mfc: Add support for HEVC decoder
  Documentation: v4l: Documentation for HEVC v4l2 definition
  s5p-mfc: Add VP9 decoder support
  v4l2: Add v4l2 control IDs for HEVC encoder
  s5p-mfc: Add support for HEVC encoder
  Documention: v4l: Documentation for HEVC CIDs

 .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
 Documentation/media/uapi/v4l/extended-controls.rst |  314 ++++++++++
 Documentation/media/uapi/v4l/pixfmt-013.rst        |    5 +
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |   88 +++
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |    2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   33 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    9 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   64 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   62 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  621 +++++++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |   14 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  420 ++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |   15 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   51 ++
 include/uapi/linux/v4l2-controls.h                 |  129 ++++
 include/uapi/linux/videodev2.h                     |    1 +
 17 files changed, 1758 insertions(+), 77 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h

-- 
1.7.2.3
