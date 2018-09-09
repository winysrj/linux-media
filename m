Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:45881 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726639AbeIIO1S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 10:27:18 -0400
Subject: Re: [PATCH v6 0/3] Add support for MPEG-2 in DELTA video decoder
To: Hugues Fruchet <hugues.fruchet@st.com>, linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
References: <1493385949-2962-1-git-send-email-hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dd3286b3-88e4-0d37-7de1-ea8d11e29dbb@xs4all.nl>
Date: Sun, 9 Sep 2018 11:38:06 +0200
MIME-Version: 1.0
In-Reply-To: <1493385949-2962-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On 04/28/2017 03:25 PM, Hugues Fruchet wrote:
> The patchset implements the MPEG-2 part of V4L2 unified low-level decoder
> API RFC [0] needed by stateless video decoders, ie decoders which requires
> specific parsing metadata in addition to video bitstream chunk in order
> to complete decoding.
> A reference implementation using STMicroelectronics DELTA video decoder
> is provided as initial support in this patchset.
> In addition to this patchset, a libv4l plugin is also provided which convert
> MPEG-2 video bitstream to "parsed MPEG-2" by parsing the user video bitstream
> and filling accordingly the dedicated controls, doing so user code remains
> unchanged whatever decoder is: stateless or not.
> 
> The first patch implements the MPEG-2 part of V4L2 unified low-level decoder
> API RFC [0]. A dedicated "parsed MPEG-2" pixel format has been introduced with
> its related extended controls in order that user provides both video bitstream
> chunk and the associated extra data resulting from this video bitstream chunk
> parsing.
> 
> The second patch adds the support of "parsed" pixel format inside DELTA video
> decoder including handling of the dedicated controls and setting of parsing
> metadata required by decoder layer.
> Please note that the current implementation has a restriction regarding
> the atomicity of S_EXT_CTRL/QBUF that must be guaranteed by user.
> This restriction will be removed when V4L2 request API will be implemented [1].
> Please also note the failure in v4l2-compliance in controls section, related
> to complex compound controls handling, to be discussed to find the right way
> to fix it in v4l2-compliance.
> 
> The third patch adds the support of DELTA MPEG-2 stateless video decoder back-end.

I've marked this (old) series as obsoleted in patchwork. The Request API together
with the cedrus stateless MPEG decoder is about to be merged for 4.20, so it would
be very nice indeed if you can resurrect this driver and base it on the Request API.

Thanks!

	Hans

> 
> 
> This driver depends on:
>   [PATCH v7 00/10] Add support for DELTA video decoder of STMicroelectronics STiH4xx SoC series https://patchwork.linuxtv.org/patch/39186/
> 
> References:
>   [0] [RFC] V4L2 unified low-level decoder API https://www.spinics.net/lists/linux-media/msg107150.html
>   [1] [ANN] Report of the V4L2 Request API brainstorm meeting https://www.spinics.net/lists/linux-media/msg106699.html
> 
> ===========
> = history =
> ===========
> version 6:
>   - patchset 5 review from Hans:
>     - revisit 32/64 bit compat in mpeg2 controls struct (using pahole utility)
>       to avoid padding fields introduction
>   - pass latest v4l2-compliance with compound controls fixes
>     - fix delta_subscribe_event() adding missing control event
>   - fix warnings at documentation generation (add exceptions)
> 
> version 5:
>   - patchset 4 review from Hans:
>     - fix 32/64 bit compat in mpeg2 controls struct (using pahole utility)
>     - fix upper case at begining of words in v4l2_ctrl_get_name()
> 
> version 4:
>   - patchset 3 review from Nicolas Dufresne
>     - one attribute per line in structure
>   - fix some multilines comments
> 
> version 3:
>   - fix warning on parisc architecture
> 
> version 2:
>   - rebase on top of DELTA v7, refer to [0]
>   - change VIDEO_STI_DELTA_DRIVER to default=y as per Mauro recommendations
> 
> version 1:
>   - Initial submission
> 
> ===================
> = v4l2-compliance =
> ===================
> Below is the v4l2-compliance report, v4l2-compliance has been build from SHA1:
> 847bf8d62cd6b11defc1e4c3b30b68d3c66876e0 v4l2/cec-compliance, cec-follower: use git -C $(srcdir) rev-parse HEAD
> 
> root@sti:~# v4l2-compliance -d /dev/video3
> v4l2-compliance SHA   : 847bf8d62cd6b11defc1e4c3b30b68d3c66876e0
> 
> Driver Info:
>         Driver name   : st-delta
>         Card type     : st-delta-21.1-3
>         Bus info      : platform:soc:delta0
>         Driver version: 4.10.0
>         Capabilities  : 0x84208000
>                 Video Memory-to-Memory
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04208000
>                 Video Memory-to-Memory
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video3 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 6 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(732): TRY_FMT cannot handle an in.
>                 warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(733): This may or may not be a pr:
>                 warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(734): http://www.mail-archive.coml
>                 test VIDIOC_TRY_FMT: OK
>                 warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(997): S_FMT cannot handle an inva.
>                 warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(998): This may or may not be a pr:
>                 warn: ../../../../../../../../../sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(999): http://www.mail-archive.coml
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK
>                 test Scaling: OK
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 6
> 
> 
> Hugues Fruchet (3):
>   [media] v4l: add parsed MPEG-2 support
>   [media] st-delta: add parsing metadata controls support
>   [media] st-delta: add mpeg2 support
> 
>  Documentation/media/uapi/v4l/extended-controls.rst |  363 +++++
>  Documentation/media/uapi/v4l/pixfmt-013.rst        |   10 +
>  Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   38 +-
>  Documentation/media/videodev2.h.rst.exceptions     |    6 +
>  drivers/media/platform/Kconfig                     |   11 +-
>  drivers/media/platform/sti/delta/Makefile          |    3 +
>  drivers/media/platform/sti/delta/delta-cfg.h       |    5 +
>  drivers/media/platform/sti/delta/delta-mpeg2-dec.c | 1401 ++++++++++++++++++++
>  drivers/media/platform/sti/delta/delta-mpeg2-fw.h  |  423 ++++++
>  drivers/media/platform/sti/delta/delta-v4l2.c      |  131 +-
>  drivers/media/platform/sti/delta/delta.h           |   34 +
>  drivers/media/v4l2-core/v4l2-ctrls.c               |   53 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
>  include/uapi/linux/v4l2-controls.h                 |   94 ++
>  include/uapi/linux/videodev2.h                     |    8 +
>  15 files changed, 2577 insertions(+), 5 deletions(-)
>  create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-dec.c
>  create mode 100644 drivers/media/platform/sti/delta/delta-mpeg2-fw.h
> 
