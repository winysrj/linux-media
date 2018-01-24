Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:11533 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932891AbeAXLX1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 06:23:27 -0500
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>
Subject: [Patch v7 00/12] Add MFC v10.10 support
Date: Wed, 24 Jan 2018 16:29:32 +0530
Message-id: <1516791584-7980-1-git-send-email-smitha.t@samsung.com>
References: <CGME20180124112324epcas2p246e0983b55ae9d6923b537cb34d7346f@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds MFC v10.10 support. MFC v10.10 is used in some
of Exynos7 variants.

This adds support for following:

* Add support for HEVC encoder and decoder
* Add support for VP9 decoder
* Update Documentation for control id definitions
* Update computation of min scratch buffer size requirement for V8 onwards

Changes since v6:
 - Addressed review comments by Kamil Debski <kamil@wypas.org>.
 - Addressed review comments by
   Stanimir Varbanov <stanimir.varbanov@linaro.org>.
 - Addressed review comments by Hans Verkuil <hverkuil@xs4all.nl>.
 - Addressed review comments by Philippe Ombredanne <pombredanne@nexb.com>
 - Rebased on latest git://linuxtv.org/snawrocki/samsung.git
   for-v4.16/media/next.
 - Applied r-o-b from Andrzej, Stanimir on respective patches.
 - Applied acked-by from Kamil, Hans on respective patches.

Smitha T Murthy (12):
  [media] s5p-mfc: Rename IS_MFCV8 macro
  [media] s5p-mfc: Adding initial support for MFC v10.10
  [media] s5p-mfc: Use min scratch buffer size as provided by F/W
  [media] s5p-mfc: Support MFCv10.10 buffer requirements
  [media] videodev2.h: Add v4l2 definition for HEVC
  [media] v4l2-ioctl: add HEVC format description
  Documentation: v4l: Documentation for HEVC v4l2 definition
  [media] s5p-mfc: Add support for HEVC decoder
  [media] s5p-mfc: Add VP9 decoder support
  [media] v4l2: Add v4l2 control IDs for HEVC encoder
  [media] s5p-mfc: Add support for HEVC encoder
  Documention: v4l: Documentation for HEVC CIDs

 .../devicetree/bindings/media/s5p-mfc.txt          |   1 +
 Documentation/media/uapi/v4l/extended-controls.rst | 400 +++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst |   5 +
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h      |  87 ++++
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |   2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  28 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c    |   9 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  68 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |   6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  48 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 557 ++++++++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h       |  14 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    | 397 +++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |  15 +
 drivers/media/v4l2-core/v4l2-ctrls.c               | 119 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c               |   1 +
 include/uapi/linux/v4l2-controls.h                 |  93 +++-
 include/uapi/linux/videodev2.h                     |   1 +
 18 files changed, 1773 insertions(+), 78 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h

-- 
2.7.4
