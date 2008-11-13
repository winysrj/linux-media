Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mADMbGuP017029
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 17:37:16 -0500
Received: from smtp-out114.alice.it (smtp-out114.alice.it [85.37.17.114])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mADMa3Lg016017
	for <video4linux-list@redhat.com>; Thu, 13 Nov 2008 17:36:16 -0500
Date: Thu, 13 Nov 2008 23:35:54 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: video4linux-list@redhat.com
Message-Id: <20081113233554.65c5a5f4.ospite@studenti.unina.it>
In-Reply-To: <1226601059.1705.12.camel@localhost>
References: <20080816050023.GB30725@thumper>
	<20080816083613.51071257@mchehab.chehab.org>
	<7813ee860808160513g2f0e3602q9f3aed45d66ef165@mail.gmail.com>
	<20081105203114.213b599a@pedra.chehab.org>
	<20081111184200.cb9a2ba4.ospite@studenti.unina.it>
	<20081111191516.20febe64.ospite@studenti.unina.it>
	<4919E47E.4000603@hhs.nl>
	<20081112191736.bcbc1e37.ospite@studenti.unina.it>
	<1226576038.2040.42.camel@localhost>
	<20081113180421.09c5ca05.ospite@studenti.unina.it>
	<1226601059.1705.12.camel@localhost>
Mime-Version: 1.0
Cc: 
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0000049151=="
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

--===============0000049151==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Thu__13_Nov_2008_23_35_54_+0100_56NnzSA6goaiy7b="

--Signature=_Thu__13_Nov_2008_23_35_54_+0100_56NnzSA6goaiy7b=
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Nov 2008 19:30:59 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

>
> On Thu, 2008-11-13 at 18:04 +0100, Antonio Ospite wrote:
> > So (cam->bulk_nurbs =3D=3D 0) would mean that the subdriver takes care =
of
> > usb tranfers, right? That would also imply that bulk_irq() is not set
> > for these drivers and sd_pkt_scan() is never called which looks fair to
> > me.
> 	[snip]
>=20
> Yes. In the finepix subdriver, the 'complete' function of the URB is
> changed to a local function which does the packet analysis and restarts
> the next transfer after a delay.
>=20
> I attached the patch of the main driver.
>

Many thanks Jean-Francois, any ETA of this change in mainline?
Some comments inlined

Regards,
   Antonio Ospite

> Cheers.
>=20
> --=20
> Ken ar c'henta=F1 |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>=20
>=20
>=20
> [gspca_bulk.patch  text/x-patch (1,9KB)]
> diff -r 417024f56f55 linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Tue Nov 11 12:42:56 2008 +0=
100
> +++ b/linux/drivers/media/video/gspca/gspca.c	Thu Nov 13 19:14:42 2008 +0=
100
> @@ -213,6 +213,7 @@
>  {
>  	struct gspca_dev *gspca_dev =3D (struct gspca_dev *) urb->context;
>  	struct gspca_frame *frame;
> +	int st;
> =20
>  	PDEBUG(D_PACK, "bulk irq");
>  	if (!gspca_dev->streaming)
> @@ -235,6 +236,13 @@
>  					frame,
>  					urb->transfer_buffer,
>  					urb->actual_length);
> +	}
> +
> +	/* resubmit the URB */
> +	if (gspca_dev->cam.bulk_nurbs !=3D 0) {

Just to be sure: this check is still needed because bulk_irq() can be
still called even for drivers like finepix, right?
I am not sure I've fully understood the code path here, maybe I should
look better at what the finepix driver does, sorry, does it still uses
the urb initialized in create_urbs(), even if it drives the submission
manually?

> +		st =3D usb_submit_urb(urb, GFP_ATOMIC);
> +		if (st < 0)
> +			PDEBUG(D_ERR|D_PACK, "usb_submit_urb() ret %d", st);
>  	}
>  }
> =20
> @@ -533,11 +541,14 @@
>  		nurbs =3D DEF_NURBS;
>  	} else {				/* bulk */
>  		npkt =3D 0;
> -		bsize =3D gspca_dev->cam.	bulk_size;
> +		bsize =3D gspca_dev->cam.bulk_size;
>  		if (bsize =3D=3D 0)
>  			bsize =3D psize;
>  		PDEBUG(D_STREAM, "bulk bsize:%d", bsize);
> -		nurbs =3D 1;
> +		if (gspca_dev->cam.bulk_nurbs !=3D 0)
> +			nurbs =3D gspca_dev->cam.bulk_nurbs;

should we set this to min(gspca_dev->cam.bulk_nurbs, MAX_NURBS) ?

> +		else
> +			nurbs =3D 1;
>  	}
> =20
>  	gspca_dev->nurbs =3D nurbs;
> @@ -625,8 +636,8 @@
>  		gspca_dev->streaming =3D 1;
>  		atomic_set(&gspca_dev->nevent, 0);
> =20
> -		/* bulk transfers are started by the subdriver */
> -		if (gspca_dev->alt =3D=3D 0)
> +		/* some bulk transfers are started by the subdriver */
> +		if (gspca_dev->alt =3D=3D 0 && gspca_dev->cam.bulk_nurbs =3D=3D 0)
>  			break;
> =20
>  		/* submit the URBs */
> diff -r 417024f56f55 linux/drivers/media/video/gspca/gspca.h
> --- a/linux/drivers/media/video/gspca/gspca.h	Tue Nov 11 12:42:56 2008 +0=
100
> +++ b/linux/drivers/media/video/gspca/gspca.h	Thu Nov 13 19:14:42 2008 +0=
100
> @@ -58,6 +58,10 @@
>  	int bulk_size;		/* buffer size when image transfer by bulk */
>  	struct v4l2_pix_format *cam_mode;	/* size nmodes */
>  	char nmodes;
> +	__u8 bulk_nurbs;	/* number of URBs in bulk mode
> +				 * - cannot be > MAX_NURBS
> +				 * - when 0 and bulk_size !=3D 0 means
> +				 *   1 URB and submit done by subdriver */
>  	__u8 epaddr;
>  };
> =20
>=20


--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Thu__13_Nov_2008_23_35_54_+0100_56NnzSA6goaiy7b=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkcq8oACgkQ5xr2akVTsAFqCACfWlBDNPUpETjdsKvR6dAyT83s
pdwAn3iA3vVtzKo38xyYpu1O/A1JkE8U
=OxbN
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Nov_2008_23_35_54_+0100_56NnzSA6goaiy7b=--


--===============0000049151==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--===============0000049151==--
