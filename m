Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34031 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0ECINr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 May 2010 04:13:47 -0400
Received: by gyg13 with SMTP id 13so1004676gyg.19
        for <linux-media@vger.kernel.org>; Mon, 03 May 2010 01:13:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BDE7DB4.7030706@redhat.com>
References: <4BDE7DB4.7030706@redhat.com>
Date: Mon, 3 May 2010 16:13:46 +0800
Message-ID: <k2y6e8e83e21005030113v64aea6c0q87754a5d8f04d2d4@mail.gmail.com>
Subject: Re: [PATCH] Fix colorspace on tm6010
From: Bee Hock Goh <beehock@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lot of good changes to tm6000. Unfortunately, I am not able to test
any of this at the moment. Git not working for me anymore as 2.6.33
insist to freeze my machine on boot.

Reverting to hg does not work as well after my upgrade to lucid. :)

Apparently, its now complain about invalid module format.

if everything work out again, I would like to try and get the audio working.


On Mon, May 3, 2010 at 3:39 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The enclosed patch fixes the color format on tm6010. What happened is that the patch
> adding fourcc control on tm6010 had one small cut-and-paste trouble: it was
> changing the wrong register ;)
>
> I've fixed it. So, now, colors are working fine. I'll be applying it at my git. This
> way, the current git contains a tm6000 code that is not so bad.
>
> With this patch, analog video on tm6000/tm6010 are working again (but see the
> patch comments bellow). Yet, there are a large number of TODO items for this driver:
> - Fix the loss of some blocks when receiving the URB's;
> - Add a lock at tm6000_read_write_usb() to prevent two simultaneous access to the
> URB control transfers;
> - Properly add the locks at tm6000-video;
> - Add audio support;
> - Add IR support;
> - Do several cleanups;
> - I think that frame1/frame0 are inverted. This causes a funny effect at the image.
>  the fix is trivial, but require some tests.
> - My tm6010 devices sometimes insist on stop working. I need to turn them off, removing
>  from my machine and wait for a while for it to work again. I'm starting to think that
>  it is an overheat issue;
> - Sometimes, tm6010 doesn't read eeprom at the proper time (hardware bug). So, the device
>  got miss-detected as a "generic" tm6000. This can be really bad if the tuner is the
>  Low Power one, as it may result on loading the high power firmware, that could damage
>  the device. Maybe we may read eeprom to double check, when the device is marked as "generic".
> - Coding Style fixes;
>
> I'll be committing a patch with the above TODO items at tm6000/README
>
> (Bee/Stefan/Dmitri, feel free to add more things at the todo - We need to write a README file
>
> The lack of locks still generate some OOPS'es, but I was not able of get any Panic. So,
> I'll likely add it at upstream drivers/staging at the next merge window.
>
> --
>
> Cheers,
> Mauro
>
>
> commit c621ed883a26dc705c38ad698f6a19a6260f172f
> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:   Mon May 3 04:25:59 2010 -0300
>
>    V4L/DVB: Fix color format with tm6010
>
>    The values for the fourcc format were correct, but applied to the
>    wrong register. With this change, video is now barely working again with
>    tm6000.
>
>    While here, let's remove, for now, the memset. This way, people can
>    have some image when testing this device.
>
>    Yet to be fixed: parts of the image frame are missed. As we don't clean
>    the buffers anymore, this is "recovered" by repeating the values from a
>    previous frame. The quality is bad, since the image pixels will contain
>    data from some previous frames, generating weird delay artifacts.
>
>    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index 860553f..bfbc53b 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -156,10 +156,13 @@ int tm6000_get_reg32 (struct tm6000_core *dev, u8 req, u16 value, u16 index)
>  void tm6000_set_fourcc_format(struct tm6000_core *dev)
>  {
>        if (dev->dev_type == TM6010) {
> +               int val;
> +
> +               val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0) & 0xfc;
>                if (dev->fourcc == V4L2_PIX_FMT_UYVY)
> -                       tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
> +                       tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
>                else
> -                       tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0x90);
> +                       tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val | 1);
>        } else {
>                if (dev->fourcc == V4L2_PIX_FMT_UYVY)
>                        tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index 4444487..9554472 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -149,8 +149,8 @@ static inline void get_next_buf(struct tm6000_dmaqueue *dma_q,
>
>        /* Cleans up buffer - Usefull for testing for frame/URB loss */
>        outp = videobuf_to_vmalloc(&(*buf)->vb);
> -       if (outp)
> -               memset(outp, 0, (*buf)->vb.size);
> +//     if (outp)
> +//             memset(outp, 0, (*buf)->vb.size);
>
>        return;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
