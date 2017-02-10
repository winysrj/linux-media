Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33088 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbdBJFAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 00:00:17 -0500
Received: by mail-io0-f194.google.com with SMTP id 101so4891825iom.0
        for <linux-media@vger.kernel.org>; Thu, 09 Feb 2017 20:59:33 -0800 (PST)
Message-ID: <1486692069.5749.1.camel@ndufresne.ca>
Subject: Re: [PATCH] media: fix s5p_mfc_set_dec_frame_buffer_v6() to print
 buf size in hex
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Shuah Khan <shuahkh@osg.samsung.com>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Feb 2017 21:01:09 -0500
In-Reply-To: <20170209221051.26234-1-shuahkh@osg.samsung.com>
References: <20170209221051.26234-1-shuahkh@osg.samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-3Oyd2INvETit4UJgirSP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-3Oyd2INvETit4UJgirSP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 09 f=C3=A9vrier 2017 =C3=A0 15:10 -0700, Shuah Khan a =C3=A9crit=
=C2=A0:
> Fix s5p_mfc_set_dec_frame_buffer_v6() to print buffer size in hex to
> be
> consistent with the rest of the messages in the routine.

Short and long descriptions are miss-leading. This patch will print the
buffer pointer as hex and keep the size as decimal. I think the patch
correctly improves consistency, the comment should match the code.

>=20
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> index d6f207e..fc45980 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
> @@ -497,7 +497,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct
> s5p_mfc_ctx *ctx)
> =C2=A0		}
> =C2=A0	}
> =C2=A0
> -	mfc_debug(2, "Buf1: %zu, buf_size1: %d (frames %d)\n",
> +	mfc_debug(2, "Buf1: %zx, buf_size1: %d (frames %d)\n",
> =C2=A0			buf_addr1, buf_size1, ctx->total_dpb_count);
> =C2=A0	if (buf_size1 < 0) {
> =C2=A0		mfc_debug(2, "Not enough memory has been
> allocated.\n");
--=-3Oyd2INvETit4UJgirSP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlidHuUACgkQcVMCLawGqBzq0wCfVB1oW98fOct02pVlOyuTwCp1
O2UAoJQX961lqSW9SziOB8YgIoY6QwEr
=aUgz
-----END PGP SIGNATURE-----

--=-3Oyd2INvETit4UJgirSP--

