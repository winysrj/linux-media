Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34192 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbcKGP3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 10:29:16 -0500
Received: by mail-it0-f66.google.com with SMTP id q124so9930683itd.1
        for <linux-media@vger.kernel.org>; Mon, 07 Nov 2016 07:29:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <65d65d048e6fa6964ccf679f400b964afac5d782.1478523166.git.mchehab@s-opensource.com>
References: <65d65d048e6fa6964ccf679f400b964afac5d782.1478523166.git.mchehab@s-opensource.com>
From: VDR User <user.vdr@gmail.com>
Date: Mon, 7 Nov 2016 07:28:26 -0800
Message-ID: <CAA7C2qjGp2gM=KxbpOvRzfabQ5T9-BuG9U2MWbBvKOKV64-rJA@mail.gmail.com>
Subject: Re: [PATCH] [media] gp8psk: fix gp8psk_usb_in_op() logic
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 7, 2016 at 4:52 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Changeset bc29131ecb10 ("[media] gp8psk: don't do DMA on stack")
> fixed the usage of DMA on stack, but the memcpy was wrong
> for gp8psk_usb_in_op(). Fix it.
>
> Suggested-by: Johannes Stezenbach <js@linuxtv.org>
> Fixes: bc29131ecb10 ("[media] gp8psk: don't do DMA on stack")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Fix confirmed using 2 different Skywalker models with HD mpeg4, SD mpeg2.

Tested-by: <user.vdr@gmail.com>

> ---
>  drivers/media/usb/dvb-usb/gp8psk.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
> index adfd76491451..2829e3082d15 100644
> --- a/drivers/media/usb/dvb-usb/gp8psk.c
> +++ b/drivers/media/usb/dvb-usb/gp8psk.c
> @@ -67,7 +67,6 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
>                 return ret;
>
>         while (ret >= 0 && ret != blen && try < 3) {
> -               memcpy(st->data, b, blen);
>                 ret = usb_control_msg(d->udev,
>                         usb_rcvctrlpipe(d->udev,0),
>                         req,
> @@ -81,8 +80,10 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
>         if (ret < 0 || ret != blen) {
>                 warn("usb in %d operation failed.", req);
>                 ret = -EIO;
> -       } else
> +       } else {
>                 ret = 0;
> +               memcpy(b, st->data, blen);
> +       }
>
>         deb_xfer("in: req. %x, val: %x, ind: %x, buffer: ",req,value,index);
>         debug_dump(b,blen,deb_xfer);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
