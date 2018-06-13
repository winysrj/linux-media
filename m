Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52319 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935348AbeFMOHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 10:07:19 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: hans.verkuil@cisco.com, acourbot@chromium.org,
        sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: tfiga@chromium.org, posciak@chromium.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, jenskuske@gmail.com,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 0/9] media: cedrus: Add H264 decoding support
Date: Wed, 13 Jun 2018 16:07:05 +0200
Message-Id: <20180613140714.1686-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is a preliminary version of the H264 decoding support in the
cedrus driver.

As you might already know, the cedrus driver relies on the Request
API, and is a reverse engineered driver for the video decoding engine
found on the Allwinner SoCs.

This work has been possible thanks to the work done by the people
behind libvdpau-sunxi found here:
https://github.com/linux-sunxi/libvdpau-sunxi/

This driver is based on the last version of the cedrus driver sent by
Paul, based on Request API v13 sent by Hans:
https://lkml.org/lkml/2018/5/7/316

This driver has been tested only with baseline profile videos, and is
missing a few key features to decode videos with higher profiles.
This has been tested using our cedrus-frame-test tool, which should be
a quite generic v4l2-to-drm decoder using the request API to
demonstrate the video decoding:
https://github.com/free-electrons/cedrus-frame-test/, branch h264

However, sending this preliminary version, I'd really like to start a
discussion and get some feedback on the user-space API for the H264
controls exposed through the request API.

I've been using the controls currently integrated into ChromeOS that
have a working version of this particular setup. However, these
controls have a number of shortcomings and inconsistencies with other
decoding API. I've worked with libva so far, but I've noticed already
that:
  - The kernel UAPI expects to have the nal_ref_idc variable, while
    libva only exposes whether that frame is a reference frame or
    not. I've looked at the rockchip driver in the ChromeOS tree, and
    our own driver, and they both need only the information about
    whether the frame is a reference one or not, so maybe we should
    change this?
  - The H264 bitstream exposes the picture default reference list (for
    both list 0 and list 1), the slice reference list and an override
    flag. The libva will only pass the reference list to be used (so
    either the picture default's or the slice's) depending on the
    override flag. The kernel UAPI wants the picture default reference
    list and the slice reference list, but doesn't expose the override
    flag, which prevents us from configuring properly the
    hardware. Our video decoding engine needs the three information,
    but we can easily adapt to having only one. However, having two
    doesn't really work for us.

It's pretty much the only one I've noticed so far, but we should
probably fix them already. And there's probably other, feel free to
step in.

Maxime Ripard (8):
  media: cedrus: Add wrappers around container_of for our buffers
  media: cedrus: Add a macro to check for the validity of a control
  media: cedrus: make engine type more generic
  media: cedrus: Remove MPEG1 support
  media: cedrus: Add ops structure
  media: cedrus: Move IRQ maintainance to cedrus_dec_ops
  media: cedrus: Add start and stop decoder operations
  media: cedrus: Add H264 decoding support

Pawel Osciak (1):
  CHROMIUM: v4l: Add H264 low-level decoder API compound controls.

 drivers/media/platform/sunxi/cedrus/Makefile  |   2 +-
 .../platform/sunxi/cedrus/sunxi_cedrus.c      |  23 +
 .../sunxi/cedrus/sunxi_cedrus_common.h        |  81 +++-
 .../platform/sunxi/cedrus/sunxi_cedrus_dec.c  |  38 +-
 .../platform/sunxi/cedrus/sunxi_cedrus_h264.c | 443 ++++++++++++++++++
 .../platform/sunxi/cedrus/sunxi_cedrus_hw.c   |  35 +-
 .../platform/sunxi/cedrus/sunxi_cedrus_hw.h   |   6 +-
 .../sunxi/cedrus/sunxi_cedrus_mpeg2.c         |  52 +-
 .../sunxi/cedrus/sunxi_cedrus_mpeg2.h         |  33 --
 .../platform/sunxi/cedrus/sunxi_cedrus_regs.h |  22 +-
 .../sunxi/cedrus/sunxi_cedrus_video.c         |  37 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          |  42 ++
 include/media/v4l2-ctrls.h                    |  10 +
 include/uapi/linux/v4l2-controls.h            | 164 +++++++
 include/uapi/linux/videodev2.h                |  11 +
 15 files changed, 912 insertions(+), 87 deletions(-)
 create mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_h264.c
 delete mode 100644 drivers/media/platform/sunxi/cedrus/sunxi_cedrus_mpeg2.h

-- 
2.17.0
