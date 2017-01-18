Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48359 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752285AbdARKJa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jan 2017 05:09:30 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [PATCH 00/11] Add MFC v10.10 support
Date: Wed, 18 Jan 2017 15:31:58 +0530
Message-id: <1484733729-25371-1-git-send-email-smitha.t@samsung.com>
References: <CGME20170118100714epcas1p274e2e68d14a788417fbde2c26c91bcb9@epcas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds MFC v10.10 support. MFC v10.10 is used in some
of Exynos7 variants.

This adds support for following:

* Add support for HEVC encoder and decoder
* Add support for VP9 decoder
* Update Documentation for control id definitions
* Update computation of min scratch buffer size requirement for V8 onwards

This patch series is created on top of krzk/for-next and following patch [1]
[1]: https://lkml.org/lkml/2017/1/18/136


Smitha T Murthy (11):
  [media] s5p-mfc: Rename IS_MFCV8 macro
  [media] s5p-mfc: Adding initial support for MFC v10.10
  [media] s5p-mfc: Use min scratch buffer size
  [media] s5p-mfc: Support MFCv10.10 buffer requirements
  [media] s5p-mfc: Add support for HEVC decoder
  [media] videodev2.h: Add v4l2 definition for HEVC
  Documentation: v4l: Documentation for HEVC v4l2 definition
  [media] s5p-mfc: Add VP9 decoder support
  [media] s5p-mfc: Add support for HEVC encoder
  [media] v4l2: Add v4l2 control IDs for HEVC encoder
  Documention: v4l: Documentation for HEVC CIDs

 .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
 Documentation/media/uapi/v4l/extended-controls.rst |  190 ++++++
 Documentation/media/uapi/v4l/pixfmt-013.rst        |    5 +
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |   84 +++
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |    2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   33 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |    9 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |   64 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |    6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   62 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  623 +++++++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |   14 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  420 ++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |   16 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   51 ++
 include/uapi/linux/v4l2-controls.h                 |  109 ++++
 include/uapi/linux/videodev2.h                     |    1 +
 17 files changed, 1613 insertions(+), 77 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h

-- 
1.7.2.3

