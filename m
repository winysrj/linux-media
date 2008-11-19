Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAJHB3dl030736
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 12:11:03 -0500
Received: from smtp-out113.alice.it (smtp-out113.alice.it [85.37.17.113])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAJHAo86026405
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 12:10:50 -0500
Date: Wed, 19 Nov 2008 18:10:18 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: =?ISO-8859-1?Q?"Erik_Andr=E9n"?= <erik.andren@gmail.com>
Message-Id: <20081119181018.bf483949.ospite@studenti.unina.it>
In-Reply-To: <62e5edd40811190750o2792293ei6e32fb25d3819218@mail.gmail.com>
References: <20081119163009.25f0b377.ospite@studenti.unina.it>
	<62e5edd40811190750o2792293ei6e32fb25d3819218@mail.gmail.com>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca: ov534 camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0431703253=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0431703253==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Wed__19_Nov_2008_18_10_18_+0100_S0UpbSE9SdH16QGl"

--Signature=_Wed__19_Nov_2008_18_10_18_+0100_S0UpbSE9SdH16QGl
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Nov 2008 16:50:20 +0100
"Erik Andr=E9n" <erik.andren@gmail.com> wrote:

> 2008/11/19 Antonio Ospite <ospite@studenti.unina.it>:
>
[snip]
> > +       sccb_reg_write(udev, 0x0c, 0xd0);
> > +       sccb_reg_write(udev, 0x64, 0xff);
> > +       sccb_reg_write(udev, 0x0d, 0x41);
> > +
> > +       sccb_reg_write(udev, 0x14, 0x41);
> > +       sccb_reg_write(udev, 0x0e, 0xcd);
> > +       sccb_reg_write(udev, 0xac, 0xbf);
> > +       sccb_reg_write(udev, 0x8e, 0x00);
> > +       sccb_reg_write(udev, 0x0c, 0xd0);
> > +
> > +       ov534_reg_write(udev, 0xe0, 0x09);
> > +       ov534_set_led(udev, 0);
> > +}
> > +
>=20
> A couple of comments:
> Why is it necessary to verify some of the writes?

This is the reverse engineered part from Jim Paris, I guess the
verification could be due to timing issues, but I don't know for sure.

> I would collect all the data to be written in tables and loop over
> them instead of having large sets of write calls.
>

I'd do that way too, normally.
But I wanted to respect the original form of the reverse engineered
code. If the driver really needs to be revolutionized, then it may be
worth copying/sharing stuff with the (non-gspca) ov772x driver.

I know that the driver is in a suboptimal state, the bridge chip
datasheet is not available, so I thought that as a first version it
could be still accepted.

[snip]
> > +       switch (sd->frame_rate) {
> > +       case 50:
> > +               sccb_reg_write(gspca_dev->dev, 0x11, 0x01);
> > +               sccb_check_status(gspca_dev->dev);
> > +               sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
> > +               sccb_check_status(gspca_dev->dev);
> > +               ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
> > +               break;
> > +       case 40:
> > +               sccb_reg_write(gspca_dev->dev, 0x11, 0x02);
> > +               sccb_check_status(gspca_dev->dev);
> > +               sccb_reg_write(gspca_dev->dev, 0x0d, 0xc1);
> > +               sccb_check_status(gspca_dev->dev);
> > +               ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
> > +               break;
> > +       case 30:
> > +       default:
> > +               sccb_reg_write(gspca_dev->dev, 0x11, 0x04);
> > +               sccb_check_status(gspca_dev->dev);
> > +               sccb_reg_write(gspca_dev->dev, 0x0d, 0x81);
> > +               sccb_check_status(gspca_dev->dev);
> > +               ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x02);
> > +               break;
> > +       case 15:
> > +               sccb_reg_write(gspca_dev->dev, 0x11, 0x03);
> > +               sccb_check_status(gspca_dev->dev);
> > +               sccb_reg_write(gspca_dev->dev, 0x0d, 0x41);
> > +               sccb_check_status(gspca_dev->dev);
> > +               ov534_reg_verify_write(gspca_dev->dev, 0xe5, 0x04);
> > +               break;
> > +       };
> > +
> When would you not like to have the maximum frame rate?
>

I just thought that capturing at 25fps is a typical case, and using a
default frame_rate near to that value would be sane, but please give
advices here.

> Thanks,
> Erik
>=20

Thanks,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Wed__19_Nov_2008_18_10_18_+0100_S0UpbSE9SdH16QGl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkkSHoACgkQ5xr2akVTsAGgBQCaAiVDfFLhM5Xdw84fo9ZTYrOy
jMkAn28HiSgyExLQAOpfRfZvGHaKnIra
=LqgI
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Nov_2008_18_10_18_+0100_S0UpbSE9SdH16QGl--


--===============0431703253==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0431703253==--
