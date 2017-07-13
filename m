Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33121 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbdGMHeE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 03:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <20170712191737.umbzyw6osz76yv3c@yves>
References: <20170712191737.umbzyw6osz76yv3c@yves>
From: Frans Klaver <fransklaver@gmail.com>
Date: Thu, 13 Jul 2017 09:06:55 +0200
Message-ID: <CAH6sp9MPi4yK6V7R+uiSoTea09GZA2Weom9Ay1mx2cvR3yLabA@mail.gmail.com>
Subject: Re: [PATCH v2] [media] lirc_zilog: Clean up lirc zilog error codes
To: =?UTF-8?Q?Yves_Lem=C3=A9e?= <yves.lemee.kernel@gmail.com>
Cc: mchehab@kernel.org, driverdevel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Almost there on the subject. Stuff between brackets is removed by git,
so you should rather use something like

[PATCH v2] staging: lirc: Clean up zilog error codes

On Wed, Jul 12, 2017 at 9:17 PM, Yves Lem=C3=A9e <yves.lemee.kernel@gmail.c=
om> wrote:
> According the coding style guidelines, the ENOSYS error code must be retu=
rned
> in case of a non existent system call. This code has been replaced with
> the ENOTTY error code indicating a missing functionality.
>
> v2: Improved punctuation
>     Fixed patch subject

This change info goes below the --- line and just above the diffstat.


> Signed-off-by: Yves Lem=C3=A9e <yves.lemee.kernel@gmail.com>
> ---
>  drivers/staging/media/lirc/lirc_zilog.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/me=
dia/lirc/lirc_zilog.c
> index 015e41bd036e..26dd32d5b5b2 100644
> --- a/drivers/staging/media/lirc/lirc_zilog.c
> +++ b/drivers/staging/media/lirc/lirc_zilog.c
> @@ -1249,7 +1249,7 @@ static long ioctl(struct file *filep, unsigned int =
cmd, unsigned long arg)
>                 break;
>         case LIRC_GET_REC_MODE:
>                 if (!(features & LIRC_CAN_REC_MASK))
> -                       return -ENOSYS;
> +                       return -ENOTTY;
>
>                 result =3D put_user(LIRC_REC2MODE
>                                   (features & LIRC_CAN_REC_MASK),
> @@ -1257,21 +1257,21 @@ static long ioctl(struct file *filep, unsigned in=
t cmd, unsigned long arg)
>                 break;
>         case LIRC_SET_REC_MODE:
>                 if (!(features & LIRC_CAN_REC_MASK))
> -                       return -ENOSYS;
> +                       return -ENOTTY;
>
>                 result =3D get_user(mode, uptr);
>                 if (!result && !(LIRC_MODE2REC(mode) & features))
> -                       result =3D -EINVAL;
> +                       result =3D -ENOTTY;
>                 break;
>         case LIRC_GET_SEND_MODE:
>                 if (!(features & LIRC_CAN_SEND_MASK))
> -                       return -ENOSYS;
> +                       return -ENOTTY;
>
>                 result =3D put_user(LIRC_MODE_PULSE, uptr);
>                 break;
>         case LIRC_SET_SEND_MODE:
>                 if (!(features & LIRC_CAN_SEND_MASK))
> -                       return -ENOSYS;
> +                       return -ENOTTY;
>
>                 result =3D get_user(mode, uptr);
>                 if (!result && mode !=3D LIRC_MODE_PULSE)
> --
> 2.13.2
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
