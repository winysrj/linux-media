Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37368 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbeIGTrB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 15:47:01 -0400
Message-ID: <a12d745c3de5ba2f3033ed025dda9e249c8e0157.camel@collabora.com>
Subject: Re: [RFP] Stateless Codec Userspace Support
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 07 Sep 2018 11:05:36 -0400
In-Reply-To: <ae73ad59-af82-040c-ec89-b8defd8e312c@xs4all.nl>
References: <ae73ad59-af82-040c-ec89-b8defd8e312c@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-/df34G4YvSWNh72Ft3/O"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-/df34G4YvSWNh72Ft3/O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 07 septembre 2018 =C3=A0 16:34 +0200, Hans Verkuil a =C3=A9crit=
 :
> Support for stateless codecs and Request API will hopefully be merged
> for
> 4.20, and the next step is to discuss how to organize the userspace
> support.
>=20
> Hopefully by the time the media summit starts we'll have some better
> ideas
> of what we want in this area.
>=20
> Some userspace support is available from bootlin for the cedrus
> driver:
>=20
>   - v4l2-request-test, that has a bunch of sample frames for various
>     codecs and will rely solely on the kernel request api (and DRM
> for
>     the display part) to test and bringup a particular driver
>     https://github.com/bootlin/v4l2-request-test
>=20
>   - libva-v4l2-request, that is a libva implementation using the
>     request API
>     https://github.com/bootlin/libva-v4l2-request
>=20
> But this is more geared towards testing and less a 'proper'
> implementation.

Considering that libva is largely supported across media players,
browsers and media frameworks, the VA Driver approach seems like the
most promising solution to get short term usage. This way, we can share
the userspace code across various codec and also across V4L2 and DRM
subsystems.

That being said, a lot of userspace will need modification. Indeed, VA
do expose some of the DRM details for zero-copy path (like DMABuf
exportation). We can emulate this support, or simply enhance VA with
it's own V4L2 specific bits. It's too early to tell, and also I'm not
deep enough into VA driver interface to be able to give guidelines.

Another thing that most userspace rely on is the presence of VPP
functions. I notice some assembly code that does detiling in that libva
driver, I bet this is related to not having enabled some sort of HW VPP
yet on the Allwinner SoC. Overall, this does not seems like a problem,
the m2m interface is well suited for that and a VA driver can make use
of that. What will be needed is a better way to figure-out what these
VPP can do, things like CSC, deinterlacing, scaling, rotation, etc.
Just like in any other library, we need to be able to announce which
"function" are supported.

Putting my GStreamer hat back, I'd very like to have a native support
for these stateless CODEC, as this would give a bit more flexibility,
but this isn't something that one can write in a day (specially if that
happens on my spare or r&d time). Though, I'm looking forward into this
in order to come up with a library, a bit like the existing GStreamer
bitstream parser library, that could handle reference picture
management and lost frame concealment (a currently missing feature in
gstreamer-vaapi).

I think that most straighforward place to add direct support (without
VA abstraction) would be FFMPEG. If I understood well, they already
share most of the decoder layer needed between their software decoder
and the VAAPI one.

One place that haven't been mentioned, but seems rather important,
would be Android. Implementing a generic OMX component for the Android
OMX stack would get quite some traction, as the CODEC integration work
would become very much a kernel work. Having that handy, would help
convince the vendors that the V4L2 framework is worth it. Making the
OMX stack in Android as vendor agnostic as possible is also helping
Android folks in eventually getting rid of OMX. OMX specification is
mostly abandoned, with no-one to review new extensions.

>=20
> I don't know yet how much time to reserve for this discussion. It's a
> bit too early for that. I would expect an hour minimum, likely more.
>=20
> Regards,
>=20
> 	Hans

--=-/df34G4YvSWNh72Ft3/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW5KTwAAKCRBxUwItrAao
HA3YAKC8jcDy+7H8BfAVvY9OMwUnNNVy0QCggzpbhcrUtLNrChSHgwp/laAMI6U=
=zS36
-----END PGP SIGNATURE-----

--=-/df34G4YvSWNh72Ft3/O--
