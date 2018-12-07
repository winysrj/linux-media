Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7F5C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8797920892
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 11:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="dv8A0j1Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8797920892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=amarulasolutions.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbeLGLZy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:25:54 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45455 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbeLGLZy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 06:25:54 -0500
Received: by mail-wr1-f68.google.com with SMTP id b14so3427748wru.12
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2018 03:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X87BwSfwpOAVWrhmNy0HsmeekdgkJntJ+VqX4INhcsA=;
        b=dv8A0j1YQnTW5sWOknHnFTQ0AnmSyf9pturhoNnrDajrR/7EMl4uLtwW3oc15VrMiz
         80JLZfPUdZVwWz3WY894eBQ6hTD2xgu2K42yFcyHtExQo0IMIvzCmzHLcN7gczauhzi3
         +S/4hp0pF6m6yJJzo16RVt8fv0SonVmB/9B+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X87BwSfwpOAVWrhmNy0HsmeekdgkJntJ+VqX4INhcsA=;
        b=GntNaId3k/ob5MeFOdxnZJ8PoMEMeoqoLXAokChk3CM4ps0ELE2z6TAJPJIHIDgjsR
         VzvalsojgjCmvtIli0aosT4Sn4hzlf8dvJAGv6C1beH+ZLrPbJ2irFQBTdAMHMMXLERB
         KLls64reIy7bkjdtdvRn5PxJxr1mfrHZglde8LI91KTMZug8XWUp+BF3UhDWTWPIhUVg
         Kq0L5T9S4LDlNlo38kRuS7CEo56hJ0zo56AfKOlEOu42fn5UzR1cWNljBpaU2PN5RQqE
         CiS7zhC+YCz7kxijEQn7AqOgq3lJv8sJItiEo08LqEijTrVvsMkVfAaNYzrxdcBvS5FM
         qjxA==
X-Gm-Message-State: AA+aEWYzfykAnwRIURa9Hg/bdHJV8Zi5uoOXjkfDNV+TxpsT9F1vj+YV
        rt3wA6MIMHRxirE0Ik4u/5LQ65z0+gi0e3tFAg4RX9GK
X-Google-Smtp-Source: AFSGD/WddUdtiOzAEUkxWl17ZisxQR3N+yWxvIyQ/encLtHkVdt3TO1UoDz5Qyl96QBwLC+l4oTTEKnKdyqhshgiAk8=
X-Received: by 2002:adf:8001:: with SMTP id 1mr1403206wrk.23.1544181951976;
 Fri, 07 Dec 2018 03:25:51 -0800 (PST)
MIME-Version: 1.0
References: <20181205154750.17996-5-pawel.mikolaj.chmiel@gmail.com> <231a4d80-4026-c17c-dfcc-80a304965391@xs4all.nl>
In-Reply-To: <231a4d80-4026-c17c-dfcc-80a304965391@xs4all.nl>
From:   Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date:   Fri, 7 Dec 2018 12:25:40 +0100
Message-ID: <CAOf5uwmXjYMdEj9SCtmem881Jm8YUzjUrjsZf9gjZ48RBdV7DQ@mail.gmail.com>
Subject: Re: [PATCH 4/5 RESEND] si470x-i2c: Add optional reset-gpio support
To:     hverkuil@xs4all.nl
Cc:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi

On Fri, Dec 7, 2018 at 12:12 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Subject: [PATCH 4/5] si470x-i2c: Add optional reset-gpio support
> Date: Wed,  5 Dec 2018 16:47:49 +0100
> From: Pawe=C5=82 Chmiel <pawel.mikolaj.chmiel@gmail.com>
> To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com
> CC: hverkuil@xs4all.nl, fischerdouglasc@gmail.com, keescook@chromium.org,=
 linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
> devicetree@vger.kernel.org, Pawe=C5=82 Chmiel <pawel.mikolaj.chmiel@gmail=
.com>
>
> If reset-gpio is defined, use it to bring device out of reset.
> Without this, it's not possible to access si470x registers.
>
> Signed-off-by: Pawe=C5=82 Chmiel <pawel.mikolaj.chmiel@gmail.com>
> ---
> For some reason this patch was not picked up by patchwork. Resending to s=
ee if
> it is picked up now.
> ---
>  drivers/media/radio/si470x/radio-si470x-i2c.c | 15 +++++++++++++++
>  drivers/media/radio/si470x/radio-si470x.h     |  1 +
>  2 files changed, 16 insertions(+)
>
> diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/medi=
a/radio/si470x/radio-si470x-i2c.c
> index a7ac09c55188..15eea2b2c90f 100644
> --- a/drivers/media/radio/si470x/radio-si470x-i2c.c
> +++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
> @@ -28,6 +28,7 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/interrupt.h>
>   #include "radio-si470x.h"
> @@ -392,6 +393,17 @@ static int si470x_i2c_probe(struct i2c_client *clien=
t,
>         radio->videodev.release =3D video_device_release_empty;
>         video_set_drvdata(&radio->videodev, radio);
>  +      radio->gpio_reset =3D devm_gpiod_get_optional(&client->dev, "rese=
t",
> +                                                   GPIOD_OUT_LOW);
> +       if (IS_ERR(radio->gpio_reset)) {
> +               retval =3D PTR_ERR(radio->gpio_reset);
> +               dev_err(&client->dev, "Failed to request gpio: %d\n", ret=
val);
> +               goto err_all;
> +       }
> +
> +       if (radio->gpio_reset)
> +               gpiod_set_value(radio->gpio_reset, 1);
> +
>         /* power up : need 110ms */
>         radio->registers[POWERCFG] =3D POWERCFG_ENABLE;
>         if (si470x_set_register(radio, POWERCFG) < 0) {
> @@ -478,6 +490,9 @@ static int si470x_i2c_remove(struct i2c_client *clien=
t)
>         video_unregister_device(&radio->videodev);
>  +      if (radio->gpio_reset)
> +               gpiod_set_value(radio->gpio_reset, 0);

I have a question for you. If the gpio is the last of the bank
acquired for this cpu, when you put to 0, then the gpio will
be free on remove and the clock of the logic will be deactivated so I
think that you don't have any
garantee that the state will be 0

Michael

> +
>         return 0;
>  }
>  diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/r=
adio/si470x/radio-si470x.h
> index 35fa0f3bbdd2..6fd6a399cb77 100644
> --- a/drivers/media/radio/si470x/radio-si470x.h
> +++ b/drivers/media/radio/si470x/radio-si470x.h
> @@ -189,6 +189,7 @@ struct si470x_device {
>   #if IS_ENABLED(CONFIG_I2C_SI470X)
>         struct i2c_client *client;
> +       struct gpio_desc *gpio_reset;
>  #endif
>  };
>  -- 2.17.1
>


--=20
| Michael Nazzareno Trimarchi                     Amarula Solutions BV |
| COO  -  Founder                                      Cruquiuskade 47 |
| +31(0)851119172                                 Amsterdam 1018 AM NL |
|                  [`as] http://www.amarulasolutions.com               |
