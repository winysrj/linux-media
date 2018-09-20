Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37550 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbeITX6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 19:58:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id c13-v6so5716214qkm.4
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2018 11:14:09 -0700 (PDT)
Message-ID: <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 20 Sep 2018 14:14:07 -0400
In-Reply-To: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-XLyBRA0eahF86vgGjAFM"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-XLyBRA0eahF86vgGjAFM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 20 septembre 2018 =C3=A0 16:42 +0200, Hans Verkuil a =C3=A9crit :
> Some parts of the V4L2 API are awkward to use and I think it would be
> a good idea to look at possible candidates for that.
>=20
> Examples are the ioctls that use struct v4l2_buffer: the multiplanar supp=
ort is
> really horrible, and writing code to support both single and multiplanar =
is hard.
> We are also running out of fields and the timeval isn't y2038 compliant.
>=20
> A proof-of-concept is here:
>=20
> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=3Dv4l2-buffer&i=
d=3Da95549df06d9900f3559afdbb9da06bd4b22d1f3
>=20
> It's a bit old, but it gives a good impression of what I have in mind.
>=20
> Another candidate is VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAMEI=
NTERVALS:
> expressing frame intervals as a fraction is really awkward and so is the =
fact
> that the subdev and 'normal' ioctls are not the same.
>=20
> Would using nanoseconds or something along those lines for intervals be b=
etter?

This one is not a good idea, because you cannot represent well known
rates used a lot in the field. Like 60000/1001 also known as 59.94 Hz.
You could endup with drift issues.

For me, what is the most difficult with this API is the fact that it
uses frame internal (duration) instead of frame rate.

>=20
> I have similar concerns with VIDIOC_SUBDEV_ENUM_FRAME_SIZE where there is=
 no
> stepwise option, making it different from VIDIOC_ENUM_FRAMESIZES. But it =
should
> be possible to extend VIDIOC_SUBDEV_ENUM_FRAME_SIZE with stepwise support=
, I
> think.

One of the thing to fix, maybe it's doable now, is the differentiation
between allocation size and display size. Pretty much all video capture
code assumes this is display size and ignores the selection API. This
should be documented explicitly.

In fact, the display/allocation dimension isn't very nice, as both
information overlaps in structures. As an example, you call S_FMT with
a display size you want, and it will return you an allocation size
(which yes, can be smaller, because we always round to the middle).

>=20
> Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps, aga=
in in
> order to improve single vs multiplanar handling.

Yes, but that would fall in a complete redesign I guess. The buffer
allocation scheme is very inflexible. You can't have buffers of two
dimensions allocated at the same time for the same queue. Worst, you
cannot leave even 1 buffer as your scannout buffer while reallocating
new buffers, this is not permitted by the framework (in software). As a
side effect, there is no way to optimize the resolution changes, you
even have to copy your scannout buffer on the CPU, to free it in order
to proceed. Resolution changes are thus painfully slow, by design.

You also cannot switch from internal buffers to importing buffers
easily (in some case you, like encoder, you cannot do that without
flushing the encoder state).

>=20
> It is not the intention to come to a full design, it's more to test the w=
aters
> so to speak.
>=20
> Regards,
>=20
> 	Hans

--=-XLyBRA0eahF86vgGjAFM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW6PjbwAKCRBxUwItrAao
HNaoAJ9MjvyOeyTBl7xDc5f03ArI5NtXKQCgirwBAxhlJGEi3QPaZXTFvgFzd3Y=
=uvnz
-----END PGP SIGNATURE-----

--=-XLyBRA0eahF86vgGjAFM--
