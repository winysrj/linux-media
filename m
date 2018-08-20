Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53935 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbeHTQTo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 12:19:44 -0400
Message-ID: <1534770242.5445.13.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
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
Date: Mon, 20 Aug 2018 15:04:02 +0200
In-Reply-To: <20180724140621.59624-2-tfiga@chromium.org>
References: <20180724140621.59624-1-tfiga@chromium.org>
         <20180724140621.59624-2-tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
[...]
> +Seek
> +====
> +
> +Seek is controlled by the ``OUTPUT`` queue, as it is the source of
> +bitstream data. ``CAPTURE`` queue remains unchanged/unaffected.
> +
> +1. Stop the ``OUTPUT`` queue to begin the seek sequence via
> +   :c:func:`VIDIOC_STREAMOFF`.
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> +
> +   * The driver must drop all the pending ``OUTPUT`` buffers and they are
> +     treated as returned to the client (following standard semantics).
> +
> +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
> +
> +   * **Required fields:**
> +
> +     ``type``
> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> +
> +   * The driver must be put in a state after seek and be ready to
> +     accept new source bitstream buffers.
> +
> +3. Start queuing buffers to ``OUTPUT`` queue containing stream data after
> +   the seek until a suitable resume point is found.
> +
> +   .. note::
> +
> +      There is no requirement to begin queuing stream starting exactly from
> +      a resume point (e.g. SPS or a keyframe). The driver must handle any
> +      data queued and must keep processing the queued buffers until it
> +      finds a suitable resume point. While looking for a resume point, the

I think the definition of a resume point is too vague in this place.
Can the driver decide whether or not a keyframe without SPS is a
suitable resume point? Or do drivers have to parse and store SPS/PPS if
the hardware does not support resuming from a keyframe without sending
SPS/PPS again?

regards
Philipp
