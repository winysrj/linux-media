Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:56774 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2AEG11 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 01:27:27 -0500
Date: Thu, 5 Jan 2012 09:28:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org, stable@vger.kernel.org
Subject: [patch -longterm v2] V4L/DVB: v4l2-ioctl: integer overflow in
 video_usercopy()
Message-ID: <20120105062822.GB10230@mwanda>
References: <20111215063445.GA2424@elgon.mountain>
 <4EE9BC25.7020303@infradead.org>
 <201112151033.35153.hverkuil@xs4all.nl>
 <4EE9C2E6.1060304@infradead.org>
 <20120103205539.GC17131@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20120103205539.GC17131@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

If p->count is too high the multiplication could overflow and
array_size would be lower than expected.  Mauro and Hans Verkuil
suggested that we cap it at 1024.  That comes from the maximum
number of controls with lots of room for expantion.

$ grep V4L2_CID include/linux/videodev2.h | wc -l
211

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b59e78c..9e2088c 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -858,6 +858,7 @@ struct v4l2_querymenu {
 #define V4L2_CTRL_FLAG_NEXT_CTRL	0x80000000
=20
 /*  User-class control IDs defined by V4L2 */
+#define V4L2_CID_MAX_CTRLS		1024
 #define V4L2_CID_BASE			(V4L2_CTRL_CLASS_USER | 0x900)
 #define V4L2_CID_USER_BASE 		V4L2_CID_BASE
 /*  IDs reserved for driver specific controls */
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-io=
ctl.c
index 265bfb5..d7332c7 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -414,6 +414,9 @@ video_usercopy(struct file *file, unsigned int cmd, uns=
igned long arg,
 		p->error_idx =3D p->count;
 		user_ptr =3D (void __user *)p->controls;
 		if (p->count) {
+			err =3D -EINVAL;
+			if (p->count > V4L2_CID_MAX_CTRLS)
+				goto out_ext_ctrl;
 			ctrls_size =3D sizeof(struct v4l2_ext_control) * p->count;
 			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
 			mbuf =3D kmalloc(ctrls_size, GFP_KERNEL);
@@ -1912,6 +1915,9 @@ long video_ioctl2(struct file *file,
 		p->error_idx =3D p->count;
 		user_ptr =3D (void __user *)p->controls;
 		if (p->count) {
+			err =3D -EINVAL;
+			if (p->count > V4L2_CID_MAX_CTRLS)
+				goto out_ext_ctrl;
 			ctrls_size =3D sizeof(struct v4l2_ext_control) * p->count;
 			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
 			mbuf =3D kmalloc(ctrls_size, GFP_KERNEL);

--l76fUT7nc3MelDdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPBUMFAAoJEOnZkXI/YHqRYaUP/29M7sG2zs9NtuntaflAdyZ9
CnOSCb5u/0yToAPCAWfS/Ayb9tgadZP0INlEg+Gegy2lV71jT3u14wgPsb0csVL0
d58u4XhZ38f78nRcos+vUVPEpAmlCJtfN3cgyfBaYLEBjCClagYdjMKFXhfIJ/In
V2jh/tDJBJ07YbqaEbKdNvHw8ceg2+EQowgArEpX/Z80cYqkffMZZ0zhC16487MJ
udMtLaMyyVctpoUDDDtTA1gxGmqytUQwrRvHH8at2hBUuFW4obRFxVntvjGAQge7
LAcgbp7/EwmBC7KIiaCoBYhtJAOmETYT8fIXqYbGSSlm/r9Cf+SVzrODHq9Rs6y6
U3JnPpkA/fjh6a+SzgmtQeGH4d7gFFSfFAkpp1zG2wCPmt3BivjntqFy0qOnv7dp
fWy8cb3qjqg6X3bKkMcZ7WFu3gzViz7h6Hsce4k56wJRfcA/Y8R7YA0DRDgTNyuH
ldoI4Ge+7qpSRRf1aYsbE7fpPlfdiCwN+IHJv3D7qaXdNPtW4VwHxU3pSV6H+q74
btcvryE3i+QgvFmLpYLC6jDtBhOm2nQSi5bTpobClaZ8EDNWMtFULKIJURIpiu5H
P5VrZOCJnmVKhLmJI6UbLa3V1QHndYCeh0um/46FHyQI6KNJZQFjr7S9G5gDx/YE
O5EmqdBKger9kYfwaNT9
=6sSB
-----END PGP SIGNATURE-----

--l76fUT7nc3MelDdI--
