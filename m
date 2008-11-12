Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mACISCuC009504
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 13:28:12 -0500
Received: from smtp-OUT05A.alice.it (smtp-OUT05A.alice.it [85.33.3.5])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mACIRvrq014037
	for <video4linux-list@redhat.com>; Wed, 12 Nov 2008 13:27:58 -0500
Date: Wed, 12 Nov 2008 19:27:46 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Message-Id: <20081112192746.f59ee94d.ospite@studenti.unina.it>
In-Reply-To: <878wrr9z9h.fsf@free.fr>
References: <20081107125919.ddf028a6.ospite@studenti.unina.it>
	<874p2jbegl.fsf@free.fr>
	<Pine.LNX.4.64.0811082119280.8956@axis700.grange>
	<20081109235940.4c009a68.ospite@studenti.unina.it>
	<Pine.LNX.4.64.0811101946200.8315@axis700.grange>
	<878wrr9z9h.fsf@free.fr>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH, RFC] mt9m111: allow data to be received on pixelclock
 falling edge?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1737932323=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1737932323==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__12_Nov_2008_19_27_46_+0100_.pN/0Bs0_TtU97=c"

--Signature=_Wed__12_Nov_2008_19_27_46_+0100_.pN/0Bs0_TtU97=c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Nov 2008 20:06:34 +0100
Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>=20
> > I would prefer not to disregard camera flags. If we don't find a better=
=20
> > solution, I would introduce platform inverter flags, and, I think, we=20
> > better put them in camera platform data - not host platform data, to=20
> > provide a finer granularity. In the end, inverters can also be located =
on=20
> > camera boards, then you plug-in a different camera and, if your=20
> > inverter-flags were in host platform data, it doesn't work again.
>
> I'm of the same opinion.
>=20
> I was thinking of another case : imagine the host needs to be configured =
on
> rising edge, and camera on falling edge. Your patch wouldn't cover that d=
evious
> case.
>=20
> I can't think of a better solution than an inverter flag as well. As this=
 would
> be very board specific, let it go in something board code sets up.
>=20
> That's how it's already done for inverted gpio Vbus sensing in the USB st=
ack for
> the pxa for example.
>=20

Ok, I hope you'll find time to add the proper solution some day, since I
don't think I can do it correctly with my current knowledge.

Thanks for the interest.

Best regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__12_Nov_2008_19_27_46_+0100_.pN/0Bs0_TtU97=c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkbICIACgkQ5xr2akVTsAGq/gCfaDB+q6yXQYASTy5QzhF6a74k
Re0Ani1YI6cNf468yxe6DBcRyg+2qQNL
=7mK6
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Nov_2008_19_27_46_+0100_.pN/0Bs0_TtU97=c--


--===============1737932323==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1737932323==--
