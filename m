Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39082 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeIHBAF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 21:00:05 -0400
Message-ID: <19062a24c3aa2cb9e0410cf2884b4589e44c263b.camel@collabora.com>
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Fri, 07 Sep 2018 17:17:03 -0300
In-Reply-To: <20180724140621.59624-3-tfiga@chromium.org>
References: <20180724140621.59624-1-tfiga@chromium.org>
         <20180724140621.59624-3-tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
> Due to complexity of the video encoding process, the V4L2 drivers of
> stateful encoder hardware require specific sequences of V4L2 API calls
> to be followed. These include capability enumeration, initialization,
> encoding, encode parameters change, drain and reset.
> 
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or coda.
> 
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the encoder part of
> the Codec API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-encoder.rst | 550 +++++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst     |   1 +
>  Documentation/media/uapi/v4l/v4l2.rst        |   2 +
>  3 files changed, 553 insertions(+)
>  create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst
> 
> diff --git a/Documentation/media/uapi/v4l/dev-encoder.rst b/Documentation/media/uapi/v4l/dev-encoder.rst
> new file mode 100644
> index 000000000000..28be1698e99c
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-encoder.rst
> @@ -0,0 +1,550 @@
> +.. -*- coding: utf-8; mode: rst -*-
> +
> +.. _encoder:
> +
> +****************************************
> +Memory-to-memory Video Encoder Interface
> +****************************************
> +
> +Input data to a video encoder are raw video frames in display order
> +to be encoded into the output bitstream. Output data are complete chunks of
> +valid bitstream, including all metadata, headers, etc. The resulting stream
> +must not need any further post-processing by the client.
> +
> +Performing software stream processing, header generation etc. in the driver
> +in order to support this interface is strongly discouraged. In case such
> +operations are needed, use of Stateless Video Encoder Interface (in
> +development) is strongly advised.
> +
> +Conventions and notation used in this document
> +==============================================
> +
> +1. The general V4L2 API rules apply if not specified in this document
> +   otherwise.
> +
> +2. The meaning of words “must”, “may”, “should”, etc. is as per RFC
> +   2119.
> +
> +3. All steps not marked “optional” are required.
> +
> +4. :c:func:`VIDIOC_G_EXT_CTRLS`, :c:func:`VIDIOC_S_EXT_CTRLS` may be used
> +   interchangeably with :c:func:`VIDIOC_G_CTRL`, :c:func:`VIDIOC_S_CTRL`,
> +   unless specified otherwise.
> +
> +5. Single-plane API (see spec) and applicable structures may be used
> +   interchangeably with Multi-plane API, unless specified otherwise,
> +   depending on driver capabilities and following the general V4L2
> +   guidelines.
> +
> +6. i = [a..b]: sequence of integers from a to b, inclusive, i.e. i =
> +   [0..2]: i = 0, 1, 2.
> +
> +7. For ``OUTPUT`` buffer A, A’ represents a buffer on the ``CAPTURE`` queue
> +   containing data (encoded frame/stream) that resulted from processing
> +   buffer A.
> +
> +Glossary
> +========
> +
> +CAPTURE
> +   the destination buffer queue; the queue of buffers containing encoded
> +   bitstream; ``V4L2_BUF_TYPE_VIDEO_CAPTURE```` or
> +   ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``; data are captured from the
> +   hardware into ``CAPTURE`` buffers
> +
> +client
> +   application client communicating with the driver implementing this API
> +
> +coded format
> +   encoded/compressed video bitstream format (e.g. H.264, VP8, etc.);
> +   see also: raw format
> +
> +coded height
> +   height for given coded resolution
> +
> +coded resolution
> +   stream resolution in pixels aligned to codec and hardware requirements;
> +   typically visible resolution rounded up to full macroblocks; see also:
> +   visible resolution
> +
> +coded width
> +   width for given coded resolution
> +
> +decode order
> +   the order in which frames are decoded; may differ from display order if
> +   coded format includes a feature of frame reordering; ``CAPTURE`` buffers
> +   must be returned by the driver in decode order
> +
> +display order
> +   the order in which frames must be displayed; ``OUTPUT`` buffers must be
> +   queued by the client in display order
> +
> +IDR
> +   a type of a keyframe in H.264-encoded stream, which clears the list of
> +   earlier reference frames (DPBs)
> +
> +keyframe
> +   an encoded frame that does not reference frames decoded earlier, i.e.
> +   can be decoded fully on its own.
> +
> +macroblock
> +   a processing unit in image and video compression formats based on linear
> +   block transforms (e.g. H264, VP8, VP9); codec-specific, but for most of
> +   popular codecs the size is 16x16 samples (pixels)
> +
> +OUTPUT
> +   the source buffer queue; the queue of buffers containing raw frames;
> +   ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or
> +   ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``; the hardware is fed with data
> +   from ``OUTPUT`` buffers
> +
> +PPS
> +   Picture Parameter Set; a type of metadata entity in H.264 bitstream
> +
> +raw format
> +   uncompressed format containing raw pixel data (e.g. YUV, RGB formats)
> +
> +resume point
> +   a point in the bitstream from which decoding may start/continue, without
> +   any previous state/data present, e.g.: a keyframe (VP8/VP9) or
> +   SPS/PPS/IDR sequence (H.264); a resume point is required to start decode
> +   of a new stream, or to resume decoding after a seek
> +
> +source
> +   data fed to the encoder; ``OUTPUT``
> +
> +source height
> +   height in pixels for given source resolution
> +
> +source resolution
> +   resolution in pixels of source frames being source to the encoder and
> +   subject to further cropping to the bounds of visible resolution
> +
> +source width
> +   width in pixels for given source resolution
> +
> +SPS
> +   Sequence Parameter Set; a type of metadata entity in H.264 bitstream
> +
> +stream metadata
> +   additional (non-visual) information contained inside encoded bitstream;
> +   for example: coded resolution, visible resolution, codec profile
> +
> +visible height
> +   height for given visible resolution; display height
> +
> +visible resolution
> +   stream resolution of the visible picture, in pixels, to be used for
> +   display purposes; must be smaller or equal to coded resolution;
> +   display resolution
> +
> +visible width
> +   width for given visible resolution; display width
> +
> +Querying capabilities
> +=====================
> +
> +1. To enumerate the set of coded formats supported by the driver, the
> +   client may call :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
> +
> +   * The driver must always return the full set of supported formats,
> +     irrespective of the format set on the ``OUTPUT`` queue.
> +
> +2. To enumerate the set of supported raw formats, the client may call
> +   :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
> +
> +   * The driver must return only the formats supported for the format
> +     currently active on ``CAPTURE``.
> +

Paul and I where discussing about the default active format on CAPTURE
and OUTPUT queues. That is, the format that is active (if any) right
after driver probes.

Currently, the v4l2-compliance tool tests the default active format,
by requiring drivers to support:

    fmt = g_fmt()
    s_fmt(fmt)

Is this actually required? Should we also require this for stateful
and stateless codecs? If yes, should it be documented?

Regards,
Ezequiel
