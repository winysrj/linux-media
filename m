Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3Ijvmi022601
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:45:57 -0500
Received: from smtp-out25.alice.it (smtp-out25.alice.it [85.33.2.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3IigaF003689
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:44:42 -0500
Date: Wed, 3 Dec 2008 19:44:26 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jim Paris <jim@jtan.com>
Message-Id: <20081203194426.f0bbdc6b.ospite@studenti.unina.it>
In-Reply-To: <20081203180128.GA19180@psychosis.jim.sh>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
	<20081127120536.62b35cd6.ospite@studenti.unina.it>
	<1227788553.1752.42.camel@localhost>
	<20081127145233.f467442a.ospite@studenti.unina.it>
	<20081203174528.712f1549.ospite@studenti.unina.it>
	<20081203180128.GA19180@psychosis.jim.sh>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca_ov534: Print only frame_rate actually used.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1141166744=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1141166744==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__3_Dec_2008_19_44_27_+0100_+H7SvAZhe1=xpFZV"

--Signature=_Wed__3_Dec_2008_19_44_27_+0100_+H7SvAZhe1=xpFZV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Dec 2008 13:01:28 -0500
Jim Paris <jim@jtan.com> wrote:

> Hi Antonio,
>=20
> Antonio Ospite wrote:
>=20
> If gspca decides to discard a frame with DISCARD_PACKET, I believe it
> won't start working again until you send another FIRST_PACKET.  In
> your code, if DISCARD_PACKET ever happens, the frame->data pointers
> won't get updated so you'll never get to FIRST_PACKET?
>

Yes, the code takes this path in gspca.c, gspca_frame_add(), line 277:

	if (packet_type =3D=3D FIRST_PACKET) {
		if ((frame->v4l2_buf.flags & BUF_ALL_FLAGS)
						!=3D V4L2_BUF_FLAG_QUEUED) {
			gspca_dev->last_packet_type =3D DISCARD_PACKET;
			return frame;
		}

and then it keeps on adding only INTER_PACKETs because of the current
end of frame check. It is a timing issue, it happens only with high
frame_rates, maybe there is some code in gspca that needs to be
protected by locking?
Or would it be normal to loose some frames at high frame rates using
smaller bulk_size?

> > As a side note, if I use this check to detect the end of the frame:
> >=20
> > 	if (len < gspca_dev->cam.bulk_size) {
> > 		...
> > 	} else ...
> >=20
> > I can recover from the previous error even if I get some frame
> > discarded from time to time. Is this check acceptable to you If I take
> > care that framesize is not a multiple of bulk_size?
>=20
> Hold off a bit on this work.
>=20
> There's a problem with breaking up the transfers, because we're not
> currently getting any header data from the bridge chip that lets us
> know when we really hit the end of a frame, and it's easy to get out
> of sync.  Using (len < bulk_size) is a good trick if they're not a
> multiple, as you say, since the last payload will be shorter, but I
> have a better solution -- I found how to get the camera to add a
> UVC-format header on each payload.  I'm finishing up the patch and
> will post it a bit later today once I iron out a few bugs.
>=20
> -jim

Ok, many thanks.

Regards,
   Antonio


--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__3_Dec_2008_19_44_27_+0100_+H7SvAZhe1=xpFZV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk204sACgkQ5xr2akVTsAEOXQCcCOK87B2x/lvxNQjyd//qnWhM
eSUAn272vdqVGTc/50k/M5NDdkUx9umz
=SPr0
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Dec_2008_19_44_27_+0100_+H7SvAZhe1=xpFZV--


--===============1141166744==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1141166744==--
