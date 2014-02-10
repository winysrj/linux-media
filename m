Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41798 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaBJJwP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:52:15 -0500
Message-ID: <52F8A146.4080407@ti.com>
Date: Mon, 10 Feb 2014 11:52:06 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] omap_vout: Add DVI display type support
References: <1391869935-10495-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391869935-10495-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="GT1bfAwAtiPiABvBbcPp3k1F09UrMhSS3"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--GT1bfAwAtiPiABvBbcPp3k1F09UrMhSS3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/02/14 16:32, Laurent Pinchart wrote:
> Since the introduction of the new OMAP DSS DVI connector driver in
> commit 348077b154357eec595068a3336ef6beb870e6f3 ("OMAPDSS: Add new DVI
> Connector driver"), DVI outputs report a new display type of
> OMAP_DISPLAY_TYPE_DVI instead of OMAP_DISPLAY_TYPE_DPI. Handle the new
> type in the IRQ handler.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap/omap_vout.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/pl=
atform/omap/omap_vout.c
> index dfd0a21..9a726ea 100644
> --- a/drivers/media/platform/omap/omap_vout.c
> +++ b/drivers/media/platform/omap/omap_vout.c
> @@ -601,6 +601,7 @@ static void omap_vout_isr(void *arg, unsigned int i=
rqstatus)
>  	switch (cur_display->type) {
>  	case OMAP_DISPLAY_TYPE_DSI:
>  	case OMAP_DISPLAY_TYPE_DPI:
> +	case OMAP_DISPLAY_TYPE_DVI:
>  		if (mgr_id =3D=3D OMAP_DSS_CHANNEL_LCD)
>  			irq =3D DISPC_IRQ_VSYNC;
>  		else if (mgr_id =3D=3D OMAP_DSS_CHANNEL_LCD2)
>=20

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi



--GT1bfAwAtiPiABvBbcPp3k1F09UrMhSS3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS+KFJAAoJEPo9qoy8lh71P24P/i7xJwG1Y6kA0GMXYLbl7rq7
VxG6iI+nAdQ7OWsLt8U0eCyfPwCWRrCDvSeteECfJVl/5lNTLdVgNEwHoFL0PAd4
vvoX+PPYy0h7258uPGv6mz/z9+V0+2UKVYsXjLdYPrYLf1bXdwSuYx47HId0as95
7pm+VS2NsE3b4yUqZEFWW3A9lbmB20fxbuO2pmsmmm1ikKtqvPPclfPmp8roMsSp
vND3AXL0QsfYBR+ZNAjeRIZS7cJe35avs+7t5+tnlgJJy1WF+T6rx+2wzC6RHQa2
UvsZxG32P8gpR0q9NY5Op+SOchLRdSj0ieTtKxC8d4t5HNI1MCMCiU+9x/dYEi8R
1sgGMEtaik4SfHyHu2VndJWiH3zyr+Pt/4akWcRNnmeoI3LDrDh7Ki76dbtbhL+H
NM8J56l4PPf7E3vELAtYIrjBKINuwofkvDn3YBdjEbxX9BNDbGlIKDJ3Tu2fDZqf
dWb0BW0JZWO9mN1bhyTM4R/oZFIyjVDkjz7+6smj7YOVGzc2WG7iN76pggmoJCra
JC4W5YjAZbS6N+r/GudoqKj96+5rnbOM5GoEk0Z1MFcMMl+tAzmTd0WXrOogZX7d
oiJe1dbaYx90nkKNTQZOkXj88ffnDLyNvZyxLsvONI5E5mo7C4m25DECP6Pz1cKs
18pmD37PaKLj28eHdcyz
=IMER
-----END PGP SIGNATURE-----

--GT1bfAwAtiPiABvBbcPp3k1F09UrMhSS3--
