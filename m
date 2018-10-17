Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44920 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbeJQHx2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 03:53:28 -0400
Received: by mail-pg1-f195.google.com with SMTP id g2-v6so11593791pgu.11
        for <linux-media@vger.kernel.org>; Tue, 16 Oct 2018 17:00:37 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v5 00/12] imx-media: Fixes for interlaced capture
Date: Tue, 16 Oct 2018 17:00:15 -0700
Message-Id: <20181017000027.23696-1-slongerbeam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A set of patches that fixes some bugs with capturing from an
interlaced source, and incompatibilites between IDMAC interlace
interweaving and 4:2:0 data write reduction.

History:
v5:
- Added a regression fix to allow empty endpoints to CSI (fix for imx6q
  SabreAuto).
- Cleaned up some convoluted code in ipu_csi_init_interface(), suggested
  by Philipp Zabel.
- Fixed a regression in csi_setup(), caught by Philipp.
- Removed interweave_offset and replace with boolean interweave_swap,
  suggested by Philipp.
- Make clear that it is IDMAC channel that does pixel reordering and
  interweave, not the CSI, in the imx.rst doc, caught by Philipp.

v4:
- rebased to latest media-tree master branch.
- Make patch author and SoB email addresses the same.

v3:
- add support for/fix interweaved scan with YUV planar output.
- fix bug in 4:2:0 U/V offset macros.
- add patch that generalizes behavior of field swap in
  ipu_csi_init_interface().
- add support for interweaved scan with field order swap.
  Suggested by Philipp Zabel.
- in v2, inteweave scan was determined using field types of
  CSI (and PRPENCVF) at the sink and source pads. In v3, this
  has been moved one hop downstream: interweave is now determined
  using field type at source pad, and field type selected at
  capture interface. Suggested by Philipp.
- make sure to double CSI crop target height when input field
  type in alternate.
- more updates to media driver doc to reflect above.

v2:
- update media driver doc.
- enable idmac interweave only if input field is sequential/alternate,
  and output field is 'interlaced*'.
- move field try logic out of *try_fmt and into separate function.
- fix bug with resetting crop/compose rectangles.
- add a patch that fixes a field order bug in VDIC indirect mode.
- remove alternate field type from V4L2_FIELD_IS_SEQUENTIAL() macro
  Suggested-by: Nicolas Dufresne <nicolas@ndufresne.ca>.
- add macro V4L2_FIELD_IS_INTERLACED().


Steve Longerbeam (12):
  media: videodev2.h: Add more field helper macros
  gpu: ipu-csi: Swap fields according to input/output field types
  gpu: ipu-v3: Add planar support to interlaced scan
  media: imx: Fix field negotiation
  media: imx-csi: Input connections to CSI should be optional
  media: imx-csi: Double crop height for alternate fields at sink
  media: imx: interweave and odd-chroma-row skip are incompatible
  media: imx-csi: Allow skipping odd chroma rows for YVU420
  media: imx: vdic: rely on VDIC for correct field order
  media: imx-csi: Move crop/compose reset after filling default mbus
    fields
  media: imx: Allow interweave with top/bottom lines swapped
  media: imx.rst: Update doc to reflect fixes to interlaced capture

 Documentation/media/v4l-drivers/imx.rst       | 103 +++++++----
 drivers/gpu/ipu-v3/ipu-cpmem.c                |  26 ++-
 drivers/gpu/ipu-v3/ipu-csi.c                  | 119 +++++++++----
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  46 +++--
 drivers/staging/media/imx/imx-media-capture.c |  14 ++
 drivers/staging/media/imx/imx-media-csi.c     | 168 +++++++++++++-----
 drivers/staging/media/imx/imx-media-vdic.c    |  12 +-
 include/uapi/linux/videodev2.h                |   7 +
 include/video/imx-ipu-v3.h                    |   6 +-
 9 files changed, 354 insertions(+), 147 deletions(-)

-- 
2.17.1
