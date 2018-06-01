Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:37791 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbeFAAbB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 20:31:01 -0400
Received: by mail-pf0-f174.google.com with SMTP id e9-v6so11596920pfi.4
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 17:31:01 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 00/10] imx-media: Fixes for interlaced capture
Date: Thu, 31 May 2018 17:30:39 -0700
Message-Id: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A set of patches that fixes some bugs with capturing from an
interlaced source, and incompatibilites between IDMAC interlace
interweaving and 4:2:0 data write reduction.

History:
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
  
Steve Longerbeam (10):
  media: imx-csi: Pass sink pad field to ipu_csi_init_interface
  gpu: ipu-csi: Check for field type alternate
  media: videodev2.h: Add macros V4L2_FIELD_IS_{INTERLACED|SEQUENTIAL}
  media: imx: interweave only for sequential input/interlaced output
    fields
  media: imx: interweave and odd-chroma-row skip are incompatible
  media: imx: Fix field setting logic in try_fmt
  media: imx-csi: Allow skipping odd chroma rows for YVU420
  media: imx: vdic: rely on VDIC for correct field order
  media: imx-csi: Move crop/compose reset after filling default mbus
    fields
  media: imx.rst: Update doc to reflect fixes to interlaced capture

 Documentation/media/v4l-drivers/imx.rst     |  51 +++++++++----
 drivers/gpu/ipu-v3/ipu-csi.c                |   3 +-
 drivers/staging/media/imx/imx-ic-prpencvf.c |  51 +++++++++++--
 drivers/staging/media/imx/imx-media-csi.c   | 114 ++++++++++++++++++----------
 drivers/staging/media/imx/imx-media-vdic.c  |  12 +--
 include/uapi/linux/videodev2.h              |   7 ++
 6 files changed, 165 insertions(+), 73 deletions(-)

-- 
2.7.4
