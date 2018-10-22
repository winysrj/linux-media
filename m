Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36862 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbeJVXIE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 19:08:04 -0400
Received: by mail-pl1-f195.google.com with SMTP id y11-v6so19185703plt.3
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 07:49:13 -0700 (PDT)
From: Tomasz Figa <tfiga@chromium.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?q?Pawe=C5=82=20O=C5=9Bciak?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH v2 0/2] Document memory-to-memory video codec interfaces
Date: Mon, 22 Oct 2018 23:48:58 +0900
Message-Id: <20181022144901.113852-1-tfiga@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's been a while, but here is the v2 of the stateful mem2mem codec
interfaces documentation. Sorry for taking so long time to respin.

This series attempts to add the documentation of what was discussed
during Media Workshops at LinuxCon Europe 2012 in Barcelona and then
later Embedded Linux Conference Europe 2014 in Düsseldorf and then
eventually written down by Pawel Osciak and tweaked a bit by Chrome OS
video team (but mostly in a cosmetic way or making the document more
precise), during the several years of Chrome OS using the APIs in
production.

Note that most, if not all, of the API is already implemented in
existing mainline drivers, such as s5p-mfc or mtk-vcodec. Intention of
this series is just to formalize what we already have.

Thanks everyone for the huge amount of useful comments for the RFC and
v1. Much of the credits should go to Pawel Osciak too, for writing most
of the original text of the initial RFC.

Changes since v1:
(https://lore.kernel.org/patchwork/project/lkml/list/?series=360520)
Decoder:
 - Removed a note about querying all combinations of OUTPUT and CAPTURE
   frame sizes, since it would conflict with scaling/composiion support
   to be added later.
 - Removed the source change event after setting non-zero width and
   height on OUTPUT queue, since the change happens as a direct result
   of a client action.
 - Moved all the setup steps for CAPTURE queue out of Initialization
   and Dynamic resolution change into a common sequence called Capture
   setup, since they were mostly duplicate of each other.
 - Described steps to allocate buffers for higher resolution than the
   stream to prepare for future resolution changes.
 - Described a way to skip the initial header parsing and speculatively
   configure the CAPTURE queue (for gstreamer/ffmpeg compatibility).
 - Reordered CAPTURE setup steps so that all the driver queries are done
   first and only then a reconfiguration may be attempted or skipped.
 - Described VIDIOC_CREATE_BUFS as another way of allocating buffers.
 - Made the decoder signal the source change event as soon as the change
   is detected, to reduce pipeline stalls in case of buffers already
   good to continue decoding.
 - Stressed out the fact that a source change may happen even without a
   change in the coded resolution.
 - Described querying pixel aspect ratio using VIDIOC_CROPCAP.
 - Extended documentation of VIDIOC_DECODER_CMD and VIDIOC_G/S/TRY_FMT
   to more precisely describe the behavior of mem2mem decoders.
 - Clarified that 0 width and height are allowed for OUTPUT side of
   mem2mem decoders in the documentation of the v4l2_pix_fmt struct.

Encoder:
 - Removed width and height from CAPTURE (coded) format, since the coded
   resolution of the stream is an internal detail of the encoded stream.
 - Made the VIDIOC_S_FMT on OUTPUT mandatory, since the default format
   normally does not make sense (even if technically valid).
 - Changed the V4L2_SEL_TGT_CROP_BOUNDS and V4L2_SEL_TGT_CROP_DEFAULT
   selection targets to be equal to the full source frame to simplify
   internal handling in drivers for simple hardware.
 - Changed the V4L2_SEL_TGT_COMPOSE_DEFAULT selection target to be equal
   to |crop width|x|crop height|@(0,0) to simplify internal handling in
   drivers for simple hardware.
 - Removed V4L2_SEL_TGT_COMPOSE_PADDED, since the encoder does not write
   to the raw buffers.
 - Extended documentation of VIDIOC_ENCODER_CMD to more precisely
   describe the behavior of mem2mem encoders.
 - Clarified that 0 width and height are allowed for CAPTURE side of
   mem2mem encoders in the documentation of the v4l2_pix_fmt struct.

General:
 - Clarified that the Drain sequence valid only if both queues are
   streaming and stopping any of the queues would abort it, since there
   is nothing to drain, if OUTPUT is stopped and there is no way to
   signal the completion if CAPTURE is stopped.
 - Clarified that VIDIOC_STREAMON on any of the queues would resume the
   codec from stopped state, to be consistent with the documentation of
   VIDIOC_ENCODER/DECODER_CMD.
 - Documented the relation between timestamps of OUTPUT and CAPTURE
   buffers and how special cases of non-1:1 relation are handled.
 - Added missing sizeimage to bitstream format operations and removed
   the mistaken mentions from descriptions of respective REQBUFS calls.
 - Removed the Pause sections, since there is no notion of pause for
   mem2mem devices.
 - Added state machine diagrams.
 - Merged both glossaries into one in the decoder document and a
   reference to it in the encoder document.
 - Added missing terms to the glossary.
 - Added "Stateful" to the interface names.
 - Reworded the text to be more userspace-centric.
 - A number of other readability improvements suggested in review comments.

For changes since RFC see the v1:
https://lore.kernel.org/patchwork/project/lkml/list/?series=360520

Tomasz Figa (2):
  media: docs-rst: Document memory-to-memory video decoder interface
  media: docs-rst: Document memory-to-memory video encoder interface

 Documentation/media/uapi/v4l/dev-decoder.rst  | 1082 +++++++++++++++++
 Documentation/media/uapi/v4l/dev-encoder.rst  |  579 +++++++++
 Documentation/media/uapi/v4l/devices.rst      |    2 +
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |   10 +
 Documentation/media/uapi/v4l/v4l2.rst         |   12 +-
 .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
 .../media/uapi/v4l/vidioc-encoder-cmd.rst     |   38 +-
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
 8 files changed, 1747 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
 create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst

-- 
2.19.1.568.g152ad8e336-goog
