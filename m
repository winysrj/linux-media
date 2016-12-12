Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:39089 "EHLO
        imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751146AbcLLWbS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 17:31:18 -0500
Date: Mon, 12 Dec 2016 22:31:15 +0000
From: James Hogan <james.hogan@imgtec.com>
To: Sean Young <sean@mess.org>
CC: <linux-media@vger.kernel.org>, Sifan Naeem <sifan.naeem@imgtec.com>
Subject: Re: [PATCH v5 02/18] [media] img-ir: use new wakeup_protocols sysfs
 mechanism
Message-ID: <20161212223115.GB30099@jhogan-linux.le.imgtec.org>
References: <cover.1481575826.git.sean@mess.org>
 <074994409ca834b6fcd950e7da60456247f12ce5.1481575826.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <074994409ca834b6fcd950e7da60456247f12ce5.1481575826.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sean (and Sifan),

On Mon, Dec 12, 2016 at 09:13:43PM +0000, Sean Young wrote:
> Rather than guessing what variant a scancode is from its length,
> use the new wakeup_protocol.
>=20
> Signed-off-by: Sean Young <sean@mess.org>
> Cc: James Hogan <james.hogan@imgtec.com>
> Cc: Sifan Naeem <sifan.naeem@imgtec.com>
> ---
>  drivers/media/rc/img-ir/img-ir-hw.c    |  2 +-
>  drivers/media/rc/img-ir/img-ir-hw.h    |  2 +-
>  drivers/media/rc/img-ir/img-ir-jvc.c   |  2 +-
>  drivers/media/rc/img-ir/img-ir-nec.c   |  6 +++---
>  drivers/media/rc/img-ir/img-ir-rc5.c   |  2 +-
>  drivers/media/rc/img-ir/img-ir-rc6.c   |  2 +-
>  drivers/media/rc/img-ir/img-ir-sanyo.c |  2 +-
>  drivers/media/rc/img-ir/img-ir-sharp.c |  2 +-
>  drivers/media/rc/img-ir/img-ir-sony.c  | 11 +++--------
>  9 files changed, 13 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-i=
r/img-ir-hw.c
> index 1a0811d..841d9d7 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -488,7 +488,7 @@ static int img_ir_set_filter(struct rc_dev *dev, enum=
 rc_filter_type type,
>  	/* convert scancode filter to raw filter */
>  	filter.minlen =3D 0;
>  	filter.maxlen =3D ~0;
> -	ret =3D hw->decoder->filter(sc_filter, &filter, hw->enabled_protocols);
> +	ret =3D hw->decoder->filter(sc_filter, &filter, dev->wakeup_protocol);

According to patch 1, wakeup_protocol can always be set to
RC_TYPE_UNKNOWN using the protocol "none", but this function is used for
the normal filter too. AFAICT that would make it impossible to set a
normal filter without first setting the (new) wakeup protocol too.
Technically when type =3D=3D RC_FILTER_NORMAL, the protocol should be based
on enabled_protocols, which should be set to a single protocol group.

I'll also note that enforcing that a wakeup protocol is set before
setting the wakeup filter (in patch 1 which I'm not Cc'd on) is an
incompatible API change. The old API basically meant that a mask of 0
disabled the wakeup filter, and there was no wakeup_protocol to set.

If wakeup filters can be changed to still be writable when wakeup
protocol is not set, then I suppose this driver could do something like:

	if (type =3D=3D RC_TYPE_NORMAL) {
		use hw->enabled_protocols;
	} else if (type =3D=3D RC_TYPE_WAKEUP) {
		if (dev->wakeup_protocol =3D=3D RC_TYPE_UNKNOWN)
			use hw->enabled_protocols;
		else
			use 1 << dev->wakeup_protocol;
	}
=09
Clearly allowing a wakeup filter with no protocol is not ideal though.

It probably isn't a big deal from the img-ir point of view for those
semantics to change slightly. The TZ1090 SoC I originally wrote the
driver for is practically obsolete from my point of view, and the common
clk and power management drivers to make this driver/feature functional
was never merged into mainline.

Sifan: Does the MIPS pistachio SoC support wake up using img-ir, and
does it even support suspend to RAM in mainline yet? If not then its
impossible to utilise the wake filters in current kernels and changing
the semantics is probably fine.

Cheers
James


>  	if (ret)
>  		goto unlock;
>  	dev_dbg(priv->dev, "IR raw %sfilter=3D%016llx & %016llx\n",
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-i=
r/img-ir-hw.h
> index 91a2977..e1959ddc 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.h
> +++ b/drivers/media/rc/img-ir/img-ir-hw.h
> @@ -179,7 +179,7 @@ struct img_ir_decoder {
>  	int (*scancode)(int len, u64 raw, u64 enabled_protocols,
>  			struct img_ir_scancode_req *request);
>  	int (*filter)(const struct rc_scancode_filter *in,
> -		      struct img_ir_filter *out, u64 protocols);
> +		      struct img_ir_filter *out, enum rc_type protocol);
>  };
> =20
>  extern struct img_ir_decoder img_ir_nec;
> diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-=
ir/img-ir-jvc.c
> index d3e2fc0..10b302c 100644
> --- a/drivers/media/rc/img-ir/img-ir-jvc.c
> +++ b/drivers/media/rc/img-ir/img-ir-jvc.c
> @@ -30,7 +30,7 @@ static int img_ir_jvc_scancode(int len, u64 raw, u64 en=
abled_protocols,
> =20
>  /* Convert JVC scancode to JVC data filter */
>  static int img_ir_jvc_filter(const struct rc_scancode_filter *in,
> -			     struct img_ir_filter *out, u64 protocols)
> +			     struct img_ir_filter *out, enum rc_type protocol)
>  {
>  	unsigned int cust, data;
>  	unsigned int cust_m, data_m;
> diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-=
ir/img-ir-nec.c
> index 0931493..fff00d4 100644
> --- a/drivers/media/rc/img-ir/img-ir-nec.c
> +++ b/drivers/media/rc/img-ir/img-ir-nec.c
> @@ -54,7 +54,7 @@ static int img_ir_nec_scancode(int len, u64 raw, u64 en=
abled_protocols,
> =20
>  /* Convert NEC scancode to NEC data filter */
>  static int img_ir_nec_filter(const struct rc_scancode_filter *in,
> -			     struct img_ir_filter *out, u64 protocols)
> +			     struct img_ir_filter *out, enum rc_type protocol)
>  {
>  	unsigned int addr, addr_inv, data, data_inv;
>  	unsigned int addr_m, addr_inv_m, data_m, data_inv_m;
> @@ -62,7 +62,7 @@ static int img_ir_nec_filter(const struct rc_scancode_f=
ilter *in,
>  	data       =3D in->data & 0xff;
>  	data_m     =3D in->mask & 0xff;
> =20
> -	if ((in->data | in->mask) & 0xff000000) {
> +	if (protocol =3D=3D RC_TYPE_NEC32) {
>  		/* 32-bit NEC (used by Apple and TiVo remotes) */
>  		/* scan encoding: as transmitted, MSBit =3D first received bit */
>  		addr       =3D bitrev8(in->data >> 24);
> @@ -73,7 +73,7 @@ static int img_ir_nec_filter(const struct rc_scancode_f=
ilter *in,
>  		data_m     =3D bitrev8(in->mask >>  8);
>  		data_inv   =3D bitrev8(in->data >>  0);
>  		data_inv_m =3D bitrev8(in->mask >>  0);
> -	} else if ((in->data | in->mask) & 0x00ff0000) {
> +	} else if (protocol =3D=3D RC_TYPE_NECX) {
>  		/* Extended NEC */
>  		/* scan encoding AAaaDD */
>  		addr       =3D (in->data >> 16) & 0xff;
> diff --git a/drivers/media/rc/img-ir/img-ir-rc5.c b/drivers/media/rc/img-=
ir/img-ir-rc5.c
> index a8a28a3..24a6bcf 100644
> --- a/drivers/media/rc/img-ir/img-ir-rc5.c
> +++ b/drivers/media/rc/img-ir/img-ir-rc5.c
> @@ -41,7 +41,7 @@ static int img_ir_rc5_scancode(int len, u64 raw, u64 en=
abled_protocols,
> =20
>  /* Convert RC5 scancode to RC5 data filter */
>  static int img_ir_rc5_filter(const struct rc_scancode_filter *in,
> -				 struct img_ir_filter *out, u64 protocols)
> +			     struct img_ir_filter *out, enum rc_type protocol)
>  {
>  	/* Not supported by the hw. */
>  	return -EINVAL;
> diff --git a/drivers/media/rc/img-ir/img-ir-rc6.c b/drivers/media/rc/img-=
ir/img-ir-rc6.c
> index de1e275..451e2ef8 100644
> --- a/drivers/media/rc/img-ir/img-ir-rc6.c
> +++ b/drivers/media/rc/img-ir/img-ir-rc6.c
> @@ -62,7 +62,7 @@ static int img_ir_rc6_scancode(int len, u64 raw, u64 en=
abled_protocols,
> =20
>  /* Convert RC6 scancode to RC6 data filter */
>  static int img_ir_rc6_filter(const struct rc_scancode_filter *in,
> -				 struct img_ir_filter *out, u64 protocols)
> +			     struct img_ir_filter *out, enum rc_type protocol)
>  {
>  	/* Not supported by the hw. */
>  	return -EINVAL;
> diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/im=
g-ir/img-ir-sanyo.c
> index f394994..8f542bd 100644
> --- a/drivers/media/rc/img-ir/img-ir-sanyo.c
> +++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
> @@ -51,7 +51,7 @@ static int img_ir_sanyo_scancode(int len, u64 raw, u64 =
enabled_protocols,
> =20
>  /* Convert Sanyo scancode to Sanyo data filter */
>  static int img_ir_sanyo_filter(const struct rc_scancode_filter *in,
> -			       struct img_ir_filter *out, u64 protocols)
> +			       struct img_ir_filter *out, enum rc_type protocol)
>  {
>  	unsigned int addr, addr_inv, data, data_inv;
>  	unsigned int addr_m, data_m;
> diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/im=
g-ir/img-ir-sharp.c
> index fe5acc4..c8b4e9b 100644
> --- a/drivers/media/rc/img-ir/img-ir-sharp.c
> +++ b/drivers/media/rc/img-ir/img-ir-sharp.c
> @@ -39,7 +39,7 @@ static int img_ir_sharp_scancode(int len, u64 raw, u64 =
enabled_protocols,
> =20
>  /* Convert Sharp scancode to Sharp data filter */
>  static int img_ir_sharp_filter(const struct rc_scancode_filter *in,
> -			       struct img_ir_filter *out, u64 protocols)
> +			       struct img_ir_filter *out, enum rc_type protocol)
>  {
>  	unsigned int addr, cmd, exp =3D 0, chk =3D 0;
>  	unsigned int addr_m, cmd_m, exp_m =3D 0, chk_m =3D 0;
> diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img=
-ir/img-ir-sony.c
> index 7f7375f..ecae41c 100644
> --- a/drivers/media/rc/img-ir/img-ir-sony.c
> +++ b/drivers/media/rc/img-ir/img-ir-sony.c
> @@ -55,7 +55,7 @@ static int img_ir_sony_scancode(int len, u64 raw, u64 e=
nabled_protocols,
> =20
>  /* Convert NEC scancode to NEC data filter */
>  static int img_ir_sony_filter(const struct rc_scancode_filter *in,
> -			      struct img_ir_filter *out, u64 protocols)
> +			      struct img_ir_filter *out, enum rc_type protocol)
>  {
>  	unsigned int dev, subdev, func;
>  	unsigned int dev_m, subdev_m, func_m;
> @@ -68,19 +68,14 @@ static int img_ir_sony_filter(const struct rc_scancod=
e_filter *in,
>  	func     =3D (in->data >> 0)  & 0x7f;
>  	func_m   =3D (in->mask >> 0)  & 0x7f;
> =20
> -	if (subdev & subdev_m) {
> +	if (protocol =3D=3D RC_TYPE_SONY20) {
>  		/* can't encode subdev and higher device bits */
>  		if (dev & dev_m & 0xe0)
>  			return -EINVAL;
> -		/* subdevice (extended) bits only in 20 bit encoding */
> -		if (!(protocols & RC_BIT_SONY20))
> -			return -EINVAL;
>  		len =3D 20;
>  		dev_m &=3D 0x1f;
> -	} else if (dev & dev_m & 0xe0) {
> +	} else if (protocol =3D=3D RC_TYPE_SONY15) {
>  		/* upper device bits only in 15 bit encoding */
> -		if (!(protocols & RC_BIT_SONY15))
> -			return -EINVAL;
>  		len =3D 15;
>  		subdev_m =3D 0;
>  	} else {
> --=20
> 2.9.3
>=20

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYTyUrAAoJEGwLaZPeOHZ6mvAP/3uRD3tBsKcoZXp4Qa4btPBC
Omih0UxnIZ+yIEZTE6zbo9KFFiHNYsQaEN1SWpx1Pj0Z48mVG4HQaVMGsxGvZyUg
IuXtc2juPPJ8P7KmenUpaj8hnG1HRw0sEjopAcbwcWS2Cr4IM9IL1xuz4XGRZwuX
gNfDoRpCMZzS2v4sNRYrYyrCZxoG61hrpfuUOSppunSUY5tY/LbyYQjX11dUBJ9c
gi0OuhQGOjCdm2n8Eqchn88yEEhg2ecbJ0wO9yjHBHoGWpKj+4Ehb2vsuUFAgf7L
oEtKZDpIifUBKzvcoD7XxG4Io/bKMXPPFG2+lWQwoBkSZY43yFGcBGzbD6vuHH+X
DKpkrFPnFkHN2gJ/fJ4VdJZOQDhc/nZmgtknt4lPEVYffJbopVF/oWF2egtsyfaS
30VT0k+YhtvWekrjPbIkHI02rze8A8k3wh44mdfzAZAYWVitiznBt9KabJkB+Zap
25qBC04Bepl2onFSPIahYV+C0ij7DOAIunMOHjzC6qKt8TCp9mBzwQWsmVSmiXaZ
2sOSw7Lhb2Wt675C7c7b+aTvMHhcgXwYfE3ThHwyDf7ohisA0yHiPhQrh6GFXHqF
os0/XQRw9pbVId/jNnyzVFfGz5eVB4XA34QRTxh+GM3c6ySv6+ImcZnFwCFWmnKr
aNZsH9JaS2+yPXJqZaCX
=+GW4
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
