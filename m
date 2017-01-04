Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:57314 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdADQ3i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 11:29:38 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: ville.syrjala@linux.intel.com, randy.li@rock-chips.com,
        linux-kernel@vger.kernel.org, daniel.vetter@intel.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v2 0/2] Add pixel formats for 10/16 bits YUV video
Date: Thu,  5 Jan 2017 00:29:09 +0800
Message-Id: <1483547351-5792-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those pixel formats mainly comes from Gstreamer and ffmpeg. Currently,
the VOP(video output mixer) found on RK3288 and future support
those 10 bits pixel formats are input. Also the decoder on RK3288
could use them as output.

The fourcc is not enough to store the endian information for those
pixel formats in v4l2, as it doesn't have a flag like drm does.

I have not met the usage of those 16 bits per-channel format,
it is a very large color range, even the DSLR only use 12 bits.

Randy Li (2):
  drm_fourcc: Add new P010, P016 video format
  [media] v4l: Add 10/16-bits per channel YUV pixel formats

 Documentation/media/uapi/v4l/pixfmt-p010.rst  |  86 ++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p010m.rst |  94 ++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016.rst  | 126 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016m.rst | 136 ++++++++++++++++++++++++++
 drivers/gpu/drm/drm_fourcc.c                  |   3 +
 include/uapi/drm/drm_fourcc.h                 |   2 +
 include/uapi/linux/videodev2.h                |   4 +
 7 files changed, 451 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010m.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016m.rst

-- 
2.7.4

