Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40643 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaADR6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 12:58:50 -0500
MIME-Version: 1.0
In-Reply-To: <1388833760-23260-1-git-send-email-m.chehab@samsung.com>
References: <1388833760-23260-1-git-send-email-m.chehab@samsung.com>
Date: Sat, 4 Jan 2014 18:58:49 +0100
Message-ID: <CA+O4pC+w7PCrMN-MHexfER79ovR+6hHGppLy0929UjjckUUCmQ@mail.gmail.com>
Subject: Re: [PATCH v4 RFC 1/2] [media] em28xx: retry I2C write ops if failed
 by timeout
From: Markus Rechberger <mrechberger@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	USB list <linux-usb@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Did you trace the i2c messages on the bus? This seems like papering
the actual bug.

USB 3.0 is a disaster with Linux, maybe your hardware or your
controller driver is not okay?
There are other bugreports out there which are USB 3.0 related, some
of our customers reported that since 3.6.0 is okay while 3.7.10 give
them a complete system lock up also with the driver in question here.


On Sat, Jan 4, 2014 at 12:09 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> At least on HVR-950, sometimes an I2C operation fails.
>
> This seems to be more frequent when the device is connected
> into an USB 3.0 port.
>
> Instead of report an error, try to repeat it, for up to
> 20 ms. That makes the code more reliable.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-i2c.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
> index 6cd3d909bb3a..35d6808aa9ff 100644
> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
> @@ -189,6 +189,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>          * Zero length reads always succeed, even if no device is connected
>          */
>
> +retry:
>         /* Write to i2c device */
>         ret = dev->em28xx_write_regs_req(dev, stop ? 2 : 3, addr, buf, len);
>         if (ret != len) {
> @@ -208,26 +209,24 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
>                 ret = dev->em28xx_read_reg(dev, 0x05);
>                 if (ret == 0) /* success */
>                         return len;
> -               if (ret == 0x10) {
> -                       em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> -                                   addr);
> -                       return -EREMOTEIO;
> -               }
> +               if (ret == 0x10)
> +                       goto retry;
>                 if (ret < 0) {
>                         em28xx_warn("failed to get i2c transfer status from bridge register (error=%i)\n",
>                                     ret);
>                         return ret;
>                 }
>                 msleep(5);
> -               /*
> -                * NOTE: do we really have to wait for success ?
> -                * Never seen anything else than 0x00 or 0x10
> -                * (even with high payload) ...
> -                */
>         }
>
> -       if (i2c_debug)
> -               em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
> +       if (ret == 0x10) {
> +               if (i2c_debug)
> +                       em28xx_warn("I2C transfer timeout on writing to addr 0x%02x",
> +                                   addr);
> +       } else {
> +               em28xx_warn("write to i2c device at 0x%x timed out (ret=0x%02x)\n",
> +                           addr, ret);
> +       }
>         return -EREMOTEIO;
>  }
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
