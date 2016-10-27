Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38676 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933792AbcJ0SJN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 14:09:13 -0400
Received: by mail-wm0-f52.google.com with SMTP id n67so64135956wme.1
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 11:09:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161027091005.GA21534@arch-desktop>
References: <20161027091005.GA21534@arch-desktop>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Thu, 27 Oct 2016 09:38:15 -0300
Message-ID: <CAAEAJfDBZjn_bLTTq8ycORwN+zzmEKekM-2611ODDAEbyyfSNQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] stk1160: Remove VIDEO_STK1160_AC97 and SND_AC97_CODEC
 from Kconfig and Makefile.
To: Marcel Hasler <mahasler@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marcel,

Thanks a lot for all your stk1160 fixes. They are much appreciated! In
particular,
the click noise was something we really wanted to get rid of:

http://mailman.alsa-project.org/pipermail/alsa-devel/2016-October/113981.ht=
ml

Regarding the linux-media fixes, is there any chance you re-submit
this set of patches, in way that they are properly numbered
PATCH 1, PATCH 2, PATCH 3...

git-format-patch is able to do that for you automatically.

You may also include a cover letter (it's optional) to explain
what stuff you are fixing, how you tested, where are the patches
based, and anything else you want to mention.

(And don't forget to Cc the media mailing list)

Thanks again!
Ezequiel

On 27 October 2016 at 06:10, Marcel Hasler <mahasler@gmail.com> wrote:
> The VIDEO_STK1160_AC97 option is no longer needed after the removal of st=
k1160-mixer. For the
> same reason SND and SND_AC97_CODEC are no longer required.
>
> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
> ---
>  drivers/media/usb/stk1160/Kconfig  | 3 +--
>  drivers/media/usb/stk1160/Makefile | 4 +---
>  2 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/usb/stk1160/Kconfig b/drivers/media/usb/stk116=
0/Kconfig
> index 53617da..22dff4f 100644
> --- a/drivers/media/usb/stk1160/Kconfig
> +++ b/drivers/media/usb/stk1160/Kconfig
> @@ -10,8 +10,7 @@ config VIDEO_STK1160_COMMON
>
>  config VIDEO_STK1160
>         tristate
> -       depends on (!VIDEO_STK1160_AC97 || (SND=3D'n') || SND) && VIDEO_S=
TK1160_COMMON
> +       depends on VIDEO_STK1160_COMMON
>         default y
>         select VIDEOBUF2_VMALLOC
>         select VIDEO_SAA711X
> -       select SND_AC97_CODEC if SND
> diff --git a/drivers/media/usb/stk1160/Makefile b/drivers/media/usb/stk11=
60/Makefile
> index dfe3e90..42d0546 100644
> --- a/drivers/media/usb/stk1160/Makefile
> +++ b/drivers/media/usb/stk1160/Makefile
> @@ -1,10 +1,8 @@
> -obj-stk1160-ac97-$(CONFIG_VIDEO_STK1160_AC97) :=3D stk1160-ac97.o
> -
>  stk1160-y :=3D   stk1160-core.o \
>                 stk1160-v4l.o \
>                 stk1160-video.o \
>                 stk1160-i2c.o \
> -               $(obj-stk1160-ac97-y)
> +               stk1160-ac97.o
>
>  obj-$(CONFIG_VIDEO_STK1160) +=3D stk1160.o
>
> --
> 2.10.1
>



--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
