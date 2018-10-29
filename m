Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54979 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbeJ2Sdp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Oct 2018 14:33:45 -0400
Received: by mail-wm1-f67.google.com with SMTP id r63-v6so7479606wma.4
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2018 02:45:50 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
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
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
References: <20181022144901.113852-1-tfiga@chromium.org>
 <20181022144901.113852-2-tfiga@chromium.org>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <31c175d6-b1e9-f8d7-0b8b-821271a59a70@linaro.org>
Date: Mon, 29 Oct 2018 11:45:46 +0200
MIME-Version: 1.0
In-Reply-To: <20181022144901.113852-2-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 10/22/2018 05:48 PM, Tomasz Figa wrote:
> Due to complexity of the video decoding process, the V4L2 drivers of
> stateful decoder hardware require specific sequences of V4L2 API calls
> to be followed. These include capability enumeration, initialization,
> decoding, seek, pause, dynamic resolution change, drain and end of
> stream.
> 
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or coda.
> 
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the decoder part of
> the Codec API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-decoder.rst  | 1082 +++++++++++++++++
>  Documentation/media/uapi/v4l/devices.rst      |    1 +
>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
>  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
>  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
>  6 files changed, 1137 insertions(+), 15 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> 
> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
> new file mode 100644
> index 000000000000..09c7a6621b8e
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst

<cut>

> +Capture setup
> +=============
> +

<cut>

> +
> +2.  **Optional.** Acquire the visible resolution via
> +    :c:func:`VIDIOC_G_SELECTION`.
> +
> +    * **Required fields:**
> +
> +      ``type``
> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> +
> +      ``target``
> +          set to ``V4L2_SEL_TGT_COMPOSE``
> +
> +    * **Return fields:**
> +
> +      ``r.left``, ``r.top``, ``r.width``, ``r.height``
> +          the visible rectangle; it must fit within the frame buffer resolution
> +          returned by :c:func:`VIDIOC_G_FMT` on ``CAPTURE``.
> +
> +    * The following selection targets are supported on ``CAPTURE``:
> +
> +      ``V4L2_SEL_TGT_CROP_BOUNDS``
> +          corresponds to the coded resolution of the stream
> +
> +      ``V4L2_SEL_TGT_CROP_DEFAULT``
> +          the rectangle covering the part of the ``CAPTURE`` buffer that
> +          contains meaningful picture data (visible area); width and height
> +          will be equal to the visible resolution of the stream
> +
> +      ``V4L2_SEL_TGT_CROP``
> +          the rectangle within the coded resolution to be output to
> +          ``CAPTURE``; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``; read-only on
> +          hardware without additional compose/scaling capabilities

Hans should correct me if I'm wrong but V4L2_SEL_TGT_CROP_xxx are
applicable over OUTPUT queue type?

> +
> +      ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> +          the maximum rectangle within a ``CAPTURE`` buffer, which the cropped
> +          frame can be output into; equal to ``V4L2_SEL_TGT_CROP`` if the
> +          hardware does not support compose/scaling
> +
> +      ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
> +          equal to ``V4L2_SEL_TGT_CROP``
> +
> +      ``V4L2_SEL_TGT_COMPOSE``
> +          the rectangle inside a ``CAPTURE`` buffer into which the cropped
> +          frame is written; defaults to ``V4L2_SEL_TGT_COMPOSE_DEFAULT``;
> +          read-only on hardware without additional compose/scaling capabilities
> +
> +      ``V4L2_SEL_TGT_COMPOSE_PADDED``
> +          the rectangle inside a ``CAPTURE`` buffer which is overwritten by the
> +          hardware; equal to ``V4L2_SEL_TGT_COMPOSE`` if the hardware does not
> +          write padding pixels
> +
> +    .. warning::
> +
> +       The values are guaranteed to be meaningful only after the decoder
> +       successfully parses the stream metadata. The client must not rely on the
> +       query before that happens.
> +

-- 
regards,
Stan
