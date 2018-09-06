Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43213 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbeIFNeh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 09:34:37 -0400
Message-ID: <1536224410.5357.2.camel@pengutronix.de>
Subject: Re: [PATCH v2 3/4] media: imx-pxp: add i.MX Pixel Pipeline driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Date: Thu, 06 Sep 2018 11:00:10 +0200
In-Reply-To: <dbc31612-1686-c115-8618-309355363f27@xs4all.nl>
References: <20180905100018.27556-1-p.zabel@pengutronix.de>
         <20180905100018.27556-4-p.zabel@pengutronix.de>
         <b2968b6b-b6ab-dfbe-b51c-5c4e73786039@xs4all.nl>
         <1536153658.4084.7.camel@pengutronix.de>
         <dbc31612-1686-c115-8618-309355363f27@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-09-06 at 09:57 +0200, Hans Verkuil wrote:
[...]
> > If userspace sets xfer_func explicitly, it will get the explicit default
> > ycbcr_enc and quantization values.
> > 
> > I think I did this to make v4l2-compliance at some point, but it could
> > be that the explicit output->capture colorimetry copy for RGB->RGB and
> > YUV->YUV conversions has me covered now.
> 
> This xfer_func test makes no sense. xfer_func is completely ignored by the
> driver (other than copying it from output to capture queue) since it can't
> make any changes to it anyway.
> 
> What you are trying to do in pxp_fixup_colorimetry() is to figure out the
> ycbcr_enc and quantization values for the capture queue.

Yes. I checked again without that. Since there is the forced out->cap
copy for RGB->RGB and YUV->YUV conversions in pxp_fixup_colorimetry,
v4l2-compliance is happy anyway. The pxp_default_quant/ycbcr_enc
functions are removed now.

> BTW, can you rename pxp_fixup_colorimetry to pxp_fixup_colorimetry_cap or
> something? Since it is specifically for the capture queue.

Ok.

> These values depend entirely on the capture queue pixelformat and on the
> colorspace and not on the xfer_func value.
> 
> So just do:
> 
> bool is_rgb = !pxp_v4l2_pix_fmt_is_yuv(dst_fourcc);
> *ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(ctx->colorspace);
> *quantization = V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb, ctx->colorspace,
> 					      *ycbcr_enc);

That's almost exactly what I ended up with, thank you.

> BTW, I just noticed that the V4L2_MAP_QUANTIZATION_DEFAULT macro no longer
> uses ycbcr_enc. The comment in videodev2.h should be updated. I can't
> change the define as it is used in applications (and we might need to
> depend on it again in the future anyway).
> 
> If this code will give you v4l2-compliance issues, please let me know.
> It shouldn't AFAICT.

There are no complaints anymore.

regards
Philipp
