Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35398 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731073AbeGROEs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 10:04:48 -0400
Received: by mail-qt0-f194.google.com with SMTP id a5-v6so3970924qtp.2
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2018 06:26:52 -0700 (PDT)
Message-ID: <4ce55726d810e308a2cae3f84bca7140bed48c7d.camel@ndufresne.ca>
Subject: Re: [PATCH] venus: vdec: fix decoded data size
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Vikash Garodia <vgarodia@codeaurora.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, acourbot@chromium.org
Date: Wed, 18 Jul 2018 09:26:49 -0400
In-Reply-To: <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org>
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
         <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-fKYfImwMbR0HkN/Oa7w8"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-fKYfImwMbR0HkN/Oa7w8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 18 juillet 2018 =C3=A0 14:31 +0300, Stanimir Varbanov a =C3=A9c=
rit :
> Hi Vikash,
>=20
> On 07/02/2018 10:44 AM, Vikash Garodia wrote:
> > Exisiting code returns the max of the decoded
> > size and buffer size. It turns out that buffer
> > size is always greater due to hardware alignment
> > requirement. As a result, payload size given to
> > client is incorrect. This change ensures that
> > the bytesused is assigned to actual payload size.
> >=20
> > Change-Id: Ie6f3429c0cb23f682544748d181fa4fa63ca2e28
> > Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> > ---
> >  drivers/media/platform/qcom/venus/vdec.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/media/platform/qcom/venus/vdec.c
> > b/drivers/media/platform/qcom/venus/vdec.c
> > index d079aeb..ada1d2f 100644
> > --- a/drivers/media/platform/qcom/venus/vdec.c
> > +++ b/drivers/media/platform/qcom/venus/vdec.c
> > @@ -890,7 +890,7 @@ static void vdec_buf_done(struct venus_inst
> > *inst, unsigned int buf_type,
> > =20
> >  		vb =3D &vbuf->vb2_buf;
> >  		vb->planes[0].bytesused =3D
> > -			max_t(unsigned int, opb_sz, bytesused);
> > +			min_t(unsigned int, opb_sz, bytesused);
>=20
> Most probably my intension was to avoid bytesused =3D=3D 0, but that is
> allowed from v4l2 driver -> userspace direction

It remains bad practice since it was used by decoders to indicate the
last buffer. Some userspace (some GStreamer versions) will stop working
if you start returning 0.

>=20
> Could you drop min/max_t macros at all and use bytesused directly
> i.e.
>=20
> vb2_set_plane_payload(vb, 0, bytesused)

--=-fKYfImwMbR0HkN/Oa7w8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW09AGQAKCRBxUwItrAao
HM7XAKDWXjbEjj3x65ftmCkFjkZXJJv/lwCfZf8yTBfGAvNVjUwn/e4272azGSw=
=jRgp
-----END PGP SIGNATURE-----

--=-fKYfImwMbR0HkN/Oa7w8--
