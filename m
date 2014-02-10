Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:54099 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbaBJKZj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 05:25:39 -0500
Message-ID: <52F8A906.9060303@imgtec.com>
Date: Mon, 10 Feb 2014 10:25:10 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] rc-core: Add Manchester encoder (phase encoder)
 support to rc-core
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com> <1391861250-26068-1-git-send-email-a.seppala@gmail.com> <1391861250-26068-2-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1391861250-26068-2-git-send-email-a.seppala@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="RSmgMBl3DhJnGvsVSk6FLV9Al2ATdSh9F"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--RSmgMBl3DhJnGvsVSk6FLV9Al2ATdSh9F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Antti,

On 08/02/14 12:07, Antti Sepp=C3=A4l=C3=A4 wrote:
> Adding a simple Manchester encoder to rc-core.
> Manchester coding is used by at least RC-5 protocol and its variants.
>=20
> Signed-off-by: Antti Sepp=C3=A4l=C3=A4 <a.seppala@gmail.com>
> ---
>  drivers/media/rc/ir-raw.c       | 44 +++++++++++++++++++++++++++++++++=
++++++++
>  drivers/media/rc/rc-core-priv.h | 14 +++++++++++++
>  2 files changed, 58 insertions(+)
>=20
> diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
> index 9d734dd..7fea9ac 100644
> --- a/drivers/media/rc/ir-raw.c
> +++ b/drivers/media/rc/ir-raw.c
> @@ -240,6 +240,50 @@ ir_raw_get_allowed_protocols(void)
>  	return protocols;
>  }
> =20
> +int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
> +			  const struct ir_raw_timings_manchester *timings,
> +			  unsigned int n, unsigned int data)
> +{
> +	bool need_pulse;
> +	int i, count =3D 0;
> +	i =3D 1 << (n - 1);
> +
> +	if (n > max || max < 2)
> +		return -EINVAL;
> +
> +	if (timings->pulse_space_start) {
> +		init_ir_raw_event_duration((*ev)++, 1, timings->clock);
> +		init_ir_raw_event_duration((*ev), 0, timings->clock);
> +		count +=3D 2;
> +	} else {
> +		init_ir_raw_event_duration((*ev), 1, timings->clock);
> +		count++;
> +	}
> +	i >>=3D 1;

If you use pulse_space_start to encode the first bit, did you mean to
discard the highest bit of data?

> +
> +	while (i > 0) {
> +		if (count > max)

if count > max I think you've already overflowed the buffer (max is more
of a max count rather than max buffer index).

> +			return -EINVAL;
> +
> +		need_pulse =3D !(data & i);
> +		if (need_pulse =3D=3D !!(*ev)->pulse) {
> +			(*ev)->duration +=3D timings->clock;
> +		} else {
> +			init_ir_raw_event_duration(++(*ev), need_pulse,
> +						   timings->clock);
> +			count++;

I guess you need to check for buffer space here too.

> +		}
> +
> +		init_ir_raw_event_duration(++(*ev), !need_pulse,
> +					   timings->clock);
> +		count++;
> +		i >>=3D 1;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ir_raw_gen_manchester);

Cheers
James


--RSmgMBl3DhJnGvsVSk6FLV9Al2ATdSh9F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJS+KkgAAoJEKHZs+irPybfut8P/2JBS0Cu+Lz/ij0OSKYESG+g
RUi7L97B3J1zGmDQzqEsayJZFZIbJIsxmemaewiwW5IwJ/1Q/YBhlE89gUjY3sF1
da5Ms2F9eD9toOIlhyEpl1dgiaUa3uIAZ1754iESZ4VyIc7GseP5tTbo3aBmLY67
/hI5jYVwqdOuHEdgiinKrAQfpvXuLurz+gjqs64eFjJz8pQgBgze2hKCYTJ5r/GM
Zr4O3a685hclhn6+C3dIASycaQwAs+2ysj78V6LP1SLjB6AcVmZ49yDTMGhMZ/Re
aDHaa1tn2hBKDHgQvwQ+2Zm9ndxnQoMWFBXB4mltP99VphcGswA0jW8+lxx3FgUl
alb9QG543DREECFVyhXN3MA4pQiF136j3KGvo8Uvwgz4kkPSFXwV7A/LgBTPIpvd
khEpQ8tbNvP+DQwJi9+KM7xta5jUkwjV81Y7G4zlf+wPzLFQ3OwZHZlJ5BD33Oh/
IMkk3hBYmHa+9IjCVdH3auMOZQlbfov85kBE0kWg55ofMY3Sd6JBiX4Lrj4IxcTc
b5yF2XzVLo8SFG90r1WPPCUl29Jvw6DoX029RSyTN/dFScRSNnY1mQm1uznNU8tp
IdygwnEjhKoZMPdM1l2AZLXM1HQKmCc4a4XCYUKXQ0rcK5RmQDCU9S1k82d6Cazf
xkBVH5pKc3/DHFOsXOHf
=zT23
-----END PGP SIGNATURE-----

--RSmgMBl3DhJnGvsVSk6FLV9Al2ATdSh9F--

