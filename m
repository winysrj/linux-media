Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:38154 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbcFWGlx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2016 02:41:53 -0400
Subject: Re: [PATCH v5 9/9] Input: sur40 - use new V4L2 touch input type
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466633313-15339-10-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	mchehab@osg.samsung.com, Martin Kaltenbrunner <modin@yuri.at>
From: Florian Echtler <floe@butterbrot.org>
Message-ID: <576B84AD.8060703@butterbrot.org>
Date: Thu, 23 Jun 2016 08:41:49 +0200
MIME-Version: 1.0
In-Reply-To: <1466633313-15339-10-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ra8U1jx7T1flqPV87ueFKRjtwnviND4bs"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ra8U1jx7T1flqPV87ueFKRjtwnviND4bs
Content-Type: multipart/mixed; boundary="lMa6GKUG3p1xGILtCmLe1hP7VhoPd7vcI"
From: Florian Echtler <floe@butterbrot.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>,
 Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org,
 Benjamin Tissoires <benjamin.tissoires@redhat.com>,
 Benson Leung <bleung@chromium.org>, Alan Bowens <Alan.Bowens@atmel.com>,
 Javier Martinez Canillas <javier@osg.samsung.com>,
 Chris Healy <cphealy@gmail.com>, Henrik Rydberg <rydberg@bitmath.org>,
 Andrew Duggan <aduggan@synaptics.com>, James Chen <james.chen@emc.com.tw>,
 Dudley Du <dudl@cypress.com>, Andrew de los Reyes <adlr@chromium.org>,
 sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
 mchehab@osg.samsung.com, Martin Kaltenbrunner <modin@yuri.at>
Message-ID: <576B84AD.8060703@butterbrot.org>
Subject: Re: [PATCH v5 9/9] Input: sur40 - use new V4L2 touch input type
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
 <1466633313-15339-10-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1466633313-15339-10-git-send-email-nick.dyer@itdev.co.uk>

--lMa6GKUG3p1xGILtCmLe1hP7VhoPd7vcI
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 23.06.2016 00:08, Nick Dyer wrote:
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscr=
een/sur40.c
> index 880c40b..841e045 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -599,7 +599,7 @@ static int sur40_probe(struct usb_interface *interf=
ace,
>  	sur40->vdev.queue =3D &sur40->queue;
>  	video_set_drvdata(&sur40->vdev, sur40);
> =20
> -	error =3D video_register_device(&sur40->vdev, VFL_TYPE_GRABBER, -1);
> +	error =3D video_register_device(&sur40->vdev, VFL_TYPE_TOUCH, -1);
>  	if (error) {
>  		dev_err(&interface->dev,
>  			"Unable to register video subdevice.");

As far as I could tell from looking at patch 1/9, the only visible
change for userspace will be the device name, so I'd be fine with this.

> @@ -794,7 +794,7 @@ static int sur40_vidioc_enum_fmt(struct file *file,=
 void *priv,
>  	if (f->index !=3D 0)
>  		return -EINVAL;
>  	strlcpy(f->description, "8-bit greyscale", sizeof(f->description));
> -	f->pixelformat =3D V4L2_PIX_FMT_GREY;
> +	f->pixelformat =3D V4L2_TCH_FMT_TU08;

I would suggest to leave the pixel format as it is. Rationale: the data
really is greyscale image intensity data (as also evidenced by [1]), not
just a synthetic image, and changing the pixel format would break all
userspace tools.

[1] https://github.com/mkalten/reacTIVision/issues/3#issuecomment-9993180=
7

Best, Florian
--=20
SENT FROM MY DEC VT50 TERMINAL


--lMa6GKUG3p1xGILtCmLe1hP7VhoPd7vcI--

--ra8U1jx7T1flqPV87ueFKRjtwnviND4bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEUEARECAAYFAldrhK0ACgkQ7CzyshGvathKsQCXRIGLjUmap2dnJEx577wNUjms
3ACg9PH5NfcuHDRGyuq299HtgKF/0q0=
=12TN
-----END PGP SIGNATURE-----

--ra8U1jx7T1flqPV87ueFKRjtwnviND4bs--
