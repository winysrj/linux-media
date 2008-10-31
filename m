Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9VHjaUk004460
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:45:36 -0400
Received: from smtp-out114.alice.it (smtp-out114.alice.it [85.37.17.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9VHjPGT012691
	for <video4linux-list@redhat.com>; Fri, 31 Oct 2008 13:45:25 -0400
Date: Fri, 31 Oct 2008 18:45:18 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-Id: <20081031184518.4ab857b2.ospite@studenti.unina.it>
In-Reply-To: <87mygkof3j.fsf@free.fr>
References: <20081029232544.661b8f17.ospite@studenti.unina.it>
	<87mygkof3j.fsf@free.fr>
Mime-Version: 1.0
Cc: 
Subject: Re: [PATCH] mt9m111: Fix YUYV format for pxa-camera
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1544457031=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============1544457031==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Fri__31_Oct_2008_18_45_18_+0100_F6bbvCrV1/BxeO4E"

--Signature=_Fri__31_Oct_2008_18_45_18_+0100_F6bbvCrV1/BxeO4E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Oct 2008 18:21:20 +0100
Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Antonio Ospite <ospite@studenti.unina.it> writes:
>
> >
> > Don't swap Cb and Cr components, to respect PXA Quick Capture Interface
> > data format.
> >
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>
>=20
> As a side note, I wonder how you found the right swap :
>  - I based the code on Intel PXA Developer Manual, table 27-19 (page 1127)
>  - and on MT9M111 specification sheet, table 3 (page 14)
> My guess is that the PXA manual is wrong somehow ...
>

Hi Robert,

I used the old scientific method: trial and error :)
I dumped the data to a file with a test app and then I tried different
combinations converting it from yuyv to rgb.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Fri__31_Oct_2008_18_45_18_+0100_F6bbvCrV1/BxeO4E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkLRC4ACgkQ5xr2akVTsAEmmACeNOgAVH9X7aIH+G0Ho6rDU+S1
acIAnAzolsL7SFLTciXOCuch3AsxCjSo
=yRii
-----END PGP SIGNATURE-----

--Signature=_Fri__31_Oct_2008_18_45_18_+0100_F6bbvCrV1/BxeO4E--


--===============1544457031==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============1544457031==--
