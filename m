Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f44.google.com ([209.85.208.44]:33765 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbeIDVtf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 17:49:35 -0400
Received: by mail-ed1-f44.google.com with SMTP id d8-v6so3916757edv.0
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 10:23:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1534328897-14957-2-git-send-email-jacopo+renesas@jmondi.org>
References: <1534328897-14957-1-git-send-email-jacopo+renesas@jmondi.org> <1534328897-14957-2-git-send-email-jacopo+renesas@jmondi.org>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Tue, 4 Sep 2018 19:22:50 +0200
Message-ID: <CAMZdPi8gr0p4GogZaj7Lyf1aJF_+xp1gfBfhh7R4S=7eNoR2TQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] media: ov5640: Re-work MIPI startup sequence
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sam Bobrowicz <sam@elite-embedded.com>,
        Jagan Teki <jagan@amarulasolutions.com>,
        Fabio Estevam <festevam@gmail.com>, pza@pengutronix.de,
        steve_longerbeam@mentor.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Daniel Mack <daniel@zonque.org>, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

> -       ret = ov5640_mod_reg(sensor, OV5640_REG_MIPI_CTRL00, BIT(5),
> -                            on ? 0 : BIT(5));
> -       if (ret)
> -               return ret;
> -       ret = ov5640_write_reg(sensor, OV5640_REG_PAD_OUTPUT00,
> -                              on ? 0x00 : 0x70);
> +       /*
> +        * Enable/disable the MIPI interface
> +        *
> +        * 0x300e = on ? 0x45 : 0x40
> +        * [7:5] = 001  : 2 data lanes mode

Does 2-Lanes work with this config?
AFAIU, if 2-Lanes is bit 5, value should be 0x25 and 0x20.

> +        * [4] = 0      : Power up MIPI HS Tx
> +        * [3] = 0      : Power up MIPI LS Rx
> +        * [2] = 1/0    : MIPI interface enable/disable
> +        * [1:0] = 01/00: FIXME: 'debug'
> +        */
> +       ret = ov5640_write_reg(sensor, OV5640_REG_IO_MIPI_CTRL00,
> +                              on ? 0x45 : 0x40);

Regards,
Loic
