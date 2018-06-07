Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60431 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753088AbeFGKkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 06:40:03 -0400
Message-ID: <1528367999.3308.7.camel@pengutronix.de>
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
 to Codec Interfaces
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_O=C5=9Bciak?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 07 Jun 2018 12:39:59 +0200
In-Reply-To: <32e8a7b8-5629-c089-7375-0513512784ff@xs4all.nl>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-3-tfiga@chromium.org>
         <32e8a7b8-5629-c089-7375-0513512784ff@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-06-07 at 11:21 +0200, Hans Verkuil wrote:
[...]
> > +Encoder
> > +=======
[...]
> > +Initialization
> > +--------------
> > +
> > +1. (optional) Enumerate supported formats and resolutions. See
> > +   capability enumeration.
> > +
> > +2. Set a coded format on the CAPTURE queue via :c:func:`VIDIOC_S_FMT`
> > +
> > +   a. Required fields:
> > +
> > +      i.  type = CAPTURE
> > +
> > +      ii. fmt.pix_mp.pixelformat set to a coded format to be produced
> > +
> > +   b. Return values:
> > +
> > +      i.  EINVAL: unsupported format.
> 
> I'm still not sure about returning an error in this case.
>
> And what should TRY_FMT do?

Also the documentation currently states in [1]:

  Drivers should not return an error code unless the type field is
 
invalid, this is a mechanism to fathom device capabilities and to
 
approach parameters acceptable for both the application and driver. 

[1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-g-fmt.html

> Do you know what current codecs do? Return EINVAL or replace with a supported format?

At least coda replaces incorrect pixelformat with a supported format.

> It would be nice to standardize on one rule or another.
> 
> The spec says that it should always return a valid format, but not all drivers adhere
> to that. Perhaps we need to add a flag to let the driver signal the behavior of S_FMT
> to userspace.
> 
> This is a long-standing issue with S_FMT, actually.
> 
[...]
> > +Encoding parameter changes
> > +--------------------------
> > +
> > +The client is allowed to use :c:func:`VIDIOC_S_CTRL` to change encoder
> > +parameters at any time. The driver must apply the new setting starting
> > +at the next frame queued to it.
> > +
> > +This specifically means that if the driver maintains a queue of buffers
> > +to be encoded and at the time of the call to :c:func:`VIDIOC_S_CTRL` not all the
> > +buffers in the queue are processed yet, the driver must not apply the
> > +change immediately, but schedule it for when the next buffer queued
> > +after the :c:func:`VIDIOC_S_CTRL` starts being processed.
> 
> Is this what drivers do today? I thought it was applied immediately?
> This sounds like something for which you need the Request API.

coda currently doesn't support dynamically changing controls at all.

> > +
> > +Flush
> > +-----
> > +
> > +Flush is the process of draining the CAPTURE queue of any remaining
> > +buffers. After the flush sequence is complete, the client has received
> > +all encoded frames for all OUTPUT buffers queued before the sequence was
> > +started.
> > +
> > +1. Begin flush by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> > +
> > +   a. Required fields:
> > +
> > +      i. cmd = ``V4L2_ENC_CMD_STOP``
> > +
> > +2. The driver must process and encode as normal all OUTPUT buffers
> > +   queued by the client before the :c:func:`VIDIOC_ENCODER_CMD` was issued.
> 
> Note: TRY_ENCODER_CMD should also be supported, likely via a standard helper
> in v4l2-mem2mem.c.

TRY_ENCODER_CMD can be used to check whether the hardware supports
things like V4L2_ENC_CMD_STOP_AT_GOP_END, I don't think this will be the
same for all codecs.

regards
Philipp
