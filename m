Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF525C282C4
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 14:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 691AF21721
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 14:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbfAVOrc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:47:32 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52726 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728712AbfAVOrc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 09:47:32 -0500
Received: from [IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe] ([IPv6:2001:420:44c1:2579:b98b:fd77:97a1:d7fe])
        by smtp-cloud8.xs4all.net with ESMTPA
        id lxKdgGKE6NR5ylxKighgeJ; Tue, 22 Jan 2019 15:47:25 +0100
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
References: <20181022144901.113852-1-tfiga@chromium.org>
 <20181022144901.113852-2-tfiga@chromium.org>
 <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl>
 <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl>
Date:   Tue, 22 Jan 2019 15:47:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDPuine/fn83y7j76CcYANlyr2qp9oNGGy6S9sf85tzmfELOX01o3O6G8Ph9ygAGqbcpnYpvLERv/uno1rdM5hhEBfwxW1IBV3zokljVD2B0dONouHgF
 xwCAQInKc2uGC3Rh65/g41T4nd1L/fXSyCdPf9wrvW1FwrtMoKrAJvfqNZueurNKTvbD1hux1CEGUjVHoMO5erikq9LZaNwvaa/pYKXEyMfMAjZBW+qnmMXq
 5mlIZX+roKWEQsS4qgEcLZtqsVp8ujVXCljT3WylqziGyMgD3JJ31DbfMn2ZU8O6U9HrmHghrMF6ly770hP1f49mhQPmcZ0oLEHGoYTL9VRDtlaW51oMV4qa
 mfwMKOYBTKAF4qereKu/QlR84V+8IHaiw0kLFB7ulDp6Y8XT9HSJ2bLfGGhYW7et3v+1+3L0bgbgCL0+zVeso34UyqdhKlE+iAnA4f8jgxxSfbYpj4vlKJqG
 87FUmPrRfFC34r7adiEiUlhDBmQYy86GfwFmhKPVIWSfmrQoVAA6fh6uZQx89F/gB7b/xhCky8o2oq1ya1H5z5DukSKIZB+bBCaESLNHkHud9Klrs9q8kxZ8
 K8ot1PCdsJBxxNcbz1wq9sQGvXWAtdr3LC+NDxfkkqJyWiXBz/y2IZIKmPcvCd2C6gWCPucvn9NmQ8BAnx9NK6EukHuWR3OojDMQMdII9K6pqh6Gq5VMerJl
 U1aKsPfZvFQMN7FxVXqzlJ+buNNBRQPwvhgW77CupbGLQqgwkMPy1WF7RGQGo7MtGwVNXjYtiI4h59afKKX7g4PzzQslV4OWmxJZeVVywSEHAT8oOgba89cq
 d1Fr7TqrSdJOIojfF8BT8U7KINvIuhTyS5kugFfz+ja6u5z8bjWDoAQXLjeVkAt1EsuQAfBRlxuficeuMe7ZfDEdAAUzifPLBBMUpMRwFXZVbUZFDpQ3KHNB
 4IJG1iDwmKIEwrbDpcRhb/syrg4K6WMXI7UGsIwXXtvwCTRUx4z2NssoPqJzCJUQ+9haag==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/22/19 11:02, Tomasz Figa wrote:
> On Mon, Nov 12, 2018 at 8:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> Hi Tomasz,
>>
>> A general note for the stateful and stateless patches: they describe specific
>> use-cases of the more generic Codec Interface, and as such should be one
>> level deeper in the section hierarchy.
> 
> I wonder what exactly this Codec Interface is. Is it a historical name
> for mem2mem? If so, perhaps it would make sense to rename it?

Yeah, it should be renamed to "Video Memory-to-Memory Interface", and the
codecs are just specific instances of such an interface.

> 
>>
>> I.e. instead of being section 4.6/7/8:
>>
>> https://hverkuil.home.xs4all.nl/request-api/uapi/v4l/devices.html
>>
>> they should be 4.5.1/2/3.
>>
> 
> FYI, the first RFC started like that, but it only made the spec
> difficult to navigate and the section numbers too long.
> 
> Still, no strong opinion. I'm okay moving it there, if you think it's better.

It should be moved and the interface name should be renamed. It makes a lot
more sense with those changes.

I've posted a patch for this.

> 
>> On 10/22/2018 04:48 PM, Tomasz Figa wrote:
>>> Due to complexity of the video decoding process, the V4L2 drivers of
>>> stateful decoder hardware require specific sequences of V4L2 API calls
>>> to be followed. These include capability enumeration, initialization,
>>> decoding, seek, pause, dynamic resolution change, drain and end of
>>> stream.
> [snipping any comments that I agree with]
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
>>
>> I would drop these three terms: they are not used in this document since this
>> describes a decoder and not an encoder.
>>
> 
> The glossary is shared between encoder and decoder, as suggested in
> previous round of review.
> 
> [snip]
>>> +
>>> +   * If width and height are set to non-zero values, the ``CAPTURE`` format
>>> +     will be updated with an appropriate frame buffer resolution instantly.
>>> +     However, for coded formats that include stream resolution information,
>>> +     after the decoder is done parsing the information from the stream, it will
>>> +     update the ``CAPTURE`` format with new values and signal a source change
>>> +     event.
>>
>> What if the initial width and height specified by userspace matches the parsed
>> width and height? Do you still get a source change event? I think you should
>> always get this event since there are other parameters that depend on the parsing
>> of the meta data.
>>
>> But that should be made explicit here.
>>
> 
> Yes, the change event should happen always after the driver determines
> the format of the stream. Will specify it explicitly.
> 
>>> +
>>> +   .. warning::
>>
>> I'd call this a note rather than a warning.
>>
> 
> I think it deserves at least the "important" level, since it informs
> about the side effects of the call, affecting any actions that the
> client might have done before.
> 
> 
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
>>
>> Why is this useful? As far as I can tell only the s5p-mfc *encoder* supports
>> this control, so this seems pointless. And since the output queue gets a bitstream
>> I don't see any reason for reading this control in a decoder.
>>
> 
> Indeed, querying this for bitstream buffers probably doesn't make much
> sense. I'll remove it.
> 
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
>>
>> As mentioned above, this makes no sense for stateful decoders IMHO.
>>
> 
> Ack.
> 
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
>>> +    in the stream.** Continue queuing/dequeuing bitstream buffers to/from the
>>> +    ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`. The
>>> +    buffers will be processed and returned to the client in order, until
>>> +    required metadata to configure the ``CAPTURE`` queue are found. This is
>>> +    indicated by the decoder sending a ``V4L2_EVENT_SOURCE_CHANGE`` event with
>>> +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type.
>>> +
>>> +    * It is not an error if the first buffer does not contain enough data for
>>> +      this to occur. Processing of the buffers will continue as long as more
>>> +      data is needed.
>>> +
>>> +    * If data in a buffer that triggers the event is required to decode the
>>> +      first frame, it will not be returned to the client, until the
>>> +      initialization sequence completes and the frame is decoded.
>>> +
>>> +    * If the client sets width and height of the ``OUTPUT`` format to 0,
>>> +      calling :c:func:`VIDIOC_G_FMT`, :c:func:`VIDIOC_S_FMT` or
>>> +      :c:func:`VIDIOC_TRY_FMT` on the ``CAPTURE`` queue will return the
>>> +      ``-EACCES`` error code, until the decoder configures ``CAPTURE`` format
>>> +      according to stream metadata.
>>> +
>>> +    .. important::
>>> +
>>> +       Any client query issued after the decoder queues the event will return
>>> +       values applying to the just parsed stream, including queue formats,
>>> +       selection rectangles and controls.
>>> +
>>> +    .. note::
>>> +
>>> +       A client capable of acquiring stream parameters from the bitstream on
>>> +       its own may attempt to set the width and height of the ``OUTPUT`` format
>>> +       to non-zero values matching the coded size of the stream, skip this step
>>> +       and continue with the `Capture setup` sequence. However, it must not
>>> +       rely on any driver queries regarding stream parameters, such as
>>> +       selection rectangles and controls, since the decoder has not parsed them
>>> +       from the stream yet. If the values configured by the client do not match
>>> +       those parsed by the decoder, a `Dynamic resolution change` will be
>>> +       triggered to reconfigure them.
>>> +
>>> +    .. note::
>>> +
>>> +       No decoded frames are produced during this phase.
>>> +
>>> +7.  Continue with the `Capture setup` sequence.
>>> +
>>> +Capture setup
>>> +=============
>>> +
>>> +1.  Call :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue to get format for the
>>> +    destination buffers parsed/decoded from the bitstream.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
>>> +
>>> +    * **Return fields:**
>>> +
>>> +      ``width``, ``height``
>>> +          frame buffer resolution for the decoded frames
>>> +
>>> +      ``pixelformat``
>>> +          pixel format for decoded frames
>>> +
>>> +      ``num_planes`` (for _MPLANE ``type`` only)
>>> +          number of planes for pixelformat
>>> +
>>> +      ``sizeimage``, ``bytesperline``
>>> +          as per standard semantics; matching frame buffer format
>>> +
>>> +    .. note::
>>> +
>>> +       The value of ``pixelformat`` may be any pixel format supported by the
>>> +       decoder for the current stream. The decoder should choose a
>>> +       preferred/optimal format for the default configuration. For example, a
>>> +       YUV format may be preferred over an RGB format if an additional
>>> +       conversion step would be required for the latter.
>>> +
>>> +2.  **Optional.** Acquire the visible resolution via
>>> +    :c:func:`VIDIOC_G_SELECTION`.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
>>> +
>>> +      ``target``
>>> +          set to ``V4L2_SEL_TGT_COMPOSE``
>>> +
>>> +    * **Return fields:**
>>> +
>>> +      ``r.left``, ``r.top``, ``r.width``, ``r.height``
>>> +          the visible rectangle; it must fit within the frame buffer resolution
>>> +          returned by :c:func:`VIDIOC_G_FMT` on ``CAPTURE``.
>>> +
>>> +    * The following selection targets are supported on ``CAPTURE``:
>>> +
>>> +      ``V4L2_SEL_TGT_CROP_BOUNDS``
>>> +          corresponds to the coded resolution of the stream
>>> +
>>> +      ``V4L2_SEL_TGT_CROP_DEFAULT``
>>> +          the rectangle covering the part of the ``CAPTURE`` buffer that
>>> +          contains meaningful picture data (visible area); width and height
>>> +          will be equal to the visible resolution of the stream
>>> +
>>> +      ``V4L2_SEL_TGT_CROP``
>>> +          the rectangle within the coded resolution to be output to
>>> +          ``CAPTURE``; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``; read-only on
>>> +          hardware without additional compose/scaling capabilities
>>> +
>>> +      ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
>>> +          the maximum rectangle within a ``CAPTURE`` buffer, which the cropped
>>> +          frame can be output into; equal to ``V4L2_SEL_TGT_CROP`` if the
>>> +          hardware does not support compose/scaling
>>> +
>>> +      ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
>>> +          equal to ``V4L2_SEL_TGT_CROP``
>>> +
>>> +      ``V4L2_SEL_TGT_COMPOSE``
>>> +          the rectangle inside a ``CAPTURE`` buffer into which the cropped
>>> +          frame is written; defaults to ``V4L2_SEL_TGT_COMPOSE_DEFAULT``;
>>> +          read-only on hardware without additional compose/scaling capabilities
>>> +
>>> +      ``V4L2_SEL_TGT_COMPOSE_PADDED``
>>> +          the rectangle inside a ``CAPTURE`` buffer which is overwritten by the
>>> +          hardware; equal to ``V4L2_SEL_TGT_COMPOSE`` if the hardware does not
>>> +          write padding pixels
>>> +
>>> +    .. warning::
>>> +
>>> +       The values are guaranteed to be meaningful only after the decoder
>>> +       successfully parses the stream metadata. The client must not rely on the
>>> +       query before that happens.
>>> +
>>> +3.  Query the minimum number of buffers required for the ``CAPTURE`` queue via
>>> +    :c:func:`VIDIOC_G_CTRL`. This is useful if the client intends to use more
>>> +    buffers than the minimum required by hardware/format.
>>
>> Is this step optional or required? Can it change when a resolution change occurs?
> 
> Probably not with a simple resolution change, but a case when a stream
> is changed on the fly would trigger what we call "resolution change"
> here, but what would effectively be a "source change" and that could
> include a change in the number of required CAPTURE buffers.
> 
>> How does this relate to the checks for the minimum number of buffers that REQBUFS
>> does?
> 
> The control returns the minimum that REQBUFS would allow, so the
> application can add few more buffers on top of that and improve the
> pipelining.
> 
>>
>> The 'This is useful if' sentence suggests that it is optional, but I think that
>> sentence just confuses the issue.
>>
> 
> It used to be optional and I didn't rephrase it after turning it into
> mandatory. How about:
> 
>     This enables the client to request more buffers
>     than the minimum required by hardware/format and achieve better pipelining.

Hmm, OK. It'll do, I guess. I never liked these MIN_BUFFERS controls, I wish they
would return something like the recommended number of buffers that will give you
decent performance.

> 
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``id``
>>> +          set to ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
>>> +
>>> +    * **Return fields:**
>>> +
>>> +      ``value``
>>> +          minimum number of buffers required to decode the stream parsed in
>>> +          this initialization sequence.
>>> +
>>> +    .. note::
>>> +
>>> +       The minimum number of buffers must be at least the number required to
>>> +       successfully decode the current stream. This may for example be the
>>> +       required DPB size for an H.264 stream given the parsed stream
>>> +       configuration (resolution, level).
>>> +
>>> +    .. warning::
>>> +
>>> +       The value is guaranteed to be meaningful only after the decoder
>>> +       successfully parses the stream metadata. The client must not rely on the
>>> +       query before that happens.
>>> +
>>> +4.  **Optional.** Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_ENUM_FMT` on
>>> +    the ``CAPTURE`` queue. Once the stream information is parsed and known, the
>>> +    client may use this ioctl to discover which raw formats are supported for
>>> +    given stream and select one of them via :c:func:`VIDIOC_S_FMT`.
>>
>> Can the list returned here differ from the list returned in the 'Querying capabilities'
>> step? If so, then I assume it will always be a subset of what was returned in
>> the 'Querying' step?
> 
> Depends on whether you're considering just VIDIOC_ENUM_FMT or also
> VIDIOC_G_FMT and VIDIOC_ENUM_FRAMESIZES.
> 
> The initial VIDIOC_ENUM_FMT has no way to account for any resolution
> constraints of the formats, so the list would include all raw pixel
> formats that the decoder can handle with selected coded pixel format.
> However, the list can be further narrowed down by using
> VIDIOC_ENUM_FRAMESIZES, to restrict each raw format only to the
> resolutions it can handle.
> 
> The VIDIOC_ENUM_FMT call in this sequence (after getting the stream
> information) would have the knowledge about the resolution, so the
> list returned here would only include the formats that can be actually
> handled. It should match the result of the initial query using both
> VIDIOC_ENUM_FMT and VIDIOC_ENUM_FRAMESIZES.

Right, so this will be a subset of the initial query taking the resolution
into account.

> 
>>
>>> +
>>> +    .. important::
>>> +
>>> +       The decoder will return only formats supported for the currently
>>> +       established coded format, as per the ``OUTPUT`` format and/or stream
>>> +       metadata parsed in this initialization sequence, even if more formats
>>> +       may be supported by the decoder in general.
>>> +
>>> +       For example, a decoder may support YUV and RGB formats for resolutions
>>> +       1920x1088 and lower, but only YUV for higher resolutions (due to
>>> +       hardware limitations). After parsing a resolution of 1920x1088 or lower,
>>> +       :c:func:`VIDIOC_ENUM_FMT` may return a set of YUV and RGB pixel formats,
>>> +       but after parsing resolution higher than 1920x1088, the decoder will not
>>> +       return RGB, unsupported for this resolution.
>>> +
>>> +       However, subsequent resolution change event triggered after
>>> +       discovering a resolution change within the same stream may switch
>>> +       the stream into a lower resolution and :c:func:`VIDIOC_ENUM_FMT`
>>> +       would return RGB formats again in that case.
>>> +
>>> +5.  **Optional.** Set the ``CAPTURE`` format via :c:func:`VIDIOC_S_FMT` on the
>>> +    ``CAPTURE`` queue. The client may choose a different format than
>>> +    selected/suggested by the decoder in :c:func:`VIDIOC_G_FMT`.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
>>> +
>>> +      ``pixelformat``
>>> +          a raw pixel format
>>> +
>>> +    .. note::
>>> +
>>> +       The client may use :c:func:`VIDIOC_ENUM_FMT` after receiving the
>>> +       ``V4L2_EVENT_SOURCE_CHANGE`` event to find out the set of raw formats
>>> +       supported for the stream.
>>
>> Isn't this a duplicate of step 4? I think this note can be dropped.
>>
> 
> Ack.
> 
>>> +
>>> +6.  If all the following conditions are met, the client may resume the decoding
>>> +    instantly:
>>> +
>>> +    * ``sizeimage`` of the new format (determined in previous steps) is less
>>> +      than or equal to the size of currently allocated buffers,
>>> +
>>> +    * the number of buffers currently allocated is greater than or equal to the
>>> +      minimum number of buffers acquired in previous steps. To fulfill this
>>> +      requirement, the client may use :c:func:`VIDIOC_CREATE_BUFS` to add new
>>> +      buffers.
>>> +
>>> +    In such case, the remaining steps do not apply and the client may resume
>>> +    the decoding by one of the following actions:
>>> +
>>> +    * if the ``CAPTURE`` queue is streaming, call :c:func:`VIDIOC_DECODER_CMD`
>>> +      with the ``V4L2_DEC_CMD_START`` command,
>>> +
>>> +    * if the ``CAPTURE`` queue is not streaming, call :c:func:`VIDIOC_STREAMON`
>>> +      on the ``CAPTURE`` queue.
>>> +
>>> +    However, if the client intends to change the buffer set, to lower
>>> +    memory usage or for any other reasons, it may be achieved by following
>>> +    the steps below.
>>> +
>>> +7.  **If the** ``CAPTURE`` **queue is streaming,** keep queuing and dequeuing
>>> +    buffers on the ``CAPTURE`` queue until a buffer marked with the
>>> +    ``V4L2_BUF_FLAG_LAST`` flag is dequeued.
>>> +
>>> +8.  **If the** ``CAPTURE`` **queue is streaming,** call :c:func:`VIDIOC_STREAMOFF`
>>> +    on the ``CAPTURE`` queue to stop streaming.
>>> +
>>> +    .. warning::
>>> +
>>> +       The ``OUTPUT`` queue must remain streaming. Calling
>>> +       :c:func:`VIDIOC_STREAMOFF` on it would abort the sequence and trigger a
>>> +       seek.
>>> +
>>> +9.  **If the** ``CAPTURE`` **queue has buffers allocated,** free the ``CAPTURE``
>>> +    buffers using :c:func:`VIDIOC_REQBUFS`.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``count``
>>> +          set to 0
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
>>> +
>>> +      ``memory``
>>> +          follows standard semantics
>>> +
>>> +10. Allocate ``CAPTURE`` buffers via :c:func:`VIDIOC_REQBUFS` on the
>>> +    ``CAPTURE`` queue.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``count``
>>> +          requested number of buffers to allocate; greater than zero
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
>>> +
>>> +      ``memory``
>>> +          follows standard semantics
>>> +
>>> +    * **Return fields:**
>>> +
>>> +      ``count``
>>> +          actual number of buffers allocated
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
>>> +       depth), the client may query the ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
>>> +       control to get the minimum number of buffers required, and pass the
>>> +       obtained value plus the number of additional buffers needed in the
>>> +       ``count`` field to :c:func:`VIDIOC_REQBUFS`.
>>
>> Same question as before: is it optional or required to obtain the value of this
>> control? And can't the driver just set the min_buffers_needed field in the capture
>> vb2_queue to the minimum number of buffers that are required?
> 
> min_buffers_needed is the number of buffers that must be queued before
> start_streaming() can be called, so not relevant here.

Yeah, sorry about that. I clearly misunderstood this.

 The control is
> about the number of buffers to be allocated. Although the drivers must
> ensure that REQBUFS allocates the absolute minimum number of buffers
> for the decoding to be able to progress, the pipeline depth is
> something that the applications should control (e.g. depending on the
> consumers of the decoded buffers) and this is allowed by this control.
> 
>>
>> Should you be allowed to allocate buffers at all if the capture format isn't
>> known? I.e. width/height is still 0. It makes no sense to call REQBUFS since
>> there is no format size known that REQBUFS can use.
>>
> 
> Indeed, REQBUFS(CAPTURE) must not be allowed before the stream
> information is known (regardless of whether it comes from the OUTPUT
> format or is parsed from the stream). Let me add this to the related
> note in the Initialization sequence, which already includes
> VIDIOC_*_FMT.
> 
> For the Capture setup sequence, though, it's expected to happen when
> the stream information is already known, so I wouldn't change the
> description here.

Makes sense.

> 
>>> +
>>> +    Alternatively, :c:func:`VIDIOC_CREATE_BUFS` on the ``CAPTURE`` queue can be
>>> +    used to have more control over buffer allocation. For example, by
>>> +    allocating buffers larger than the current ``CAPTURE`` format, future
>>> +    resolution changes can be accommodated.
>>> +
>>> +    * **Required fields:**
>>> +
>>> +      ``count``
>>> +          requested number of buffers to allocate; greater than zero
>>> +
>>> +      ``type``
>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
>>> +
>>> +      ``memory``
>>> +          follows standard semantics
>>> +
>>> +      ``format``
>>> +          a format representing the maximum framebuffer resolution to be
>>> +          accommodated by newly allocated buffers
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
>>> +    .. note::
>>> +
>>> +       To allocate buffers for a format different than parsed from the stream
>>> +       metadata, the client must proceed as follows, before the metadata
>>> +       parsing is initiated:
>>> +
>>> +       * set width and height of the ``OUTPUT`` format to desired coded resolution to
>>> +         let the decoder configure the ``CAPTURE`` format appropriately,
>>> +
>>> +       * query the ``CAPTURE`` format using :c:func:`VIDIOC_G_FMT` and save it
>>> +         until this step.
>>> +
>>> +       The format obtained in the query may be then used with
>>> +       :c:func:`VIDIOC_CREATE_BUFS` in this step to allocate the buffers.
>>> +
>>> +11. Call :c:func:`VIDIOC_STREAMON` on the ``CAPTURE`` queue to start decoding
>>> +    frames.
>>> +
>>> +Decoding
>>> +========
>>> +
>>> +This state is reached after the `Capture setup` sequence finishes succesfully.
>>> +In this state, the client queues and dequeues buffers to both queues via
>>> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following the standard
>>> +semantics.
>>> +
>>> +The contents of the source ``OUTPUT`` buffers depend on the active coded pixel
>>> +format and may be affected by codec-specific extended controls, as stated in
>>> +the documentation of each format.
>>> +
>>> +Both queues operate independently, following the standard behavior of V4L2
>>> +buffer queues and memory-to-memory devices. In addition, the order of decoded
>>> +frames dequeued from the ``CAPTURE`` queue may differ from the order of queuing
>>> +coded frames to the ``OUTPUT`` queue, due to properties of the selected coded
>>> +format, e.g. frame reordering.
>>> +
>>> +The client must not assume any direct relationship between ``CAPTURE``
>>> +and ``OUTPUT`` buffers and any specific timing of buffers becoming
>>> +available to dequeue. Specifically,
>>> +
>>> +* a buffer queued to ``OUTPUT`` may result in no buffers being produced
>>> +  on ``CAPTURE`` (e.g. if it does not contain encoded data, or if only
>>> +  metadata syntax structures are present in it),
>>> +
>>> +* a buffer queued to ``OUTPUT`` may result in more than 1 buffer produced
>>> +  on ``CAPTURE`` (if the encoded data contained more than one frame, or if
>>> +  returning a decoded frame allowed the decoder to return a frame that
>>> +  preceded it in decode, but succeeded it in the display order),
>>> +
>>> +* a buffer queued to ``OUTPUT`` may result in a buffer being produced on
>>> +  ``CAPTURE`` later into decode process, and/or after processing further
>>> +  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
>>> +  reordering is used,
>>> +
>>> +* buffers may become available on the ``CAPTURE`` queue without additional
>>> +  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because of the
>>> +  ``OUTPUT`` buffers queued in the past whose decoding results are only
>>> +  available at later time, due to specifics of the decoding process.
>>> +
>>> +.. note::
>>> +
>>> +   To allow matching decoded ``CAPTURE`` buffers with ``OUTPUT`` buffers they
>>> +   originated from, the client can set the ``timestamp`` field of the
>>> +   :c:type:`v4l2_buffer` struct when queuing an ``OUTPUT`` buffer. The
>>> +   ``CAPTURE`` buffer(s), which resulted from decoding that ``OUTPUT`` buffer
>>> +   will have their ``timestamp`` field set to the same value when dequeued.
>>> +
>>> +   In addition to the straighforward case of one ``OUTPUT`` buffer producing

straighforward -> straightforward

>>> +   one ``CAPTURE`` buffer, the following cases are defined:
>>> +
>>> +   * one ``OUTPUT`` buffer generates multiple ``CAPTURE`` buffers: the same
>>> +     ``OUTPUT`` timestamp will be copied to multiple ``CAPTURE`` buffers,
>>> +
>>> +   * multiple ``OUTPUT`` buffers generate one ``CAPTURE`` buffer: timestamp of
>>> +     the ``OUTPUT`` buffer queued last will be copied,
>>> +
>>> +   * the decoding order differs from the display order (i.e. the
>>> +     ``CAPTURE`` buffers are out-of-order compared to the ``OUTPUT`` buffers):
>>> +     ``CAPTURE`` timestamps will not retain the order of ``OUTPUT`` timestamps
>>> +     and thus monotonicity of the timestamps cannot be guaranteed.

I think this last point should be rewritten. The timestamp is just a value that
is copied, there are no monotonicity requirements for m2m devices in general.

>>
>> Should stateful codecs be required to support 'tags'? See:
>>
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg136314.html
>>
>> To be honest, I'm inclined to require this for all m2m devices eventually.
>>
> 
> I guess this goes outside of the scope now, since we deferred tags.
> 
> Other than that, I would indeed make all m2m devices support tags,
> since it shouldn't differ from the timestamp copy feature as we have
> now.

I agree.

> 
>>> +
>>> +During the decoding, the decoder may initiate one of the special sequences, as
>>> +listed below. The sequences will result in the decoder returning all the
>>> +``CAPTURE`` buffers that originated from all the ``OUTPUT`` buffers processed
>>> +before the sequence started. Last of the buffers will have the
>>> +``V4L2_BUF_FLAG_LAST`` flag set. To determine the sequence to follow, the client
>>> +must check if there is any pending event and,
>>> +
>>> +* if a ``V4L2_EVENT_SOURCE_CHANGE`` event is pending, the `Dynamic resolution
>>> +  change` sequence needs to be followed,
>>> +
>>> +* if a ``V4L2_EVENT_EOS`` event is pending, the `End of stream` sequence needs
>>> +  to be followed.
>>> +
>>> +Some of the sequences can be intermixed with each other and need to be handled
>>> +as they happen. The exact operation is documented for each sequence.
>>> +
>>> +Seek
>>> +====
>>> +
>>> +Seek is controlled by the ``OUTPUT`` queue, as it is the source of coded data.
>>> +The seek does not require any specific operation on the ``CAPTURE`` queue, but
>>> +it may be affected as per normal decoder operation.
>>> +
>>> +1. Stop the ``OUTPUT`` queue to begin the seek sequence via
>>> +   :c:func:`VIDIOC_STREAMOFF`.
>>> +
>>> +   * **Required fields:**
>>> +
>>> +     ``type``
>>> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
>>> +
>>> +   * The decoder will drop all the pending ``OUTPUT`` buffers and they must be
>>> +     treated as returned to the client (following standard semantics).
>>> +
>>> +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
>>> +
>>> +   * **Required fields:**
>>> +
>>> +     ``type``
>>> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
>>> +
>>> +   * The decoder will start accepting new source bitstream buffers after the
>>> +     call returns.
>>> +
>>> +3. Start queuing buffers containing coded data after the seek to the ``OUTPUT``
>>> +   queue until a suitable resume point is found.
>>> +
>>> +   .. note::
>>> +
>>> +      There is no requirement to begin queuing coded data starting exactly
>>> +      from a resume point (e.g. SPS or a keyframe). Any queued ``OUTPUT``
>>> +      buffers will be processed and returned to the client until a suitable
>>> +      resume point is found.  While looking for a resume point, the decoder
>>> +      should not produce any decoded frames into ``CAPTURE`` buffers.
>>> +
>>> +      Some hardware is known to mishandle seeks to a non-resume point. Such an
>>> +      operation may result in an unspecified number of corrupted decoded frames
>>> +      being made available on the ``CAPTURE`` queue. Drivers must ensure that
>>> +      no fatal decoding errors or crashes occur, and implement any necessary
>>> +      handling and workarounds for hardware issues related to seek operations.
>>
>> Is there a requirement that those corrupted frames have V4L2_BUF_FLAG_ERROR set?
>> I.e., can userspace detect those currupted frames?
>>
> 
> I think the question is whether the kernel driver can actually detect
> those corrupted frames. We can't guarantee reporting errors to the
> userspace, if the hardware doesn't actually report them.
> 
> Could we perhaps keep this an open question and possibly address with
> some extension that could be an opt in for the decoders that can
> report errors?

Hmm, how about: If the hardware can detect such corrupted decoded frames, then
it shall set V4L2_BUF_FLAG_ERROR.

> 
>>> +
>>> +   .. warning::
>>> +
>>> +      In case of the H.264 codec, the client must take care not to seek over a
>>> +      change of SPS/PPS. Even though the target frame could be a keyframe, the
>>> +      stale SPS/PPS inside decoder state would lead to undefined results when
>>> +      decoding. Although the decoder must handle such case without a crash or a
>>> +      fatal decode error, the client must not expect a sensible decode output.
>>> +
>>> +4. After a resume point is found, the decoder will start returning ``CAPTURE``
>>> +   buffers containing decoded frames.
>>> +
>>> +.. important::
>>> +
>>> +   A seek may result in the `Dynamic resolution change` sequence being
>>> +   iniitated, due to the seek target having decoding parameters different from
>>> +   the part of the stream decoded before the seek. The sequence must be handled
>>> +   as per normal decoder operation.
>>> +
>>> +.. warning::
>>> +
>>> +   It is not specified when the ``CAPTURE`` queue starts producing buffers
>>> +   containing decoded data from the ``OUTPUT`` buffers queued after the seek,
>>> +   as it operates independently from the ``OUTPUT`` queue.
>>> +
>>> +   The decoder may return a number of remaining ``CAPTURE`` buffers containing
>>> +   decoded frames originating from the ``OUTPUT`` buffers queued before the
>>> +   seek sequence is performed.
>>> +
>>> +   The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
>>> +   ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` buffers
>>> +   queued before the seek sequence may have matching ``CAPTURE`` buffers
>>> +   produced.  For example, given the sequence of operations on the
>>> +   ``OUTPUT`` queue:
>>> +
>>> +     QBUF(A), QBUF(B), STREAMOFF(), STREAMON(), QBUF(G), QBUF(H),
>>> +
>>> +   any of the following results on the ``CAPTURE`` queue is allowed:
>>> +
>>> +     {A’, B’, G’, H’}, {A’, G’, H’}, {G’, H’}.
>>
>> Isn't it the case that if you would want to avoid that, then you should call
>> DECODER_STOP, wait for the last buffer on the CAPTURE queue, then seek and
>> call DECODER_START. If you do that, then you should always get {A’, B’, G’, H’}.
>> (basically following the Drain sequence).
> 
> Yes, it is, but I think it depends on the application needs. Here we
> just give a primitive to change the place in the stream that's being
> decoded (or change the stream on the fly).
> 
> Actually, with the timestamp copy, I guess we wouldn't even need to do
> the DECODER_STOP, as we could just discard the CAPTURE buffers until
> we get one that matches the timestamp of the first OUTPUT buffer after
> the seek.
> 
>>
>> Admittedly, you typically want to do an instantaneous seek, so this is probably
>> not what you want to do normally.
>>
>> It might help to have this documented in a separate note.
>>
> 
> The instantaneous seek is documented below. I'm not sure if there is
> any practical need to document the other case, but I could add a
> sentence like below to the warning above. What do you think?
> 
>    The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
>    ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` buffers
>    queued before the seek sequence may have matching ``CAPTURE`` buffers
>    produced.  For example, given the sequence of operations on the
>    ``OUTPUT`` queue:
> 
>      QBUF(A), QBUF(B), STREAMOFF(), STREAMON(), QBUF(G), QBUF(H),
> 
>    any of the following results on the ``CAPTURE`` queue is allowed:

is allowed -> are allowed

> 
>      {A’, B’, G’, H’}, {A’, G’, H’}, {G’, H’}.
> 
>    To determine the CAPTURE buffer containing the first decoded frame
> after the seek,
>    the client may observe the timestamps to match the CAPTURE and OUTPUT buffers
>    or use V4L2_DEC_CMD_STOP and V4L2_DEC_CMD_START to drain the decoder.

Ack.

> 
>>> +
>>> +.. note::
>>> +
>>> +   To achieve instantaneous seek, the client may restart streaming on the
>>> +   ``CAPTURE`` queue too to discard decoded, but not yet dequeued buffers.
>>> +
>>> +Dynamic resolution change
>>> +=========================
>>> +
>>> +Streams that include resolution metadata in the bitstream may require switching
>>> +to a different resolution during the decoding.
>>> +
>>> +The sequence starts when the decoder detects a coded frame with one or more of
>>> +the following parameters different from previously established (and reflected
>>> +by corresponding queries):
>>> +
>>> +* coded resolution (``OUTPUT`` width and height),
>>> +
>>> +* visible resolution (selection rectangles),
>>> +
>>> +* the minimum number of buffers needed for decoding.
>>> +
>>> +Whenever that happens, the decoder must proceed as follows:
>>> +
>>> +1.  After encountering a resolution change in the stream, the decoder sends a
>>> +    ``V4L2_EVENT_SOURCE_CHANGE`` event with source change type set to
>>> +    ``V4L2_EVENT_SRC_CH_RESOLUTION``.
>>> +
>>> +    .. important::
>>> +
>>> +       Any client query issued after the decoder queues the event will return
>>> +       values applying to the stream after the resolution change, including
>>> +       queue formats, selection rectangles and controls.
>>> +
>>> +2.  The decoder will then process and decode all remaining buffers from before
>>> +    the resolution change point.
>>> +
>>> +    * The last buffer from before the change must be marked with the
>>> +      ``V4L2_BUF_FLAG_LAST`` flag, similarly to the `Drain` sequence above.
>>> +
>>> +    .. warning::
>>> +
>>> +       The last buffer may be empty (with :c:type:`v4l2_buffer` ``bytesused``
>>> +       = 0) and in such case it must be ignored by the client, as it does not
>>> +       contain a decoded frame.
>>> +
>>> +    .. note::
>>> +
>>> +       Any attempt to dequeue more buffers beyond the buffer marked with
>>> +       ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
>>> +       :c:func:`VIDIOC_DQBUF`.
>>> +
>>> +The client must continue the sequence as described below to continue the
>>> +decoding process.
>>> +
>>> +1.  Dequeue the source change event.
>>> +
>>> +    .. important::
>>> +
>>> +       A source change triggers an implicit decoder drain, similar to the
>>> +       explicit `Drain` sequence. The decoder is stopped after it completes.
>>> +       The decoding process must be resumed with either a pair of calls to
>>> +       :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
>>> +       ``CAPTURE`` queue, or a call to :c:func:`VIDIOC_DECODER_CMD` with the
>>> +       ``V4L2_DEC_CMD_START`` command.
>>> +
>>> +2.  Continue with the `Capture setup` sequence.
>>> +
>>> +.. note::
>>> +
>>> +   During the resolution change sequence, the ``OUTPUT`` queue must remain
>>> +   streaming. Calling :c:func:`VIDIOC_STREAMOFF` on the ``OUTPUT`` queue would
>>> +   abort the sequence and initiate a seek.
>>> +
>>> +   In principle, the ``OUTPUT`` queue operates separately from the ``CAPTURE``
>>> +   queue and this remains true for the duration of the entire resolution change
>>> +   sequence as well.
>>> +
>>> +   The client should, for best performance and simplicity, keep queuing/dequeuing
>>> +   buffers to/from the ``OUTPUT`` queue even while processing this sequence.
>>> +
>>> +Drain
>>> +=====
>>> +
>>> +To ensure that all queued ``OUTPUT`` buffers have been processed and related
>>> +``CAPTURE`` buffers output to the client, the client must follow the drain
>>> +sequence described below. After the drain sequence ends, the client has
>>> +received all decoded frames for all ``OUTPUT`` buffers queued before the
>>> +sequence was started.
>>> +
>>> +1. Begin drain by issuing :c:func:`VIDIOC_DECODER_CMD`.
>>> +
>>> +   * **Required fields:**
>>> +
>>> +     ``cmd``
>>> +         set to ``V4L2_DEC_CMD_STOP``
>>> +
>>> +     ``flags``
>>> +         set to 0
>>> +
>>> +     ``pts``
>>> +         set to 0
>>> +
>>> +   .. warning::
>>> +
>>> +   The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE`` queues
>>
>> 'sentence'? You mean 'decoder command'?
> 
> Sequence. :)

Ah, that makes a lot more sense!

> 
>>
>>> +   are streaming. For compatibility reasons, the call to
>>> +   :c:func:`VIDIOC_DECODER_CMD` will not fail even if any of the queues is not
>>> +   streaming, but at the same time it will not initiate the `Drain` sequence
>>> +   and so the steps described below would not be applicable.
>>> +
>>> +2. Any ``OUTPUT`` buffers queued by the client before the
>>> +   :c:func:`VIDIOC_DECODER_CMD` was issued will be processed and decoded as
>>> +   normal. The client must continue to handle both queues independently,
>>> +   similarly to normal decode operation. This includes,
>>> +
>>> +   * handling any operations triggered as a result of processing those buffers,
>>> +     such as the `Dynamic resolution change` sequence, before continuing with
>>> +     the drain sequence,
>>> +
>>> +   * queuing and dequeuing ``CAPTURE`` buffers, until a buffer marked with the
>>> +     ``V4L2_BUF_FLAG_LAST`` flag is dequeued,
>>> +
>>> +     .. warning::
>>> +
>>> +        The last buffer may be empty (with :c:type:`v4l2_buffer`
>>> +        ``bytesused`` = 0) and in such case it must be ignored by the client,
>>> +        as it does not contain a decoded frame.
>>> +
>>> +     .. note::
>>> +
>>> +        Any attempt to dequeue more buffers beyond the buffer marked with
>>> +        ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
>>> +        :c:func:`VIDIOC_DQBUF`.
>>> +
>>> +   * dequeuing processed ``OUTPUT`` buffers, until all the buffers queued
>>> +     before the ``V4L2_DEC_CMD_STOP`` command are dequeued.
>>> +
>>> +   * dequeuing the ``V4L2_EVENT_EOS`` event, if the client subscribed to it.
>>> +
>>> +   .. note::
>>> +
>>> +      For backwards compatibility, the decoder will signal a ``V4L2_EVENT_EOS``
>>> +      event when the last the last frame has been decoded and all frames are
>>
>> 'the last the last' -> the last
> 
> Ack.
> 
>>
>>> +      ready to be dequeued. It is a deprecated behavior and the client must not
>>> +      rely on it. The ``V4L2_BUF_FLAG_LAST`` buffer flag should be used
>>> +      instead.
>>> +
>>> +3. Once all the ``OUTPUT`` buffers queued before the ``V4L2_DEC_CMD_STOP`` call
>>> +   and the last ``CAPTURE`` buffer are dequeued, the decoder is stopped and it
>>
>> This sentence is a bit confusing. This is better IMHO:
>>
>> 3. Once all the ``OUTPUT`` buffers queued before the ``V4L2_DEC_CMD_STOP`` call
>>    are dequeued and the last ``CAPTURE`` buffer is dequeued, the decoder is stopped and it
>>
> 
> Ack.
> 
>>> +   will accept, but not process any newly queued ``OUTPUT`` buffers until the
>>
>> process any -> process, any
>>
> 
> Ack.
> 
>>> +   client issues any of the following operations:
>>> +
>>> +   * ``V4L2_DEC_CMD_START`` - the decoder will resume the operation normally,
>>> +
>>> +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
>>> +     ``CAPTURE`` queue - the decoder will resume the operation normally,
>>> +     however any ``CAPTURE`` buffers still in the queue will be returned to the
>>> +     client,
>>> +
>>> +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
>>> +     ``OUTPUT`` queue - any pending source buffers will be returned to the
>>> +     client and the `Seek` sequence will be triggered.
>>> +
>>> +.. note::
>>> +
>>> +   Once the drain sequence is initiated, the client needs to drive it to
>>> +   completion, as described by the steps above, unless it aborts the process by
>>> +   issuing :c:func:`VIDIOC_STREAMOFF` on any of the ``OUTPUT`` or ``CAPTURE``
>>> +   queues.  The client is not allowed to issue ``V4L2_DEC_CMD_START`` or
>>> +   ``V4L2_DEC_CMD_STOP`` again while the drain sequence is in progress and they
>>> +   will fail with -EBUSY error code if attempted.
>>> +
>>> +   Although mandatory, the availability of decoder commands may be queried
>>> +   using :c:func:`VIDIOC_TRY_DECODER_CMD`.
>>> +
>>> +End of stream
>>> +=============
>>> +
>>> +If the decoder encounters an end of stream marking in the stream, the decoder
>>> +will initiate the `Drain` sequence, which the client must handle as described
>>> +above, skipping the initial :c:func:`VIDIOC_DECODER_CMD`.
>>> +
>>> +Commit points
>>> +=============
>>> +
>>> +Setting formats and allocating buffers trigger changes in the behavior of the
>>> +decoder.
>>> +
>>> +1. Setting the format on the ``OUTPUT`` queue may change the set of formats
>>> +   supported/advertised on the ``CAPTURE`` queue. In particular, it also means
>>> +   that the ``CAPTURE`` format may be reset and the client must not rely on the
>>> +   previously set format being preserved.
>>> +
>>> +2. Enumerating formats on the ``CAPTURE`` queue always returns only formats
>>> +   supported for the current ``OUTPUT`` format.
>>> +
>>> +3. Setting the format on the ``CAPTURE`` queue does not change the list of
>>> +   formats available on the ``OUTPUT`` queue. An attempt to set the ``CAPTURE``
>>> +   format that is not supported for the currently selected ``OUTPUT`` format
>>> +   will result in the decoder adjusting the requested ``CAPTURE`` format to a
>>> +   supported one.
>>> +
>>> +4. Enumerating formats on the ``OUTPUT`` queue always returns the full set of
>>> +   supported coded formats, irrespectively of the current ``CAPTURE`` format.
>>> +
>>> +5. While buffers are allocated on the ``OUTPUT`` queue, the client must not
>>> +   change the format on the queue. Drivers will return the -EBUSY error code
>>> +   for any such format change attempt.
>>> +
>>> +To summarize, setting formats and allocation must always start with the
>>> +``OUTPUT`` queue and the ``OUTPUT`` queue is the master that governs the
>>> +set of supported formats for the ``CAPTURE`` queue.
>>> diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
>>> index fb7f8c26cf09..12d43fe711cf 100644
>>> --- a/Documentation/media/uapi/v4l/devices.rst
>>> +++ b/Documentation/media/uapi/v4l/devices.rst
>>> @@ -15,6 +15,7 @@ Interfaces
>>>      dev-output
>>>      dev-osd
>>>      dev-codec
>>> +    dev-decoder
>>>      dev-effect
>>>      dev-raw-vbi
>>>      dev-sliced-vbi
>>> diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> index 826f2305da01..ca5f2270a829 100644
>>> --- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
>>> @@ -32,6 +32,11 @@ Single-planar format structure
>>>       to a multiple of the scale factor of any smaller planes. For
>>>       example when the image format is YUV 4:2:0, ``width`` and
>>>       ``height`` must be multiples of two.
>>> +
>>> +     For compressed formats that contain the resolution information encoded
>>> +     inside the stream, when fed to a stateful mem2mem decoder, the fields
>>> +     may be zero to rely on the decoder to detect the right values. For more
>>> +     details see :ref:`decoder` and format descriptions.
>>>      * - __u32
>>>        - ``pixelformat``
>>>        - The pixel format or type of compression, set by the application.
>>> diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
>>> index b89e5621ae69..65dc096199ad 100644
>>> --- a/Documentation/media/uapi/v4l/v4l2.rst
>>> +++ b/Documentation/media/uapi/v4l/v4l2.rst
>>> @@ -53,6 +53,10 @@ Authors, in alphabetical order:
>>>
>>>    - Original author of the V4L2 API and documentation.
>>>
>>> +- Figa, Tomasz <tfiga@chromium.org>
>>> +
>>> +  - Documented the memory-to-memory decoder interface.
>>> +
>>>  - H Schimek, Michael <mschimek@gmx.at>
>>>
>>>    - Original author of the V4L2 API and documentation.
>>> @@ -61,6 +65,10 @@ Authors, in alphabetical order:
>>>
>>>    - Documented the Digital Video timings API.
>>>
>>> +- Osciak, Pawel <posciak@chromium.org>
>>> +
>>> +  - Documented the memory-to-memory decoder interface.
>>> +
>>>  - Osciak, Pawel <pawel@osciak.com>
>>>
>>>    - Designed and documented the multi-planar API.
>>> @@ -85,7 +93,7 @@ Authors, in alphabetical order:
>>>
>>>    - Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended control ioctls, major parts of the sliced VBI API, the MPEG encoder and decoder APIs and the DV Timings API.
>>>
>>> -**Copyright** |copy| 1999-2016: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari.
>>> +**Copyright** |copy| 1999-2018: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari, Tomasz Figa
>>>
>>>  Except when explicitly stated as GPL, programming examples within this
>>>  part can be used and distributed without restrictions.
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
>>> index 85c916b0ce07..2f73fe22a9cd 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
>>> @@ -49,14 +49,16 @@ The ``cmd`` field must contain the command code. Some commands use the
>>>
>>>  A :ref:`write() <func-write>` or :ref:`VIDIOC_STREAMON`
>>>  call sends an implicit START command to the decoder if it has not been
>>> -started yet.
>>> +started yet. Applies to both queues of mem2mem decoders.
>>>
>>>  A :ref:`close() <func-close>` or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>`
>>>  call of a streaming file descriptor sends an implicit immediate STOP
>>> -command to the decoder, and all buffered data is discarded.
>>> +command to the decoder, and all buffered data is discarded. Applies to both
>>> +queues of mem2mem decoders.
>>>
>>> -These ioctls are optional, not all drivers may support them. They were
>>> -introduced in Linux 3.3.
>>> +In principle, these ioctls are optional, not all drivers may support them. They were
>>> +introduced in Linux 3.3. They are, however, mandatory for stateful mem2mem decoders
>>> +(as further documented in :ref:`decoder`).
>>>
>>>
>>>  .. tabularcolumns:: |p{1.1cm}|p{2.4cm}|p{1.2cm}|p{1.6cm}|p{10.6cm}|
>>> @@ -160,26 +162,36 @@ introduced in Linux 3.3.
>>>       ``V4L2_DEC_CMD_RESUME`` for that. This command has one flag:
>>>       ``V4L2_DEC_CMD_START_MUTE_AUDIO``. If set, then audio will be
>>>       muted when playing back at a non-standard speed.
>>> +
>>> +     For stateful mem2mem decoders, the command may be also used to restart
>>> +     the decoder in case of an implicit stop initiated by the decoder
>>> +     itself, without the ``V4L2_DEC_CMD_STOP`` being called explicitly.
>>> +     No flags or other arguments are accepted in case of mem2mem decoders.
>>> +     See :ref:`decoder` for more details.
>>>      * - ``V4L2_DEC_CMD_STOP``
>>>        - 1
>>>        - Stop the decoder. When the decoder is already stopped, this
>>>       command does nothing. This command has two flags: if
>>>       ``V4L2_DEC_CMD_STOP_TO_BLACK`` is set, then the decoder will set
>>>       the picture to black after it stopped decoding. Otherwise the last
>>> -     image will repeat. mem2mem decoders will stop producing new frames
>>> -     altogether. They will send a ``V4L2_EVENT_EOS`` event when the
>>> -     last frame has been decoded and all frames are ready to be
>>> -     dequeued and will set the ``V4L2_BUF_FLAG_LAST`` buffer flag on
>>> -     the last buffer of the capture queue to indicate there will be no
>>> -     new buffers produced to dequeue. This buffer may be empty,
>>> -     indicated by the driver setting the ``bytesused`` field to 0. Once
>>> -     the ``V4L2_BUF_FLAG_LAST`` flag was set, the
>>> -     :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
>>> -     but return an ``EPIPE`` error code. If
>>> +     image will repeat. If
>>>       ``V4L2_DEC_CMD_STOP_IMMEDIATELY`` is set, then the decoder stops
>>>       immediately (ignoring the ``pts`` value), otherwise it will keep
>>>       decoding until timestamp >= pts or until the last of the pending
>>>       data from its internal buffers was decoded.
>>> +
>>> +     A stateful mem2mem decoder will proceed with decoding the source
>>> +     buffers pending before the command is issued and then stop producing
>>> +     new frames. It will send a ``V4L2_EVENT_EOS`` event when the last frame
>>> +     has been decoded and all frames are ready to be dequeued and will set
>>> +     the ``V4L2_BUF_FLAG_LAST`` buffer flag on the last buffer of the
>>> +     capture queue to indicate there will be no new buffers produced to
>>> +     dequeue. This buffer may be empty, indicated by the driver setting the
>>> +     ``bytesused`` field to 0. Once the buffer with the
>>> +     ``V4L2_BUF_FLAG_LAST`` flag set was dequeued, the :ref:`VIDIOC_DQBUF
>>> +     <VIDIOC_QBUF>` ioctl will not block anymore, but return an ``EPIPE``
>>> +     error code. No flags or other arguments are accepted in case of mem2mem
>>> +     decoders.  See :ref:`decoder` for more details.
>>>      * - ``V4L2_DEC_CMD_PAUSE``
>>>        - 2
>>>        - Pause the decoder. When the decoder has not been started yet, the
>>> diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
>>> index 3ead350e099f..0fc0b78a943e 100644
>>> --- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
>>> +++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
>>> @@ -53,6 +53,13 @@ devices that is either the struct
>>>  member. When the requested buffer type is not supported drivers return
>>>  an ``EINVAL`` error code.
>>>
>>> +A stateful mem2mem decoder will not allow operations on the
>>> +``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``
>>> +buffer type until the corresponding ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or
>>> +``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` buffer type is configured. If such an
>>> +operation is attempted, drivers return an ``EACCES`` error code. Refer to
>>> +:ref:`decoder` for more details.
>>
>> This isn't right. EACCES is returned as long as the output format resolution is
>> unknown. If it is set explicitly, then this will work without an error.

Ah, sorry, I phrased that poorly. Let me try again:

This isn't right. EACCES is returned for CAPTURE operations as long as the
output format resolution is unknown or the CAPTURE format is explicitly set.
If the CAPTURE format is set explicitly, then this will work without an error.

> 
> I think that's what is written above. The stream resolution is known
> when the applicable OUTPUT queue is configured, which lets the driver
> determine the format constraints on the applicable CAPTURE queue. If
> it's not clear, could you help rephrasing?
> 
>>
>>> +
>>>  To change the current format parameters applications initialize the
>>>  ``type`` field and all fields of the respective ``fmt`` union member.
>>>  For details see the documentation of the various devices types in
>>> @@ -145,6 +152,13 @@ On success 0 is returned, on error -1 and the ``errno`` variable is set
>>>  appropriately. The generic error codes are described at the
>>>  :ref:`Generic Error Codes <gen-errors>` chapter.
>>>
>>> +EACCES
>>> +    The format is not accessible until another buffer type is configured.
>>> +    Relevant for the V4L2_BUF_TYPE_VIDEO_CAPTURE and
>>> +    V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE buffer types of mem2mem decoders, which
>>> +    require the format of V4L2_BUF_TYPE_VIDEO_OUTPUT or
>>> +    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer type to be configured first.
>>
>> Ditto.
> 
> Ditto.
> 
> Best regards,
> Tomasz
> 

Regards,

	Hans
