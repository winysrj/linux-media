Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:55065 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2ADNec (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 08:34:32 -0500
Date: Wed, 4 Jan 2012 16:35:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [patch -longterm] V4L/DVB: v4l2-ioctl: integer overflow in
 video_usercopy()
Message-ID: <20120104133518.GA1506@mwanda>
References: <20111215063445.GA2424@elgon.mountain>
 <4EE9BC25.7020303@infradead.org>
 <201112151033.35153.hverkuil@xs4all.nl>
 <4EE9C2E6.1060304@infradead.org>
 <20120103205539.GC17131@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20120103205539.GC17131@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 03, 2012 at 12:55:39PM -0800, Greg KH wrote:
> Ok, can someone please send me the "accepted" version of this patch for
> inclusion in the 2.6.32-stable tree?
>=20

Sorry for that.  Holidays and all.  I'll send a patch tomorrow.

regards,
dan carpenter


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPBFWWAAoJEOnZkXI/YHqR/nEP/1tTLjhrAqvxGtp912DNgVJ3
08fNL2NvBY8bJaiQG0jF5RQmlHMPjTlQorAO1x6nXlk1IuXcVMdoY0k5QfQ76ggm
7k7tE+qyqQUsLzHoryAbl4FkRrjq4296xLzXWTUhz/nRO+lxbKAR+nJDuIcMtnkT
3RrwPurmwzmYoDpbRiKgglmhIQU/vC9FLdCB/5NMJ0WYTgt5vEMVbsiPBmer+d62
bSfY35lxqTcrX3ssUodtdiVBpneHchhsIbSEEkqhHdXAxktkQO+W7e2jpL22oc1a
mgsopBKT6vr8Qe8lsiYEYoCcOGXF7nkgF8RkcKuh9kUJHU0iCJ6ApgO+o9GBB9M6
iLNQ7G15YkKRjJ5RolTVJaJagUbQXzxfjsz3wQSWmod8mFAYw4I0qeK2EzJ++Slt
RfiBtcKz7tVSb/bMck8DITOW+a/waVoIuUOnwMt8U7S5SiWtG2sffqOVSbeqOFf0
/FjiCRKY+qgKZNOG6a0DnglID84L8PZqCg9NGakIigrEfi714vxsSROzKcexKL6K
kKrBAjx0I6st14ZFHMCHPl4UobHD1d/RsC8OTUiPDzqwL8NTOeFt307Cb7SxVHBz
/Fs9RIl3Uar6sDVGoTmg8x+A/eZIeb73ehe1SpAPFeWUT0uHqP2RGpNOqTwHBLXq
kJhuKcmvBlHhmVLqSF8H
=bxfR
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
