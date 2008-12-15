Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBFEvj8q011895
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 09:57:45 -0500
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id mBFEvSV4016639
	for <video4linux-list@redhat.com>; Mon, 15 Dec 2008 09:57:29 -0500
Date: Mon, 15 Dec 2008 15:57:14 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-Id: <20081215155715.7e8f34e9.ospite@studenti.unina.it>
In-Reply-To: <200812151145.54346.hverkuil@xs4all.nl>
References: <200812151145.54346.hverkuil@xs4all.nl>
Mime-Version: 1.0
Cc: v4l <video4linux-list@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Integrating v4l2_device/v4l2_subdev into the soc_camera
 framework
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0639117006=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0639117006==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Mon__15_Dec_2008_15_57_15_+0100_gax6sc6qQ4YuEFMN"

--Signature=_Mon__15_Dec_2008_15_57_15_+0100_gax6sc6qQ4YuEFMN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Dec 2008 11:45:54 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Guennadi,
>=20
> Now that the v4l2_device and v4l2_subdev structs are merged into the=20
> master v4l-dvb repository it is time to look at what needs to be done=20
> to integrate it into the soc-camera framework.
>=20
> The goal is to make the i2c sub-device drivers independent from how they=
=20
> are used. That is, whether a sensor is used in an embedded device or in=20
> a USB webcam or something else should not matter for the sensor driver.
>

Is something like this planned for gspca as well?

Thanks,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Mon__15_Dec_2008_15_57_15_+0100_gax6sc6qQ4YuEFMN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklGcEsACgkQ5xr2akVTsAGDlwCfRDM1xaNTKDNt2HDnmbjHy+ka
bvwAn0cTBzH0PrJ13XQT+AeO7tVlvEhm
=fAO0
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Dec_2008_15_57_15_+0100_gax6sc6qQ4YuEFMN--


--===============0639117006==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0639117006==--
