Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36559 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752929AbdEJQSB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 12:18:01 -0400
Received: by mail-pf0-f170.google.com with SMTP id m17so154626pfg.3
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 09:18:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m3d1bhhwf3.fsf_-_@t19.piap.pl>
References: <590ADAB1.1040501@suntec.net> <m3h90thwjt.fsf@t19.piap.pl> <m3d1bhhwf3.fsf_-_@t19.piap.pl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Wed, 10 May 2017 13:18:00 -0300
Message-ID: <CAAEAJfBVOKBcZBg91EKHBXKMOkM6eRafe8=XnW8E=6vtn2dBmQ@mail.gmail.com>
Subject: Re: [PATCH] TW686x: Fix OOPS on buffer alloc failure
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: linux-media <linux-media@vger.kernel.org>,
        zhaoxuegang <zhaoxuegang@suntec.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

On 10 May 2017 at 06:51, Krzysztof Ha=C5=82asa <khalasa@piap.pl> wrote:
> Signed-off-by: Krzysztof Ha=C5=82asa <khalasa@piap.pl>
>
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/=
tw686x/tw686x-video.c
> index c3fafa9..d637f47 100644
> --- a/drivers/media/pci/tw686x/tw686x-video.c
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -1190,6 +1190,13 @@ int tw686x_video_init(struct tw686x_dev *dev)
>                         return err;
>         }
>
> +       /* Initialize vc->dev and vc->ch for the error path first */
> +       for (ch =3D 0; ch < max_channels(dev); ch++) {
> +               struct tw686x_video_channel *vc =3D &dev->video_channels[=
ch];
> +               vc->dev =3D dev;
> +               vc->ch =3D ch;
> +       }
> +

I'm not sure where is the oops this commit fixes, care to explain it to me?

>         for (ch =3D 0; ch < max_channels(dev); ch++) {
>                 struct tw686x_video_channel *vc =3D &dev->video_channels[=
ch];
>                 struct video_device *vdev;
> @@ -1198,9 +1205,6 @@ int tw686x_video_init(struct tw686x_dev *dev)
>                 spin_lock_init(&vc->qlock);
>                 INIT_LIST_HEAD(&vc->vidq_queued);
>
> -               vc->dev =3D dev;
> -               vc->ch =3D ch;
> -
>                 /* default settings */
>                 err =3D tw686x_set_standard(vc, V4L2_STD_NTSC);
>                 if (err)

Thanks,
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
