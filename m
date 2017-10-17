Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:55962 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933638AbdJQLdJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 07:33:09 -0400
Received: by mail-oi0-f68.google.com with SMTP id g125so2132567oib.12
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 04:33:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3fuail25k.fsf@t19.piap.pl>
References: <m3fuail25k.fsf@t19.piap.pl>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 17 Oct 2017 09:33:08 -0200
Message-ID: <CAOMZO5A6PYfXz6T4ZTs7M3rtUZLKOjf636i-v6uCjxNfxETQyQ@mail.gmail.com>
Subject: Re: [PATCH][MEDIA]i.MX6 CSI: Fix MIPI camera operation in RAW/Bayer mode
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

On Tue, Oct 17, 2017 at 4:27 AM, Krzysztof Ha=C5=82asa <khalasa@piap.pl> wr=
ote:
> Without this fix, in 8-bit Y/Bayer mode, every other 8-byte group
> of pixels is lost.
> Not sure about possible side effects, though.
>
> Signed-off-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>
>
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -340,7 +340,7 @@ static int csi_idmac_setup_channel(struct csi_priv *p=
riv)
>         case V4L2_PIX_FMT_SGBRG8:
>         case V4L2_PIX_FMT_SGRBG8:
>         case V4L2_PIX_FMT_SRGGB8:
> -               burst_size =3D 8;
> +               burst_size =3D 16;
>                 passthrough =3D true;
>                 passthrough_bits =3D 8;
>                 break;

Russell has sent the same fix and Philipp made a comment about the
possibility of using 32-byte or 64-byte bursts:
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2017-Octo=
ber/111960.html
