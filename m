Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34100 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751158AbeBWBGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 20:06:18 -0500
MIME-Version: 1.0
In-Reply-To: <45c87e6b-9e01-eb5c-3c47-5aa6dcabb004@users.sourceforge.net>
References: <45c87e6b-9e01-eb5c-3c47-5aa6dcabb004@users.sourceforge.net>
From: Alexey Klimov <klimov.linux@gmail.com>
Date: Fri, 23 Feb 2018 01:06:16 +0000
Message-ID: <CALW4P+J4tf377puAGJRQK1rXgWzxRBLjLkBb4RuBTq6Z4hwAyw@mail.gmail.com>
Subject: Re: [PATCH v2] [media] Delete unnecessary variable initialisations in
 seven functions
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Linux Media <linux-media@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Romain Reignier <r.reignier@robopec.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Sean Young <sean@mess.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 22, 2018 at 9:22 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 22 Feb 2018 21:45:47 +0100
>
> Some local variables will be set to an appropriate value before usage.
> Thus omit explicit initialisations at the beginning of these functions.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>
> v2:
> Hans Verkuil insisted on patch squashing. Thus some changes
> were recombined based on source files from Linux next-20180216.
>
>  drivers/media/radio/radio-mr800.c             | 2 +-

For radio-mr800:

Acked-by: Alexey Klimov <klimov.linux@gmail.com>

>  drivers/media/radio/radio-wl1273.c            | 2 +-
>  drivers/media/radio/si470x/radio-si470x-usb.c | 2 +-
>  drivers/media/usb/cx231xx/cx231xx-cards.c     | 2 +-
>  drivers/media/usb/cx231xx/cx231xx-dvb.c       | 2 +-
>  drivers/media/usb/go7007/snd-go7007.c         | 2 +-
>  drivers/media/usb/tm6000/tm6000-cards.c       | 2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
> index dc6c4f985911..0f292c6ba338 100644
> --- a/drivers/media/radio/radio-mr800.c
> +++ b/drivers/media/radio/radio-mr800.c
> @@ -511,5 +511,5 @@ static int usb_amradio_probe(struct usb_interface *intf,
>                                 const struct usb_device_id *id)
>  {
>         struct amradio_device *radio;
> -       int retval = 0;
> +       int retval;
>
> diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c

[..]

Thanks!
Alexey
