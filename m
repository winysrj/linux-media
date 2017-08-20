Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34402 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752844AbdHTNLW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 09:11:22 -0400
Received: by mail-qk0-f174.google.com with SMTP id u139so72051291qka.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 06:11:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804104155.37386-5-hverkuil@xs4all.nl>
References: <20170804104155.37386-1-hverkuil@xs4all.nl> <20170804104155.37386-5-hverkuil@xs4all.nl>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Sun, 20 Aug 2017 15:11:21 +0200
Message-ID: <CA+M3ks4ZL4FXgWkuQkKvhUfou0S7a-u4LbJ0dPRfDuLkS8vM-A@mail.gmail.com>
Subject: Re: [PATCH 4/5] stih-cec: use CEC_CAP_DEFAULTS
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-08-04 12:41 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Use the new CEC_CAP_DEFAULTS define in this driver.
> This also adds the CEC_CAP_RC capability which was missing here
> (and this is also the reason for this new define, to avoid missing
> such capabilities).
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

> ---
>  drivers/media/platform/sti/cec/stih-cec.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/pl=
atform/sti/cec/stih-cec.c
> index ce7964c71b50..dc221527fd05 100644
> --- a/drivers/media/platform/sti/cec/stih-cec.c
> +++ b/drivers/media/platform/sti/cec/stih-cec.c
> @@ -351,9 +351,7 @@ static int stih_cec_probe(struct platform_device *pde=
v)
>         }
>
>         cec->adap =3D cec_allocate_adapter(&sti_cec_adap_ops, cec,
> -                       CEC_NAME,
> -                       CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
> -                       CEC_CAP_TRANSMIT, CEC_MAX_LOG_ADDRS);
> +                       CEC_NAME, CEC_CAP_DEFAULTS, CEC_MAX_LOG_ADDRS);
>         if (IS_ERR(cec->adap))
>                 return PTR_ERR(cec->adap);
>
> --
> 2.13.2
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
