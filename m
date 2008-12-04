Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB4BtsRW018673
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 06:55:54 -0500
Received: from smtp-out28.alice.it (smtp-out28.alice.it [85.33.2.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB4Btb7I019893
	for <video4linux-list@redhat.com>; Thu, 4 Dec 2008 06:55:38 -0500
Date: Thu, 4 Dec 2008 12:55:23 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Message-Id: <20081204125523.ebe375e2.ospite@studenti.unina.it>
In-Reply-To: <1228331840.1705.15.camel@localhost>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
	<20081127120536.62b35cd6.ospite@studenti.unina.it>
	<1227788553.1752.42.camel@localhost>
	<20081127145233.f467442a.ospite@studenti.unina.it>
	<20081203174528.712f1549.ospite@studenti.unina.it>
	<20081203180128.GA19180@psychosis.jim.sh>
	<20081203194426.f0bbdc6b.ospite@studenti.unina.it>
	<1228331840.1705.15.camel@localhost>
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
Content-Type: multipart/mixed; boundary="===============1298082501=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1298082501==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__4_Dec_2008_12_55_23_+0100_5L_mb64ieCF9k8wv"

--Signature=_Thu__4_Dec_2008_12_55_23_+0100_5L_mb64ieCF9k8wv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Dec 2008 20:17:20 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Wed, 2008-12-03 at 19:44 +0100, Antonio Ospite wrote:
> > Yes, the code takes this path in gspca.c, gspca_frame_add(), line 277:
> >=20
> > 	if (packet_type =3D=3D FIRST_PACKET) {
> > 		if ((frame->v4l2_buf.flags & BUF_ALL_FLAGS)
> > 						!=3D V4L2_BUF_FLAG_QUEUED) {
> > 			gspca_dev->last_packet_type =3D DISCARD_PACKET;
> > 			return frame;
> > 		}
> >=20
> > and then it keeps on adding only INTER_PACKETs because of the current
> > end of frame check. It is a timing issue, it happens only with high
> > frame_rates, maybe there is some code in gspca that needs to be
> > protected by locking?
> > Or would it be normal to loose some frames at high frame rates using
> > smaller bulk_size?
> >=20
>=20
> Hi Antonio,
>=20
> The problem comes from the availability of the application buffer. In
> the bulk_irq, there is:
>=20
> 	frame =3D gspca_get_i_frame(gspca_dev);
> 	if (!frame) {
> 		gspca_dev->last_packet_type =3D DISCARD_PACKET;
> 	} else {
> 		.. pkt_scan(..);
> 	}
>=20
> Then, you are not called and you cannot know how many bytes have been
> really received.
>

And this happens because we couldn't have two separate events for
LAST_PACKET and FIRST_PACKET, right?

> As the buffer check exists in frame_add, I may call you each time with a
> valid frame pointer (see patch). In this case, you cannot count the
> image bytes with the data_end. You should have a counter in the sd
> structure.
>=20
> An other solution is to start and stop the transfer for each image as it
> was in the original driver, but it asks for a kernel thread.
>=20
> Anyway, if Jim may add a mark between the images, if will be the best...
>

Ok, we'll go with Jim changes. Thanks anyway for the patch, but I don't
think it is needed anymore.

Regards,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Thu__4_Dec_2008_12_55_23_+0100_5L_mb64ieCF9k8wv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk3xSsACgkQ5xr2akVTsAGtkACgoQxITgFMkWk+ebWSSeQIpJ4W
+UQAn25SX5qvkVW1qTBH+bl06d/lKDPK
=Zobc
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Dec_2008_12_55_23_+0100_5L_mb64ieCF9k8wv--


--===============1298082501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1298082501==--
