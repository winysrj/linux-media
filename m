Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:47510 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732387AbeGKLQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 07:16:31 -0400
Date: Wed, 11 Jul 2018 13:12:30 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong <yong.deng@magewell.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Thierry Reding <treding@nvidia.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v10 2/2] media: V3s: Add support for Allwinner CSI.
Message-ID: <20180711111230.gpv7ww2nhaha5hou@flea>
References: <1525417745-37964-1-git-send-email-yong.deng@magewell.com>
 <20180626110821.wkal6fcnoncsze6y@valkosipuli.retiisi.org.uk>
 <20180705154802.03604f156709be11892b19c0@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wbnyxjafmaafjrkv"
Content-Disposition: inline
In-Reply-To: <20180705154802.03604f156709be11892b19c0@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wbnyxjafmaafjrkv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Thu, Jul 05, 2018 at 03:48:02PM +0800, Yong wrote:
> > > +
> > > +/* -----------------------------------------------------------------=
------------
> > > + * Media Operations
> > > + */
> > > +static int sun6i_video_formats_init(struct sun6i_video *video,
> > > +				    const struct media_pad *remote)
> > > +{
> > > +	struct v4l2_subdev_mbus_code_enum mbus_code =3D { 0 };
> > > +	struct sun6i_csi *csi =3D video->csi;
> > > +	struct v4l2_format format;
> > > +	struct v4l2_subdev *subdev;
> > > +	u32 pad;
> > > +	const u32 *pixformats;
> > > +	int pixformat_count =3D 0;
> > > +	u32 subdev_codes[32]; /* subdev format codes, 32 should be enough */
> > > +	int codes_count =3D 0;
> > > +	int num_fmts =3D 0;
> > > +	int i, j;
> > > +
> > > +	pad =3D remote->index;
> > > +	subdev =3D media_entity_to_v4l2_subdev(remote->entity);
> > > +	if (subdev =3D=3D NULL)
> > > +		return -ENXIO;
> > > +
> > > +	/* Get supported pixformats of CSI */
> > > +	pixformat_count =3D sun6i_csi_get_supported_pixformats(csi, &pixfor=
mats);
> > > +	if (pixformat_count <=3D 0)
> > > +		return -ENXIO;
> > > +
> > > +	/* Get subdev formats codes */
> > > +	mbus_code.pad =3D pad;
> > > +	mbus_code.which =3D V4L2_SUBDEV_FORMAT_ACTIVE;
> > > +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL,
> > > +				 &mbus_code)) {
> >=20
> > The formats supported by the external sub-device may depend on horizont=
al
> > and vertical flipping. You shouldn't assume any particular configuration
> > here: instead, bridge drivers generally just need to make sure the form=
ats
> > match in link validation when streaming is started. At least the CSI-2
> > receiver driver and the DMA engine driver (video device) should check t=
he
> > configuration is valid. See e.g. the IPU3 driver:
> > drivers/media/pci/intel/ipu3/ipu3-cio2.c .
>=20
> Can mbus_code be added dynamically ?
> The code here only enum the mbus code and get the possible supported
> pairs of pixformat and mbus by SoC. Not try to check if the formats
> (width height ...) is valid or not. The formats validation will be=20
> in link validation when streaming is started as per your advise.=20

Can you reply to this so that Yong has a chance to resubmit his serie
before the 4.19 merge window starts?

Or alternatively, is this something we can fix later on, once it's
merged?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--wbnyxjafmaafjrkv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAltF5gwACgkQ0rTAlCFN
r3TWNw/+KtCfTkV+mWO7syASSLV3TlKy+Uac+vNGvjw9EqP+7JKvxvosSriQMs8D
Q2CFOLZam7c0+oTqMl8t+QXkW0Z2B54akBlcAGa2hSAd01mquQ3nEzI/BJlMx2Sm
0N9G2QQO4u440h2Nzi2wvEfj30Qc7P6x5dpir8vAlXYU870JRTPnUOIMwGZRn/a8
ZhBJ6TSxn572FFkyC7IcPWJBuCY8ZaJlGiiriIpF6MKq57WIDqyQ7lIT5zxbtry3
x68EPuGyRrjSaWcM08RVzjnVNEtNH9C2bN1WvjRldE00PmYJxLiskCOVN+ZHHrLE
qNbRDGJOG1yMwSaRPEFJxs0bb7/lsmRZgsA7ZUnuTrLZnLIfe7vbfnBdTDcOgCxG
cO/1kH/ub5l81UqPgGUjg5Q0ZohurUd5BzmUoR/x9EutW21m1rHLaJB/CYYaB37a
pT+xKktQpFO5GLQDLKK2qsUw0jtv8WiL5PRsi8dnCHfGHUH1YUZ5RiCXZ5BBX4+2
giIlT91cIWKIcBsRdDfDAS9AMfAXiNS47VdFlb6rcXFBLQ/cK9LItSuLKc7yXVcS
OJGoQPt8m985lFwIGIpZ8KLzsupee3gbvHy8RCvAdhGM6sdCi6SnZ0O8b1/86pMM
OZGXDI9bfwI1vU4azLEoKBHe5x6GSkjhF8amdyPMUMrDZLw4Slo=
=NKp6
-----END PGP SIGNATURE-----

--wbnyxjafmaafjrkv--
