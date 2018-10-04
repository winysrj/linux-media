Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt1-f169.google.com ([209.85.160.169]:37144 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbeJEBEc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 21:04:32 -0400
Received: by mail-qt1-f169.google.com with SMTP id d14-v6so2319761qto.4
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 11:10:07 -0700 (PDT)
Message-ID: <5085f73bc44424b20f1bd0dc1332d9baabecb090.camel@ndufresne.ca>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Paul Kocialkowski <contact@paulk.fr>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2018 14:10:04 -0400
In-Reply-To: <f1fa989b372b514f0a7534057de80b0c453cc8a3.camel@paulk.fr>
References: <20181004081119.102575-1-acourbot@chromium.org>
         <f1fa989b372b514f0a7534057de80b0c453cc8a3.camel@paulk.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-WITFkROoIaAo+RDmdg+G"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-WITFkROoIaAo+RDmdg+G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 04 octobre 2018 =C3=A0 14:47 +0200, Paul Kocialkowski a =C3=A9crit=
 :
> > +    Instance of struct v4l2_ctrl_h264_scaling_matrix, containing the s=
caling
> > +    matrix to use when decoding the next queued frame. Applicable to t=
he H.264
> > +    stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM``
>=20
> Ditto with "H264_SLICE_PARAMS".
>=20
> > +    Array of struct v4l2_ctrl_h264_slice_param, containing at least as=
 many
> > +    entries as there are slices in the corresponding ``OUTPUT`` buffer=
.
> > +    Applicable to the H.264 stateless decoder.
> > +
> > +``V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAM``
> > +    Instance of struct v4l2_ctrl_h264_decode_param, containing the hig=
h-level
> > +    decoding parameters for a H.264 frame. Applicable to the H.264 sta=
teless
> > +    decoder.
>=20
> Since we require all the macroblocks to decode one frame to be held in
> the same OUTPUT buffer, it probably doesn't make sense to keep
> DECODE_PARAM and SLICE_PARAM distinct.
>=20
> I would suggest merging both in "SLICE_PARAMS", similarly to what I
> have proposed for H.265: https://patchwork.kernel.org/patch/10578023/
>=20
> What do you think?

I don't understand why we add this arbitrary restriction of "all the
macroblocks to decode one frame". The bitstream may contain multiple
NALs per frame (e.g. slices), and stateless API shall pass each NAL
separately imho. The driver can then decide to combine them if needed,
or to keep them seperate. I would expect most decoder to decode each
slice independently from each other, even though they write into the
same frame.

Nicolas

--=-WITFkROoIaAo+RDmdg+G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW7ZXfAAKCRBxUwItrAao
HN+lAJ9mLHnynjV7/5/fV/twzlfr93Ny3gCfQWLpOzVsima2HI6MxxdFSOCBSBE=
=qB0v
-----END PGP SIGNATURE-----

--=-WITFkROoIaAo+RDmdg+G--
