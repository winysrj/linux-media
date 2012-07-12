Return-path: <linux-media-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:47275 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2GLBfr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 21:35:47 -0400
Date: Thu, 12 Jul 2012 11:35:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	s.nawrocki@samsung.com
Subject: Re: [PATCH 1/1] v4l: Export v4l2-common.h in include/linux/Kbuild
Message-Id: <20120712113535.08e86e61c0ed2b8c9be2a8c6@canb.auug.org.au>
In-Reply-To: <1341825026-29120-1-git-send-email-sakari.ailus@iki.fi>
References: <20120709115046.f09fe2d15e33e7502cbad222@canb.auug.org.au>
	<1341825026-29120-1-git-send-email-sakari.ailus@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Jul_2012_11_35_35_+1000_8vmfeOZ7vVjhdM=x"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Thu__12_Jul_2012_11_35_35_+1000_8vmfeOZ7vVjhdM=x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Mon,  9 Jul 2012 12:10:26 +0300 Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
> v4l2-common.h is a header file that's used in user space, thus it must be
> exported using header-y.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> Hi Stephen,
>=20
> Could you try is this patch fixes your issue? The header file indeed shou=
ld
> be exported which wasn't done previously.

I have added this as a merge fixup in linux-next today and it fixes the
problem.  Mauro, please put this into the v4l-dvb tree.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

>  include/linux/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index d38b3a8..ef4cc94 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -382,6 +382,7 @@ header-y +=3D usbdevice_fs.h
>  header-y +=3D utime.h
>  header-y +=3D utsname.h
>  header-y +=3D uvcvideo.h
> +header-y +=3D v4l2-common.h
>  header-y +=3D v4l2-dv-timings.h
>  header-y +=3D v4l2-mediabus.h
>  header-y +=3D v4l2-subdev.h

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Jul_2012_11_35_35_+1000_8vmfeOZ7vVjhdM=x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP/innAAoJEECxmPOUX5FEnWgQAIj+vfD7p7CFQ4nTFkH3ems2
/xKZirC6R+1lDeuUOl4l1WKXZvtR7PSUafeip/d1s0FCZsDi/Tx33r9hbFrhkYnM
DPsok9fNReQ3lwqVmvgYewOl9lG6X2QzJatuwX3iUVjRL8CTWEZYw1goCnAVwvhM
DgERI+Xmb0DVXT5CZ2vD4vb/zhKhG6gAD2YXWGLk8HpihfBp565dJoMQ8o3PmYu3
cOKp1HncTpYBNX13frTHVBu1Ya5yt5KJ3Q4qd3og8+fQjAgSxmSpdTTmge7QifnL
zNVaDnn3UKLVDLIvaSFFntpO8+PxAqGpIhgy00IyKC/UCPeZFXqODUT63UecT2VS
WhoXUzaHQoRREJTBdBtmrQMR8z1FAsNmG5zmVSE3YJsaFm95AFuBaxlbV+eNIb72
9XuGiCuFDjtgv144536i6/hWhmsG4lDSU8e8s6NhSqpopS2jl0nBomTOTqZ69R+e
J4m+THYodn6bRjPOUynLPkwn6ME4JfJAvE5cztvqs7TbbEq3fbeuSlcmEfVEf0f3
8Qyr8U14mW5VvmP/P6b62Jd71iLOL8vYuK3rvx73S8ERCtj5x4627lY6J/wWIkYy
Npf9XDZuQwk5eQnHoZGcPBF2TcAKwn3Y4e896AtDW22cWv2oEI1t8vvUVPfR3h/5
w93wfGes9r4qZzNKPz9r
=Tk7m
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jul_2012_11_35_35_+1000_8vmfeOZ7vVjhdM=x--
