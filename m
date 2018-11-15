Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:58730 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbeKOS4s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 13:56:48 -0500
Message-ID: <e05791cac4a78985926cafba1b3ac6d541234d7d.camel@bootlin.com>
Subject: Re: [PATCH] cedrus: add action item to the TODO
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Date: Thu, 15 Nov 2018 09:49:30 +0100
In-Reply-To: <99a00f6e-3cd7-b063-107f-ec27c5c9833d@xs4all.nl>
References: <99a00f6e-3cd7-b063-107f-ec27c5c9833d@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-WjFNXPObEjrLaHp10c/x"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-WjFNXPObEjrLaHp10c/x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2018-11-15 at 08:49 +0100, Hans Verkuil wrote:
> Mention that the request validation should increment the memory refcount
> of reference buffers so we don't forget to do this.

Thanks for adding this item, we should definitely take care of it before
unstaging.

Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/staging/media/sunxi/cedrus/TODO b/drivers/staging/me=
dia/sunxi/cedrus/TODO
> index ec277ece47af..a951b3fd1ea1 100644
> --- a/drivers/staging/media/sunxi/cedrus/TODO
> +++ b/drivers/staging/media/sunxi/cedrus/TODO
> @@ -5,3 +5,8 @@ Before this stateless decoder driver can leave the stagin=
g area:
>  * Userspace support for the Request API needs to be reviewed;
>  * Another stateless decoder driver should be submitted;
>  * At least one stateless encoder driver should be submitted.
> +* When queueing a request containing references to I frames, the
> +  refcount of the memory for those I frames needs to be incremented
> +  and decremented when the request is completed. This will likely
> +  require some help from vb2. The driver should fail the request
> +  if the memory/buffer is gone.
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-WjFNXPObEjrLaHp10c/x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlvtMxoACgkQ3cLmz3+f
v9F3BQf+NedEMgSnnQKsEPXufeMmlGKi4T7aIZ3fhylPLwek7PKOqttdFZcS/Qph
QEBEAhE9BaKFHSb3cm6ULkDE4eT6RHuzk3zzZeSQNNcJq9tD8OAvaYNDULW6gX8g
L+NDUfrEL6biXSo7FX6cCARrSTN+cPOlE4YWgsuAPyR05TG50LixTkQjuajWjR29
qKSiIYROVKiqbhTrRE6zkYj4DE5DBV1w4S7KPczTVMgJI3nS/V2mbmoIX7HsEp13
BbnhcKQQzTaubmIV/znndYnNyjcGZUtipZgwsigg0zW4oMH+m/CBbvvpwUh4zEC6
bRlo8+oFtKNss7NZ8G0Fy5F34Kdjpg==
=BjlX
-----END PGP SIGNATURE-----

--=-WjFNXPObEjrLaHp10c/x--
