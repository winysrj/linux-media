Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:56021 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbeIMTiL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 15:38:11 -0400
Date: Thu, 13 Sep 2018 16:28:19 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, slongerbeam@gmail.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/3] media: renesas-ceu: Use default mbus settings
Message-ID: <20180913142819.GG11509@w540>
References: <1536847191-17175-1-git-send-email-jacopo+renesas@jmondi.org>
 <1536847191-17175-4-git-send-email-jacopo+renesas@jmondi.org>
 <20180913142236.4g2eo3exn7rjwlpk@kekkonen.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3xoW37o/FfUZJwQG"
Content-Disposition: inline
In-Reply-To: <20180913142236.4g2eo3exn7rjwlpk@kekkonen.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3xoW37o/FfUZJwQG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,

On Thu, Sep 13, 2018 at 05:22:36PM +0300, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Thu, Sep 13, 2018 at 03:59:51PM +0200, Jacopo Mondi wrote:
> > As the v4l2-fwnode now allows drivers to set defaults, and eventually
> > override them by specifying properties in DTS, use defaults for the CEU
> > driver.
> >
> > Also remove endpoint properties from the gr-peach-audiocamerashield as
> > they match the defaults now specified in the driver code.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi |  4 ----
> >  drivers/media/platform/renesas-ceu.c              | 20 +++++++++++---------
> >  2 files changed, 11 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi b/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi
> > index e31a9e3..8d77579 100644
> > --- a/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi
> > +++ b/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi
> > @@ -69,10 +69,6 @@
> >
> >  	port {
> >  		ceu_in: endpoint {
> > -			hsync-active = <1>;
> > -			vsync-active = <1>;
> > -			bus-width = <8>;
> > -			pclk-sample = <1>;
>
> Do I understand correctly that pclk-sample was never relevant for the
> hardware, and is removed because of that? You could mention that in the
> commit message. That's perhaps a minor detail.

Correct, it's not relevant for the CEU, as it cannot be configured.

>
> The set seems good to me.

I can add that to commit message and re-send, or if it's easier for
you, you can change the last paragraph when applying to:

Also remove endpoint properties from the gr-peach-audiocamerashield as
they match the defaults now specified in the driver code
(h/vsync-active and bus-width) or are not relevant to the interface
as they cannot be configured (pclk-sample).

Thanks
  j

>
> >  			remote-endpoint = <&mt9v111_out>;
> >  		};
> >  	};
> > diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
> > index 035f1d3..150196f 100644
> > --- a/drivers/media/platform/renesas-ceu.c
> > +++ b/drivers/media/platform/renesas-ceu.c
> > @@ -1551,7 +1551,16 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
> >  		return ret;
> >
> >  	for (i = 0; i < num_ep; i++) {
> > -		struct v4l2_fwnode_endpoint fw_ep = { .bus_type = 0 };
> > +		struct v4l2_fwnode_endpoint fw_ep = {
> > +			.bus_type = V4L2_MBUS_PARALLEL,
> > +			.bus = {
> > +				.parallel = {
> > +					.flags = V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> > +						 V4L2_MBUS_VSYNC_ACTIVE_HIGH,
> > +					.bus_width = 8,
> > +				},
> > +			},
> > +		};
> >
> >  		ep = of_graph_get_endpoint_by_regs(of, 0, i);
> >  		if (!ep) {
> > @@ -1564,14 +1573,7 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
> >  		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
> >  		if (ret) {
> >  			dev_err(ceudev->dev,
> > -				"Unable to parse endpoint #%u.\n", i);
> > -			goto error_cleanup;
> > -		}
> > -
> > -		if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
> > -			dev_err(ceudev->dev,
> > -				"Only parallel input supported.\n");
> > -			ret = -EINVAL;
> > +				"Unable to parse endpoint #%u: %d.\n", i, ret);
> >  			goto error_cleanup;
> >  		}
> >
>
> --
> Kind regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

--3xoW37o/FfUZJwQG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbmnQDAAoJEHI0Bo8WoVY8QRUQAJtkajCIs+YaM1jpwb5RrUvg
RjJaI7CDcPfpgcIhlHPgOqiCxRKGZ9fa3c3jRBqZSdCcErRBW3lcf1oA592e+7te
cnErf9yrUXgiKwMB4rCg2CUZQR/pkKRaAmpSDUVw/uM0RNOU2ft/YO0SFMeGCi7L
5heipnNz8eqxqiNUY+LJ1xqlslh9obgHMInehlO1lsPGb5xm2qdIgtlab6MYcdy8
LSQVw4xdustc10rwx9WD/NvjRizh1d6s7GCVUEEcYCvmBnMty+IbXMhgJK2VDub/
06OWPFt6rKpaXdfAFajvQP7OIEz596g0Itx195OOi28BhY96I1r8d65pl/0c1F/4
JOZOoLiqcsOjmn90kF6oj110BjUARRkSF5sPYL+9cIGD7wPFxUohyoWZ8pKMcsjI
0oFw/7MAf3wYM2ms2Y3V4EtyNrDrowfAQA+186A1FBVM2EP4zQR/8a40rUhF68OE
fCp5Td4WtdhpdZk5o01KQcoAno0p1wNgGf9PUXVQqdiFmZA7aPdrMAFzKi6R0KBs
79Uzgrs5suGHZUPS/M2ZWX0+O1y3ZVWjbO1L9UrwwcVID+lnyTqTYalbcl07GQt/
mFX9DRZYVLY1Pk0XNZA2lNOBPWusJyb0meMqz7AJA4M19KJNInv35s4Qu/h4QpuK
f92q7ckhxVVXluuqzypr
=bYA3
-----END PGP SIGNATURE-----

--3xoW37o/FfUZJwQG--
