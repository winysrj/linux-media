Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59991 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728963AbeGYOxC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:53:02 -0400
Message-ID: <1532526073.4879.6.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        ezequiel@collabora.com
Date: Wed, 25 Jul 2018 15:41:13 +0200
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

Thanks a lot for the update, 
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
[...]
> +
> +Commit points
> +=============
> +
> +Setting formats and allocating buffers triggers changes in the behavior
> +of the driver.
> +
> +1. Setting format on ``CAPTURE`` queue may change the set of formats
> +   supported/advertised on the ``OUTPUT`` queue. In particular, it also
> +   means that ``OUTPUT`` format may be reset and the client must not
> +   rely on the previously set format being preserved.

Since the only property of the CAPTURE format that can be set directly
via S_FMT is the pixelformat, should this be made explicit?

1. Setting pixelformat on ``CAPTURE`` queue may change the set of
   formats supported/advertised on the ``OUTPUT`` queue. In particular,
   it also means that ``OUTPUT`` format may be reset and the client
   must not rely on the previously set format being preserved.

?

> +2. Enumerating formats on ``OUTPUT`` queue must only return formats
> +   supported for the ``CAPTURE`` format currently set.

Same here, as it usually is the codec selected by CAPTURE pixelformat
that determines the supported OUTPUT pixelformats and resolutions.

2. Enumerating formats on ``OUTPUT`` queue must only return formats
   supported for the ``CAPTURE`` pixelformat currently set.

This could prevent the possible misconception that the CAPTURE
width/height might in any form limit the OUTPUT format, when in fact it
is determined by it.

> +3. Setting/changing format on ``OUTPUT`` queue does not change formats
> +   available on ``CAPTURE`` queue.

3. Setting/changing format on the ``OUTPUT`` queue does not change
   pixelformats available on the ``CAPTURE`` queue.

?

Because setting OUTPUT width/height or CROP SELECTION very much limits
the possible values of CAPTURE width/height.

Maybe 'available' in this context should be specified somewhere to mean
'returned by ENUM_FMT and allowed by S_FMT/TRY_FMT'.

> +   An attempt to set ``OUTPUT`` format that
> +   is not supported for the currently selected ``CAPTURE`` format must
> +   result in the driver adjusting the requested format to an acceptable
> +   one.

   An attempt to set ``OUTPUT`` format that is not supported for the
  
currently selected ``CAPTURE`` pixelformat must result in the driver
  
adjusting the requested format to an acceptable one.

> +4. Enumerating formats on ``CAPTURE`` queue always returns the full set of
> +   supported coded formats, irrespective of the current ``OUTPUT``
> +   format.
> +
> +5. After allocating buffers on the ``CAPTURE`` queue, it is not possible to
> +   change format on it.
> +
> +To summarize, setting formats and allocation must always start with the
> +``CAPTURE`` queue and the ``CAPTURE`` queue is the master that governs the
> +set of supported formats for the ``OUTPUT`` queue.

To summarize, setting formats and allocation must always start with
setting the encoded pixelformat on the ``CAPTURE`` queue. The
``CAPTURE`` queue is the master that governs the set of supported
formats for the ``OUTPUT`` queue.

Or is this too verbose?

regards
Philipp
