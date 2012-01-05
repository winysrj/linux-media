Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:32667 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2AEG1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 01:27:04 -0500
Date: Thu, 5 Jan 2012 09:27:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org, stable@vger.kernel.org
Subject: [patch -next] V4L/DVB: v4l2-ioctl: integer overflow in
 video_usercopy()
Message-ID: <20120105062756.GA10230@mwanda>
References: <20111215063445.GA2424@elgon.mountain>
 <4EE9BC25.7020303@infradead.org>
 <201112151033.35153.hverkuil@xs4all.nl>
 <4EE9C2E6.1060304@infradead.org>
 <20120103205539.GC17131@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20120103205539.GC17131@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If ctrls->count is too high the multiplication could overflow and
array_size would be lower than expected.  Mauro and Hans Verkuil
suggested that we cap it at 1024.  That comes from the maximum
number of controls with lots of room for expantion.

$ grep V4L2_CID include/linux/videodev2.h | wc -l
211

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index d2f981a..4942f81 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1133,6 +1133,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
=20
 /*  User-class control IDs defined by V4L2 */
+#define V4L2_CID_MAX_CTRLS		1024
 #define V4L2_CID_BASE			(V4L2_CTRL_CLASS_USER | 0x900)
 #define V4L2_CID_USER_BASE 		V4L2_CID_BASE
 /*  IDs reserved for driver specific controls */
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-io=
ctl.c
index e1da8fc..639abee 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2226,6 +2226,10 @@ static int check_array_args(unsigned int cmd, void *=
parg, size_t *array_size,
 		struct v4l2_ext_controls *ctrls =3D parg;
=20
 		if (ctrls->count !=3D 0) {
+			if (ctrls->count > V4L2_CID_MAX_CTRLS) {
+				ret =3D -EINVAL;
+				break;
+			}
 			*user_ptr =3D (void __user *)ctrls->controls;
 			*kernel_ptr =3D (void *)&ctrls->controls;
 			*array_size =3D sizeof(struct v4l2_ext_control)

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPBULsAAoJEOnZkXI/YHqRXMIP/1LQ3YlDpmQIn1sz6tZWt82g
MJ8VVBWubBvpRLuKT6hHbxkowTvYxFY0j4WW9gLL092AGDKi8yL8ARDMuwHw3IUq
LYugc44ge4eAwWxsvFoMQLFjUfzVYGuN2HmNWqm8k0bYmmKe4jkf/XM9wTr7QOIx
Qx8jr++S9t4p2i9EFuSTu8aXGEPZ97AEfJO3ZGndiPzu5G98c0kQ+bAn6BiTLXYB
Li24CQakqLZVJwGkaUj02QM0mP9yEp3lxj3a66GFiIEBnS4s7Nn2j8HxwTWDGcd/
Rqu2cn8bN4UeOesF3OEGmpfPfIDwL1PIoY+D0SapPgzNNR2ul8KY+A/7b2BUsyKv
YFDJ9xLultm1R1pv3Vc5AIP2hEdDSwo3BOj3ULHocLlhJyTzrX4PxyfrNplxyUhA
roGj8AtXLXtsA8gxGQHoPxZKayXZA1DHJVrJ8MkCx/cH0H+c9Vc+kUxJ2sP1NYXi
syiE634oh1vuBUmvqKXcfDTL4MeTEtFiQDS0cvxlj8jalmxENcXqlfwXuwCJEQVR
h4+m6uTbb2IWdSw/ZeS8vymFBR/dsD0EhU698FRc+qpFGp37OGTdIC1c20981+Au
XAD92koxENdtOOUAdN5xwseyzGk2PV0nTy+cjRZ55K2BWixB5WlG6LCXci5b6qt3
sjeV3gB+l1kkwvByUlAg
=Ss7x
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
