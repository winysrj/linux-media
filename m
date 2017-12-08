Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44641 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754194AbdLHPr2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Dec 2017 10:47:28 -0500
Received: by mail-qt0-f195.google.com with SMTP id m59so26808381qte.11
        for <linux-media@vger.kernel.org>; Fri, 08 Dec 2017 07:47:28 -0800 (PST)
Message-ID: <1512748044.24635.1.camel@ndufresne.ca>
Subject: Re: [Patch v6 05/12] [media] videodev2.h: Add v4l2 definition for
 HEVC
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com
Date: Fri, 08 Dec 2017 10:47:24 -0500
In-Reply-To: <1512724105-1778-6-git-send-email-smitha.t@samsung.com>
References: <1512724105-1778-1-git-send-email-smitha.t@samsung.com>
         <CGME20171208093649epcas1p1a4079fba04eb53bc9249a35361746ea9@epcas1p1.samsung.com>
         <1512724105-1778-6-git-send-email-smitha.t@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-zBflTywZusYwpgjvxYQ5"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-zBflTywZusYwpgjvxYQ5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 08 d=C3=A9cembre 2017 =C3=A0 14:38 +0530, Smitha T Murthy a =C3=
=A9crit :
> Add V4L2 definition for HEVC compressed format
>=20
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/videodev2.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev=
2.h
> index 185d6a0..bd9b5d5 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -634,6 +634,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPT=
E 421M Annex L compliant stream */
>  #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
>  #define V4L2_PIX_FMT_VP9      v4l2_fourcc('V', 'P', '9', '0') /* VP9 */
> +#define V4L2_PIX_FMT_HEVC     v4l2_fourcc('H', 'E', 'V', 'C') /* HEVC ak=
a H.265 */

Wouldn't it be more consistent to call it V4L2_PIX_FMT_H265 as we have
used H264 for the previous generation, or is there a formal rationale ?
Also, this is byte-stream right ? With start codes ?

> =20
>  /*  Vendor-specific formats   */
>  #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 Y=
UV */
--=-zBflTywZusYwpgjvxYQ5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWiq0DAAKCRBxUwItrAao
HLNBAKDXtuL/XqlyvgodZ7lwK6E6esKRqACeKTMpiOEDhZ9IswDMc/PtewU6ioc=
=FLnp
-----END PGP SIGNATURE-----

--=-zBflTywZusYwpgjvxYQ5--
