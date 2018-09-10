Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42238 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbeIJWLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 18:11:39 -0400
Received: by mail-qk1-f194.google.com with SMTP id g13-v6so14873289qki.9
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 10:16:34 -0700 (PDT)
Message-ID: <85a5d85cc6fc6bb21dafc78e744c350db25894d2.camel@ndufresne.ca>
Subject: Re: [PATCH 2/2] vicodec: set state->info before calling the
 encode/decode funcs
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Mon, 10 Sep 2018 13:16:31 -0400
In-Reply-To: <d58b839f60c07bef6e08184de243380550e75171.camel@collabora.com>
References: <20180910150040.39265-1-hverkuil@xs4all.nl>
         <20180910150040.39265-2-hverkuil@xs4all.nl>
         <d58b839f60c07bef6e08184de243380550e75171.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-rXkLAZJpeTWKBt6VHQHa"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-rXkLAZJpeTWKBt6VHQHa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 10 septembre 2018 =C3=A0 12:37 -0300, Ezequiel Garcia a =C3=A9crit=
 :
> On Mon, 2018-09-10 at 17:00 +0200, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >=20
> > state->info was NULL since I completely forgot to set state->info.
> > Oops.
> >=20
> > Reported-by: Ezequiel Garcia <ezequiel@collabora.com>
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> For both patches:
>=20
> Tested-by: Ezequiel Garcia <ezequiel@collabora.com>
>=20
> With these changes, now this gstreamer pipeline no longer
> crashes:
>=20
> gst-launch-1.0 -v videotestsrc num-buffers=3D30 ! video/x-
> raw,width=3D1280,height=3D720 ! v4l2fwhtenc capture-io-mode=3Dmmap output=
-
> io-mode=3Dmmap ! v4l2fwhtdec
> capture-io-mode=3Dmmap output-io-mode=3Dmmap ! fakesink
>=20
> A few things:
>=20
>   * You now need to mark "[PATCH] vicodec: fix sparse warning" as
> invalid.
>   * v4l2fwhtenc/v4l2fwhtdec elements are not upstream yet.
>   * Gstreamer doesn't end properly; and it seems to negotiate

Is the driver missing CMD_STOP implementation ? (draining flow)

>     different sizes for encoded and decoded unless explicitly set.
>=20
> Thanks!
>=20
> >  drivers/media/platform/vicodec/vicodec-core.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/media/platform/vicodec/vicodec-core.c
> > b/drivers/media/platform/vicodec/vicodec-core.c
> > index fdd77441a47b..5d42a8414283 100644
> > --- a/drivers/media/platform/vicodec/vicodec-core.c
> > +++ b/drivers/media/platform/vicodec/vicodec-core.c
> > @@ -176,12 +176,15 @@ static int device_process(struct vicodec_ctx
> > *ctx,
> >  	}
> > =20
> >  	if (ctx->is_enc) {
> > -		unsigned int size =3D v4l2_fwht_encode(state, p_in,
> > p_out);
> > -
> > -		vb2_set_plane_payload(&out_vb->vb2_buf, 0, size);
> > +		state->info =3D q_out->info;
> > +		ret =3D v4l2_fwht_encode(state, p_in, p_out);
> > +		if (ret < 0)
> > +			return ret;
> > +		vb2_set_plane_payload(&out_vb->vb2_buf, 0, ret);
> >  	} else {
> > +		state->info =3D q_cap->info;
> >  		ret =3D v4l2_fwht_decode(state, p_in, p_out);
> > -		if (ret)
> > +		if (ret < 0)
> >  			return ret;
> >  		vb2_set_plane_payload(&out_vb->vb2_buf, 0, q_cap-
> > >sizeimage);
> >  	}
>=20
>=20

--=-rXkLAZJpeTWKBt6VHQHa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW5am8AAKCRBxUwItrAao
HO1QAJ9QXbfDsdR8IBOKpxMmQxy3AnMksACeIpwqR0DfwR9CsuBnWlRGZoXeeQY=
=XKsw
-----END PGP SIGNATURE-----

--=-rXkLAZJpeTWKBt6VHQHa--
