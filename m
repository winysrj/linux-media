Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34106 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751588AbdHPINH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 04:13:07 -0400
Date: Wed, 16 Aug 2017 10:13:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] et8ek8: Decrease stack usage
Message-ID: <20170816081305.GA19601@amd>
References: <1502868825-4531-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1502868825-4531-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-08-16 10:33:45, Sakari Ailus wrote:
> The et8ek8 driver combines I=B2C register writes to a single array that it
> passes to i2c_transfer(). The maximum number of writes is 48 at once,
> decrease it to 8 and make more transfers if needed, thus avoiding a
> warning on stack usage.

Dunno. Slowing down code to save stack does not sound attractive.

What about this one? Way simpler, too... (Unless there's some rule
about i2c, DMA and static buffers. Is it?)

Signed-off-by: Pavel Machek <pavel@ucw.cz>

 (untested)
								Pavel

diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c/e=
t8ek8/et8ek8_driver.c
index f39f517..64da731 100644
--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -227,7 +227,7 @@ static int et8ek8_i2c_buffered_write_regs(struct i2c_cl=
ient *client,
 					  int cnt)
 {
 	struct i2c_msg msg[ET8EK8_MAX_MSG];
-	unsigned char data[ET8EK8_MAX_MSG][6];
+	static unsigned char data[ET8EK8_MAX_MSG][6];
 	int wcnt =3D 0;
 	u16 reg, data_length;
 	u32 val;



> ---
> Pavel: this is just compile tested. Could you test it on N900, please?
>=20
>  drivers/media/i2c/et8ek8/et8ek8_driver.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c=
/et8ek8/et8ek8_driver.c
> index f39f517..c14f0fd 100644
> --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> @@ -43,7 +43,7 @@
> =20
>  #define ET8EK8_NAME		"et8ek8"
>  #define ET8EK8_PRIV_MEM_SIZE	128
> -#define ET8EK8_MAX_MSG		48
> +#define ET8EK8_MAX_MSG		8
> =20
>  struct et8ek8_sensor {
>  	struct v4l2_subdev subdev;
> @@ -220,7 +220,8 @@ static void et8ek8_i2c_create_msg(struct i2c_client *=
client, u16 len, u16 reg,
> =20
>  /*
>   * A buffered write method that puts the wanted register write
> - * commands in a message list and passes the list to the i2c framework
> + * commands in smaller number of message lists and passes the lists to
> + * the i2c framework
>   */
>  static int et8ek8_i2c_buffered_write_regs(struct i2c_client *client,
>  					  const struct et8ek8_reg *wnext,
> @@ -231,11 +232,7 @@ static int et8ek8_i2c_buffered_write_regs(struct i2c=
_client *client,
>  	int wcnt =3D 0;
>  	u16 reg, data_length;
>  	u32 val;
> -
> -	if (WARN_ONCE(cnt > ET8EK8_MAX_MSG,
> -		      ET8EK8_NAME ": %s: too many messages.\n", __func__)) {
> -		return -EINVAL;
> -	}
> +	int rval;
> =20
>  	/* Create new write messages for all writes */
>  	while (wcnt < cnt) {
> @@ -249,10 +246,21 @@ static int et8ek8_i2c_buffered_write_regs(struct i2=
c_client *client,
> =20
>  		/* Update write count */
>  		wcnt++;
> +
> +		if (wcnt < ET8EK8_MAX_MSG)
> +			continue;
> +
> +		rval =3D i2c_transfer(client->adapter, msg, wcnt);
> +		if (rval < 0)
> +			return rval;
> +
> +		cnt -=3D wcnt;
> +		wcnt =3D 0;
>  	}
> =20
> -	/* Now we send everything ... */
> -	return i2c_transfer(client->adapter, msg, wcnt);
> +	rval =3D i2c_transfer(client->adapter, msg, wcnt);
> +
> +	return rval < 0 ? rval : 0;
>  }
> =20
>  /*

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmT/pEACgkQMOfwapXb+vL9SgCeINMAOoL9gtZv7J+0SpwtgJmy
K+wAniZKkYEfFsrf/j0eje6ouFC5zPSn
=7UgL
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
