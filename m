Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39135 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbeKJHEA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 02:04:00 -0500
Received: by mail-qk1-f194.google.com with SMTP id e4so4163859qkh.6
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2018 13:21:38 -0800 (PST)
Message-ID: <0841fd86ea9bf52057e2a4622a7b9719662cc484.camel@ndufresne.ca>
Subject: Re: [PATCH v4 2/3] media: meson: add v4l2 m2m video decoder driver
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Maxime Jourdan <mjourdan@baylibre.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Date: Fri, 09 Nov 2018 16:21:35 -0500
In-Reply-To: <2f88a17d-76f8-ec70-c18f-aa0d688249be@xs4all.nl>
References: <20181106075926.19269-1-mjourdan@baylibre.com>
         <20181106075926.19269-3-mjourdan@baylibre.com>
         <2f88a17d-76f8-ec70-c18f-aa0d688249be@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-LJ1ZOKBs27Eu2dHy/4L4"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-LJ1ZOKBs27Eu2dHy/4L4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 08 novembre 2018 =C3=A0 09:42 +0100, Hans Verkuil a =C3=A9crit :
> > +static int vdec_queue_setup(struct vb2_queue *q,
> > +             unsigned int *num_buffers, unsigned int *num_planes,
> > +             unsigned int sizes[], struct device *alloc_devs[])
> > +{
> > +     struct amvdec_session *sess =3D vb2_get_drv_priv(q);
> > +     const struct amvdec_format *fmt_out =3D sess->fmt_out;
> > +     u32 output_size =3D amvdec_get_output_size(sess);
> > +     u32 buffers_total;
> > +
> > +     if (*num_planes) {
>=20
> If you are not supporting create_bufs, then you can drop this part.
> Without create_bufs you can assume that *num_planes =3D=3D 0 and
> q->num_buffers =3D=3D 0.
>=20
> You should add a comment here mentioning that create_bufs isn't
> supported by this driver and explain why it isn't supported.
>=20
> I understand it is due to gstreamer problems, but the explanation
> in your cover letter didn't say why it is a problem with this driver
> but not other drivers (apparently).

There is problems in GStreamer with this, but it was disabled because
the firmware does not really allow adding buffers at run-time. Worst,
we would often seen kernel crash when this was enabled.

No decoder before this one implements CREATE_BUFS from what I'm aware,
which explain why I never catched the GStreamer issues before.

Nicolas

--=-LJ1ZOKBs27Eu2dHy/4L4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW+X6XwAKCRBxUwItrAao
HOZ5AJsH8ZD3W+TeUWe/UNJV3bYp0L8AXgCfXruwEQXll0C8dn63JN5dNOcXfpY=
=Smtu
-----END PGP SIGNATURE-----

--=-LJ1ZOKBs27Eu2dHy/4L4--
