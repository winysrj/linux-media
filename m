Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58582 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1IAGdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 02:33:31 -0400
Date: Thu, 1 Sep 2011 08:33:23 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] [media] tm6000: Add fast USB access quirk
Message-ID: <20110901063323.GA30810@avionic-0098.adnet.avionic-design.de>
References: <4E5F1C87.9050207@redhat.com>
 <1314858441-30813-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <1314858441-30813-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Thierry Reding wrote:
> Some devices support fast access to registers using the USB interface
> while others require a certain delay after each operation. This commit
> adds a quirk that can be enabled by devices that don't need the delay.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/staging/tm6000/tm6000-core.c |    3 ++-
>  drivers/staging/tm6000/tm6000.h      |    6 ++++++
>  2 files changed, 8 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm600=
0/tm6000-core.c
> index 64fc1c6..93a0772 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -89,7 +89,8 @@ int tm6000_read_write_usb(struct tm6000_core *dev, u8 r=
eq_type, u8 req,
> =20
>  	kfree(data);
> =20
> -	msleep(5);
> +	if ((dev->quirks & TM6000_QUIRK_NO_USB_DELAY) =3D=3D 0)
> +		msleep(5);

This is of course completely wrong. The quirk as defined below is actually a
bit position. I'll send another update where the quirk is defined as bit ma=
sk
for the given position.

Thierry

> =20
>  	mutex_unlock(&dev->usb_lock);
>  	return ret;
> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6=
000.h
> index dac2063..0e35812 100644
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -169,6 +169,10 @@ struct tm6000_endpoint {
>  	unsigned			maxsize;
>  };
> =20
> +enum {
> +	TM6000_QUIRK_NO_USB_DELAY,
> +};
> +
>  struct tm6000_core {
>  	/* generic device properties */
>  	char				name[30];	/* name (including minor) of the device */
> @@ -260,6 +264,8 @@ struct tm6000_core {
>  	struct usb_isoc_ctl          isoc_ctl;
> =20
>  	spinlock_t                   slock;
> +
> +	unsigned long quirks;
>  };
> =20
>  enum tm6000_ops_type {
> --=20
> 1.7.6.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5fJzMACgkQZ+BJyKLjJp8/IwCgspNO7Et4vlo9ZWjmlF01KpY5
G5IAoKMshzOdZSW1f2eFTtgSJaeKnLDe
=F5WA
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
