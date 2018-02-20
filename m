Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:56486 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbeBTI7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Feb 2018 03:59:08 -0500
Date: Tue, 20 Feb 2018 09:58:57 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 11/11] media: i2c: ov7670: Fully set mbus frame fmt
Message-ID: <20180220085857.GC7203@w540>
References: <1519059584-30844-1-git-send-email-jacopo+renesas@jmondi.org>
 <1519059584-30844-12-git-send-email-jacopo+renesas@jmondi.org>
 <1963190.TI9O1pFqZp@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1963190.TI9O1pFqZp@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Feb 19, 2018 at 09:19:32PM +0200, Laurent Pinchart wrote:
> Hi Jacopo,
>
> Thank you for the patch.
>
> On Monday, 19 February 2018 18:59:44 EET Jacopo Mondi wrote:
> > The sensor driver sets mbus format colorspace information and sizes,
> > but not ycbcr encoding, quantization and xfer function. When supplied
> > with an badly initialized mbus frame format structure, those fields
> > need to be set explicitly not to leave them uninitialized. This is
> > tested by v4l2-compliance, which supplies a mbus format description
> > structure and checks for all fields to be properly set.
> >
> > Without this commit, v4l2-compliance fails when testing formats with:
> > fail: v4l2-test-formats.cpp(335): ycbcr_enc >= 0xff
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  drivers/media/i2c/ov7670.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > index 25b26d4..61c472e 100644
> > --- a/drivers/media/i2c/ov7670.c
> > +++ b/drivers/media/i2c/ov7670.c
> > @@ -996,6 +996,10 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev
> > *sd, fmt->height = wsize->height;
> >  	fmt->colorspace = ov7670_formats[index].colorspace;
>
> On a side note, if I'm not mistaken the colorspace field is set to SRGB for
> all entries. Shouldn't you hardcode it here and remove the field ?
>
> > +	fmt->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> > +	fmt->quantization = V4L2_QUANTIZATION_DEFAULT;
> > +	fmt->xfer_func = V4L2_XFER_FUNC_DEFAULT;
>
> How about setting the values explicitly instead of relying on defaults ? That
> would be V4L2_YCBCR_ENC_601, V4L2_QUANTIZATION_LIM_RANGE and
> V4L2_XFER_FUNC_SRGB. And could you then check a captured frame to see if the
> sensor outputs limited or full range ?
>

This actually makes me wonder if those informations (ycbcb_enc,
quantization and xfer_func) shouldn't actually be part of the
supported format list... I blindly added those default fields in the
try_fmt function, but I doubt they applies to all supported formats.

Eg. the sensor supports YUYV as well as 2 RGB encodings (RGB444 and
RGB 565) and 1 raw format (BGGR). I now have a question here:

1) ycbcr_enc transforms non-linear R'G'B' to Y'CbCr: does this
applies to RGB and raw formats? I don't think so, and what value is
the correct one for the ycbcr_enc field in this case? I assume
xfer_func and quantization applies to all formats instead..

Thanks
   j

> >  	info->format = *fmt;
> >
> >  	return 0;
>
> --
> Regards,
>
> Laurent Pinchart
>
