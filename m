Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:35780 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbdK3PYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 10:24:42 -0500
Date: Thu, 30 Nov 2017 16:24:40 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas van Kleef <thomas@vitsch.nl>
Cc: Giulio Benetti <giulio.benetti@micronovasrl.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andreas Baierl <list@imkreisrum.de>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux@armlinux.org.uk, wens@csie.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [linux-sunxi] Cedrus driver
Message-ID: <20171130152440.k62tjegzj2dtsmt2@flea.lan>
References: <1511969761-6608110782.e622897b62@prakkezator.vehosting.nl>
 <cc728978-e723-289c-ec85-d2d27e937083@vitsch.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uec25nwo55fhy7v5"
Content-Disposition: inline
In-Reply-To: <cc728978-e723-289c-ec85-d2d27e937083@vitsch.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uec25nwo55fhy7v5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Wed, Nov 29, 2017 at 04:36:01PM +0100, Thomas van Kleef wrote:
> > C) I'm not sure what you tried to do with the application of the
> >    request API patches (such as e1ca861c168f) but we want to have the
> >    whole commits in there, and not a patch adding all of them. This
> >    will make the work so much easier to rebase to a later version when
> >    some patches wouldn't have been merged and some would have.
> >=20
> > D) Rebase :)
>
> Thank you. Giulio asked before if I could add a repo and commit the=20
> patches so that is what I did. I will push a different code where the
> full history is present in commits.
>=20
> So, I got it setup. As I did test it before on the slightly newer branch,
> I did not verify, again, if the video-decoder worked on this specific=20
> state of the linux kernel, 4.14. But it should x:
> If you rather wait for me to tell if it work let me know, but we could do
> a pull request then again anyway.

Yeah, I'd rather wait for at least small test that the general case is
working.

> So here is the new pull-request
> The following changes since commit bebc6082da0a9f5d47a1ea2edc099bf671058b=
d4:
>=20
>   Linux 4.14 (2017-11-12 10:46:13 -0800)
>=20
> are available in the git repository at:
>=20
>   https://github.com/thomas-vitsch/linux-a20-cedrus.git linux-sunxi-cedrus
>=20
> for you to fetch changes up to 26701eca67a07ab002c7fd18038fa299b9589939:
>=20
>   Fix the sun5i and sun8i dts files (2017-11-29 15:18:05 +0100)
>=20
> ----------------------------------------------------------------
> Bob Ham (1):
>       sunxi-cedrus: Fix compilation errors from bad types under GCC 6.2
>=20
> Florent Revest (8):
>       Both mainline and cedrus had added their own formats with both are =
added.
>       v4l: Add MPEG2 low-level decoder API control
>       v4l: Add MPEG4 low-level decoder API control
>       media: platform: Add Sunxi Cedrus decoder driver
>       sunxi-cedrus: Add a MPEG 2 codec
>       sunxi-cedrus: Add a MPEG 4 codec
>       sunxi-cedrus: Add device tree binding document
>       ARM: dts: sun5i: Use video-engine node
>=20
> Hans Verkuil (15):
>       videodev2.h: add max_reqs to struct v4l2_query_ext_ctrl
>       videodev2.h: add request to v4l2_ext_controls
>       videodev2.h: add request field to v4l2_buffer.
>       vb2: add allow_requests flag
>       v4l2-ctrls: add request support
>       v4l2-ctrls: add function to apply a request.
>       v4l2-ctrls: implement delete request(s)
>       v4l2-ctrls: add VIDIOC_REQUEST_CMD
>       v4l2: add initial V4L2_REQ_CMD_QUEUE support
>       vb2: add helper function to queue request-specific buffer.
>       v4l2-device: keep track of registered video_devices
>       v4l2-device: add v4l2_device_req_queue
>       vivid: add request support for video capture.
>       v4l2-ctrls: add REQ_KEEP flag
>       Documentation: add v4l2-requests.txt
>=20
> Icenowy Zheng (2):
>       sunxi-cedrus: add syscon support
>       ARM: dts: sun8i: add video engine support for A33
>=20
> Thomas van Kleef (4):
>       Merged requests2 into linux 4.14
>       Fix merge error
>       Remove reject file from merge
>       Fix the sun5i and sun8i dts files

There's still two minor issues with your patches here.

Your SoB should contain your name only, so you should drop the Vitsch
Electronics part. And the patches that are fixing compilation issues
should be squashed in the patches that introduced the breakage in the
first place. So a01b8665802145f1180680b67e5e1d04f2050fe3 should be
merged with 1c735c83c68d54616503481b2796005f02930b85 for example.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--uec25nwo55fhy7v5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlogIpoACgkQ0rTAlCFN
r3SCCA//eymfGNCinyfvtYr+Ekdg2phEyB8RRFuuY0FIG3enVW1ElTF0Chc1cKEr
31ntCS+zcGhrLnFmzp5LL0efPQ+elsBmLCTJYW+NbFBc/FQ3tc2j9lRUPGU0ypol
hkXiKgJTlXTDC+H8q+DMs9Qql8jK6oruZGNVS74HMU2mR/3b/Dv0ejQj10xxrhtC
BFh1sqLeIsfIVR8VElFV03jc8y4dZZn59pUHWFzKGqNYjYyPDanDxCRlao6hWAVL
isKuiyFBZnbWHOi3zF2aNfw+Wk2f6T+9cEgK0kOij9Go4q5APToUZF28HLZ1volG
9UNNcbd3ehKa6GgCO8Mxnc2U+MpnxM+gcV8n3U6I9G4WX7a787TcQuYx0akOEYkJ
4Q+zbyeGjuUUVaCJfxGCgWF3St+NOWRC0ugvR6/4UqQkMUUTkALt/MH+gTMxdJdn
Tpj8z0XamrAHKrtrhChjVk3OwT2PAw1j0K7bxB7GKAjox2kfHgfekaQ1mbcWN3qi
XJAT33DPhcMGqRJ7jc9957cRq/jurQWRxNvLROSrA6W5vkfKnhVwgWYKZtjWmQyn
NQKhv+vwUUc/vTkLNYn3K8vEfsRPm2Qk77z9Vr/i7i2Rh5Lnz4DhahfjcyXwYTj8
oeOoHNNP9lv7WN4PFqvtsL8E098P4P1afTJM798dNkBMYHCJH7U=
=LA4H
-----END PGP SIGNATURE-----

--uec25nwo55fhy7v5--
