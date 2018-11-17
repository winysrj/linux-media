Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:38305 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726003AbeKQV7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 16:59:49 -0500
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
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
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
References: <20181022144901.113852-1-tfiga@chromium.org>
 <20181022144901.113852-2-tfiga@chromium.org>
 <45f6797a-5e9c-e2f9-2606-a5bb81d12f11@xs4all.nl>
 <8620b9ae8ba94bf24788def5775d559c1b5b0666.camel@ndufresne.ca>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <dd83d36b-c8a1-6f84-a4a2-103607897a64@xs4all.nl>
Date: Sat, 17 Nov 2018 12:43:19 +0100
MIME-Version: 1.0
In-Reply-To: <8620b9ae8ba94bf24788def5775d559c1b5b0666.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/17/2018 05:31 AM, Nicolas Dufresne wrote:
> Le jeudi 15 novembre 2018 à 15:34 +0100, Hans Verkuil a écrit :
>> On 10/22/2018 04:48 PM, Tomasz Figa wrote:
>>> Due to complexity of the video decoding process, the V4L2 drivers of
>>> stateful decoder hardware require specific sequences of V4L2 API calls
>>> to be followed. These include capability enumeration, initialization,
>>> decoding, seek, pause, dynamic resolution change, drain and end of
>>> stream.
>>>
>>> Specifics of the above have been discussed during Media Workshops at
>>> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
>>> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
>>> originated at those events was later implemented by the drivers we already
>>> have merged in mainline, such as s5p-mfc or coda.
>>>
>>> The only thing missing was the real specification included as a part of
>>> Linux Media documentation. Fix it now and document the decoder part of
>>> the Codec API.
>>>
>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>>> ---
>>>  Documentation/media/uapi/v4l/dev-decoder.rst  | 1082 +++++++++++++++++
>>>  Documentation/media/uapi/v4l/devices.rst      |    1 +
>>>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
>>>  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
>>>  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
>>>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
>>>  6 files changed, 1137 insertions(+), 15 deletions(-)
>>>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
>>>
>>> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
>>> new file mode 100644
>>> index 000000000000..09c7a6621b8e
>>> --- /dev/null
>>> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
>>> @@ -0,0 +1,1082 @@
>>> +.. -*- coding: utf-8; mode: rst -*-
>>> +
>>> +.. _decoder:
>>> +
>>> +*************************************************
>>> +Memory-to-memory Stateful Video Decoder Interface
>>> +*************************************************
>>> +
>>> +A stateful video decoder takes complete chunks of the bitstream (e.g. Annex-B
>>> +H.264/HEVC stream, raw VP8/9 stream) and decodes them into raw video frames in
>>> +display order. The decoder is expected not to require any additional information
>>> +from the client to process these buffers.
>>> +
>>> +Performing software parsing, processing etc. of the stream in the driver in
>>> +order to support this interface is strongly discouraged. In case such
>>> +operations are needed, use of the Stateless Video Decoder Interface (in
>>> +development) is strongly advised.
>>> +
>>> +Conventions and notation used in this document
>>> +==============================================
>>> +
>>> +1. The general V4L2 API rules apply if not specified in this document
>>> +   otherwise.
>>> +
>>> +2. The meaning of words “must”, “may”, “should”, etc. is as per RFC
>>> +   2119.
>>> +
>>> +3. All steps not marked “optional” are required.
>>> +
>>> +4. :c:func:`VIDIOC_G_EXT_CTRLS`, :c:func:`VIDIOC_S_EXT_CTRLS` may be used
>>> +   interchangeably with :c:func:`VIDIOC_G_CTRL`, :c:func:`VIDIOC_S_CTRL`,
>>> +   unless specified otherwise.
>>> +
>>> +5. Single-plane API (see spec) and applicable structures may be used
>>> +   interchangeably with Multi-plane API, unless specified otherwise,
>>> +   depending on decoder capabilities and following the general V4L2
>>> +   guidelines.
>>> +
>>> +6. i = [a..b]: sequence of integers from a to b, inclusive, i.e. i =
>>> +   [0..2]: i = 0, 1, 2.
>>> +
>>> +7. Given an ``OUTPUT`` buffer A, A’ represents a buffer on the ``CAPTURE``
>>> +   queue containing data (decoded frame/stream) that resulted from processing
>>> +   buffer A.
>>> +
>>> +.. _decoder-glossary:
>>> +
>>> +Glossary
>>> +========
>>> +
>>> +CAPTURE
>>> +   the destination buffer queue; for decoder, the queue of buffers containing
>>> +   decoded frames; for encoder, the queue of buffers containing encoded
>>> +   bitstream; ``V4L2_BUF_TYPE_VIDEO_CAPTURE```` or
>>> +   ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``; data are captured from the hardware
>>> +   into ``CAPTURE`` buffers
>>> +
>>> +client
>>> +   application client communicating with the decoder or encoder implementing
>>> +   this interface
>>> +
>>> +coded format
>>> +   encoded/compressed video bitstream format (e.g. H.264, VP8, etc.); see
>>> +   also: raw format
>>> +
>>> +coded height
>>> +   height for given coded resolution
>>> +
>>> +coded resolution
>>> +   stream resolution in pixels aligned to codec and hardware requirements;
>>> +   typically visible resolution rounded up to full macroblocks;
>>> +   see also: visible resolution
>>> +
>>> +coded width
>>> +   width for given coded resolution
>>> +
>>> +decode order
>>> +   the order in which frames are decoded; may differ from display order if the
>>> +   coded format includes a feature of frame reordering; for decoders,
>>> +   ``OUTPUT`` buffers must be queued by the client in decode order; for
>>> +   encoders ``CAPTURE`` buffers must be returned by the encoder in decode order
>>> +
>>> +destination
>>> +   data resulting from the decode process; ``CAPTURE``
>>> +
>>> +display order
>>> +   the order in which frames must be displayed; for encoders, ``OUTPUT``
>>> +   buffers must be queued by the client in display order; for decoders,
>>> +   ``CAPTURE`` buffers must be returned by the decoder in display order
>>> +
>>> +DPB
>>> +   Decoded Picture Buffer; an H.264 term for a buffer that stores a decoded
>>> +   raw frame available for reference in further decoding steps.
>>> +
>>> +EOS
>>> +   end of stream
>>> +
>>> +IDR
>>> +   Instantaneous Decoder Refresh; a type of a keyframe in H.264-encoded stream,
>>> +   which clears the list of earlier reference frames (DPBs)
>>> +
>>> +keyframe
>>> +   an encoded frame that does not reference frames decoded earlier, i.e.
>>> +   can be decoded fully on its own.
>>> +
>>> +macroblock
>>> +   a processing unit in image and video compression formats based on linear
>>> +   block transforms (e.g. H.264, VP8, VP9); codec-specific, but for most of
>>> +   popular codecs the size is 16x16 samples (pixels)
>>> +
>>> +OUTPUT
>>> +   the source buffer queue; for decoders, the queue of buffers containing
>>> +   encoded bitstream; for encoders, the queue of buffers containing raw frames;
>>> +   ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``; the
>>> +   hardware is fed with data from ``OUTPUT`` buffers
>>> +
>>> +PPS
>>> +   Picture Parameter Set; a type of metadata entity in H.264 bitstream
>>> +
>>> +raw format
>>> +   uncompressed format containing raw pixel data (e.g. YUV, RGB formats)
>>> +
>>> +resume point
>>> +   a point in the bitstream from which decoding may start/continue, without
>>> +   any previous state/data present, e.g.: a keyframe (VP8/VP9) or
>>> +   SPS/PPS/IDR sequence (H.264); a resume point is required to start decode
>>> +   of a new stream, or to resume decoding after a seek
>>> +
>>> +source
>>> +   data fed to the decoder or encoder; ``OUTPUT``
>>> +
>>> +source height
>>> +   height in pixels for given source resolution; relevant to encoders only
>>> +
>>> +source resolution
>>> +   resolution in pixels of source frames being source to the encoder and
>>> +   subject to further cropping to the bounds of visible resolution; relevant to
>>> +   encoders only
>>> +
>>> +source width
>>> +   width in pixels for given source resolution; relevant to encoders only
>>> +
>>> +SPS
>>> +   Sequence Parameter Set; a type of metadata entity in H.264 bitstream
>>> +
>>> +stream metadata
>>> +   additional (non-visual) information contained inside encoded bitstream;
>>> +   for example: coded resolution, visible resolution, codec profile
>>> +
>>> +visible height
>>> +   height for given visible resolution; display height
>>> +
>>> +visible resolution
>>> +   stream resolution of the visible picture, in pixels, to be used for
>>> +   display purposes; must be smaller or equal to coded resolution;
>>> +   display resolution
>>> +
>>> +visible width
>>> +   width for given visible resolution; display width
>>> +
>>> +State machine
>>> +=============
>>> +
>>> +.. kernel-render:: DOT
>>> +   :alt: DOT digraph of decoder state machine
>>> +   :caption: Decoder state machine
>>> +
>>> +   digraph decoder_state_machine {
>>> +       node [shape = doublecircle, label="Decoding"] Decoding;
>>> +
>>> +       node [shape = circle, label="Initialization"] Initialization;
>>> +       node [shape = circle, label="Capture\nsetup"] CaptureSetup;
>>> +       node [shape = circle, label="Dynamic\nresolution\nchange"] ResChange;
>>> +       node [shape = circle, label="Stopped"] Stopped;
>>> +       node [shape = circle, label="Drain"] Drain;
>>> +       node [shape = circle, label="Seek"] Seek;
>>> +       node [shape = circle, label="End of stream"] EoS;
>>> +
>>> +       node [shape = point]; qi
>>> +       qi -> Initialization [ label = "open()" ];
>>> +
>>> +       Initialization -> CaptureSetup [ label = "CAPTURE\nformat\nestablished" ];
>>> +
>>> +       CaptureSetup -> Stopped [ label = "CAPTURE\nbuffers\nready" ];
>>> +
>>> +       Decoding -> ResChange [ label = "Stream\nresolution\nchange" ];
>>> +       Decoding -> Drain [ label = "V4L2_DEC_CMD_STOP" ];
>>> +       Decoding -> EoS [ label = "EoS mark\nin the stream" ];
>>> +       Decoding -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
>>> +       Decoding -> Stopped [ label = "VIDIOC_STREAMOFF(CAPTURE)" ];
>>> +       Decoding -> Decoding;
>>> +
>>> +       ResChange -> CaptureSetup [ label = "CAPTURE\nformat\nestablished" ];
>>> +       ResChange -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
>>> +
>>> +       EoS -> Drain [ label = "Implicit\ndrain" ];
>>> +
>>> +       Drain -> Stopped [ label = "All CAPTURE\nbuffers dequeued\nor\nVIDIOC_STREAMOFF(CAPTURE)" ];
>>> +       Drain -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
>>> +
>>> +       Seek -> Decoding [ label = "VIDIOC_STREAMON(OUTPUT)" ];
>>> +       Seek -> Initialization [ label = "VIDIOC_REQBUFS(OUTPUT, 0)" ];
>>> +
>>> +       Stopped -> Decoding [ label = "V4L2_DEC_CMD_START\nor\nVIDIOC_STREAMON(CAPTURE)" ];
>>> +       Stopped -> Seek [ label = "VIDIOC_STREAMOFF(OUTPUT)" ];
>>> +   }
>>> +
>>> +Querying capabilities
>>> +=====================
>>> +
>>> +1. To enumerate the set of coded formats supported by the decoder, the
>>> +   client may call :c:func:`VIDIOC_ENUM_FMT` on ``OUTPUT``.
>>> +
>>> +   * The full set of supported formats will be returned, regardless of the
>>> +     format set on ``CAPTURE``.
>>> +
>>> +2. To enumerate the set of supported raw formats, the client may call
>>> +   :c:func:`VIDIOC_ENUM_FMT` on ``CAPTURE``.
>>> +
>>> +   * Only the formats supported for the format currently active on ``OUTPUT``
>>> +     will be returned.
>>> +
>>> +   * In order to enumerate raw formats supported by a given coded format,
>>> +     the client must first set that coded format on ``OUTPUT`` and then
>>> +     enumerate formats on ``CAPTURE``.
>>> +
>>> +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
>>> +   resolutions for a given format, passing desired pixel format in
>>> +   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
>>> +
>>> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` for a coded pixel
>>> +     formats will include all possible coded resolutions supported by the
>>> +     decoder for given coded pixel format.
>>> +
>>> +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` for a raw pixel format
>>> +     will include all possible frame buffer resolutions supported by the
>>> +     decoder for given raw pixel format and the coded format currently set on
>>> +     ``OUTPUT``.
>>> +
>>> +4. Supported profiles and levels for given format, if applicable, may be
>>> +   queried using their respective controls via :c:func:`VIDIOC_QUERYCTRL`.
>>> +
>>> +Initialization
>>> +==============
>>> +
>>> +1. **Optional.** Enumerate supported ``OUTPUT`` formats and resolutions. See
>>> +   `Querying capabilities` above.
>>> +
>>> +2. Set the coded format on ``OUTPUT`` via :c:func:`VIDIOC_S_FMT`
>>> +
>>> +   * **Required fields:**
>>> +
>>> +     ``type``
>>> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
>>> +
>>> +     ``pixelformat``
>>> +         a coded pixel format
>>> +
>>> +     ``width``, ``height``
>>> +         required only if cannot be parsed from the stream for the given
>>> +         coded format; optional otherwise - set to zero to ignore
>>> +
>>> +     ``sizeimage``
>>> +         desired size of ``OUTPUT`` buffers; the decoder may adjust it to
>>> +         match hardware requirements
>>> +
>>> +     other fields
>>> +         follow standard semantics
>>> +
>>> +   * **Return fields:**
>>> +
>>> +     ``sizeimage``
>>> +         adjusted size of ``CAPTURE`` buffers
>>> +
>>> +   * If width and height are set to non-zero values, the ``CAPTURE`` format
>>> +     will be updated with an appropriate frame buffer resolution instantly.
>>> +     However, for coded formats that include stream resolution information,
>>> +     after the decoder is done parsing the information from the stream, it will
>>> +     update the ``CAPTURE`` format with new values and signal a source change
>>> +     event.
>>> +
>>> +   .. warning::
>>> +
>>> +      Changing the ``OUTPUT`` format may change the currently set ``CAPTURE``
>>> +      format. The decoder will derive a new ``CAPTURE`` format from the
>>> +      ``OUTPUT`` format being set, including resolution, colorimetry
>>> +      parameters, etc. If the client needs a specific ``CAPTURE`` format, it
>>> +      must adjust it afterwards.
>>> +
>>> +3.  **Optional.** Query the minimum number of buffers required for ``OUTPUT``
>>> +    queue via :c:func:`VIDIOC_G_CTRL`. This is useful if the client intends to
>>> +    use more buffers than the minimum required by hardware/format.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``id``
>>> +          set to ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
>>> +
>>> +    * **Return fields:**
>>> +
>>> +      ``value``
>>> +          the minimum number of ``OUTPUT`` buffers required for the currently
>>> +          set format
>>> +
>>> +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on
>>> +    ``OUTPUT``.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``count``
>>> +          requested number of buffers to allocate; greater than zero
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
>>> +
>>> +      ``memory``
>>> +          follows standard semantics
>>> +
>>> +    * **Return fields:**
>>> +
>>> +      ``count``
>>> +          the actual number of buffers allocated
>>> +
>>> +    .. warning::
>>> +
>>> +       The actual number of allocated buffers may differ from the ``count``
>>> +       given. The client must check the updated value of ``count`` after the
>>> +       call returns.
>>> +
>>> +    .. note::
>>> +
>>> +       To allocate more than the minimum number of buffers (for pipeline
>>> +       depth), the client may query the ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
>>> +       control to get the minimum number of buffers required by the
>>> +       decoder/format, and pass the obtained value plus the number of
>>> +       additional buffers needed in the ``count`` field to
>>> +       :c:func:`VIDIOC_REQBUFS`.
>>> +
>>> +    Alternatively, :c:func:`VIDIOC_CREATE_BUFS` on the ``OUTPUT`` queue can be
>>> +    used to have more control over buffer allocation.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``count``
>>> +          requested number of buffers to allocate; greater than zero
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
>>> +
>>> +      ``memory``
>>> +          follows standard semantics
>>> +
>>> +      ``format``
>>> +          follows standard semantics
>>> +
>>> +    * **Return fields:**
>>> +
>>> +      ``count``
>>> +          adjusted to the number of allocated buffers
>>> +
>>> +    .. warning::
>>> +
>>> +       The actual number of allocated buffers may differ from the ``count``
>>> +       given. The client must check the updated value of ``count`` after the
>>> +       call returns.
>>> +
>>> +5.  Start streaming on the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`.
>>> +
>>> +6.  **This step only applies to coded formats that contain resolution information
>>> +    in the stream.**
>>
>> As far as I know all codecs have resolution/metadata in the stream.
> 
> Was this comment about what we currently support in V4L2 interface ? In

Yes, I was talking about all V4L2 codecs.

> real life, there is CODEC that works only with out-of-band codec data.
> A well known one is AVC1 (and HVC1). In this mode, the AVC H264 does
> not have start code, and the headers are not allowed in the bitstream
> itself. This format is much more efficient to process then AVC Annex B,
> since you can just read the NAL size and jump over instead of scanning
> for start code. This is the format used in the very popular ISOMP4
> container.

How would such a codec handle resolution changes? Or is that not allowed?

> 
> The other sign that these codecs do exist is the recurence of the
> notion of codec data in pretty much every codec abstraction there is
> (ffmpeg, GStreamer, Android Media Codec)
>>
>> As discussed in the "[PATCH vicodec v4 0/3] Add support to more pixel formats in
>> vicodec" thread, it is easiest to assume that there is always metadata.
>>
>> Perhaps there should be a single mention somewhere that such codecs are not
>> supported at the moment, but to be frank how can you decode a stream without
>> it containing such essential information? You are much more likely to implement
>> such a codec as a stateless codec.
> 
> That is I believe a miss-interpretation of what a stateless codec is.
> It's not because you have to set one blob of CODEC data after S_FMT on
> a specific control that this CODEC becomes stateless. The fact is not
> supported now is just become we didn't have come accross HW that
> supports these.
> 
> FFMPEG offers a state full software codec, and you still have this
> codec_data blob for many of the format. They also only supports AVC1,
> they parser will always convert the stream to that, because it's just
> more efficient format. Android Media Codec works similarly. What keeps
> them stateful, is that you don't need to parse it, you don't even need
> to know what these data contains. They are blobs placed in the
> container that you pass as-is to the decoder.

This is all useful information, thank you.

I think I stand by my recommendation to add a statement that we don't
support such codecs at the moment. When we add support for such a codec,
then we will need to update the spec with the right rules.

I think it is difficult to make assumptions without having seen how a
typical stateful HW codec would handle this.

Regards,

	Hans

> 
>>
>> So I would just drop this sentence here (and perhaps at other places in this
>> document or the encoder document as well).
>>
>> Regards,
>>
>> 	Hans
> 
