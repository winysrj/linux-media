Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9BIpUGh004150
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 14:51:30 -0400
Received: from mx1.riseup.net (mx1.riseup.net [204.13.164.18])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9BIpEcs008009
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 14:51:14 -0400
From: rafael2k <rafael@riseup.net>
To: video4linux-list@redhat.com
Date: Sat, 11 Oct 2008 15:51:05 -0300
References: <1223640548.5171.64.camel@luis> <20081010130124.GA850@daniel.bse>
In-Reply-To: <20081010130124.GA850@daniel.bse>
MIME-Version: 1.0
Message-Id: <200810111551.13338.rafael@riseup.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: analize ASI with dvbnoop and dektec 140
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0598709466=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0598709466==
Content-Type: multipart/signed; boundary="nextPart3402860.9NTEpNBeE6";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3402860.9NTEpNBeE6
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I think you could write a v4l2 wrapper using the dektec API.

bye,
rafael diniz

Em Friday 10 October 2008, Daniel Gl=F6ckner escreveu:
> On Fri, Oct 10, 2008 at 02:09:08PM +0200, luisan82@gmail.com wrote:
> > I've been trying to analyze a ts with dvbsnoop through an ASI input
> > unsuccessfully.
> > When I execute dvbsnoop, it tries to read from a location (/dev/dvb/...)
> > wich doesn't exists.
>
> The drivers provided by DekTec do not implement the Linux DVB API.
> You can't use dvbsnoop.
> You need to write your own program using their proprietary DTAPI library.
> At least their drivers are open source...


=2D-=20
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+=
=2D+-+-
Ci=EAncia da Computa=E7=E3o @  Unicamp
R=E1dio Muda, radiolivre.org, TV Piolho, tvlivre.org, www.midiaindependente=
=2Eorg
Chave PGP: http://pgp.mit.edu:11371/pks/lookup?op=3Dget&search=3D0x2FF86098
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+=
=2D+-+-


--nextPart3402860.9NTEpNBeE6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjw9ZoACgkQoZ5YIC/4YJgWGwCfd5yH0E8ru/aBYm5+VxdYLOU9
UCcAoJRioa8uugJs7nqO959Rg05nFTZd
=o99/
-----END PGP SIGNATURE-----

--nextPart3402860.9NTEpNBeE6--


--===============0598709466==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0598709466==--
