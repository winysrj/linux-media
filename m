Return-path: <linux-media-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.211]:40704 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdK2K40 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:56:26 -0500
Date: Wed, 29 Nov 2017 10:49:47 +0000
From: James Hogan <james.hogan@mips.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH 04/12] media: img-ir-hw: fix one kernel-doc comment
Message-ID: <20171129104946.GE5027@jhogan-linux.mipstec.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
 <86850b9a0495b10326765f03b9e77fd46e83981c.1511952372.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <86850b9a0495b10326765f03b9e77fd46e83981c.1511952372.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2017 at 05:46:25AM -0500, Mauro Carvalho Chehab wrote:
> Needed to suppress the following warnings:
> 	drivers/media/rc/img-ir/img-ir-hw.c:351: warning: No description found f=
or parameter 'reg_timings'
> 	drivers/media/rc/img-ir/img-ir-hw.c:351: warning: Excess function parame=
ter 'timings' description in 'img_ir_decoder_convert'
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Very true.
Acked-by: James Hogan <jhogan@kernel.org>

Thanks
James

> ---
>  drivers/media/rc/img-ir/img-ir-hw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-i=
r/img-ir-hw.c
> index f54bc5d23893..ec4ded84cd17 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -339,7 +339,7 @@ static void img_ir_decoder_preprocess(struct img_ir_d=
ecoder *decoder)
>  /**
>   * img_ir_decoder_convert() - Generate internal timings in decoder.
>   * @decoder:	Decoder to be converted to internal timings.
> - * @timings:	Timing register values.
> + * @reg_timings: Timing register values.
>   * @clock_hz:	IR clock rate in Hz.
>   *
>   * Fills out the repeat timings and timing register values for a specifi=
c clock
> --=20
> 2.14.3
>=20

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAloekMMACgkQbAtpk944
dnpB8RAAidkQcFYhnGK0yHJRecT7rASmMff5UD5NcKFYifI/VuQ2Np027OeMtG0J
+NFZ1ATL50l9H84BtOc7vHGrDVQC3hhlFVJ8EMsrvv9YcfPU1USm9RJngQ9fJgGb
sZLABXQQTLIv6WEBTKBXVxCWQaxXb5T5mfpH8a66bgY901i2ahCHv9fePsftkijs
a7rwu38QBp3mAsEFTIOSDKd83+K/9qZyMTcVC4MqZvF9mSZu4ZkUHhOhe6UIRjTN
s+ikMDHc7MAPpFOpOcGs1UyvGqPq0r4nR8YMDzvb3ayIpcA0E6r1FIF7ymhf36WW
3/KEvwdQd36bxizc+BrNKnXvCTyCpWwsx0lL7z6sIUDUEDtAZfJISUnf++ySG+Mw
BuSwK8Xb5+tpxzrc0+hGWqoOO3D6fLunEefkID3W2nFKMSlwkHO1tuBGS0dbFBUx
a0xCL7C9v4eL7ir738gnrRjXiOPZ6ok4fo9HV17J1mLaKtsOnU5Uf9PIDgUhekx8
l3DIlGkweHGlhmiZ0llN/KPuuoX4IrNKEUXaie8BmsVwr3Mk5292qwDAZJazv0nm
rzjI+iC+vEbBQ/DHI65LACv1IzVsNUdhAA0GEp10n8K3HIRcs+RAVU0Z/2nCj7Lf
jQ5eStyCEaTpDLGeKcyzeKJJZKvv4fh6x/u5VaQrTxDB2xI8tDs=
=RZNk
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
