Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39401 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756208AbdLOOhf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 09:37:35 -0500
Date: Fri, 15 Dec 2017 15:37:28 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: kieran.bingham@ideasonboard.com
Cc: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH/RFC v2 10/15] adv748x: csi2: add translation from
 pixelcode to CSI-2 datatype
Message-ID: <20171215143728.GD3375@w540>
References: <20171214190835.7672-1-niklas.soderlund+renesas@ragnatech.se>
 <20171214190835.7672-11-niklas.soderlund+renesas@ragnatech.se>
 <a41181ea-30a2-7b0d-d836-f4e5c8eba4f6@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a41181ea-30a2-7b0d-d836-f4e5c8eba4f6@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thu, Dec 14, 2017 at 10:25:36PM +0000, Kieran Bingham wrote:
> Hi Niklas,
>
> On 14/12/17 19:08, Niklas Söderlund wrote:
> > This will be needed to fill out the frame descriptor information
> > correctly.
> >
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/i2c/adv748x/adv748x-csi2.c | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/drivers/media/i2c/adv748x/adv748x-csi2.c b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > index 2a5dff8c571013bf..a2a6d93077204731 100644
> > --- a/drivers/media/i2c/adv748x/adv748x-csi2.c
> > +++ b/drivers/media/i2c/adv748x/adv748x-csi2.c
> > @@ -18,6 +18,28 @@
> >
> >  #include "adv748x.h"
> >
> > +struct adv748x_csi2_format {
> > +	unsigned int code;
> > +	unsigned int datatype;
> > +};
> > +
> > +static const struct adv748x_csi2_format adv748x_csi2_formats[] = {
> > +	{ .code = MEDIA_BUS_FMT_RGB888_1X24,    .datatype = 0x24, },
> > +	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,     .datatype = 0x1e, },
> > +	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,      .datatype = 0x1e, },
> > +	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,    .datatype = 0x1e, },

YUV 422 10 bit is associated to data type 0x1d in CSI-2 specifications

> > +};
>
> Is the datatype mapping specific to the ADV748x here?
> or are these generic/common CSI2 mappings?
>
> What do those datatype magic numbers represent?

They are fixed mappings defined by CSI-2 specifications and they
should probably be generic to all drivers imho

>
> --
> Kieran
>
> > +
> > +static unsigned int adv748x_csi2_code_to_datatype(unsigned int code)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(adv748x_csi2_formats); i++)
> > +		if (adv748x_csi2_formats[i].code == code)
> > +			return adv748x_csi2_formats[i].datatype;
> > +	return 0;
> > +}
> > +
> >  static bool is_txa(struct adv748x_csi2 *tx)
> >  {
> >  	return tx == &tx->state->txa;
> >
