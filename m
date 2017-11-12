Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:48988 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbdKLIis (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Nov 2017 03:38:48 -0500
Received: by mail-qt0-f195.google.com with SMTP id f8so16391872qta.5
        for <linux-media@vger.kernel.org>; Sun, 12 Nov 2017 00:38:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171111205527.g5dach2rmhlxmr5x@gofer.mess.org>
References: <20171023185750.5m5qo575myogzbhz@gofer.mess.org>
 <CACG2urzH5dAtnasGfjiK1Y8owGcsn0VtRSEWX75A6mb0pyuSRw@mail.gmail.com>
 <20171029193121.p2q6dxxz376cpx5y@gofer.mess.org> <CACG2urwdnXs2v8hv24R3+sNW6qOifh6Gtt+semez_c8QC58-gA@mail.gmail.com>
 <20171107084245.47dce306@vento.lan> <CACG2ury9Ab3pHGVyNLQeOH03TF3r_oeX1h3=AuJ5XzNgjx+yag@mail.gmail.com>
 <20171111105643.ozwukzmdhalxhoho@gofer.mess.org> <CACG2urwv1dTtEW5vuspTF5A3t2F1s-iRPZE5SiCt9o8k+k71hA@mail.gmail.com>
 <20171111180159.fb33mc2t467ygfqw@gofer.mess.org> <CACG2uryHHu-vvHj0B1wGRYZuczB5_8cbD3LBscaBmbN-LFJQMg@mail.gmail.com>
 <20171111205527.g5dach2rmhlxmr5x@gofer.mess.org>
From: Laurent Caumont <lcaumont2@gmail.com>
Date: Sun, 12 Nov 2017 09:38:47 +0100
Message-ID: <CACG2urxfW-O_AEhOKFApxxSdoSxJRkaTd1TNQ-6jNxouquB2fA@mail.gmail.com>
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

Thank you for the changes, It's better like this, I will test it.
Don't you think that a much better way would be to make the kalloc
directly inside dvb_usb_generic_rw instead of changing each call of
it? Are you sure there are no other mistake somewhere else ?

Laurent

2017-11-11 21:55 GMT+01:00 Sean Young <sean@mess.org>:
> Hi Laurant,
>
> On Sat, Nov 11, 2017 at 08:06:38PM +0100, Laurent Caumont wrote:
>> Hi Sean,
>>
>> I hope this one will be okay.
>
> There is a memory leak in there, and there is no reason to have to kmallocs
> for this function. Please would you mind testing this version?
>
> Please note that there were other issues like whitespace which I've fixed
> up.
>
> Thanks,
> Sean
> ----
> From 8362bc3e95016944b173c3866c103fcbc2587b6d Mon Sep 17 00:00:00 2001
> From: Laurent Caumont <lcaumont2@gmail.com>
> Date: Sat, 11 Nov 2017 18:44:46 +0100
> Subject: [PATCH] media: dvb: i2c transfers over usb cannot be done from stack
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Laurent Caumont <lcaumont2@gmail.com>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/usb/dvb-usb/dibusb-common.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
> index 8207e6900656..bcacb0f22028 100644
> --- a/drivers/media/usb/dvb-usb/dibusb-common.c
> +++ b/drivers/media/usb/dvb-usb/dibusb-common.c
> @@ -223,8 +223,20 @@ EXPORT_SYMBOL(dibusb_i2c_algo);
>
>  int dibusb_read_eeprom_byte(struct dvb_usb_device *d, u8 offs, u8 *val)
>  {
> -       u8 wbuf[1] = { offs };
> -       return dibusb_i2c_msg(d, 0x50, wbuf, 1, val, 1);
> +       u8 *buf;
> +       int rc;
> +
> +       buf = kmalloc(2, GFP_KERNEL);
> +       if (!buf)
> +               return -ENOMEM;
> +
> +       buf[0] = offs;
> +
> +       rc = dibusb_i2c_msg(d, 0x50, &buf[0], 1, &buf[1], 1);
> +       *val = buf[1];
> +       kfree(buf);
> +
> +       return rc;
>  }
>  EXPORT_SYMBOL(dibusb_read_eeprom_byte);
>
> --
> 2.13.6
>
