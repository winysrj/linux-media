Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34119 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2HHEQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2012 00:16:44 -0400
Received: by eeil10 with SMTP id l10so74322eei.19
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2012 21:16:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344380196-9488-2-git-send-email-crope@iki.fi>
References: <1344380196-9488-1-git-send-email-crope@iki.fi>
	<1344380196-9488-2-git-send-email-crope@iki.fi>
Date: Wed, 8 Aug 2012 07:16:43 +0300
Message-ID: <CAHp75Vd=EiGvgWh=t22DTOx0=3x8EjC2wbcgXKba56YtSr22_w@mail.gmail.com>
Subject: Re: [PATCH 2/2] dvb_usb_v2: use %*ph to dump usb xfer debugs
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 8, 2012 at 1:56 AM, Antti Palosaari <crope@iki.fi> wrote:
> diff --git a/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c b/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
> index 5f5bdd0..0431bee 100644
> --- a/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c
> +++ b/drivers/media/dvb/dvb-usb-v2/dvb_usb_urb.c

> @@ -37,10 +36,8 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
>         if (ret < 0)
>                 return ret;
>
> -#ifdef DVB_USB_XFER_DEBUG
> -       print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": >>> ", DUMP_PREFIX_NONE,
> -                       32, 1, wbuf, wlen, 0);
> -#endif
> +       dev_dbg(&d->udev->dev, "%s: >>> %*ph\n", __func__, wlen, wbuf);
> +
>         ret = usb_bulk_msg(d->udev, usb_sndbulkpipe(d->udev,
>                         d->props->generic_bulk_ctrl_endpoint), wbuf, wlen,
>                         &actual_length, 2000);
> @@ -64,11 +61,8 @@ int dvb_usbv2_generic_rw(struct dvb_usb_device *d, u8 *wbuf, u16 wlen, u8 *rbuf,
>                         dev_err(&d->udev->dev, "%s: 2nd usb_bulk_msg() " \
>                                         "failed=%d\n", KBUILD_MODNAME, ret);
>
> -#ifdef DVB_USB_XFER_DEBUG
> -               print_hex_dump(KERN_DEBUG, KBUILD_MODNAME ": <<< ",
> -                               DUMP_PREFIX_NONE, 32, 1, rbuf, actual_length,
> -                               0);
> -#endif
> +               dev_dbg(&d->udev->dev, "%s: <<< %*ph\n", __func__,
> +                               actual_length, rbuf);
>         }
>
Antti, I didn't check how long buffer could be in above cases, but be
aware that %*ph prints up to 64 bytes only. Is it enough here?

-- 
With Best Regards,
Andy Shevchenko
