Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932823AbcKOAyE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 19:54:04 -0500
Date: Tue, 15 Nov 2016 01:53:58 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161115005357.xjom264pjxbfubtz@earth>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <20161103224843.itxlvvotni6w6tmu@earth>
 <20161103230501.GJ3217@valkosipuli.retiisi.org.uk>
 <20161104000525.jzouapxxwwiwdwjy@earth>
 <20161114215827.GU3217@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c3p36kse4522cdcz"
Content-Disposition: inline
In-Reply-To: <20161114215827.GU3217@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--c3p36kse4522cdcz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Mon, Nov 14, 2016 at 11:58:28PM +0200, Sakari Ailus wrote:
> [...]
>
> On Fri, Nov 04, 2016 at 01:05:25AM +0100, Sebastian Reichel wrote:
> > I'm not sure what part relevant for video-bus-switch is currently
> > not supported?
> >=20
> > video-bus-switch registers its own async notifier and only registers
> > itself as subdevices to omap3isp, once its own subdevices have been
> > registered successfully.
>=20
> Do you happen to have patches for this?
> I still think we should clean up the V4L2 async framework though.

http://git.kernel.org/cgit/linux/kernel/git/sre/linux-n900.git/tree/drivers=
/media/platform/video-bus-switch.c?h=3Dn900-camera-ivo

It was inside of the RFC series Ivo sent in April.

> [...]

-- Sebastian

--c3p36kse4522cdcz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlgqXKMACgkQ2O7X88g7
+ppdCg//X2XUCFFUFo0Ixifq+9J8GdSJ+vU+cCs/TauGl+f9Rwf5E6iiCjFq3swv
CFfLyXgY/WSxZHjhOwrpVKoYJpk8yzzhbNFcayTO5HAvdIS0U/0PIc1wOG4QwSbp
4V3s05A1IzH8qAsJJ2CAktB2cUWhLeTysNMwtitY+qS92sX/4Pj9HUJw9F3TO4sK
Fgc9lpBsYZMZGUkCS12sxom+S99xnpOpsLufFuTHBGsuKUo2sGr0oeWmXodl0d19
7bU55CtY4ic43Dwg1zaubyicIv4wHVzrcIwy58JrbMlHvNdiH213UZkF9TCo9/oR
p6CCwDKr2L9RZXpoc7XDdlUUf4mYwiNbnPwhr/ARZFxTPq8yvSf4uWNYZB3TDJhw
4BQHECZsnqKFzq7uNT2eP2D4MP3ut0fQsJyhL/XBtAXdiSKE6k42I4ADegIf6o1A
Xbo6d+SZvu6jdPcIJ12jdCEsunJXTxAuZ97wbVMppK37HELU9VMKsLaflb7BaNw6
ZGBA3St62UskekxhQSBJz/FsazSVSs2hBNdSPSEp/EUtQhmFh2CbDPjovgOVlKvw
5VE9kpZo8mTPhPmFW8KEtKT25u51bO6ta9Q3J8JTVOxP3yYX2/76QqWOY0VAwxCO
+UyNnHgKnjU1SDNf6/RiBex2I6JxaCEQI6umRkACBLkSH9V4tJQ=
=oN9h
-----END PGP SIGNATURE-----

--c3p36kse4522cdcz--
