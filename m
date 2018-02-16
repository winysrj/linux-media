Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46201 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbeBPUrk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Feb 2018 15:47:40 -0500
Received: by mail-qt0-f193.google.com with SMTP id u6so5365321qtg.13
        for <linux-media@vger.kernel.org>; Fri, 16 Feb 2018 12:47:39 -0800 (PST)
Message-ID: <1518814056.24316.12.camel@ndufresne.ca>
Subject: Re: [PATCH v3 3/9] uapi: media: New fourcc codes needed by Xilinx
 Video IP
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        michal.simek@xilinx.com, hyun.kwon@xilinx.com
Cc: Jeffrey Mouroux <jmouroux@xilinx.com>,
        Satish Kumar Nagireddy <satishna@xilinx.com>
Date: Fri, 16 Feb 2018 15:47:36 -0500
In-Reply-To: <1518676931-19474-1-git-send-email-satishna@xilinx.com>
References: <1518676931-19474-1-git-send-email-satishna@xilinx.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-oSUr8+mW+7LhRV7wkALW"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-oSUr8+mW+7LhRV7wkALW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 14 f=C3=A9vrier 2018 =C3=A0 22:42 -0800, Satish Kumar Nagireddy=
 a =C3=A9crit :
> From: Jeffrey Mouroux <jmouroux@xilinx.com>
>=20
> The Xilinx Video Framebuffer DMA IP supports video memory formats
> that are not represented in the current V4L2 fourcc library. This
> patch adds those missing fourcc codes. This includes both new
> 8-bit and 10-bit pixel formats.

As Hyon spotted, this is missing Documentation/media/uapi/v4l/ doc.
But there is some comment here that can be improved, see next:

>=20
> Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
> ---
>  include/uapi/linux/videodev2.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev=
2.h
> index 9827189..9fa4313c 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -509,7 +509,10 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_XBGR32  v4l2_fourcc('X', 'R', '2', '4') /* 32  BGRX=
-8-8-8-8  */
>  #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32  RGB-=
8-8-8-8   */
>  #define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2', '4') /* 32  ARGB=
-8-8-8-8  */
> +#define V4L2_PIX_FMT_BGRA32  v4l2_fourcc('A', 'B', 'G', 'R') /* 32  ABGR=
-8-8-8-8  */
>  #define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B', 'X', '2', '4') /* 32  XRGB=
-8-8-8-8  */
> +#define V4L2_PIX_FMT_BGRX32  v4l2_fourcc('X', 'B', 'G', 'R') /* 32  XBGR=
-8-8-8-8 */
> +#define V4L2_PIX_FMT_XBGR30  v4l2_fourcc('R', 'X', '3', '0') /* 32  XBGR=
-2-10-10-10 */
>=20
>  /* Grey formats */
>  #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Grey=
scale     */
> @@ -537,12 +540,16 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV =
4:2:2     */
>  #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV =
4:1:1     */
>  #define V4L2_PIX_FMT_YUV444  v4l2_fourcc('Y', '4', '4', '4') /* 16  xxxx=
yyyy uuuuvvvv */
> +#define V4L2_PIX_FMT_XVUY32  v4l2_fourcc('X', 'V', '3', '2') /* 32  XVUY=
 8:8:8:8 */
> +#define V4L2_PIX_FMT_AVUY32  v4l2_fourcc('A', 'V', '3', '2') /* 32  AVUY=
 8:8:8:8 */
> +#define V4L2_PIX_FMT_VUY24   v4l2_fourcc('V', 'U', '2', '4') /* 24  VUY =
8:8:8 */

If you read the convention, X:Y:Z is used to illustrate the sub-
sampling. The three previous are representing the number of bits, so
should have a comment like:
  XVUY-8-8-8-8
  AVUY-8-8-8-8
  VUY-8-8-8

>  #define V4L2_PIX_FMT_YUV555  v4l2_fourcc('Y', 'U', 'V', 'O') /* 16  YUV-=
5-5-5     */
>  #define V4L2_PIX_FMT_YUV565  v4l2_fourcc('Y', 'U', 'V', 'P') /* 16  YUV-=
5-6-5     */
>  #define V4L2_PIX_FMT_YUV32   v4l2_fourcc('Y', 'U', 'V', '4') /* 32  YUV-=
8-8-8-8   */
>  #define V4L2_PIX_FMT_HI240   v4l2_fourcc('H', 'I', '2', '4') /*  8  8-bi=
t color   */
>  #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV =
4:2:0 16x16 macroblocks */
>  #define V4L2_PIX_FMT_M420    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV =
4:2:0 2 lines y, 1 line uv interleaved */
> +#define V4L2_PIX_FMT_XVUY10  v4l2_fourcc('X', 'Y', '1', '0') /* 32  XVUY=
 2-10-10-10 */
>=20
>  /* two planes -- one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/Cb=
Cr 4:2:0  */
> @@ -551,6 +558,8 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/Cr=
Cb 4:2:2  */
>  #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/Cb=
Cr 4:4:4  */
>  #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/Cr=
Cb 4:4:4  */
> +#define V4L2_PIX_FMT_XV20    v4l2_fourcc('X', 'V', '2', '0') /* 32  XY/U=
V 4:2:2 10-bit */
> +#define V4L2_PIX_FMT_XV15    v4l2_fourcc('X', 'V', '1', '5') /* 32  XY/U=
V 4:2:0 10-bit */
>=20
>  /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/Cb=
Cr 4:2:0  */
> @@ -558,6 +567,8 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/Cb=
Cr 4:2:2  */
>  #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/Cr=
Cb 4:2:2  */
>  #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/Cb=
Cr 4:2:0 64x32 macroblocks */
> +#define V4L2_PIX_FMT_XV20M   v4l2_fourcc('X', 'M', '2', '0') /* 32  XY/U=
V 4:2:2 10-bit */
> +#define V4L2_PIX_FMT_XV15M   v4l2_fourcc('X', 'M', '1', '5') /* 32  XY/U=
V 4:2:0 10-bit */
>  #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12 =
 Y/CbCr 4:2:0 16x16 macroblocks */
>=20
>  /* three planes - Y Cb, Cr */
> --
> 2.7.4
>=20
> This email and any attachments are intended for the sole use of the named=
 recipient(s) and contain(s) confidential information that may be proprieta=
ry, privileged or copyrighted under applicable law. If you are not the inte=
nded recipient, do not read, copy, or forward this email message or any att=
achments. Delete this email message and any attachments immediately.
--=-oSUr8+mW+7LhRV7wkALW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWodDaAAKCRBxUwItrAao
HL7TAJoDhOET12pytdfjvAUzvOjB/HrzegCZAS5hUTdBwhe5MJrugXpPOMSOZzU=
=6DBz
-----END PGP SIGNATURE-----

--=-oSUr8+mW+7LhRV7wkALW--
