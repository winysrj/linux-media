Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44829 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388326AbeKPC7p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 21:59:45 -0500
Received: by mail-qk1-f194.google.com with SMTP id n12so32803573qkh.11
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 08:51:10 -0800 (PST)
Message-ID: <f3572cbeecbcbeeb37a6e2d29b4e72e2a9ae75bc.camel@ndufresne.ca>
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Nov 2018 11:51:08 -0500
In-Reply-To: <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
References: <20181113093048.236201-1-acourbot@chromium.org>
         <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
         <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com>
         <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-zHZ7Ei4DWZbZ/lADHTh8"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-zHZ7Ei4DWZbZ/lADHTh8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 15 novembre 2018 =C3=A0 11:49 -0500, Nicolas Dufresne a =C3=A9crit=
 :
> Sending buffers with payload size to 0 just for the sake of setting the
> V4L2_BUF_FLAG_LAST was considered a waste. Specially that after that,
> every polls should return EPIPE. So in the end, we decided the it
> should just unblock the userspace and return EPIPE.

errata, DQBUF returns EPIPE, not sure why I keep saying poll.

sorry for that,
Nicolas

--=-zHZ7Ei4DWZbZ/lADHTh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW+2j/AAKCRBxUwItrAao
HEN5AKDdT0awi1JnbZR4oAi4PaDyutHeegCfXblCg4heJ0HpNxGyNq+4pP2Tewk=
=0c25
-----END PGP SIGNATURE-----

--=-zHZ7Ei4DWZbZ/lADHTh8--
