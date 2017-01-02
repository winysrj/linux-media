Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:47980 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdABIuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2017 03:50:21 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: daniel.vetter@intel.com, jani.nikula@linux.intel.com,
        seanpaul@chromium.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, randy.li@rock-chips.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH 0/2] Add pixel format for 10 bits YUV video
Date: Mon,  2 Jan 2017 16:50:02 +0800
Message-Id: <1483347004-32593-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those pixel formats comes from Gstreamer and ffmpeg. Currently,
the VOP(video output mixer) found on RK3288 and future support
those pixel formats are input. Also the decoder on RK3288
could use them as output.

Randy Li (2):
  drm_fourcc: Add new P010 video format
  [media] v4l: Add 10-bits per channel YUV pixel formats

 include/uapi/drm/drm_fourcc.h  | 1 +
 include/uapi/linux/videodev2.h | 2 ++
 2 files changed, 3 insertions(+)

-- 
2.7.4

