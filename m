Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:19712 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752815AbeCTMOb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 08:14:31 -0400
To: linux-media@vger.kernel.org
Cc: Smitha T Murthy <smitha.t@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] HEVC V4L2 controls and s5p-mfc update
Message-id: <d4d81bd9-faff-b612-9f92-b6884eac07be@samsung.com>
Date: Tue, 20 Mar 2018 13:14:25 +0100
MIME-version: 1.0
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20180320121429epcas2p276e834ad420d7553013981d35750a9b8@epcas2p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3f127ce11353fd1071cae9b65bc13add6aec6b90:

  media: em28xx-cards: fix em28xx_duplicate_dev() (2018-03-08 06:06:51 -0500)

are available in the git repository at:

  git://linuxtv.org/snawrocki/samsung.git tags/v4.17-media-samsung

for you to fetch changes up to 8e8ae9fe34ac0611494b0b540476c4b9b52eac5b:

  s5p-mfc: Amend initial min, max values of HEVC hierarchical coding QP controls (2018-03-19 17:44:24 +0100)

----------------------------------------------------------------
Support for MFC v10.10 in the s5p-mfc driver and addition
of related HEVC V4L2 controls.

----------------------------------------------------------------
Marek Szyprowski (1):
      media: s5p-mfc: Use real device for request_firmware() call

Smitha T Murthy (12):
      videodev2.h: Add v4l2 definition for HEVC
      v4l2-ioctl: add HEVC format description
      v4l2: Documentation of HEVC compressed format
      v4l2: Add v4l2 control IDs for HEVC encoder
      v4l2: Documentation for HEVC CIDs
      s5p-mfc: Rename IS_MFCV8 macro
      s5p-mfc: Adding initial support for MFC v10.10
      s5p-mfc: Use min scratch buffer size as provided by F/W
      s5p-mfc: Support MFCv10.10 buffer requirements
      s5p-mfc: Add support for HEVC decoder
      s5p-mfc: Add VP9 decoder support
      s5p-mfc: Add support for HEVC encoder

Sylwester Nawrocki (2):
      s5p-mfc: Ensure HEVC QP controls range is properly updated
      s5p-mfc: Amend initial min, max values of HEVC hierarchical coding QP controls

 Documentation/devicetree/bindings/media/s5p-mfc.txt |   1 +
 Documentation/media/uapi/v4l/extended-controls.rst  | 410 ++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-compressed.rst  |   5 +
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h       |  87 +++
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h        |   2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c            |  28 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c     |   9 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h     |  68 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c       |   8 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c        |  48 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c        | 597 ++++++++++++++++++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h        |  14 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c     | 397 ++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h     |  15 +
 drivers/media/v4l2-core/v4l2-ctrls.c                | 119 ++++
 drivers/media/v4l2-core/v4l2-ioctl.c                |   1 +
 include/uapi/linux/v4l2-controls.h                  |  93 +++-
 include/uapi/linux/videodev2.h                      |   1 +
 18 files changed, 1824 insertions(+), 79 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h


-- 
Regards,
Sylwester
