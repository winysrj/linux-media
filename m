Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41410 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933402AbcKWUYu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 15:24:50 -0500
Message-ID: <1479932682.29275.1.camel@ndufresne.ca>
Subject: Re: [PATCH v3 4/9] media: venus: vdec: add video decoder files
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Wed, 23 Nov 2016 15:24:42 -0500
In-Reply-To: <113772f1-8eb9-dd44-42c6-4f109200dff7@linaro.org>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org>
         <1478540043-24558-5-git-send-email-stanimir.varbanov@linaro.org>
         <63a91a5a-a97b-f3df-d16d-c8f76bf20c30@xs4all.nl>
         <4ec31084-1720-845a-30f6-60ddfe285ff1@linaro.org>
         <86442d1d-4a12-71c1-97fa-12bc73bb5045@linaro.org>
         <9ff4f3cf-f6d1-cebe-6f1a-e4209c55e4f4@xs4all.nl>
         <15975057-dd6a-6946-07ac-93a748b6a176@linaro.org>
         <aed4a795-3abe-2d5a-abc4-c638cd4f4d61@xs4all.nl>
         <113772f1-8eb9-dd44-42c6-4f109200dff7@linaro.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-LvdPIuNxhIpqCiz7jP0D"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-LvdPIuNxhIpqCiz7jP0D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 21 novembre 2016 =C3=A0 18:09 +0200, Stanimir Varbanov a =C3=A9cri=
t=C2=A0:
> >> Meanwhile I have found bigger obstacle - I cannot run multiple
> instances
> >> simultaneously. By m2m design it can execute only one job (m2m
> context)
> >> at a time per m2m device. Can you confirm that my observation is
> correct?
> >=C2=A0
> > The m2m framework assumes a single HW instance, yes. Do you have
> multiple
> > HW decoders? I might not understand what you mean...
> >=C2=A0
>=20
> I mean that I can start and execute up to 16 decoder sessions
> simultaneously. Its a firmware responsibility how those sessions are
> scheduled and how the hardware is shared between them. Of course
> depending on the resolution the firmware can refuse to start the
> session
> because the hardware will be overloaded and will not be able to
> satisfy
> the bitrate requirements.

This is similar to S5P-MFC driver, which you may have notice not use
m2m framework.

Nicolas
--=-LvdPIuNxhIpqCiz7jP0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlg1+woACgkQcVMCLawGqByaFACfVxvrtN7/QXJ9xx6lFvBZEkLA
ProAoK7M9lM+hN70Sy0XdD2uN6/W9gw8
=JN3J
-----END PGP SIGNATURE-----

--=-LvdPIuNxhIpqCiz7jP0D--

