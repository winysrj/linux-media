Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9G8SMkd014913
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 04:28:22 -0400
Received: from smtp-out112.alice.it (smtp-out112.alice.it [85.37.17.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9G8R9Eg019309
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 04:27:10 -0400
Date: Thu, 16 Oct 2008 10:27:01 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081016102701.1bcb2c59.ospite@studenti.unina.it>
In-Reply-To: <u63nt9mvx.wl%morimoto.kuninori@renesas.com>
References: <u63nt9mvx.wl%morimoto.kuninori@renesas.com>
Mime-Version: 1.0
Subject: Re: [PATCH] Add ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0683881305=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0683881305==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__16_Oct_2008_10_27_01_+0200_foLQYfDCa4u7qTvh"

--Signature=_Thu__16_Oct_2008_10_27_01_+0200_foLQYfDCa4u7qTvh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Oct 2008 13:28:52 +0900
Kuninori Morimoto <morimoto.kuninori@renesas.com> wrote:

> This patch adds ov772x driver that use soc_camera framework.

Hi, this sensor is used also in some usb cameras (Playstation Eye, for
instance), and this code can be reused to improve the previously posted
ov534 driver.

The question is: is there any mechanism to share sensor code between
usb and i2c drivers or we have to copy and paste?

Thanks, and sorry for the noise.

Regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Thu__16_Oct_2008_10_27_01_+0200_foLQYfDCa4u7qTvh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj2+tUACgkQ5xr2akVTsAHALwCdEVP5ktTcwQQzIYa000wdG9lk
qYIAn1yiyrRYc1nclfETV/DDqfqNQJYv
=FPE8
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Oct_2008_10_27_01_+0200_foLQYfDCa4u7qTvh--


--===============0683881305==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0683881305==--
