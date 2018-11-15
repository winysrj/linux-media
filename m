Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44568 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387548AbeKPBFC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 20:05:02 -0500
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
Subject: [PATCH v2 0/2] media: cedrus: Add H264 decoding support
Date: Thu, 15 Nov 2018 15:56:48 +0100
Message-Id: <20181115145650.9827-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

Here is a new version of the H264 decoding support in the cedrus
driver.

As you might already know, the cedrus driver relies on the Request
API, and is a reverse engineered driver for the video decoding engine
found on the Allwinner SoCs.

This work has been possible thanks to the work done by the people
behind libvdpau-sunxi found here:
https://github.com/linux-sunxi/libvdpau-sunxi/

It's based on v4.20-rc1, plus the tag patches sent this week by Hans
Verkuil.

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

I've tested the various ABI using this gdb script:
http://code.bulix.org/jl4se4-505620?raw

And this test script:
http://code.bulix.org/8zle4s-505623?raw

The application compiled is quite trivial:
http://code.bulix.org/e34zp8-505624?raw

The output is:
arm:	builds/arm-test-v4l2-h264-structures
	SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318
x86:	builds/x86-test-v4l2-h264-structures
	SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318
x64:	builds/x64-test-v4l2-h264-structures
	SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318
arm64:	builds/arm64-test-v4l2-h264-structures
	SHA1: 88cbf7485ba81831fc3b93772b215599b3b38318

Let me know if there's any flaw using that test setup, or if you have
any comments on the patches.

Maxime

Changes from v1:
  - Rebased on 4.20
  - Did the documentation for the userspace API
  - Used the tags instead of buffer IDs
  - Added a comment to explain why we still needed the swdec trigger
  - Reworked the MV col buffer in order to have one slot per frame
  - Removed the unused neighbor info buffer
  - Made sure to have the same structure offset and alignments across
    32 bits and 64 bits architecture

Maxime Ripard (1):
  media: cedrus: Add H264 decoding support

Pawel Osciak (1):
  media: uapi: Add H264 low-level decoder API compound controls.

 Documentation/media/uapi/v4l/biblio.rst       |   9 +
 .../media/uapi/v4l/extended-controls.rst      | 364 ++++++++++++++
 .../media/uapi/v4l/pixfmt-compressed.rst      |  20 +
 .../media/uapi/v4l/vidioc-queryctrl.rst       |  30 ++
 .../media/videodev2.h.rst.exceptions          |   5 +
 drivers/media/v4l2-core/v4l2-ctrls.c          |  42 ++
 drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
 drivers/staging/media/sunxi/cedrus/Makefile   |   3 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c   |  25 +
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  35 +-
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  11 +
 .../staging/media/sunxi/cedrus/cedrus_h264.c  | 470 ++++++++++++++++++
 .../staging/media/sunxi/cedrus/cedrus_hw.c    |   4 +
 .../staging/media/sunxi/cedrus/cedrus_regs.h  |  63 +++
 .../staging/media/sunxi/cedrus/cedrus_video.c |   9 +
 include/media/v4l2-ctrls.h                    |  10 +
 include/uapi/linux/v4l2-controls.h            | 166 +++++++
 include/uapi/linux/videodev2.h                |  11 +
 18 files changed, 1276 insertions(+), 2 deletions(-)
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_h264.c

-- 
2.19.1
