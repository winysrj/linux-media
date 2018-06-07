Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:47999 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932188AbeFGJVu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Jun 2018 05:21:50 -0400
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
 to Codec Interfaces
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
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
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
 <20180605103328.176255-3-tfiga@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <32e8a7b8-5629-c089-7375-0513512784ff@xs4all.nl>
Date: Thu, 7 Jun 2018 11:21:44 +0200
MIME-Version: 1.0
In-Reply-To: <20180605103328.176255-3-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/05/2018 12:33 PM, Tomasz Figa wrote:
> Due to complexity of the video encoding process, the V4L2 drivers of
> stateful encoder hardware require specific sequencies of V4L2 API calls

sequences

> to be followed. These include capability enumeration, initialization,
> encoding, encode parameters change and flush.
> 
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or mtk-vcodec.
> 
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the encoder part of
> the Codec API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-codec.rst | 313 +++++++++++++++++++++
>  1 file changed, 313 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
> index 0483b10c205e..325a51bb09df 100644
> --- a/Documentation/media/uapi/v4l/dev-codec.rst
> +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> @@ -805,3 +805,316 @@ of the driver.
>  To summarize, setting formats and allocation must always start with the
>  OUTPUT queue and the OUTPUT queue is the master that governs the set of
>  supported formats for the CAPTURE queue.
> +
> +Encoder
> +=======
> +
> +Querying capabilities
> +---------------------
> +
> +1. To enumerate the set of coded formats supported by the driver, the
> +   client uses :c:func:`VIDIOC_ENUM_FMT` for CAPTURE. The driver must always
> +   return the full set of supported formats, irrespective of the
> +   format set on the OUTPUT queue.
> +
> +2. To enumerate the set of supported raw formats, the client uses
> +   :c:func:`VIDIOC_ENUM_FMT` for OUTPUT queue. The driver must return only
> +   the formats supported for the format currently set on the
> +   CAPTURE queue.
> +   In order to enumerate raw formats supported by a given coded
> +   format, the client must first set that coded format on the
> +   CAPTURE queue and then enumerate the OUTPUT queue.
> +
> +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect supported
> +   resolutions for a given format, passing its fourcc in
> +   :c:type:`v4l2_frmivalenum` ``pixel_format``.
> +
> +   a. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for coded formats
> +      must be maximums for given coded format for all supported raw
> +      formats.
> +
> +   b. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for raw formats must
> +      be maximums for given raw format for all supported coded
> +      formats.
> +
> +   c. The client should derive the supported resolution for a
> +      combination of coded+raw format by calculating the
> +      intersection of resolutions returned from calls to
> +      :c:func:`VIDIOC_ENUM_FRAMESIZES` for the given coded and raw formats.
> +
> +4. Supported profiles and levels for given format, if applicable, may be
> +   queried using their respective controls via :c:func:`VIDIOC_QUERYCTRL`.
> +
> +5. The client may use :c:func:`VIDIOC_ENUM_FRAMEINTERVALS` to enumerate maximum
> +   supported framerates by the driver/hardware for a given
> +   format+resolution combination.
> +
> +6. Any additional encoder capabilities may be discovered by querying
> +   their respective controls.
> +
> +.. note::
> +
> +   Full format enumeration requires enumerating all raw formats
> +   on the OUTPUT queue for all possible (enumerated) coded formats on
> +   CAPTURE queue (setting each format on the CAPTURE queue before each
> +   enumeration on the OUTPUT queue.
> +
> +Initialization
> +--------------
> +
> +1. (optional) Enumerate supported formats and resolutions. See
> +   capability enumeration.
> +
> +2. Set a coded format on the CAPTURE queue via :c:func:`VIDIOC_S_FMT`
> +
> +   a. Required fields:
> +
> +      i.  type = CAPTURE
> +
> +      ii. fmt.pix_mp.pixelformat set to a coded format to be produced
> +
> +   b. Return values:
> +
> +      i.  EINVAL: unsupported format.

I'm still not sure about returning an error in this case.

And what should TRY_FMT do?

Do you know what current codecs do? Return EINVAL or replace with a supported format?

It would be nice to standardize on one rule or another.

The spec says that it should always return a valid format, but not all drivers adhere
to that. Perhaps we need to add a flag to let the driver signal the behavior of S_FMT
to userspace.

This is a long-standing issue with S_FMT, actually.

> +
> +      ii. Others: per spec
> +
> +   c. Return fields:
> +
> +      i. fmt.pix_mp.width, fmt.pix_mp.height should be 0.
> +
> +   .. note::
> +
> +      After a coded format is set, the set of raw formats
> +      supported as source on the OUTPUT queue may change.
> +
> +3. (optional) Enumerate supported OUTPUT formats (raw formats for
> +   source) for the selected coded format via :c:func:`VIDIOC_ENUM_FMT`.
> +
> +   a. Required fields:
> +
> +      i.  type = OUTPUT
> +
> +      ii. index = per spec
> +
> +   b. Return values: per spec
> +
> +   c. Return fields:
> +
> +      i. pixelformat: raw format supported for the coded format
> +         currently selected on the OUTPUT queue.
> +
> +4. Set a raw format on the OUTPUT queue and visible resolution for the
> +   source raw frames via :c:func:`VIDIOC_S_FMT` on the OUTPUT queue.
> +
> +   a. Required fields:
> +
> +      i.   type = OUTPUT
> +
> +      ii.  fmt.pix_mp.pixelformat = raw format to be used as source of
> +           encode
> +
> +      iii. fmt.pix_mp.width, fmt.pix_mp.height = input resolution
> +           for the source raw frames
> +
> +      iv.  num_planes: set to number of planes for pixelformat.
> +
> +      v.   For each plane p = [0, num_planes-1]:
> +           plane_fmt[p].sizeimage, plane_fmt[p].bytesperline: as
> +           per spec for input resolution.
> +
> +   b. Return values: as per spec.
> +
> +   c. Return fields:
> +
> +      i.  fmt.pix_mp.width, fmt.pix_mp.height = may be adjusted by
> +          driver to match alignment requirements, as required by the
> +          currently selected formats.
> +
> +      ii. For each plane p = [0, num_planes-1]:
> +          plane_fmt[p].sizeimage, plane_fmt[p].bytesperline: as
> +          per spec for the adjusted input resolution.
> +
> +   d. Setting the input resolution will reset visible resolution to the
> +      adjusted input resolution rounded up to the closest visible
> +      resolution supported by the driver. Similarly, coded size will
> +      be reset to input resolution rounded up to the closest coded
> +      resolution supported by the driver (typically a multiple of
> +      macroblock size).
> +
> +5. (optional) Set visible size for the stream metadata via

What exactly do you mean with 'stream metadata'? Definitely something for
the glossary.

> +   :c:func:`VIDIOC_S_SELECTION` on the OUTPUT queue.
> +
> +   a. Required fields:
> +
> +      i.   type = OUTPUT
> +
> +      ii.  target = ``V4L2_SEL_TGT_CROP``
> +
> +      iii. r.left, r.top, r.width, r.height: visible rectangle; this
> +           must fit within coded resolution returned from

from -> by

> +           :c:func:`VIDIOC_S_FMT`.
> +
> +   b. Return values: as per spec.
> +
> +   c. Return fields:
> +
> +      i. r.left, r.top, r.width, r.height: visible rectangle adjusted by
> +         the driver to match internal constraints.
> +
> +   d. This resolution must be used as the visible resolution in the
> +      stream metadata.
> +
> +   .. note::
> +
> +      The driver might not support arbitrary values of the
> +      crop rectangle and will adjust it to the closest supported
> +      one.
> +
> +6. Allocate buffers for both OUTPUT and CAPTURE queues via
> +   :c:func:`VIDIOC_REQBUFS`. This may be performed in any order.
> +
> +   a. Required fields:
> +
> +      i.   count = n, where n > 0.
> +
> +      ii.  type = OUTPUT or CAPTURE
> +
> +      iii. memory = as per spec
> +
> +   b. Return values: Per spec.
> +
> +   c. Return fields:
> +
> +      i. count: adjusted to allocated number of buffers
> +
> +   d. The driver must adjust count to minimum of required number of
> +      buffers for given format and count passed. The client must
> +      check this value after the ioctl returns to get the number of
> +      buffers actually allocated.
> +
> +   .. note::
> +
> +      Passing count = 1 is useful for letting the driver choose the
> +      minimum according to the selected format/hardware
> +      requirements.
> +
> +   .. note::
> +
> +      To allocate more than minimum number of buffers (for pipeline
> +      depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT)`` or
> +      G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE)``, respectively,
> +      to get the minimum number of buffers required by the
> +      driver/format, and pass the obtained value plus the number of
> +      additional buffers needed in count field to :c:func:`VIDIOC_REQBUFS`.
> +
> +7. Begin streaming on both OUTPUT and CAPTURE queues via
> +   :c:func:`VIDIOC_STREAMON`. This may be performed in any order.
> +
> +Encoding
> +--------
> +
> +This state is reached after a successful initialization sequence. In
> +this state, client queues and dequeues buffers to both queues via
> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, as per spec.
> +
> +Both queues operate independently. The client may queue and dequeue
> +buffers to queues in any order and at any rate, also at a rate different
> +for each queue. The client may queue buffers within the same queue in
> +any order (V4L2 index-wise).

I'd drop the whole 'in any order' in the text above. This has always been
the case, and I think it is only confusing. I think what you really want
to say is that both queues operate independently and quite possibly at
different rates. So clients should operate them independently as well.

 It is recommended for the client to operate
> +the queues independently for best performance.
> +
> +Source OUTPUT buffers must contain full raw frames in the selected
> +OUTPUT format, exactly one frame per buffer.
> +
> +Encoding parameter changes
> +--------------------------
> +
> +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> +parameters at any time. The driver must apply the new setting starting
> +at the next frame queued to it.
> +
> +This specifically means that if the driver maintains a queue of buffers
> +to be encoded and at the time of the call to :c:func:`VIDIOC_S_CTRL` not all the
> +buffers in the queue are processed yet, the driver must not apply the
> +change immediately, but schedule it for when the next buffer queued
> +after the :c:func:`VIDIOC_S_CTRL` starts being processed.

Is this what drivers do today? I thought it was applied immediately?
This sounds like something for which you need the Request API.

> +
> +Flush
> +-----
> +
> +Flush is the process of draining the CAPTURE queue of any remaining
> +buffers. After the flush sequence is complete, the client has received
> +all encoded frames for all OUTPUT buffers queued before the sequence was
> +started.
> +
> +1. Begin flush by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> +
> +   a. Required fields:
> +
> +      i. cmd = ``V4L2_ENC_CMD_STOP``
> +
> +2. The driver must process and encode as normal all OUTPUT buffers
> +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued.

Note: TRY_ENCODER_CMD should also be supported, likely via a standard helper
in v4l2-mem2mem.c.

> +
> +3. Once all OUTPUT buffers queued before ``V4L2_ENC_CMD_STOP`` are
> +   processed:
> +
> +   a. Once all decoded frames (if any) are ready to be dequeued on the
> +      CAPTURE queue, the driver must send a ``V4L2_EVENT_EOS``. The
> +      driver must also set ``V4L2_BUF_FLAG_LAST`` in
> +      :c:type:`v4l2_buffer` ``flags`` field on the buffer on the CAPTURE queue
> +      containing the last frame (if any) produced as a result of
> +      processing the OUTPUT buffers queued before
> +      ``V4L2_ENC_CMD_STOP``. If no more frames are left to be
> +      returned at the point of handling ``V4L2_ENC_CMD_STOP``, the
> +      driver must return an empty buffer (with
> +      :c:type:`v4l2_buffer` ``bytesused`` = 0) as the last buffer with
> +      ``V4L2_BUF_FLAG_LAST`` set instead.
> +      Any attempts to dequeue more buffers beyond the buffer
> +      marked with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE
> +      error from :c:func:`VIDIOC_DQBUF`.
> +
> +4. At this point, encoding is paused and the driver will accept, but not
> +   process any newly queued OUTPUT buffers until the client issues
> +   ``V4L2_ENC_CMD_START`` or :c:func:`VIDIOC_STREAMON`.

STREAMON on which queue? Shouldn't there be a STREAMOFF first?

> +
> +Once the flush sequence is initiated, the client needs to drive it to
> +completion, as described by the above steps, unless it aborts the
> +process by issuing :c:func:`VIDIOC_STREAMOFF` on OUTPUT queue. The client is not
> +allowed to issue ``V4L2_ENC_CMD_START`` or ``V4L2_ENC_CMD_STOP`` again
> +while the flush sequence is in progress.
> +
> +Issuing :c:func:`VIDIOC_STREAMON` on OUTPUT queue will implicitly restart
> +encoding.

This feels wrong. Calling STREAMON on a queue that is already streaming does nothing
according to the spec. I think you should either call CMD_START or STREAMOFF/ON on
the OUTPUT queue. Of course, calling STREAMOFF first will dequeue any queued OUTPUT
buffers that were queued since ENC_CMD_STOP was called. But that's normal behavior
for STREAMOFF.

 :c:func:`VIDIOC_STREAMON` and :c:func:`VIDIOC_STREAMOFF` on CAPTURE queue will
> +not affect the flush sequence, allowing the client to change CAPTURE
> +buffer set if needed.
> +
> +Commit points
> +-------------
> +
> +Setting formats and allocating buffers triggers changes in the behavior
> +of the driver.
> +
> +1. Setting format on CAPTURE queue may change the set of formats
> +   supported/advertised on the OUTPUT queue. It also must change the
> +   format currently selected on OUTPUT queue if it is not supported
> +   by the newly selected CAPTURE format to a supported one.
> +
> +2. Enumerating formats on OUTPUT queue must only return OUTPUT formats
> +   supported for the CAPTURE format currently set.
> +
> +3. Setting/changing format on OUTPUT queue does not change formats
> +   available on CAPTURE queue. An attempt to set OUTPUT format that
> +   is not supported for the currently selected CAPTURE format must
> +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
> +
> +4. Enumerating formats on CAPTURE queue always returns a full set of
> +   supported coded formats, irrespective of the current format
> +   selected on OUTPUT queue.
> +
> +5. After allocating buffers on a queue, it is not possible to change
> +   format on it.
> +
> +In summary, the CAPTURE (coded format) queue is the master that governs
> +the set of supported formats for the OUTPUT queue.
> 

Regards,

	Hans
