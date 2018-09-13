Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:58028 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726886AbeIMQ4n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:56:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: [PATCH 0/5] Rename AdobeRGB to opRGB
Date: Thu, 13 Sep 2018 13:47:26 +0200
Message-Id: <20180913114731.16500-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series replaces all AdobeRGB references by opRGB references.

In November last year all references to the AdobeRGB colorspace were removed
from the CTA-861 standards (all versions) and replaced with the corresponding
international opRGB standard (IEC 61966-2-5) due to trademark issues.

This patch series makes the same change in the kernel because:

1) it makes sense to keep in sync with the CTA-861 standard,
2) using an international standard is always preferable to a company standard,
3) avoid possible future trademark complaints.

The first two patches can go through the media subsystem. The third patch
changes hdmi.c/h, but since the renamed defines from hdmi.h are only used
in the media subsystem I would prefer to merge this via the media subsystem
as well. So if I can get an Ack, then that would be great.

The fourth patch I can push to drm-misc when it's reviewed, and the final
patch can go through the AMD GPU maintainers.

There are only two references to the old name left since they are part of
the V4L2 public API, so I can't remove them.

Regards,

	Hans


Hans Verkuil (5):
  media: replace ADOBERGB by OPRGB
  media colorspaces*.rst: rename AdobeRGB to opRGB
  hdmi.h: rename ADOBE_RGB to OPRGB and ADOBE_YCC to OPYCC
  drm/bridge/synopsys/dw-hdmi.h: rename ADOBE to OP
  drm/amd: rename ADOBE to OP

 Documentation/media/uapi/v4l/biblio.rst       |  10 -
 .../media/uapi/v4l/colorspaces-defs.rst       |   8 +-
 .../media/uapi/v4l/colorspaces-details.rst    |  13 +-
 .../media/videodev2.h.rst.exceptions          |   2 +
 .../drm/amd/display/dc/core/dc_hw_sequencer.c |   4 +-
 .../gpu/drm/amd/display/dc/core/dc_resource.c |   4 +-
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h  |   2 +-
 .../amd/display/dc/dce/dce_stream_encoder.c   |   2 +-
 .../amd/display/dc/dcn10/dcn10_hw_sequencer.c |   2 +-
 .../display/dc/dcn10/dcn10_stream_encoder.c   |   2 +-
 .../gpu/drm/amd/display/dc/inc/hw/transform.h |   4 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.h     |   4 +-
 .../media/common/v4l2-tpg/v4l2-tpg-colors.c   | 262 +++++++++---------
 drivers/media/i2c/adv7511.c                   |   6 +-
 drivers/media/i2c/adv7604.c                   |   2 +-
 drivers/media/i2c/tc358743.c                  |   4 +-
 drivers/media/platform/vivid/vivid-core.h     |   2 +-
 drivers/media/platform/vivid/vivid-ctrls.c    |   6 +-
 drivers/media/platform/vivid/vivid-vid-out.c  |   2 +-
 drivers/media/v4l2-core/v4l2-dv-timings.c     |  12 +-
 drivers/video/hdmi.c                          |   8 +-
 include/linux/hdmi.h                          |   4 +-
 include/uapi/linux/videodev2.h                |  16 +-
 23 files changed, 190 insertions(+), 191 deletions(-)

-- 
2.18.0
