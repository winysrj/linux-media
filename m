Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48655 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730831AbeGSM4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 08:56:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tom aan de Wiel <tom.aandewiel@gmail.com>
Subject: [PATCH 0/5] vicodec: the Virtual Codec driver
Date: Thu, 19 Jul 2018 14:13:48 +0200
Message-Id: <20180719121353.20021-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is the first non-RFC version of the new vicodec driver, a driver that
emulates a HW codec.

The software codec was developed two years ago by Tom aan de Wiel
as a university project for this specific purpose but it took
until now to turn it into a proper driver. Many thanks to Tom for
creating this codec based on the patent-free Fast Walsh Hadamard
Transform.

The goal is to make this a reference driver for stateful codecs,
and in the near future also for stateless codecs.

This driver is missing support for mid-stream resolution changes.

Also it assumes that the width/height is correctly set up with S_FMT
on both capture and output side.

There are probably some changes that need to be made once the
Codec API Specification that Tomasz Figa is working on is finalized,
but that can be added later.

The vicodec driver supports YUV420 (default), YVU420, NV12 and NV21
raw formats.

To encode:

v4l2-ctl --stream-mmap --stream-out-mmap --stream-to-hdr out.comp --stream-from in.yuv

To encode from an nv12 raw file:

v4l2-ctl -v pixelformat=NV12 --stream-mmap --stream-out-mmap --stream-to-hdr out.comp --stream-from in.nv12

You can leave out the --stream-from option, in that case the built-in test
pattern generator is used to generate the raw frames.

To decode:

v4l2-ctl -d1 --stream-mmap --stream-out-mmap --stream-from-hdr out.comp --stream-to out.yuv

To decode to an nv12 raw file:

v4l2-ctl -x pixelformat=NV12 -d1 --stream-mmap --stream-out-mmap --stream-from-hdr out.comp --stream-to out.yuv

Note: this requires the latest v4l-utils code.

The --stream-from/to-hdr options expect a header in front of each compressed
frame that contains the size of that frame. Normally sizeimage is used, but
that doesn't work for compressed frames, so I made these new options.

If you have some 720p mkv/mp4/whatever file that you want to test vicodec
with, then you can extract a raw YUV420 file from it as follows:

ffmpeg -i test.mkv -c:v rawvideo -frames 150 -pix_fmt yuv420p in.yuv

That command extracts the first 150 frames from the mkv.

To play back the result from the decoder use:

mplayer -demuxer rawvideo -rawvideo format=i420:w=1280:h=720:fps=25 out.yuv

Feedback is welcome!

Regards,

	Hans

Hans Verkuil (5):
  media.h: add encoder/decoder functions for codecs
  videodev.h: add PIX_FMT_FWHT for use with vicodec
  v4l2-mem2mem: add v4l2_m2m_last_buf()
  vicodec: add the FWHT software codec
  vicodec: add the virtual codec driver

 .../media/uapi/mediactl/media-types.rst       |   11 +
 .../media/uapi/v4l/pixfmt-compressed.rst      |    7 +
 MAINTAINERS                                   |    8 +
 drivers/media/platform/Kconfig                |    3 +
 drivers/media/platform/Makefile               |    1 +
 drivers/media/platform/vicodec/Kconfig        |   13 +
 drivers/media/platform/vicodec/Makefile       |    4 +
 .../media/platform/vicodec/vicodec-codec.c    |  791 ++++++++++
 .../media/platform/vicodec/vicodec-codec.h    |   95 ++
 drivers/media/platform/vicodec/vicodec-core.c | 1321 +++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c          |    1 +
 drivers/media/v4l2-core/v4l2-mem2mem.c        |   18 +
 include/media/v4l2-mem2mem.h                  |   29 +
 include/uapi/linux/media.h                    |    2 +
 include/uapi/linux/videodev2.h                |    1 +
 15 files changed, 2305 insertions(+)
 create mode 100644 drivers/media/platform/vicodec/Kconfig
 create mode 100644 drivers/media/platform/vicodec/Makefile
 create mode 100644 drivers/media/platform/vicodec/vicodec-codec.c
 create mode 100644 drivers/media/platform/vicodec/vicodec-codec.h
 create mode 100644 drivers/media/platform/vicodec/vicodec-core.c

-- 
2.17.0
