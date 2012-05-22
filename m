Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48497 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2EVMiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 08:38:55 -0400
Received: by vcbf11 with SMTP id f11so506563vcb.19
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 05:38:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1SW6Oa-00026y-9q@www.linuxtv.org>
References: <E1SW6Oa-00026y-9q@www.linuxtv.org>
Date: Tue, 22 May 2012 08:38:53 -0400
Message-ID: <CAOcJUbw9uxkaE19k03T+0oKBq7ftj4LjfMb4ROtHB5E2B1n8Zg@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v3.5] [media] au0828: Add USB ID used by many dongles
From: Michael Krufky <mkrufky@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: linuxtv-commits@linuxtv.org,
	Ismael Luceno <ismael.luceno@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm glad that we were able to add support for additional devices, but
this device is not in fact the "Hauppauge Woodbury" that it claims to
be -- I think it would be a better idea to copy the
AU0828_BOARD_HAUPPAUGE_WOODBURY configuration into a new structure,
rename it to something more appropriate, and use that instead.

-Mike

On Sun, May 20, 2012 at 9:30 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] au0828: Add USB ID used by many dongles
> Author:  Ismael Luceno <ismael.luceno@gmail.com>
> Date:    Fri May 11 02:14:51 2012 -0300
>
> Tested with Yfeng 680 ATV dongle.
>
> Signed-off-by: Ismael Luceno <ismael.luceno@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
>  drivers/media/video/au0828/au0828-cards.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=e2b710bfde37dcc5e5c55fe09e640c1a218a81a2
>
> diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
> index 1c6015a..e3fe9a6 100644
> --- a/drivers/media/video/au0828/au0828-cards.c
> +++ b/drivers/media/video/au0828/au0828-cards.c
> @@ -325,6 +325,8 @@ struct usb_device_id au0828_usb_id_table[] = {
>                .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
>        { USB_DEVICE(0x2040, 0x7281),
>                .driver_info = AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL },
> +       { USB_DEVICE(0x05e1, 0x0480),
> +               .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
>        { USB_DEVICE(0x2040, 0x8200),
>                .driver_info = AU0828_BOARD_HAUPPAUGE_WOODBURY },
>        { USB_DEVICE(0x2040, 0x7260),
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
