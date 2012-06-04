Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:49145 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448Ab2FDPW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 11:22:27 -0400
Received: by lahi5 with SMTP id i5so4163371lah.14
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 08:22:24 -0700 (PDT)
Date: Mon, 4 Jun 2012 18:13:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Bhupesh Sharma <bhupesh.sharma@st.com>
Cc: laurent.pinchart@ideasonboard.com, linux-usb@vger.kernel.org,
	balbi@ti.com, linux-media@vger.kernel.org,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH 4/5] usb: gadget/uvc: Port UVC webcam gadget to use
 videobuf2 framework
Message-ID: <20120604151355.GA20313@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1338543124.git.bhupesh.sharma@st.com>
 <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <243660e539dcccd868c641188faef26d83c2b894.1338543124.git.bhupesh.sharma@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 01, 2012 at 03:08:57PM +0530, Bhupesh Sharma wrote:
> This patch reworks the videobuffer management logic present in the UVC
> webcam gadget and ports it to use the "more apt" videobuf2 framework for
> video buffer management.
>=20
> To support routing video data captured from a real V4L2 video capture
> device with a "zero copy" operation on videobuffers (as they pass from th=
e V4L2
> domain to UVC domain via a user-space application), we need to support US=
ER_PTR
> IO method at the UVC gadget side.
>=20
> So the V4L2 capture device driver can still continue to use MMAO IO method
> and now the user-space application can just pass a pointer to the video b=
uffers
> being DeQueued from the V4L2 device side while Queueing them at the UVC g=
adget
> end. This ensures that we have a "zero-copy" design as the videobuffers p=
ass
> from the V4L2 capture device to the UVC gadget.
>=20
> Note that there will still be a need to apply UVC specific payload headers
> on top of each UVC payload data, which will still require a copy operation
> to be performed in the 'encode' routines of the UVC gadget.
>=20
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>

this patch doesn't apply. Please refresh on top of v3.5-rc1 or my gadget
branch which I will update in a while.

--=20
balbi

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzNCzAAoJEIaOsuA1yqREefUP/2otpTQjNNzwrJJqcnPlcFXG
QN3sxUMd9+p08VGoCcNkI+SKkI8ZlX4JVWPe460pfFJg0Y7TIh9hw3uuD/+RalLn
C14R44IEGd8MQZPFEUHPA8NPWenXYQ3sMHqWDozLBiUb4skXWCiHHVGt+seSg7gj
+dqOnGR8XJKU20tonoqT8sB5IPTWuGs+tAfOS3HEuSmQAKiPhFT+1jAs1jKnl3gU
a1l5bOaXt+CpsO9BsnR0IrsftWu54Np4jC82H7ZbojoNFInAtkICBxlbN9P2qDFf
3Jd1W7aHrS7QWtvQVeyTrO0vszzxVy85RgGiwxJdi3WSuGFSerGC5LRsXPg9Nu7d
WVtLH19UsfhYJdcIU15/8PWdqK599m2/4gbu3jBUdtwd+87CiJna0XCZa4SRKgpc
5exYIxppWDD+Vq01h2g5KlmgA3TCh4He8/4KqYOXQ3SQ4JAEMhYyakFYu2AWnHWy
ug+r6BYGbNXQWEAFOSBUYDyJ7ruGnMwQRuxxlG17eUuGEiA148mucv8A6Gm4CUe/
FTBH7vbTq6mg70OEclItQr+wLFv1Chwr9Jir/ZxCv8kvz7piTzUoTxWiZ7z7SCYz
Z3TOyd9fDG89+4LrCpxdZrC7l3Q+ubRhGasTClFpvbI6VMGh/6M1csZqbRYa9Nqu
zMVALwmwfc4wKT5NA2n7
=JQSp
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
