Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51079 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbeK2ADG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 19:03:06 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 0/2] Clarify H.264 loop filter offset controls and fix them for coda
Date: Wed, 28 Nov 2018 14:01:20 +0100
Message-Id: <20181128130122.4916-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the coda driver handles the H.264 loop filter alpha/beta offset controls
incorrectly. When trying to fix them, I noticed that the documentation
is not clear about what these values actually are.

>From the value range of -6 to +6 used in the existing drivers (s5p-mfc,
venus), it looks like they currently correspond directly to the values
stored into the slice headers: slice_alpha_c0_offset_div2 and
slice_beta_offset_div2. These are only half of the actual alpha/beta
filter offsets.

The ITU-T Rec. H.264 (02/2016) states:

  slice_alpha_c0_offset_div2 specifies the offset used in accessing the
  α [...] deblocking filter tables for filtering operations controlled
  by the macroblocks within the slice. From this value, the offset that
  shall be applied when addressing these tables shall be computed as

      FilterOffsetA = slice_alpha_c0_offset_div2 << 1             (7-32)

  The value of slice_alpha_c0_offset_div2 shall be in the range of −6 to
  +6, inclusive. When slice_alpha_c0_offset_div2 is not present in the
  slice header, the value of slice_alpha_c0_offset_div2 shall be inferred
  to be equal to 0.

And the same for slice_beta_offset_div2 / FilterOffsetB.

Do the s5p-mfc and venus drivers use the controls
V4L2_MPEG_VIDEO_H264_LOOP_FILTER_ALPHA and _BETA directly as slice
header fields, and thus their values are to be interpreted as half of
FilterOffsetA/B defined in the H.264 spec, respectively?

regards
Philipp

Philipp Zabel (2):
  media: v4l2: clarify H.264 loop filter offset controls
  media: coda: fix H.264 deblocking filter controls

 .../media/uapi/v4l/extended-controls.rst      |  6 ++++++
 drivers/media/platform/coda/coda-bit.c        | 19 +++++++++----------
 drivers/media/platform/coda/coda-common.c     | 15 +++++++--------
 drivers/media/platform/coda/coda.h            |  6 +++---
 drivers/media/platform/coda/coda_regs.h       |  2 +-
 5 files changed, 26 insertions(+), 22 deletions(-)

-- 
2.19.1
