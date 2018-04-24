Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44538 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752949AbeDXLvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 07:51:00 -0400
Date: Tue, 24 Apr 2018 13:50:49 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com
Subject: Re: [RESEND PATCH 1/1] ov5640: Use dev_fwnode() to obtain device's
 fwnode
Message-ID: <20180424115049.rn5o3jqiigfbjtfo@flea>
References: <20180424111029.18751-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ie5anjnyxup3fnup"
Content-Disposition: inline
In-Reply-To: <20180424111029.18751-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ie5anjnyxup3fnup
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 24, 2018 at 02:10:29PM +0300, Sakari Ailus wrote:
> Use dev_fwnode() on the device instead of getting an fwnode handle of the
> device's OF node. The result is the same on OF-based systems and looks
> better, too.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--ie5anjnyxup3fnup
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlrfGhgACgkQ0rTAlCFN
r3QfkQ//eClthhCgouqTmRRkuS4ajFTzS2RpiMJJGpMPgXpMWLF/MqBsme6BS3uL
Eov45Gy1OMUELKYiZk9lKQcWZA2T9QTQI1M9ZOfZ7nZPhs1gdYc8PixMLWOC8C2W
K8D/8BCBkMtYFVJOQz+5dJiIF78PuA9hdDeRL2LbY69kS5QHuJL6hiW4BdMhiQ7D
BqPDJmsTs+2xJfqksfcDniJ3IjPdFC0wqbtnK6AyJ/J2UhRffa16kkJ4MQcUakX1
CDINQj3h9XvZ+5KZ8E6+J+/v4ThJ5kZ3L6GJ7SlGxlSh8cotXw0Npaa0UMle77QC
Hv82WQ9mBEL7HhUEr5+uPu3cb2EVeGLSwV5iCdGh885IweZEpFMfYirul31xAGhV
NxmdMlQfzsOo+SfIPCgShEKO/SK0lQ+JApykhpwEyRdyXHbCLHKI4YXds13NxZL1
dbsgF2yHGsQJeGwyTVxZ9Fo5g4VRcvDoy7S1tAcIOmhES5H/TasDF76lD3sPoTyA
ZUDA2HXRvUAJqmnu+MIu7igi+1LgCbIRt1ZBRllqp02qf4M6vAk5KOZUw49btmXb
UCZc7l+fVpwNWzrkRpGnBHyoKE0n7WdAMzVeIc3CxkbGe9rG08/WZwpYjKf+EEkJ
mjsE2TXNoGC074j2m4oAsFHBATz/eIMkfVKPfw9cR2XWKza0nU4=
=OWt9
-----END PGP SIGNATURE-----

--ie5anjnyxup3fnup--
