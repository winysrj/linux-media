Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36CB4C4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 09:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F85F2177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 09:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbfBRJHR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 04:07:17 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:41454 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfBRJHQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 04:07:16 -0500
Received: by mail-ua1-f67.google.com with SMTP id z24so5554264ual.8;
        Mon, 18 Feb 2019 01:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B6S0H04HTAomNezrtT8nJl7aWmSqM3cscv4l462UHHM=;
        b=f5Sfp0PnC0FF/UGt3IfUpJBBpgEbCzd3dBYlitm4zhmWkHH7i64BqZsDqbRsCyzy5F
         HnUinnl+QX0dUSdw/1RHtkj4wsso3vhvOvTzMS9cHkOwvd45UAwsIDiTVvTrh9bDNaMm
         nKdyc+alMClBz//1avRBqdkKHWTYpu7XlyR6tobQ23l/oc1Y/+mmSPYIhMZqhOR6gh0D
         TgEx1pv9EyBp+1Bs08P1/NS8xce6GWsImBJNxj8b2BiGdM8nQ0zdIJugXPjXC6ioXaFH
         EkJU11IncTX1nVjzz8/zGPdLhLAWslhaQPxuc167h2xgvJLUleMt95gT5Zo7vpfjoDhf
         f4og==
X-Gm-Message-State: AHQUAubgzzCPvZtAmdfmMi5pcv5Vv2SDJMsQi7QLkQIYkJ9vffLCRhnb
        7BlVWYlkyQBMvxqfS56oTeoRQWbgVyMdXgSWTX7+R35K
X-Google-Smtp-Source: AHgI3IabRubpJALmQyGM7UfgbF8BOLM7nSzlJA4iGqQOC3bNjTolr8DXGKcPhsI3NVK2kv2HqI5j+/6lxuhVpQ2kBog=
X-Received: by 2002:a9f:30dc:: with SMTP id k28mr4229312uab.75.1550480835848;
 Mon, 18 Feb 2019 01:07:15 -0800 (PST)
MIME-Version: 1.0
References: <20190216225638.7159-1-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20190216225638.7159-1-niklas.soderlund+renesas@ragnatech.se>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 Feb 2019 10:07:04 +0100
Message-ID: <CAMuHMdUcGeffyxgZ2eBU2A=t-8c2Mo2eqvr-czSMRJy13AyYJA@mail.gmail.com>
Subject: Re: [PATCH] rcar-csi2: Use standby mode instead of resetting
To:     =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On Sun, Feb 17, 2019 at 8:54 AM Niklas Söderlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Later versions of the datasheet updates the reset procedure to more
> closely resemble the standby mode. Update the driver to enter and exit
> the standby mode instead of resetting the hardware before and after
> streaming is started and stopped.
>
> While at it break out the full start and stop procedures from
> rcsi2_s_stream() into the existing helper functions.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Thanks for your patch!

> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c

> @@ -936,6 +947,10 @@ static int rcsi2_probe_resources(struct rcar_csi2 *priv,
>         if (irq < 0)
>                 return irq;
>
> +       priv->rstc = devm_reset_control_get(&pdev->dev, NULL);
> +       if (IS_ERR(priv->rstc))
> +               return PTR_ERR(priv->rstc);
> +
>         return 0;

Does the driver Kconfig option need "select RESET_CONTROLLER"?
If the option is not enabled, devm_reset_control_get() will return -ENOTSUPP.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
