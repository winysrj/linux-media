Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44419 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbeJQTFv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 15:05:51 -0400
Message-ID: <1539774637.4729.3.camel@pengutronix.de>
Subject: Re: [PATCH v3 10/16] gpu: ipu-v3: image-convert: select optimal
 seam positions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Date: Wed, 17 Oct 2018 13:10:37 +0200
In-Reply-To: <d3e2a6ec-2961-2f97-7a53-d016bc6ad515@gmail.com>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
         <20180918093421.12930-11-p.zabel@pengutronix.de>
         <d3e2a6ec-2961-2f97-7a53-d016bc6ad515@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-10-12 at 17:33 -0700, Steve Longerbeam wrote:
> 
> On 09/18/2018 02:34 AM, Philipp Zabel wrote:
> 
> <snip>
> > +/*
> > + * Tile left edges are required to be aligned to multiples of 8 bytes
> > + * by the IDMAC.
> > + */
> > +static inline u32 tile_left_align(const struct ipu_image_pixfmt *fmt)
> > +{
> > +	return fmt->planar ? 8 * fmt->uv_width_dec : 64 / fmt->bpp;
> > +}
> 
> <snip>
> 
> As I indicated, shouldn't this be
> 
> return fmt->planar ? 8 * fmt->uv_width_dec : 8;
> 
> ?
>
> Just from a unit analysis perspective, "64 / fmt->bp" has
> units of pixels / 8-bytes, it should have units of bytes.

The tile alignment is in pixels, not in bytes. For 16-bit and 32-bit
packed formats, we only need to align to 4 or 2 pixels, respectively,
as the LCM of 8-byte alignment and 2-byte or 4-byte pixel size is
always 8 bytes.

But now that you pointed it out, it is quite obvious that this can't
work for 24-bit packed formats. Here the LCM of 8-byte alignment and 3-
byte pixels is 24 bytes, or 8 pixels.

How about:

	if (fmt->planar)
		return fmt->uv_packed ? 8 : 8 * fmt->uv_width_dec;
	else
		return fmt->bpp == 32 ? 2 : fmt->bpp == 16 ? 4 : 8;

regards
Philipp
