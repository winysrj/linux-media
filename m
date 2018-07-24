Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f173.google.com ([209.85.215.173]:39131 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388352AbeGXPNP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 11:13:15 -0400
Received: by mail-pg1-f173.google.com with SMTP id g2-v6so2988461pgs.6
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2018 07:06:36 -0700 (PDT)
From: Tomasz Figa <tfiga@chromium.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Tiffany=20Lin=20=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?q?Andrew-CT=20Chen=20=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        ezequiel@collabora.com, Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH 0/2] Document memory-to-memory video codec interfaces
Date: Tue, 24 Jul 2018 23:06:19 +0900
Message-Id: <20180724140621.59624-1-tfiga@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

It is an initial conversion from Google Docs to RST, so formatting is
likely to need some further polishing. It is also the first time for me
to create such long RST documention. I could not find any other instance
of similar userspace sequence specifications among our Media documents,
so I mostly followed what was there in the source. Feel free to suggest
a better format.

Much of credits should go to Pawel Osciak, for writing most of the
original text of the initial RFC.

Changes since RFC:
(https://lore.kernel.org/patchwork/project/lkml/list/?series=348588)
 - The number of changes is too big to list them all here. Thanks to
   a huge number of very useful comments from everyone (Philipp, Hans,
   Nicolas, Dave, Stanimir, Alexandre) we should have the interfaces much
   more specified now. The issues collected since previous revisions and
   answers leading to this revision are listed below.

General issues

  Should TRY_/S_FMT really return an error if invalid format is set,
  rather than falling back to some valid format? That would be
  contradicting to the general spec.

  Answer: Keep non-error behavior for existing spec compatibility, but
  consider returning error for Request API.

  The number of possible opens of M2M video node should not be
  artificially limited. Drivers should defer allocating limited resources
  (e.g. hardware instances) until initialization is attempted to allow
  probing and pre-opening of video nodes. (Hans suggested vb2 queue setup
  or REQBUFS.)

  Answer: Allocate hardware resources in REQBUFS (or later).

  How about colorimetry settings (colorspace, xfer function, etc.)?
  Normally it is not needed for decoding itself, but some codecs can parse
  it from the stream.  If user space can parse by itself, should it set it
  on OUTPUT queue?  What should happen on CAPTURE queue if colorimetry can
  be parsed, colorimetry can’t be parsed.

  Answer: Mention copying colorimetry from OUTPUT to CAPTURE queue only.
  Potentially extend for hardware that can do colorspace conversion later.

Decoder issues

  Is VIDIOC_ENUM_FRAMESIZES mandatory? Coda doesn’t implement it, s5p-mfc
  either.

  Answer: Make it mandatory. Otherwise nobody would implement it.

  Should we support all the three specification modes of
  VIDIOC_ENUM_FRAMESIZES (continuous, discrete and stepwise)? On both
  queues?

  Answer: Support all 3 size specification modes, not to diverge from
  general specification.

  Should ENUM_FRAMESIZES return coded or visible size?

  Answer: That should be the value that characterizes the stream, so
  coded size. Visible size is just a crop.

  How should ENUM_FRAMESIZES be affected by profiles and levels?

  Answer: Not in current specification - the logic is too complicated and
  it might make more sense to actually handle this in user space.  (In
  theory, level implies supported frame sizes + other factors.)

  Is VIDIOC_ENUM_FRAMEINTERVALS mandatory?  Coda doesn’t implement it,
  s5p-mfc either.  What is the meaning of frame interval for m2m in
  general?

  Answer: Do not include in this specification, because there is no way
  to return meaningful values for memory-to-memory devices.

  What to do for coded formats for which coded resolution can’t be parsed
  (due to format or hardware limitation)? Current draft mentions setting
  them on OUTPUT queue. What would be the effect on CAPTURE queue?
  Should OUTPUT queue format include width/height? Would that mean coded
  or visible size? If so, should they always be configured? Gstreamer
  seems to pass visible size from the container.

  Answer: If OUTPUT format has non-zero width and height, the driver must
  behave as it instantly parsed the coded size from the stream, including
  updating CAPTURE format and queuing source change event. If another
  parameters are parsed later by hardware, a dynamic resolution change
  sequence would be triggered. However, for hardware not parsing such
  parameters from the stream, stateless API should be seriously
  considered.

  How about the legacy behavior of G_FMT(CAPTURE) blocking until queued
  OUTPUT buffers are processed?

  Answer: Do not include in the specification, keep in existing drivers for
  compatibility.

  Should we allow preallocating CAPTURE queue before parsing as an
  optimization?  If user space allocated buffers bigger than required, it
  may be desirable to use them if hardware allows.  Similarly, if a
  decreasing resolution change happened, it may be desirable to avoid
  buffer reallocation.  Gstreamer seems to rely on this behavior to be
  allowed and works luckily because it allocates resolutions matching what
  is parsed later.

  Answer: Yes. The client can setup CAPTURE queue beforehand. The driver
  would still issue a source change event, but if existing buffers are
  compatible with driver requirements (size and count), there is no need to
  reallocate. Similarly for dynamic resolution change. 

  What is the meaning of CAPTURE format?  Should it be coded format,
  visible format or something else?

  Answer: It should be a hardware-specific frame buffer size (>= coded
  size), minimum needed for decoding to proceed.

  Which selection target should be used for visible rectangle? Should we
  also report CROP/COMPOSE_DEFAULT and COMPOSE_PADDED (the area that
  hardware actually overwrites)? How about CROP_BOUNDS?

  Answer: COMPOSE. Also require most of the other meaningful targets.
  Make them default to visible rectangle and, on hardware without
  crop/compose/scale ability, read-only.

  What if the hardware only supports handling complete frames?  Current
  draft says that Source OUTPUT buffers must contain: - H.264/AVC: one or
  more complete NALUs of an Annex B elementary stream; one buffer does not
  have to contain enough data to decode a frame;

  Answer: Defer to specification of particular V4L2_PIX_FMT (FourCC), to be
  further specified later. Current drivers seem to implement support for
  various formats in various ways (especially H264). Moreover, various
  userspace applications have their own way of splitting the bitstream. We
  need to keep all existing users working, so sorting this out will require
  quite a bit of effort and should not be blocking the already de facto
  defined part of the specification.

  Does the driver need to flush its CAPTURE queue internally when a seek is
  issued? Or the client needs to explicitly restart streaming on CAPTURE
  queue?

  Answer: No guarantees for CAPTURE queue from codec. User space needs to
  handle.

  Must all drivers support dynamic resolution change?  Gstreamer parses the
  stream itself and it can handle the change itself by resetting the
  decode.

  Answer: Yes, if it's a feature of the coded format. There is already
  userspace relying on this. A hardware that cannot support this, should
  likely use the stateless codec interface.

  What happens with OUTPUT queue format (resolution, colorimetry) after
  resolution change? Currently always 0 on s5p-mfc. mtk-vcodec reports
  coded resolution.

  Answer: Coded size on OUTPUT queue.

  Can we allow G_FMT(CAPTURE) after resolution change before
  REQBUFS(CAPTURE, 0)?  This would allow keeping current buffer set if the
  resolution decreased.

  Answer: Yes, even before STREAMOFF(CAPTURE).

  Should the client also read visible resolution after resolution change?
  Current draft doesn’t mention it.

  Answer: Yes.

  Is there a requirement or expectation for the encoded data to be framed
  as a single encoded frame per buffer, or is feeding in full buffer sized
  chunks from a ES valid?  It's not stated for the description of
  V4L2_PIX_FMT_H264 etc either.  Should we tie such requirements to
  particular format (FourCC)?

  Answer: Defer to specification of particular V4L2_PIX_FMT (FourCC), to be
  further specified later. Similarly to the earlier issue with H264.

  How about first frame in case of VP8, VP9 or H264_NO_SC? Should that
  include only headers?

  Answer: There is no separate header in case of VP8 and VP9. There are
  only full frames. V4L2_PIX_FMT_H264_NO_SC implies user space splitting
  headers (SPS, PPS) and frame data (slice) into separate buffers, due
  to the nature of the format.

  Should we have a separate format for headers and data in separate
  buffers?

  Answer: As with the other format-specific issues - defer to format
  specification.`

  How about timestamp copying between OUTPUT and CAPTURE buffers?
  The draft says - buffers may become available on the CAPTURE queue
  without additional buffers queued to OUTPUT (e.g. during flush or EOS)
  What timestamps would those buffers have?

  Answer: Those CAPTURE buffers would originate from an earelier OUTPUT
  buffer, just being delayed. Timestamp would match those OUTPUT buffers.

  Supposedly there are existing decoders that can’t deal with seek to a
  non-resume point and end up returning corrupt frames.

  Answer: There is userspace relying on this behavior not crashing the
  system or causing a fatal decode error. Corrupt frames are okay. We can
  extend the specification later with a control that gives a hint to the
  client.

  Maybe we should state what happens to reference buffers, things like DPB.
  Can we CMD_STOP, then V4L2_DEC_CMD_START and continue with the ref kept?

  Answer: Refs lost - same as STREAMOFF(CAPTURE), STREAMON(CAPTURE), except
  that buffers are successfully returned to user space.

  After I streamoff, do I need to send PPS/SPS again after STREAMON, or
  will the codec remember, and the following IDR is fine? (ndufresne: For
  sure the DPB will be gone)

  Answer: Decoder needs to keep PPS/SPS across STREAMOFF(OUTPUT),
  STREAMON(OUTPUT). If we seek to another place in the stream that
  references the same PPS/SPS, no need to queue the same PPS/SPS again
  (since decoder needs to hold it). If we seek somewhere far, skipping
  PPS/SPS on the way, we can’t guarantee anything. In practice most client
  implementations already include PPS/SPS at seek before IDR.

Encoder issues

  Is S_FMT() really mandatory during initialization sequence?  In theory,
  the client could just G_FMT() and use what’s already there. (tfiga: In
  practice unlikely.)

  Answer: Not mandatory, but it's the only thing that makes sense.

  When does the actual encoding start? Once both queues are streaming?

  Answer: When both queues start streaming.

  When does the encoding stop/resets? As soon as one queue receives
  STREAMOFF?

  Answer: STREAMOFF on CAPTURE. After restarting streaming on CAPTURE,
  encoder will generate a stream independent of the stream generated
  before. E.g. no references frames from before the restart (no H.264 long
  term reference), any headers that must be included in a standalone stream
  must be produced again. OUTPUT queue might be restarted on demand to
  let the client change the buffer set or extended later to support
  encoding streams with dynamic resolution changes.

  How should we handle hardware that cannot control encoding parameters
  dynamically?  Should the driver internally stop, reconfigure and restart?
  Or should we defer this to user space?

  Answer: Disallow setting respective controls when streaming.

  Which queue should be master, i.e. be capable of overriding settings on
  the other queue?

  Answer: CAPTURE, since coded format is likely to determine the list of
  supported raw formats.

  How should we describe the behavior of two queues?

  Answer: Say that standard M2M principles apply. Also mention no direct
  relation between order of raw frames being queued and encoded frames
  dequeued, other than timestamp.

  How should encoder controls be handled?  
  
  Answer: Keep up to the driver. Use Request API to set controls for exact
  frames.

  What should VIDIOC_STREAMON do on an already streaming queue, but after
  V4L2_ENC_CMD_STOP?
  https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-encoder-cmd.html
  says A read() or VIDIOC_STREAMON call sends an implicit START command to
  the encoder if it has not been started yet.
  https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-streamon.html
  says If VIDIOC_STREAMON is called when streaming is already in progress,
  or if VIDIOC_STREAMOFF is called when streaming is already stopped, then
  0 is returned. Nothing happens in the case of VIDIOC_STREAMON[...].

  Answer: Nothing, as per the specification. Use V4L2_ENC_CMD_START for
  resuming from pause.

Tomasz Figa (2):
  media: docs-rst: Document memory-to-memory video decoder interface
  media: docs-rst: Document memory-to-memory video encoder interface

 Documentation/media/uapi/v4l/dev-decoder.rst | 872 +++++++++++++++++++
 Documentation/media/uapi/v4l/dev-encoder.rst | 550 ++++++++++++
 Documentation/media/uapi/v4l/devices.rst     |   2 +
 Documentation/media/uapi/v4l/v4l2.rst        |  12 +-
 4 files changed, 1435 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
 create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst

-- 
2.18.0.233.g985f88cf7e-goog
