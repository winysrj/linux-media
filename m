Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35226 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751530AbdHPOve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 10:51:34 -0400
MIME-Version: 1.0
In-Reply-To: <20170718102339.28726-2-wsa+renesas@sang-engineering.com>
References: <20170718102339.28726-1-wsa+renesas@sang-engineering.com> <20170718102339.28726-2-wsa+renesas@sang-engineering.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 16 Aug 2017 16:51:33 +0200
Message-ID: <CAMuHMdUiVH5FarZLaJ=_aon2LOApoTgH6aZomjS3BgcdCcPY7Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] i2c: add helpers to ease DMA handling
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

On Tue, Jul 18, 2017 at 12:23 PM, Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> One helper checks if DMA is suitable and optionally creates a bounce
> buffer, if not. The other function returns the bounce buffer and makes
> sure the data is properly copied back to the message.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
> Changes since v2:
>
> * rebased to v4.13-rc1
> * helper functions are not inlined anymore but moved to i2c core
> * __must_check has been added to the buffer check helper
> * the release function has been renamed to contain 'dma' as well

Right:

drivers/i2c/i2c-core-base.c:2310:15: error: 'i2c_release_bounce_buf'
undeclared here (not in a function)
 EXPORT_SYMBOL_GPL(i2c_release_bounce_buf);

> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c

> +/**
> + * i2c_release_bounce_buf - copy data back from bounce buffer and release it
      ^^^^^^^^^^^^^^^^^^^^^^
> + * @msg: the message to be copied back to
> + * @bounce_buf: the bounce buffer obtained from i2c_check_msg_for_dma().
> + *             May be NULL.
> + */
> +void i2c_release_dma_bounce_buf(struct i2c_msg *msg, u8 *bounce_buf)
> +{
> +       if (!bounce_buf)
> +               return;
> +
> +       if (msg->flags & I2C_M_RD)
> +               memcpy(msg->buf, bounce_buf, msg->len);
> +
> +       kfree(bounce_buf);
> +}
> +EXPORT_SYMBOL_GPL(i2c_release_bounce_buf);
                     ^^^^^^^^^^^^^^^^^^^^^^

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
