Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA7FKI0p027636
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 10:20:18 -0500
Received: from smtp-out114.alice.it (smtp-out114.alice.it [85.37.17.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA7FK40J003619
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 10:20:04 -0500
Date: Fri, 7 Nov 2008 16:19:56 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081107161956.c096dd03.ospite@studenti.unina.it>
In-Reply-To: <200811071050.25149.hverkuil@xs4all.nl>
References: <491339D9.2010504@personnelware.com>
	<30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
	<4913E9DB.8040801@hhs.nl> <200811071050.25149.hverkuil@xs4all.nl>
Mime-Version: 1.0
Subject: Re: weeding out v4l ver 1 stuff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0839646593=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0839646593==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Fri__7_Nov_2008_16_19_56_+0100_o.1=jK4a0w=P3IWH"

--Signature=_Fri__7_Nov_2008_16_19_56_+0100_o.1=jK4a0w=P3IWH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Nov 2008 10:50:25 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Friday 07 November 2008 08:10:19 Hans de Goede wrote:
> >
> > ? What new media framework ? You mean the planned changes to the v4l2
> > API for multifunction devices? Anyways this won't make gspca
> > obsolete, gspca is a framework for writing usb webcam drivers, as
> > such it tries to do things common to all usb webcam drivers inside
> > the gspca-core. If the v4l2 core changes the gspca-core will adapt
> > and in most cases of v4l2-core changes, the gspca subdrivers will not
> > need to change at all. So if anything using gspca makes your driver
> > more future proof against v4l2-core changes as in most cases the
> > necessary changes for all gspca drivers only need to be made once in
> > gspca-core
>=20
> That's right. If possible, then I definitely recommend moving away from=20
> separate webcam drivers to gspca where possible. The planned new v4l2=20
> core framework enhancements have nothing to do with this.
>=20

Hi, maybe the gspca framework should be better advertised, the only doc
I could find in linux is in Documentation/video4linux/gspca.txt which
doesn't clearly present gspca as a _generic_ framework for usb cameras,
although one can still infer that information seeing that it supports
different bridges and sensors, restating it could only be good.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Fri__7_Nov_2008_16_19_56_+0100_o.1=jK4a0w=P3IWH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkUXJwACgkQ5xr2akVTsAFGIwCbByaUPQLLVPpU2Dq+jfrqbp5C
7K0AniCe1LZ8ACcIsAPMWIeG8cBK5uaY
=byoM
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_16_19_56_+0100_o.1=jK4a0w=P3IWH--


--===============0839646593==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0839646593==--
