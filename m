Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA77BJSw024710
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 02:11:19 -0500
Received: from smtp-out113.alice.it (smtp-out113.alice.it [85.37.17.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA77AXr3021745
	for <video4linux-list@redhat.com>; Fri, 7 Nov 2008 02:10:34 -0500
Date: Fri, 7 Nov 2008 08:10:20 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081107081020.736ce3ad.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0811070040130.8681@axis700.grange>
References: <1226012656-17334-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0811070040130.8681@axis700.grange>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] pxa_camera: Fix YUV format handling.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2080988644=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============2080988644==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Fri__7_Nov_2008_08_10_20_+0100_M9iK_pMLA0ZDoU3o"

--Signature=_Fri__7_Nov_2008_08_10_20_+0100_M9iK_pMLA0ZDoU3o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Nov 2008 00:52:12 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

>=20
> So, let's just get the naming consistent. Are you also planning to update=
=20
> your "Add new pixel format VYUY 16 bits wide" patch as requested by Hans=
=20
> Verkuil? Then you could put all these patches in a patch series to make i=
t=20
> easier to manage them:-)
>=20
> Also, I would _at the very least_ give credit to Antonio Ospite for=20
> reporting the problem and suggesting a first fix in your patch for=20
> mt9m111. Eventually we would also like to have a Tested-by from him.
>

If you can provide a patch series it will be easier to test for me.

Thanks,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Fri__7_Nov_2008_08_10_20_+0100_M9iK_pMLA0ZDoU3o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkT6dwACgkQ5xr2akVTsAEjMwCeP5dTZZo9Kid4cuGNV2d7wgXk
s/EAn1OuksTYUhYgTUUUjuKuS6VMneW6
=mLR/
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_08_10_20_+0100_M9iK_pMLA0ZDoU3o--


--===============2080988644==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============2080988644==--
