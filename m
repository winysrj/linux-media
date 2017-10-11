Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60248 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdJKV0q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 17:26:46 -0400
Date: Wed, 11 Oct 2017 23:26:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mats Randgaard <matrandg@cisco.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Benoit Parrot <bparrot@ti.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Sebastian Reichel <sre@kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 04/24] media: v4l2-mediabus: convert flags to enums and
 document them
Message-ID: <20171011212644.GB32314@amd>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <8d351f92fb18148b4d53acdc7f7c8fb0e9f537d9.1507544011.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <8d351f92fb18148b4d53acdc7f7c8fb0e9f537d9.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-10-09 07:19:10, Mauro Carvalho Chehab wrote:
> There is a mess with media bus flags: there are two sets of
> flags, one used by parallel and ITU-R BT.656 outputs,
> and another one for CSI2.
>=20
> Depending on the type, the same bit has different meanings.
>=20

> @@ -86,11 +125,22 @@ enum v4l2_mbus_type {
>  /**
>   * struct v4l2_mbus_config - media bus configuration
>   * @type:	in: interface type
> - * @flags:	in / out: configuration flags, depending on @type
> + * @pb_flags:	in / out: configuration flags, if @type is
> + *		%V4L2_MBUS_PARALLEL or %V4L2_MBUS_BT656.
> + * @csi2_flags:	in / out: configuration flags, if @type is
> + *		%V4L2_MBUS_CSI2.
> + * @flag:	access flags, no matter the @type.
> + *		Used just to avoid needing to rewrite the logic inside
> + *		soc_camera and pxa_camera drivers. Don't use on newer
> + * 		drivers!
>   */
>  struct v4l2_mbus_config {
>  	enum v4l2_mbus_type type;
> -	unsigned int flags;
> +	union {
> +		enum v4l2_mbus_parallel_and_bt656_flags	pb_flags;
> +		enum v4l2_mbus_csi2_flags		csi2_flags;
> +		unsigned int				flag;
> +	};
>  };
> =20
>  static inline void v4l2_fill_pix_format(struct v4l2_pix_format
>  *pix_fmt,

The flags->flag conversion is quite subtle, and "flag" is confusing
because there is more than one inside. What about something like
__legacy_flags?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnejJQACgkQMOfwapXb+vL1ngCfSJfjpkYdLKbCx9x4YXgpGmoX
nLQAn3G4E0g7OK73fDvk/torTdpsYPBp
=i6Pt
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
