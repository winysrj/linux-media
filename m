Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764222AbcLVXkg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Dec 2016 18:40:36 -0500
Date: Fri, 23 Dec 2016 00:40:28 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161222234028.oxntlek2oy62cjnh@earth>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161222143244.ykza4wdxmop2t7bg@earth>
 <20161222224226.GB31151@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ygqd7rfv63aec7my"
Content-Disposition: inline
In-Reply-To: <20161222224226.GB31151@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ygqd7rfv63aec7my
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 22, 2016 at 11:42:26PM +0100, Pavel Machek wrote:
> On Thu 2016-12-22 15:32:44, Sebastian Reichel wrote:
> > Hi Pavel,
> >=20
> > On Thu, Dec 22, 2016 at 02:39:38PM +0100, Pavel Machek wrote:
> > > N900 contains front and back camera, with a switch between the
> > > two. This adds support for the swich component.
> > >=20
> > > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > >=20
> > > --
> > >=20
> > > I see this needs dts documentation, anything else than needs to be
> > > done?
> >=20
> > Yes. This driver takes care of the switch gpio, but the cameras also
> > use different bus settings. Currently omap3isp gets the bus-settings
> > from the link connected to the CCP2 port in DT at probe time (*).
> >=20
> > So there are two general problems:
> >=20
> > 1. Settings must be applied before the streaming starts instead of
> > at probe time, since the settings may change (based one the selected
> > camera). That should be fairly easy to implement by just moving the
> > code to the s_stream callback as far as I can see.
> >=20
> > 2. omap3isp should try to get the bus settings from using a callback
> > in the connected driver instead of loading it from DT. Then the
> > video-bus-switch can load the bus-settings from its downstream links
> > in DT and propagate the correct ones to omap3isp based on the
> > selected port. The DT loading part should actually remain in omap3isp
> > as fallback, in case it does not find a callback in the connected drive=
r.
> > That way everything is backward compatible and the DT variant is
> > nice for 1-on-1 scenarios.
>=20
> So... did I understood it correctly? (Needs some work to be done...)

I had a quick look and yes, that's basically what I had in mind to
solve the issue. If callback is not available the old system should
be used of course.

> [...]
>
>  static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
> diff --git a/drivers/media/platform/video-bus-switch.c b/drivers/media/pl=
atform/video-bus-switch.c
> index 1a5d944..3a2d442 100644
> --- a/drivers/media/platform/video-bus-switch.c
> +++ b/drivers/media/platform/video-bus-switch.c
> @@ -247,12 +247,21 @@ static int vbs_s_stream(struct v4l2_subdev *sd, int=
 enable)
>  {
>  	struct v4l2_subdev *subdev =3D vbs_get_remote_subdev(sd);
> =20
> +	/* FIXME: we need to set the GPIO here */
> +

The gpio is set when the pad is selected, so no need to do it again.
The gpio selection actually works with your branch (assuming its
based on Ivo's).

>  	if (IS_ERR(subdev))
>  		return PTR_ERR(subdev);
> =20
>  	return v4l2_subdev_call(subdev, video, s_stream, enable);
>  }
> =20
> +static int vbs_g_endpoint_config(struct v4l2_subdev *sd, struct isp_bus_=
cfg *cfg)
> +{
> +	printk("vbs_g_endpoint_config...\n");
> +	return 0;
> +}

Would be nice to find something more abstract than isp_bus_cfg,
which is specific to omap3isp.

-- Sebastian

--ygqd7rfv63aec7my
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhcZGkACgkQ2O7X88g7
+prwSRAAmtUDpDT98p/Vja0Oo81k9lTeli+Gzow+jOW1yGc4MsInGH0+m6dbLGy/
6crPQ4MlKrS6FNr2oSlfH1BkuOq3uOgsZd/BfYJQ5X6h1eoyv1C9NwRcZSk7DkOS
eXnucXI9NZAeS0PXd3H3xH9BDZLV56UIIuPyqfV73WiB3Ciq2561s/1m0TXEXXTa
WCEBc5g+8zG/7GKTk89EttRu41DT49kpFpTtIzVM0xd5V9ZO7iiQ1ZELS3W09rJ3
WDNOBIcAEb7FT+ZEqzC8dSvNi9u/0ECTleS3C0uFbqQG/Y9EtnT/JTHZ56FS5pAY
InMixZagOJl88HRsG0TR0bj34un4Yo3wfrEtCsSQ5vIYD3ETXt5YUp+AjcSvoJ7s
GKHMLnKE6D6ef+ipYmnz/LG1XA5grcQ3iYAtuVjTKPduEUhTlemfhevMV7J/8PPA
6Pw3q0qObeVlTAp4LOEwzkThxsmfKnK3s2UUoPFLq5X9qZFtCtpCNnTSl/dJlmSr
jFlB8kYLL0qZgJ/Ibbf7XmjS/OHBi5VOURZPXGNCRariR2gWTa+q0u9lae1+l5Ij
vo/X3lGTF3SRjEyBIN2wIag1MuSPFC4rZoyjN6tEeDcykoU7fKq9KobBvBI5fS0V
JKDBeRbmmmfaAs77kT4nWZLEo2b3RjRUjiedLHiU4CMEkZAc7vQ=
=FUGn
-----END PGP SIGNATURE-----

--ygqd7rfv63aec7my--
