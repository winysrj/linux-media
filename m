Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:42270 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753236AbdK0UzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 15:55:03 -0500
Date: Mon, 27 Nov 2017 17:45:31 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        y2038@lists.linaro.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] [media] solo6x10: use ktime_get_ts64() for time sync
Message-ID: <20171127204530.GB330@pirotess.bf.iodev.co.uk>
References: <20171127132027.1734806-1-arnd@arndb.de>
 <20171127132027.1734806-3-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20171127132027.1734806-3-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27/Nov/2017 14:19, Arnd Bergmann wrote:
> solo6x10 correctly deals with time stamps and will never
> suffer from overflows, but it uses the deprecated 'struct timespec'
> type and 'ktime_get_ts()' interface to read the monotonic clock.
>=20
> This changes it to use ktime_get_ts64() instead, so we can
> eventually remove ktime_get_ts().
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/pci/solo6x10/solo6x10-core.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/p=
ci/solo6x10/solo6x10-core.c
> index ca0873e47bea..19ffd2ed3cc7 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-core.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-core.c
> @@ -47,18 +47,19 @@ MODULE_PARM_DESC(full_eeprom, "Allow access to full 1=
28B EEPROM (dangerous)");
> =20
>  static void solo_set_time(struct solo_dev *solo_dev)
>  {
> -	struct timespec ts;
> +	struct timespec64 ts;
> =20
> -	ktime_get_ts(&ts);
> +	ktime_get_ts64(&ts);
> =20
> -	solo_reg_write(solo_dev, SOLO_TIMER_SEC, ts.tv_sec);
> -	solo_reg_write(solo_dev, SOLO_TIMER_USEC, ts.tv_nsec / NSEC_PER_USEC);
> +	/* no overflow because we use monotonic timestamps */
> +	solo_reg_write(solo_dev, SOLO_TIMER_SEC, (u32)ts.tv_sec);
> +	solo_reg_write(solo_dev, SOLO_TIMER_USEC, (u32)ts.tv_nsec / NSEC_PER_US=
EC);
>  }
> =20
>  static void solo_timer_sync(struct solo_dev *solo_dev)
>  {
>  	u32 sec, usec;
> -	struct timespec ts;
> +	struct timespec64 ts;
>  	long diff;
> =20
>  	if (solo_dev->type !=3D SOLO_DEV_6110)
> @@ -72,11 +73,11 @@ static void solo_timer_sync(struct solo_dev *solo_dev)
>  	sec =3D solo_reg_read(solo_dev, SOLO_TIMER_SEC);
>  	usec =3D solo_reg_read(solo_dev, SOLO_TIMER_USEC);
> =20
> -	ktime_get_ts(&ts);
> +	ktime_get_ts64(&ts);
> =20
> -	diff =3D (long)ts.tv_sec - (long)sec;
> +	diff =3D (s32)ts.tv_sec - (s32)sec;
>  	diff =3D (diff * 1000000)
> -		+ ((long)(ts.tv_nsec / NSEC_PER_USEC) - (long)usec);
> +		+ ((s32)(ts.tv_nsec / NSEC_PER_USEC) - (s32)usec);
> =20
>  	if (diff > 1000 || diff < -1000) {
>  		solo_set_time(solo_dev);
> --=20
> 2.9.0
>=20

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEAqyZ04eQQpueXW0v7JuE7EFrBNgFAloceWQACgkQ7JuE7EFr
BNjV0Q/+INPRiVf49QVyMIqBaR2mLn9v+IO80q2Oe+YtpszphwX02mB9wB9Slqf9
TdxTwy/3OQ3ic1yOMNiewubjM0ro6adBhACX/S/uSwwpfT6I0nPItnmcnFQnENiw
B0haRm8XlzO7dRa2C3XqYil71POFpxlLSi/nU2IRCz72OcDxVmrz1fRR9E7TuDVQ
YvT6gbOv9e4QKT/CyUID+O5piL9cOkErYmySpb9mw1qp+yIM9lsnCDfKkQcGuIf+
os3O6aeVZ4p12ctFE5op9VbamRoxusKv8BuICeR3mymhh7KQ6xLVImKjm0jo5le4
yONuIVip/wjdB20zwitLfcEnWbAds7bmdKEpTz+GEeqIsCBxZ/sT+/GCMyEzhuFY
z/Yy+avcXuvE29vGvShUka4zgBcQKBn3gpPEW4WkyCmAx9W+ssteyLlyRlfMfXuD
8BuqywUZ1Gfwx71Eri6dTVzqymdzCvdA5b4NfKa1z5rcKq2Ykr0rrV8jqhaV7iha
Ti/K3M19s6GpUTeGqhkACHRPoCDGErggvYbkHH9T6EUDMDmKNV5bVjGiPv4KYNHZ
cY+/18M/ZFQmnjmrXGlHMaBNNtEhWtJttcMa8xQu6Mdj+2W2Dz3je8xWV+Jg2WPG
jCGo6JDuysnz6KuvQH83sh14Wekak0sWw8J+sEWFFKK1RBaQ1eU=
=sCj8
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
