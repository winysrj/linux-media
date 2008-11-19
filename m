Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 19 Nov 2008 08:46:23 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Adam Baker <linux@baker-net.org.uk>
Message-Id: <20081119084623.f4d9b08c.ospite@studenti.unina.it>
In-Reply-To: <200811190020.15663.linux@baker-net.org.uk>
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
	<200811190020.15663.linux@baker-net.org.uk>
Mime-Version: 1.0
Cc: Hans de Goede <hdegoede@redhat.com>, video4linux-list@redhat.com,
	sqcam-devel@lists.sourceforge.net, kilgota@banach.math.auburn.edu
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
 driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1443628165=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1443628165==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__19_Nov_2008_08_46_23_+0100_+S8kZUHimBu8n_7M"

--Signature=_Wed__19_Nov_2008_08_46_23_+0100_+S8kZUHimBu8n_7M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Nov 2008 00:20:15 +0000
Adam Baker <linux@baker-net.org.uk> wrote:

> On Tuesday 18 November 2008, kilgota@banach.math.auburn.edu wrote:
>=20
> >
> > 3. Even so, you should both take seriously the question whether these
> > cameras actually need a kernel driver, or whether it would actually be
> > useful. Perhaps it would be a better idea to do something totally in
> > userspace and figure out how to hook that into a frontend program like
> > xawtv or some other program which is associated with V4L instead of
> > getting input from a kernel-supported device? The reasons I say this ar=
e:
> >
> > a. There is IMHO a too big proliferation of kernel modules especially in
> > this area of video. It seems every new device that comes along needs its
> > own separate module. It would be nice if it is possible to slow down on
> > this. In general, I think it is a *good idea* if more is done in usersp=
ace
> > and as little as is needed is done in the kernel.
>=20
> I've been thinking about that for quite a while now. The problem is that=
=20
> applications are written to use V4L2 and a V4L2 camera has a device node.=
 I=20
> did consider for a while the idea of creating a kernel space driver that =
just=20
> exposed an interface that a user space libusb app could provide video dat=
a to=20
> but concluded it seemed like a lot of work for little benefit.
>=20

There were some v4l1 solutions for that already, but nothing that can
go to linux mainline without rewriting. See:
http://www.lavrsen.dk/twiki/bin/view/Motion/VideoFourLinuxLoopbackDevice

There is also a v4l2 solution, but I've never tried it:
http://sourceforge.net/projects/v4l2vd/

Having such a virtual device in mainline would be very good.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__19_Nov_2008_08_46_23_+0100_+S8kZUHimBu8n_7M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkjxE8ACgkQ5xr2akVTsAFj6QCeKE/7rkoyzEUUzRw5jKOkjDnZ
fusAoKezAsV7nl1M1QwClqb+4qXPdnEz
=6nun
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Nov_2008_08_46_23_+0100_+S8kZUHimBu8n_7M--


--===============1443628165==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1443628165==--
