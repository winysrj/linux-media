Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48557 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732173AbeGaPmZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 11:42:25 -0400
Date: Tue, 31 Jul 2018 16:01:53 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Colin Ian King <colin.king@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][media-next] media: i2c: mt9v111: fix off-by-one array
 bounds check
Message-ID: <20180731140153.GE370@w540>
References: <20180731133343.22337-1-colin.king@canonical.com>
 <20180731135341.GD370@w540>
 <c2684aa2-71d7-b82e-df18-65ea3f026d97@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <c2684aa2-71d7-b82e-df18-65ea3f026d97@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Colin,

On Tue, Jul 31, 2018 at 02:55:25PM +0100, Colin Ian King wrote:
> On 31/07/18 14:53, jacopo mondi wrote:
> > Hi Colin,
> >    thanks for the patch.
> >
> > On Tue, Jul 31, 2018 at 02:33:43PM +0100, Colin King wrote:
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> The check of fse->index is off-by-one and should be using >= rather
> >> than > to check the maximum allowed array index. Fix this.
> >>
> >> Detected by CoverityScan, CID#172122 ("Out-of-bounds read")
> >>
> >> Fixes: aab7ed1c3927 ("media: i2c: Add driver for Aptina MT9V111")
> >> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >
> > Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >
> > Thanks
> >   j
> >
>
> Just to note, I also got a build warning on this driver, so that's
> something that should be fixed up too.
>
> drivers/media/i2c/mt9v111.c:887:15: warning: 'idx' may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>   unsigned int idx;

Yes, that's false positive but indeed gcc doesn't know about that.

A patch has already been sent and will hopefully be collected soon:
https://patchwork.linuxtv.org/patch/51259/

Thanks for noticing
   j

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbYGvRAAoJEHI0Bo8WoVY8rS8QAJOIcceLmLJW2x1mtyw4zFJ4
sn6jRcKEzBgWjTT2FuLgKXyGXCeDXCy3q0oqLhWjAOd0EwXP6DBEr9AHfDVuCpAj
ZFQEJ41Whvq63wBDtCOZaJH9a/A3SSp6Jy7uOTYL1xdmZQrwbcS4y+eodhm9aFcE
2klEOc4wfGanUjwLI4yUVNMQS7J694j4PyA+7gCXU01bh0vtJ6VuAudscTvWIr99
pn7XY8yYwSWl/6MIWCWTOXpxeq7ujRRcmg6N5VZFNowkD2xGUE1skfEQaunSPMZ9
U1bDaglzbB7NhXqQB/T3u6BiD/Y/dM2ICC+gDsw6/hpr1z0gEtRqSLqZPefDJC6R
8BQdneF1uNDZRB7LrBlbn1qbRCBpQ3tKreJXmw6tce9OA3KZcM8lJqzKZhVJey2+
pA+JGZo/Ukdk3DkbpPGglDcrZgxKBS75H999h0CgMImAy1PsRs8hIwgy/ltr6lgR
vfheY6q2vKofHioXs3xUHaATeIxdG/gioQtwdnyKQ+Qwh7ImNy46sUgICxoCFHBj
De5N2AcYqU9NdZQVXQYwzGy8GlRs1UOdcar5gvTbJ+3VEpZxmtG3jMD4TQozeemI
2lGDLJCCsr7m1IdO0gxXBdf69iDaFBP6RNP/PG+l/Y8iHcb6PdNYJ4Yr9yFqmarU
FLhsFNiQmeFvwcAQafq8
=FtHl
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
