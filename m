Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60375 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933819AbcKDOSS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 10:18:18 -0400
Message-ID: <1478269090.18909.8.camel@ndufresne.ca>
Subject: Re: [RFC] V4L2 unified low-level decoder API
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        Randy Li <randy.li@rock-chips.com>,
        "posciak@chromium.org" <posciak@chromium.org>,
        "jung.zhao@rock-chips.com" <jung.zhao@rock-chips.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Florent Revest <florent.revest@free-electrons.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>,
        "eddie.cai" <eddie.cai@rock-chips.com>,
        "linux-rockchip@lists.infradead.org"
        <linux-rockchip@lists.infradead.org>,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>,
        =?UTF-8?Q?=E6=9E=97=E9=87=91=E5=8F=91?= <alpha.lin@rock-chips.com>
Date: Fri, 04 Nov 2016 10:18:10 -0400
In-Reply-To: <e6b89733-465e-74d3-45b9-0a39d1136779@st.com>
References: <58C70A34B28DE743B9604C8841D375C2793D2999@SAFEX1MAIL5.st.com>
         <aab23d5d-d41d-78e1-7324-77b9d98ee127@rock-chips.com>
         <e6b89733-465e-74d3-45b9-0a39d1136779@st.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-/lWNLrjFYHOAxgWE6iwN"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-/lWNLrjFYHOAxgWE6iwN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 04 novembre 2016 =C3=A0 14:55 +0100, Hugues FRUCHET a =C3=A9cri=
t=C2=A0:
> >>
> >> I can help on H264 on a code review basis based on the functional H264
> >> setup I have in-house and codec knowledge, but I cannot provide
> >> implementation in a reasonable timeframe, same for VP8.
> >>
> >>
> >>
> >> Apart of very details of each codec, we have also to state about gener=
ic
> >> concerns such as:
> >>
> >> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 new pixel form=
at introduction (VP8 =3D> VP8F, H264 =3D> S264,
> >> MPG2 =3D> MG2F, MPG4 =3D> MG4F)
> > I don't think it is necessary.
>=20
> But currently it is done that way in all patches proposals I have seen=C2=
=A0
> so far, including rockchip:
> rockchip_decoder_v4l2.c:{VAProfileH264Baseline,V4L2_PIX_FMT_H264_SLICE},
>=20
> We have to state about it all together. Seems natural to me to do this=C2=
=A0
> way instead of device caps.
> Doing so user knows that the driver is based on "Frame API" -so=C2=A0
> additional headers are required to decode input stream- and not
> on "Stream API" -H264 stream can be decoded directly-.

We should probably use something else then "STREAMING" in the
capabilities instead of duplicating all the encoding formats (exception
to H264 byte-stream and H264 AVC, that also applies to streaming
drivers and there is not easy way to introduce stream-format in the API
atm). Other then that, this solution works, so it could just be
considered the right way, I just find it less elegant personally.

my two cents,
Nicolas

--=-/lWNLrjFYHOAxgWE6iwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlgcmKIACgkQcVMCLawGqBxHtQCfYLV4JGXKWR9naxz2oiqzH2wg
KWMAn0YB1mBwmWN+iIPIGyUclveK/q2q
=1Ku1
-----END PGP SIGNATURE-----

--=-/lWNLrjFYHOAxgWE6iwN--

