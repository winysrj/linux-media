Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:39126 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdCEKAo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 05:00:44 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: clinton.a.taylor@intel.com, daniel@fooishbar.org,
        ville.syrjala@linux.intel.com, linux-media@vger.kernel.org,
        mchehab@kernel.org, linux-kernel@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v6 0/3] Add pixel format for 10 bits YUV video
Date: Sun,  5 Mar 2017 18:00:30 +0800
Message-Id: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks to Clint's work, this version just correct some wrong info
in the comment.

I also offer a driver sample here, but it have been verified with
the 10 bits properly. I lacks of the userspace tool. And I am
not sure whether it is a properly way to support the pixel format
used in rockchip, although it is not common used pixel format,
but it could save lots of memory, it may be welcome by the
other vendor, also I think the 3GR serial from Intel would
use the same pixel format as the video IP comes from rockchip.

Randy Li (3):
  drm_fourcc: Add new P010, P016 video format
  v4l: Add 10/16-bits per channel YUV pixel formats
  drm/rockchip: Support 10 bits yuv format in vop

 Documentation/media/uapi/v4l/pixfmt-p010.rst  | 126 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p010m.rst | 135 ++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016.rst  | 125 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016m.rst | 134 +++++++++++++++++++++++++
 Documentation/media/uapi/v4l/yuv-formats.rst  |   4 +
 drivers/gpu/drm/drm_fourcc.c                  |   3 +
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c    |   1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c   |  34 ++++++-
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h   |   1 +
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c   |   2 +
 include/uapi/drm/drm_fourcc.h                 |  32 ++++++
 include/uapi/linux/videodev2.h                |   5 +
 12 files changed, 599 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010m.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016m.rst

-- 
2.7.4
