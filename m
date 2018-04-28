Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50636 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbeD1QBX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 12:01:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        jacopo mondi <jacopo@jmondi.org>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v14 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Sat, 28 Apr 2018 19:01:37 +0300
Message-ID: <1887143.X2lPidqNhn@avalon>
In-Reply-To: <20180426232832.GA14242@bigcity.dyn.berto.se>
References: <20180426202121.27243-1-niklas.soderlund+renesas@ragnatech.se> <4257407.ajpJjWYCOs@avalon> <20180426232832.GA14242@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Friday, 27 April 2018 02:28:32 EEST Niklas S=F6derlund wrote:
> On 2018-04-27 00:30:25 +0300, Laurent Pinchart wrote:
> > On Thursday, 26 April 2018 23:21:21 EEST Niklas S=F6derlund wrote:
> >> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> >> supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> >> connected between the video sources and the video grabbers (VIN).
> >>=20
> >> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
> >>=20
> >> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> >> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> >> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>=20
> >> ---
> >>=20
> >> * Changes since v13
> >> - Change return rcar_csi2_formats + i to return &rcar_csi2_formats[i].
> >> - Add define for PHCLM_STOPSTATECKL.
> >> - Update spelling in comments.
> >> - Update calculation in rcar_csi2_calc_phypll() according to
> >>   https://linuxtv.org/downloads/v4l-dvb-apis/kapi/csi2.html. The one
> >>   before v14 did not take into account that 2 bits per sample is
> >>   transmitted.
> >=20
> > Just one small comment about this, please see below.
> >=20
> >> - Use Geert's suggestion of (1 << priv->lanes) - 1 instead of switch
> >>   statement to set correct number of lanes to enable.
> >> - Change hex constants in hsfreqrange_m3w_h3es1[] to lower case to mat=
ch
> >>   style of rest of file.
> >> - Switch to %u instead of 0x%x when printing bus type.
> >> - Switch to %u instead of %d for priv->lanes which is unsigned.
> >> - Add MEDIA_BUS_FMT_YUYV8_1X16 to the list of supported formats in
> >>   rcar_csi2_formats[].
> >> - Fixed bps for MEDIA_BUS_FMT_YUYV10_2X10 to 20 and not 16.
> >> - Set INTSTATE after PL-11 is confirmed to match flow chart in
> >>   datasheet.
> >> - Change priv->notifier.subdevs =3D=3D NULL to !priv->notifier.subdevs.
> >> - Add Maxime's and laurent's tags.
> >> ---
> >>=20
> >>  drivers/media/platform/rcar-vin/Kconfig     |  12 +
> >>  drivers/media/platform/rcar-vin/Makefile    |   1 +
> >>  drivers/media/platform/rcar-vin/rcar-csi2.c | 883 ++++++++++++++++++++
> >>  3 files changed, 896 insertions(+)
> >>  create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c
> >=20
> > [snip]
> >=20
> >> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c
> >> b/drivers/media/platform/rcar-vin/rcar-csi2.c new file mode 100644
> >> index 0000000000000000..49b29d5680f9d80b
> >> --- /dev/null
> > > +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> >=20
> > [snip]
> >=20
> >> +static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv, unsigned int
> >> bpp,
> >> +				 u32 *phypll)
> >> +{
> >> +	const struct phypll_hsfreqrange *hsfreq;
> >> +	struct v4l2_subdev *source;
> >> +	struct v4l2_ctrl *ctrl;
> >> +	u64 mbps;
> >> +
> >> +	if (!priv->remote)
> >> +		return -ENODEV;
> >> +
> >> +	source =3D priv->remote;
> >> +
> >> +	/* Read the pixel rate control from remote */
> >> +	ctrl =3D v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
> >> +	if (!ctrl) {
> >> +		dev_err(priv->dev, "no pixel rate control in subdev %s\n",
> >> +			source->name);
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Calculate the phypll in mbps (from v4l2 documentation)
> >> +	 * link_freq =3D (pixel_rate * bits_per_sample) / (2 * nr_of_lanes)
> >> +	 */
> >> +	mbps =3D v4l2_ctrl_g_ctrl_int64(ctrl) * bpp;
> >> +	do_div(mbps, priv->lanes * 2000000);
> >=20
> > pixel rate * bits per sample will give you the overall bit rate, which =
you
> > then divide by the number of lanes to get the bitrate per lane, and then
> > by 2 as D-PHY is a DDR PHY and transmits 2 bits per clock cycle. You th=
en
> > end up with the link frequency, which is thus expressed in MHz, not in
> > Mbps. I would thus name the mbps variable freq, and rename the
> > phypll_hsfreqrange mbps field to freq (maybe with a small comment right
> > after the field to tell the value is expressed in MHz).
>=20
> I agree that freq would be a better name for what it represents. Never
> the less I prefer to stick with mbps as that is whats used in the
> datasheet. See Table '25.9 HSFREQRANGE Bit Set Values'.
>=20
> With this in mind if you still feel strongly about renaming it I could
> do so. But at lest for me it feels more useful to easily be able to map
> the variable to the datasheet tables :-)

After reading the datasheet I don't care too strongly about a rename, but I=
=20
now care about getting it right :-) The datasheet clearly specifies the=20
maximum data rate to be 1.5 Gbps / lane (section 25.1.1 Features), and figu=
re=20
25.9 corroborates that and shows a corresponding frequency of 750 MHz. I th=
us=20
believe that the values in table 25.9 and 25.10 are indeed bitrates (in Mbp=
s /=20
lane), so I think you shouldn't divide by 2 in the above formula.

> >> +	for (hsfreq =3D priv->info->hsfreqrange; hsfreq->mbps !=3D 0; hsfreq=
++)
> >> +		if (hsfreq->mbps >=3D mbps)
> >> +			break;
> >> +
> >> +	if (!hsfreq->mbps) {
> >> +		dev_err(priv->dev, "Unsupported PHY speed (%llu Mbps)", mbps);
> >> +		return -ERANGE;
> >> +	}
> >> +
> >> +	dev_dbg(priv->dev, "PHY HSFREQRANGE requested %llu got %u Mbps\n",
> >> mbps,
> >> +		hsfreq->mbps);
> >> +
> >> +	*phypll =3D PHYPLL_HSFREQRANGE(hsfreq->reg);
> >> +
> >> +	return 0;
> >> +}
> >=20
> > [snip]

=2D-=20
Regards,

Laurent Pinchart
