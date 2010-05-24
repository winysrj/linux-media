Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49600 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab0EXOfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 10:35:34 -0400
MIME-Version: 1.0
In-Reply-To: <1274698635-19512-2-git-send-email-daniel@caiaq.de>
References: <AANLkTikffmoWofbIo2h6zw-VW5aKEH8T_b0vMfKdo3KJ@mail.gmail.com>
	 <1274698635-19512-2-git-send-email-daniel@caiaq.de>
Date: Mon, 24 May 2010 10:35:32 -0400
Message-ID: <AANLkTimSMLPf697B831bEyiSaeKgcOlKPmnu-0EXuqtX@mail.gmail.com>
Subject: Re: [PATCH 2/2] drivers/media/dvb/dvb-usb/dib0700: CodingStyle fixes
From: David Ellingsworth <david@identd.dyndns.org>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

See comments below:

On Mon, May 24, 2010 at 6:57 AM, Daniel Mack <daniel@caiaq.de> wrote:

<snip />
> @@ -106,28 +106,29 @@ int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen
>  int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_dir, u8 gpio_val)
>  {
>        u8 buf[3] = { REQUEST_SET_GPIO, gpio, ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6) };
> -       return dib0700_ctrl_wr(d,buf,3);
> +       return dib0700_ctrl_wr(d, buf, sizeof(buf));
>  }
>
>  static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
>  {
> -    struct dib0700_state *st = d->priv;
> -    u8 b[3];
> -    int ret;
> -
> -    if (st->fw_version >= 0x10201) {
> -       b[0] = REQUEST_SET_USB_XFER_LEN;
> -       b[1] = (nb_ts_packets >> 8)&0xff;
> -       b[2] = nb_ts_packets & 0xff;
> -
> -       deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
> -
> -       ret = dib0700_ctrl_wr(d, b, 3);
> -    } else {
> -       deb_info("this firmware does not allow to change the USB xfer len\n");
> -       ret = -EIO;
> -    }
> -    return ret;
> +       struct dib0700_state *st = d->priv;
> +       u8 b[3];
> +       int ret;
> +
> +       if (st->fw_version >= 0x10201) {
> +               b[0] = REQUEST_SET_USB_XFER_LEN;
> +               b[1] = (nb_ts_packets >> 8) & 0xff;
> +               b[2] = nb_ts_packets & 0xff;
> +
> +               deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
> +
> +               ret = dib0700_ctrl_wr(d, b, 3);

sizeof(b) would be better than the hard-coded value of 3 above.

> +       } else {
> +               deb_info("this firmware does not allow to change the USB xfer len\n");
> +               ret = -EIO;
> +       }
> +
> +       return ret;
>  }
>
>  /*
<snip />

Everything else looks good.

Regards,

David Ellingsworth
