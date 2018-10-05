Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53141 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728170AbeJEOqr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org
Subject: [RFC PATCH 00/11] Convert last remaining g/s_crop/cropcap drivers
Date: Fri,  5 Oct 2018 09:49:00 +0200
Message-Id: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts the last remaining drivers that use g/s_crop and
cropcap to g/s_selection.

The first two patches do some minor code cleanup.

The third patch adds a new video_device flag to indicate that the driver
inverts the normal usage of g/s_crop/cropcap. This applies to the old
Samsung drivers that predate the Selection API and that abused the existing
crop API.

The next three patches do some code cleanup and prepare drivers for the
removal of g/s_crop and ensure that cropcap only returns the pixelaspect.

The next three patches convert the remaining Samsung drivers and set the
QUIRK flag for all three.

The final two patches remove vidioc_g/s_crop and rename vidioc_cropcap
to vidioc_g_pixelaspect.

I would really appreciate it if someone from Samsung can test these
three drivers or at the very least review the code.

Niklas, this series supersedes your 'v4l2-ioctl: fix CROPCAP type handling'
patch. Sorry about that :-)

Regards,

	Hans

Hans Verkuil (11):
  v4l2-ioctl: don't use CROP/COMPOSE_ACTIVE
  v4l2-common.h: put backwards compat defines under #ifndef __KERNEL__
  v4l2-ioctl: add QUIRK_INVERTED_CROP
  davinci/vpbe: drop unused g_cropcap
  cropcap/g_selection split
  exynos-gsc: replace v4l2_crop by v4l2_selection
  s5p_mfc_dec.c: convert g_crop to g_selection
  exynos4-is: convert g/s_crop to g/s_selection
  s5p-g2d: convert g/s_crop to g/s_selection
  v4l2-ioctl: remove unused vidioc_g/s_crop
  vidioc_cropcap -> vidioc_g_pixelaspect

 drivers/media/pci/bt8xx/bttv-driver.c         |  12 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c        |  48 +++++--
 drivers/media/pci/cx18/cx18-ioctl.c           |  13 +-
 drivers/media/pci/cx23885/cx23885-video.c     |  40 ++++--
 drivers/media/pci/ivtv/ivtv-ioctl.c           |  17 +--
 drivers/media/pci/saa7134/saa7134-video.c     |  21 ++-
 drivers/media/platform/am437x/am437x-vpfe.c   |  31 ++---
 drivers/media/platform/davinci/vpbe.c         |  23 ----
 drivers/media/platform/davinci/vpbe_display.c |  10 +-
 drivers/media/platform/davinci/vpfe_capture.c |  12 +-
 drivers/media/platform/exynos-gsc/gsc-core.c  |  57 +++-----
 drivers/media/platform/exynos-gsc/gsc-core.h  |   3 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c   |  23 ++--
 drivers/media/platform/exynos4-is/fimc-core.h |   6 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c  | 130 ++++++++++--------
 drivers/media/platform/rcar-vin/rcar-v4l2.c   |  10 +-
 drivers/media/platform/s5p-g2d/g2d.c          | 102 +++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |   1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |  49 ++++---
 drivers/media/platform/vivid/vivid-core.c     |   9 +-
 drivers/media/platform/vivid/vivid-vid-cap.c  |  18 ++-
 drivers/media/platform/vivid/vivid-vid-cap.h  |   2 +-
 drivers/media/platform/vivid/vivid-vid-out.c  |  18 ++-
 drivers/media/platform/vivid/vivid-vid-out.h  |   2 +-
 drivers/media/usb/au0828/au0828-video.c       |  38 +++--
 drivers/media/usb/cpia2/cpia2_v4l.c           |  31 +++--
 drivers/media/usb/cx231xx/cx231xx-417.c       |  41 ++++--
 drivers/media/usb/cx231xx/cx231xx-video.c     |  41 ++++--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c      |  13 +-
 drivers/media/v4l2-core/v4l2-dev.c            |   8 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  44 ++++--
 include/media/davinci/vpbe.h                  |   4 -
 include/media/v4l2-dev.h                      |  13 +-
 include/media/v4l2-ioctl.h                    |  16 +--
 include/uapi/linux/v4l2-common.h              |  28 ++--
 35 files changed, 537 insertions(+), 397 deletions(-)

-- 
2.18.0
