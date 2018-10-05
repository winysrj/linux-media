Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:33352 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbeJFAJY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 20:09:24 -0400
Message-ID: <dc1045e5806638d58ae5ace796541cb8a3d29481.camel@paulk.fr>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
From: Paul Kocialkowski <contact@paulk.fr>
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Fri, 05 Oct 2018 19:10:06 +0200
In-Reply-To: <5085f73bc44424b20f1bd0dc1332d9baabecb090.camel@ndufresne.ca>
References: <20181004081119.102575-1-acourbot@chromium.org>
         <f1fa989b372b514f0a7534057de80b0c453cc8a3.camel@paulk.fr>
         <5085f73bc44424b20f1bd0dc1332d9baabecb090.camel@ndufresne.ca>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-iFSnDOpqPj8PwitcW17P"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-iFSnDOpqPj8PwitcW17P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le jeudi 04 octobre 2018 =C3=A0 14:10 -0400, Nicolas Dufresne a =C3=A9crit =
:
> Le jeudi 04 octobre 2018 =C3=A0 14:47 +0200, Paul Kocialkowski a =C3=A9cr=
it :
> > > +    Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the=
 scaling
> > > +    matrix to use when decoding the next queued frame. Applicable to=
 the H.264
> > > +    stateless decoder.
> > > +
> > > +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM``
> >=20
> > Ditto with "H264_SLICE_PARAMS".
> >=20
> > > +    Array of struct v4l2_ctrl_h264_slice_param, containing at least =
as many
> > > +    entries as there are slices in the corresponding ``OUTPUT`` buff=
er.
> > > +    Applicable to the H.264 stateless decoder.
> > > +
> > > +``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM``
> > > +    Instance of struct v4l2_ctrl_h264_decode_param, containing the h=
igh-level
> > > +    decoding parameters for a H.264 frame. Applicable to the H.264 s=
tateless
> > > +    decoder.
> >=20
> > Since we require all the macroblocks to decode one frame to be held in
> > the same OUTPUT buffer, it probably doesn't make sense to keep
> > DECODE_PARAM and SLICE_PARAM distinct.
> >=20
> > I would suggest merging both in "SLICE_PARAMS", similarly to what I
> > have proposed for H.265: https://patchwork.kernel.org/patch/10578023/
> >=20
> > What do you think?
>=20
> I don't understand why we add this arbitrary restriction of "all the
> macroblocks to decode one frame". The bitstream may contain multiple
> NALs per frame (e.g. slices), and stateless API shall pass each NAL
> separately imho. The driver can then decide to combine them if needed,
> or to keep them seperate. I would expect most decoder to decode each
> slice independently from each other, even though they write into the
> same frame.

Well, we sort of always assumed that there is a 1:1 correspondency
between request and output frame when implemeting the software for
cedrus, which simplified both userspace and the driver. The approach we
have taken is to use one of the slice parameters for the whole series
of slices and just append the slice data.

Now that you bring it up, I realize this is an unfortunate decision.
This may have been the cause of bugs and limitations with our driver
because the slice parameters may very well be distinct for each slice.
Moreover, I suppose that just appending the slices data implies that
they are coded in the same order as the picture, which is probably
often the case but certainly not anything guaranteed.=20

So I think we should change our software to associate one request per
slice, not per frame and drop this limitation that all the macroblocks
for the frame must be included.

This will require a number of changes to our driver and userspace, but
also to the MPEG-2 controls where I don't think we have the macroblock
position specified.

So it certainly makes sense to keep SLICE_PARAMS separate from
DECODE_PARAMS for H.264. I should probably also rework the H.265
controls to reflect this. Still, all controls must be passed per slice
(and the hardware decoding pipeline is fully reconfigured then), so I
guess it doesn't make such a big difference in practice.

Thanks for pointing this out, it should help bring the API closer to
what is represented in the bitstream.

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-iFSnDOpqPj8PwitcW17P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlu3mu4ACgkQhP3B6o/u
lQxj8A/+KXicOc1t6TihkQElO50sDdpbqQ9i7ebWG+NJhpS8FTKeew4ZMazMKo9c
9C7PbQfKMadSqrKluS4cm1TxQ/NrsJiKs8qRKogg83M7/F8xCK7LF5ocwYS39Fa4
lJ2s75Priq7dtlYUjS8Hc91cRkbZnzurvWwvedWu3kwbi6d5xV8m1W+USaDCTMVs
uQ9eTcavYJ3aksFgqK/zfCG9DR7ZBT3ftXRBFjyjPWiXqNpvTxMxCU9OdFPJrczK
e5l9lij7ntflTofMOnfnCYvp+nvZxD6dk+KA9x3BeYK0i+O3tQSc6z249QU0S+og
Q87mVXyzqD5xwiuTW+ac5K6XK7dKrTVAC+w+duHgoIbZmINRdNgrCahNCeBxB/N+
ofmnEBDPEfzjCX3nDgP/OqQQiXMoCrvC6SZ5mnMSWUQfSRZkCO+DzK01hdbevrhK
MV/phq4dh01ca6eVIfL/0h/h7OevTDj22cH3u6kzXMAdGFBiBqfRTIBB2lLMEHtC
n+MxkQs4MBTDLKaYvry32ocyNk9riME5UbecqsUROzTC5OqyLLjx3M5AtclaMasS
6NMLZhageDGnDvb6M4aG+gTjluEizyb3b1i7ZGjhyR0nmt2XbUMvpWLxaaDB8Gba
5OvB09eM8FoWbiv2TZ3ov1ruE8pbtjA+N5UQp6iuy7VBgwSKtk4=
=cYDd
-----END PGP SIGNATURE-----

--=-iFSnDOpqPj8PwitcW17P--
