Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35802 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbeHJNPs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 09:15:48 -0400
Date: Fri, 10 Aug 2018 12:46:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv16 01/34] Documentation: v4l: document request API
Message-ID: <20180810104623.GA6350@amd>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
 <20180705160337.54379-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20180705160337.54379-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
> From: Alexandre Courbot <acourbot@chromium.org>
>=20
> Document the request API for V4L2 devices, and amend the documentation
> of system calls influenced by it.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst
> @@ -306,10 +306,15 @@ struct v4l2_buffer
>        - A place holder for future extensions. Drivers and applications
>  	must set this to 0.
>      * - __u32
> -      - ``reserved``
> +      - ``request_fd``
>        -
> -      - A place holder for future extensions. Drivers and applications
> -	must set this to 0.
> +      - The file descriptor of the request to queue the buffer to. If sp=
ecified
> +        and flag ``V4L2_BUF_FLAG_REQUEST_FD`` is set, then the buffer wi=
ll be

Delete "specified and" -- 0 is valid fd?

> +	queued to that request. This is set by the user when calling
> +	:ref:`ioctl VIDIOC_QBUF <VIDIOC_QBUF>` and ignored by other ioctls.
> +	If the device does not support requests, then ``EPERM`` will be returne=
d.
> +	If requests are supported but an invalid request FD is given, then
> +	``ENOENT`` will be returned.

Should this still specify that this should be 0 if
V4L2_BUF_FLAG_REQUEST_FD is not set?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlttbP8ACgkQMOfwapXb+vJnkQCgpWbIB8uOuRXVG59azzJPejmd
cFUAn0Qq5GmZIibPVvQ1fG4OLBucm8TS
=4O5L
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
