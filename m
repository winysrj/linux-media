Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37993 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbeJSG6E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 02:58:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id 193-v6so1885635wme.3
        for <linux-media@vger.kernel.org>; Thu, 18 Oct 2018 15:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20180918093421.12930-1-p.zabel@pengutronix.de> <20180918093421.12930-2-p.zabel@pengutronix.de>
In-Reply-To: <20180918093421.12930-2-p.zabel@pengutronix.de>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 18 Oct 2018 15:53:58 -0700
Message-ID: <CAJ+vNU2vraT=vUwS+1TYKuX50OsjZsNaN220y1kz8XgHvC48Sg@mail.gmail.com>
Subject: Re: [PATCH v3 01/16] media: imx: add mem2mem device
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media <linux-media@vger.kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>, nicolas@ndufresne.ca,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 18, 2018 at 2:34 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> Add a single imx-media mem2mem video device that uses the IPU IC PP
> (image converter post processing) task for scaling and colorspace
> conversion.
> On i.MX6Q/DL SoCs with two IPUs currently only the first IPU is used.
>
> The hardware only supports writing to destination buffers up to
> 1024x1024 pixels in a single pass, arbitrary sizes can be achieved
> by rendering multiple tiles per frame.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> [steve_longerbeam@mentor.com: use ipu_image_convert_adjust(), fix
>  device_run() error handling]
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
> Changes since v2:
>  - Rely on ipu_image_convert_adjust() in mem2mem_try_fmt() for format
>    adjustments. This makes the mem2mem driver mostly a V4L2 mem2mem API
>    wrapper around the IPU image converter, and independent of the
>    internal image converter implementation.
>  - Remove the source and destination buffers on error in device_run().
>    Otherwise the conversion is re-attempted apparently over and over
>    again (with WARN() backtraces).
>  - Allow subscribing to control changes.
> ---
>  drivers/staging/media/imx/Kconfig             |   1 +
>  drivers/staging/media/imx/Makefile            |   1 +
>  drivers/staging/media/imx/imx-media-dev.c     |  11 +
>  drivers/staging/media/imx/imx-media-mem2mem.c | 873 ++++++++++++++++++
>  drivers/staging/media/imx/imx-media.h         |  10 +
>  5 files changed, 896 insertions(+)
>  create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c
>

Philipp,

Thanks for submitting this!

I'm hoping this lets us use non-IMX capture devices along with the IMX
media controller entities to so we can use hardware
CSC,scaling,pixel-format-conversions and ultimately coda based encode.

I've built this on top of linux-media and see that it registers as
/dev/video8 but I'm not clear how to use it? I don't see it within the
media controller graph.

Regards,

Tim
