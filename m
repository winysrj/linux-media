Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:43052 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbaDCX1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 19:27:39 -0400
Received: by mail-wg0-f41.google.com with SMTP id n12so2670916wgh.24
        for <linux-media@vger.kernel.org>; Thu, 03 Apr 2014 16:27:38 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: Re: [PATCH 05/11] rc-core: split dev->s_filter
Date: Fri, 04 Apr 2014 00:27:29 +0100
Message-ID: <3169568.oAQQsFv03l@radagast>
In-Reply-To: <20140329161111.13234.73883.stgit@zeus.muc.hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu> <20140329161111.13234.73883.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8677081.v55TuiO7Rv"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart8677081.v55TuiO7Rv
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi David,

On Saturday 29 March 2014 17:11:11 David H=E4rdeman wrote:
> Overloading dev->s_filter to do two different functions (set wakeup f=
ilters
> and generic hardware filters) makes it impossible to tell what the
> hardware actually supports, so create a separate dev->s_wakeup_filter=
 and
> make the distinction explicit.
>=20
> Signed-off-by: David H=E4rdeman <david@hardeman.nu>
> ---

> @@ -1121,9 +1126,11 @@ static ssize_t store_filter(struct device *dev=
ice,
>  =09if (ret < 0)
>  =09=09return ret;
>=20
> -=09/* Scancode filter not supported (but still accept 0) */
> -=09if (!dev->s_filter && fattr->type !=3D RC_FILTER_NORMAL)
> -=09=09return val ? -EINVAL : count;
> +=09/* Can the scancode filter be set? */
> +=09set_filter =3D (fattr->type =3D=3D RC_FILTER_NORMAL)
> +=09=09? dev->s_filter : dev->s_wakeup_filter;
> +=09if (!set_filter)
> +=09=09return -EINVAL;

Technically the removal of the "fattr->type !=3D RC_FILTER_NORMAL" cond=
ition and=20
returning -EINVAL rather than "val ? -EINVAL : count" should be in patc=
h 6=20
since it's for generic scancode filter support.


> -=09if (dev->s_filter) {
> -=09=09ret =3D dev->s_filter(dev, fattr->type, &local_filter);
> -=09=09if (ret < 0)
> -=09=09=09goto unlock;
> -=09}
> +
> +=09ret =3D set_filter(dev, &local_filter);
> +=09if (ret < 0)
> +=09=09goto unlock;

same here for removing the if condition.

Otherwise this patch looks okay to me.

Cheers
James
--nextPart8677081.v55TuiO7Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTPe5nAAoJEKHZs+irPybfWkwP/1lP6vZsjCeMYI5g65mXBHbp
99Kvbo+twJtOiaS63Qs4vsiGqEeeDp/5PPrhYCkXcwCALHS7xOyE1a98xivN+izY
Uts1E7p9OEZ6bkdHkdM7nKzWNYBqc1whrSSCu2ZvPHvJvkWwOy6qxE/K6AMUizwp
1AYGMvYSN2DHUL3U4z75SCzm5Cai+JsvDZbiWvXaaXqgavnAdfodlJd/BqzWpwNj
j3kx7n+7jizZybmTrNFUd7P1IFXpYsJ2ZLYqU0jWXBqWV54Yi7qbGjt46oUcRTwx
zJKsz104qx0ZMqd3r0R6r7ER6aqOdJZTP5//rB6nOadsz+Mh9kbuLLmYhQjJWBcX
gFPIKETrHFCv328xQBupXU2masSWK0laLIYMNLDNPS01rNKCE+OJTFXBHvWY75Qj
ZVD1b35SPutJzt+ZLs3UaQSTS9yyXM7x9ae1qfydf+JzZ/c8tPZekiWsp1j36byh
SIgR7HxKxI1f9n8VLj/PMX9a/y4bjyvof1AhFCbn1MC7h2eBnK4IkNaadyQlBax7
7h1VHtF+VD/PtY+RigRYKHLC0SEhkg8uPrJ7MnDFES+NnAhMt0JRkEPRrK8AEYJw
U9rrb/6eMggrxtbV+bMkddp7Fvz+L9R/qoLzjliqcuC0YfiBeRRHWIHgS1d4Jz8Y
LAlTjxcBpldJmNo/h/De
=DPg/
-----END PGP SIGNATURE-----

--nextPart8677081.v55TuiO7Rv--

