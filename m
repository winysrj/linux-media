Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:33716 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbeISVcB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 17:32:01 -0400
Received: by mail-qt0-f194.google.com with SMTP id r37-v6so5571143qtc.0
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 08:53:28 -0700 (PDT)
Message-ID: <bec2edfda26ecbac928871ad14d768790e3175a8.camel@ndufresne.ca>
Subject: Re: [PATCH] venus: vdec: fix decoded data size
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: vgarodia@codeaurora.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 19 Sep 2018 11:53:25 -0400
In-Reply-To: <6d65ac0d-80a0-88fe-ed19-4785f2675e36@linaro.org>
References: <1530517447-29296-1-git-send-email-vgarodia@codeaurora.org>
         <01451f8e-aea3-b276-cb01-b0666a837d62@linaro.org>
         <4ce55726d810e308a2cae3f84bca7140bed48c7d.camel@ndufresne.ca>
         <92f6f79a-02ae-d23e-1b97-fc41fd921c89@linaro.org>
         <33e8d8e3-138e-0031-5b75-4bef114ac75e@xs4all.nl>
         <36b42952-982c-9048-77fb-72ca45cc7476@linaro.org>
         <051af6fb-e0e8-4008-99c5-9685ac24e454@xs4all.nl>
         <CAPBb6MVupMsdhF6Rtk4fm8JeVurrK+ZsuxAQ-BwrTzdSP1xP0Q@mail.gmail.com>
         <6d65ac0d-80a0-88fe-ed19-4785f2675e36@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-RGb6Gp4tD6j4myXgFZQA"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-RGb6Gp4tD6j4myXgFZQA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 19 septembre 2018 =C3=A0 18:02 +0300, Stanimir Varbanov a
=C3=A9crit :
> > --- a/drivers/media/platform/qcom/venus/vdec.c
> > +++ b/drivers/media/platform/qcom/venus/vdec.c
> > @@ -943,8 +943,7 @@ static void vdec_buf_done(struct venus_inst
> > *inst,
> > unsigned int buf_type,
> >                 unsigned int opb_sz =3D
> > venus_helper_get_opb_size(inst);
> >=20
> >                 vb =3D &vbuf->vb2_buf;
> > -               vb->planes[0].bytesused =3D
> > -                       max_t(unsigned int, opb_sz, bytesused);
> > +                vb2_set_plane_payload(vb, 0, bytesused ? :
> > opb_sz);
> >                 vb->planes[0].data_offset =3D data_offset;
> >                 vb->timestamp =3D timestamp_us * NSEC_PER_USEC;
> >                 vbuf->sequence =3D inst->sequence_cap++;
> >=20
> > It works fine for me, and should not return 0 more often than it
> > did
> > before (i.e. never). In practice I also never see the firmware
> > reporting a payload of zero on SDM845, but maybe older chips
> > differ?
>=20
> yes, it looks fine. Let me test it with older versions.

What about removing the allow_zero_bytesused flag on this specific
queue ? Then you can leave it to 0, and the framework will change it to
the buffer size.

Nicolas

--=-RGb6Gp4tD6j4myXgFZQA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW6Jw9QAKCRBxUwItrAao
HFjZAKDRumEFmZk46/FnEsuGsQ6l9tC3ewCfeQOroYDAPOBtlLaONtwjkz7IAgo=
=7Xsu
-----END PGP SIGNATURE-----

--=-RGb6Gp4tD6j4myXgFZQA--
