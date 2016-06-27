Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38243 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbcF0Ppl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 11:45:41 -0400
Received: by mail-wm0-f49.google.com with SMTP id r201so121294838wme.1
        for <linux-media@vger.kernel.org>; Mon, 27 Jun 2016 08:45:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <527358bfde61acf7ac1a6e5bfc737f5645ba05a7.1461770668.git.mchehab@osg.samsung.com>
References: <a3c0afb9b600b5284d6643bc165241eb1b81cdf6.1461770188.git.mchehab@osg.samsung.com>
 <527358bfde61acf7ac1a6e5bfc737f5645ba05a7.1461770668.git.mchehab@osg.samsung.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Mon, 27 Jun 2016 12:45:38 -0300
Message-ID: <CAAEAJfD=kGG1+3zBS8A+PvVTEBva_Bw-ipNWGORGRnD1ttaqKg@mail.gmail.com>
Subject: Re: [PATCH v3] tw686x: use a formula instead of two tables for div
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks a lot for the patch.

On 27 April 2016 at 12:27, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Instead of using two tables to estimate the temporal decimation
> factor, use a formula. This allows to get the closest fps, with
> sounds better than the current tables.
>
> Compile-tested only.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> [media] tw686x: cleanup the fps estimation code
>
> There are some issues with the old code:
>         1) it uses two static tables;
>         2) some values for 50Hz standards are wrong;
>         3) it doesn't store the real framerate.
>
> This patch fixes the above issues.
>
> Compile-tested only.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> -
>
> v3: Patch v2 were actually a diff patch against PATCH v1. Fold the two patches in one.
>
> PS.: With this patch, it should be easy to add support for
> VIDIOC_G_PARM and VIDIOC_S_PARM, as vc->fps will now store the
> real frame rate, with should be used when returning from those
> functions.
>
> ---
>  drivers/media/pci/tw686x/tw686x-video.c | 110 +++++++++++++++++++++-----------
>  1 file changed, 73 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> index 253e10823ba3..b247a7b4ddd8 100644
> --- a/drivers/media/pci/tw686x/tw686x-video.c
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -43,53 +43,89 @@ static const struct tw686x_format formats[] = {
>         }
>  };
>
> -static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
> +static const unsigned int fps_map[15] = {
> +       /*
> +        * bit 31 enables selecting the field control register
> +        * bits 0-29 are a bitmask with fields that will be output.
> +        * For NTSC (and PAL-M, PAL-60), all 30 bits are used.
> +        * For other PAL standards, only the first 25 bits are used.
> +        */

I ran a few tests and it worked perfectly fine for 60Hz standards.
For 50Hz standards, or at least for PAL-Nc, it didn't
work so well, and the real FPS was too different from the requested
one. I need to look into it some more.

> +       0x00000000, /* output all fields */
> +       0x80000006, /* 2 fps (60Hz), 2 fps (50Hz) */
> +       0x80018006, /* 4 fps (60Hz), 4 fps (50Hz) */
> +       0x80618006, /* 6 fps (60Hz), 6 fps (50Hz) */
> +       0x81818186, /* 8 fps (60Hz), 8 fps (50Hz) */
> +       0x86186186, /* 10 fps (60Hz), 8 fps (50Hz) */
> +       0x86619866, /* 12 fps (60Hz), 10 fps (50Hz) */
> +       0x86666666, /* 14 fps (60Hz), 12 fps (50Hz) */
> +       0x9999999e, /* 16 fps (60Hz), 14 fps (50Hz) */
> +       0x99e6799e, /* 18 fps (60Hz), 16 fps (50Hz) */
> +       0x9e79e79e, /* 20 fps (60Hz), 16 fps (50Hz) */
> +       0x9e7e7e7e, /* 22 fps (60Hz), 18 fps (50Hz) */
> +       0x9fe7f9fe, /* 24 fps (60Hz), 20 fps (50Hz) */
> +       0x9ffe7ffe, /* 26 fps (60Hz), 22 fps (50Hz) */
> +       0x9ffffffe, /* 28 fps (60Hz), 24 fps (50Hz) */

Why this particular selection of fps values and bits set in each case?
Is it arbitrary?

> +};
> +
> +static unsigned int tw686x_real_fps(unsigned int index, unsigned int max_fps)
> +{
> +       unsigned int i, bits, c = 0;
> +
> +       if (!index || index >= ARRAY_SIZE(fps_map))
> +               return max_fps;
> +
> +       bits = fps_map[index];
> +       for (i = 0; i < max_fps; i++)
> +               if ((1 << i) & bits)
> +                       c++;
> +

We can use hweight_long here to count the number of bits set.
If you are OK with it, I can rework the patch and submit a new version.
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
