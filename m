Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38092 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755072AbeFNMed (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 08:34:33 -0400
Received: by mail-wr0-f194.google.com with SMTP id e18-v6so6269092wrs.5
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 05:34:32 -0700 (PDT)
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        =?UTF-8?B?UGF3ZcWCIE/Fm2NpYWs=?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
 <20180605103328.176255-2-tfiga@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <89dca3ae-cbbc-4b5b-1c8a-207951997839@linaro.org>
Date: Thu, 14 Jun 2018 15:34:27 +0300
MIME-Version: 1.0
In-Reply-To: <20180605103328.176255-2-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,


On 06/05/2018 01:33 PM, Tomasz Figa wrote:
> Due to complexity of the video decoding process, the V4L2 drivers of
> stateful decoder hardware require specific sequencies of V4L2 API calls
> to be followed. These include capability enumeration, initialization,
> decoding, seek, pause, dynamic resolution change, flush and end of
> stream.
> 
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or mtk-vcodec.
> 
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the decoder part of
> the Codec API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-codec.rst | 771 +++++++++++++++++++++
>  Documentation/media/uapi/v4l/v4l2.rst      |  14 +-
>  2 files changed, 784 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
> index c61e938bd8dc..0483b10c205e 100644
> --- a/Documentation/media/uapi/v4l/dev-codec.rst
> +++ b/Documentation/media/uapi/v4l/dev-codec.rst

<snip>

> +Initialization sequence
> +-----------------------
> +
> +1. (optional) Enumerate supported OUTPUT formats and resolutions. See
> +   capability enumeration.
> +
> +2. Set a coded format on the source queue via :c:func:`VIDIOC_S_FMT`
> +
> +   a. Required fields:
> +
> +      i.   type = OUTPUT
> +
> +      ii.  fmt.pix_mp.pixelformat set to a coded format
> +
> +      iii. fmt.pix_mp.width, fmt.pix_mp.height only if cannot be
> +           parsed from the stream for the given coded format;
> +           ignored otherwise;

Can we say that if width != 0 and height != 0 then the user knows the
real coded resolution? And vise versa if width/height are both zero the
driver should parse the stream metadata?

Also what about fmt.pix_mp.plane_fmt.sizeimage, as per spec (S_FMT) this
field should be filled with correct image size? If the coded
width/height is zero sizeimage will be unknown. I think we have two
options, the user fill sizeimage with bigger enough size or the driver
has to have some default size.

> +
> +   b. Return values:
> +
> +      i.  EINVAL: unsupported format.
> +
> +      ii. Others: per spec
> +
> +   .. note::
> +
> +      The driver must not adjust pixelformat, so if
> +      ``V4L2_PIX_FMT_H264`` is passed but only
> +      ``V4L2_PIX_FMT_H264_SLICE`` is supported, S_FMT will return
> +      -EINVAL. If both are acceptable by client, calling S_FMT for
> +      the other after one gets rejected may be required (or use
> +      :c:func:`VIDIOC_ENUM_FMT` to discover beforehand, see Capability
> +      enumeration).
> +
> +3.  (optional) Get minimum number of buffers required for OUTPUT queue
> +    via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to use
> +    more buffers than minimum required by hardware/format (see
> +    allocation).
> +
> +    a. Required fields:
> +
> +       i. id = ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
> +
> +    b. Return values: per spec.
> +
> +    c. Return fields:
> +
> +       i. value: required number of OUTPUT buffers for the currently set
> +          format;
> +
> +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` on OUTPUT
> +    queue.
> +
> +    a. Required fields:
> +
> +       i.   count = n, where n > 0.
> +
> +       ii.  type = OUTPUT
> +
> +       iii. memory = as per spec
> +
> +    b. Return values: Per spec.
> +
> +    c. Return fields:
> +
> +       i. count: adjusted to allocated number of buffers
> +
> +    d. The driver must adjust count to minimum of required number of
> +       source buffers for given format and count passed. The client
> +       must check this value after the ioctl returns to get the
> +       number of buffers allocated.
> +
> +    .. note::
> +
> +       Passing count = 1 is useful for letting the driver choose
> +       the minimum according to the selected format/hardware
> +       requirements.
> +
> +    .. note::
> +
> +       To allocate more than minimum number of buffers (for pipeline
> +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT)`` to
> +       get minimum number of buffers required by the driver/format,
> +       and pass the obtained value plus the number of additional
> +       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
> +
> +5.  Begin parsing the stream for stream metadata via :c:func:`VIDIOC_STREAMON` on
> +    OUTPUT queue. This step allows the driver to parse/decode
> +    initial stream metadata until enough information to allocate
> +    CAPTURE buffers is found. This is indicated by the driver by
> +    sending a ``V4L2_EVENT_SOURCE_CHANGE`` event, which the client
> +    must handle.
> +
> +    a. Required fields: as per spec.
> +
> +    b. Return values: as per spec.
> +
> +    .. note::
> +
> +       Calling :c:func:`VIDIOC_REQBUFS`, :c:func:`VIDIOC_STREAMON`
> +       or :c:func:`VIDIOC_G_FMT` on the CAPTURE queue at this time is not
> +       allowed and must return EINVAL.
> +
> +6.  This step only applies for coded formats that contain resolution
> +    information in the stream.

maybe an example of such coded formats will be good to have.

> +    Continue queuing/dequeuing bitstream buffers to/from the
> +    OUTPUT queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`. The driver
> +    must keep processing and returning each buffer to the client
> +    until required metadata to send a ``V4L2_EVENT_SOURCE_CHANGE``
> +    for source change type ``V4L2_EVENT_SRC_CH_RESOLUTION`` is
> +    found. There is no requirement to pass enough data for this to
> +    occur in the first buffer and the driver must be able to
> +    process any number
> +
> +    a. Required fields: as per spec.
> +
> +    b. Return values: as per spec.
> +
> +    c. If data in a buffer that triggers the event is required to decode
> +       the first frame, the driver must not return it to the client,
> +       but must retain it for further decoding.
> +
> +    d. Until the resolution source event is sent to the client, calling
> +       :c:func:`VIDIOC_G_FMT` on the CAPTURE queue must return -EINVAL.
> +
> +    .. note::
> +
> +       No decoded frames are produced during this phase.
> +

<snip>

-- 
regards,
Stan
