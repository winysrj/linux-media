Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0BE8C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 22:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FDB021848
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 22:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d75Mlvqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731392AbfBRWE7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 17:04:59 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44850 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbfBRWE7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 17:04:59 -0500
Received: by mail-qt1-f194.google.com with SMTP id n32so20905549qte.11;
        Mon, 18 Feb 2019 14:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UJEIjvFn5lDWyFGKQ6nt9TMgckGmOcCuBM72TI/2smU=;
        b=d75MlvqbxFQqce46nPdMbicc+JCmML4ejDSpaQ2ahLgc12VraUb4wVPwzyd7wUYXTv
         yfis+GaGOHF/1Vw+is5EzYiRLMBO/eH0wMTZ5XHyrkgbqXw901a9NCPlgZv4fa5UrtiK
         0Tg0SQ3y1z4o5l3re/2cu68hMJjjgk7vGBwoZW2TJDGRJ0R8lANedHQ/PcD53lDtqKgP
         gbdqmW2sizt3JCjdNLm+2z3qqnZ24g7PhU/qnItzMXCOZzkg2JY/PWEA4QLEnX+e3vyi
         RBqs6M5yMaLg3kt/gLRdb20iN6RwRd96nhB8mGYnBt3L2MreIeuR0LYIzZAdfPL6oXu1
         V4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UJEIjvFn5lDWyFGKQ6nt9TMgckGmOcCuBM72TI/2smU=;
        b=CkJ/je2St/xGp/dUNIaUJlRFEAfyezEqxJaZnJ1ND/SmwdZPWynXo/zyCmbjiGegO5
         VWxdfF8kyew/N6b9JLAS2MlFurS7PVUviFP2YPos4HuhE8s6AxNKfAAxINBROC96NSYL
         bg8u9uV96zRaHltbqFp11Le30Osa+8it1E/5O9vavatBs0fVbnDYksE4BNbAjvFTngOZ
         JFsEF+j5IrdO7lUmQmDIi7Kzp/ZrPIGZc1koDcfqEMPHfv94VRn3HOLLISPK+g7UD58F
         50Q45Cs4AEZGF2xpl7JeMnbH/KMVY3i7yyav8qb/snVcyQLxjTCvayKjfruFhdTjhTpX
         AAlA==
X-Gm-Message-State: AHQUAubjQ2gxjVryrbDMESVW52x4rY+BPV0P98TIkuJzE2+hu9JCbPYd
        +0Tlxo3H2sQiHwuT3qwZoCXV1XA6zNxfYNUBDbk=
X-Google-Smtp-Source: AHgI3IayEKqP5K/9ta9zQQ8xRffxLB9j+zI0CAuiSixorC6YG4GFoRQVMKpWCGKl5j9r6SK2Zl6rz6NIyfwUBuUzrow=
X-Received: by 2002:a0c:963d:: with SMTP id 58mr19213670qvx.25.1550527497638;
 Mon, 18 Feb 2019 14:04:57 -0800 (PST)
MIME-Version: 1.0
References: <20181221011752.25627-1-sre@kernel.org> <20181221011752.25627-3-sre@kernel.org>
In-Reply-To: <20181221011752.25627-3-sre@kernel.org>
From:   Enric Balletbo Serra <eballetbo@gmail.com>
Date:   Mon, 18 Feb 2019 23:04:46 +0100
Message-ID: <CAFqH_50kd4TRg6FTNZ-hZAPN14X8t++zY7mobTmPDfre8x59JQ@mail.gmail.com>
Subject: Re: [PATCH 02/14] ARM: dts: IGEP: Add WiLink UART node
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sebastian,

Sorry to take so long to reply

Missatge de Sebastian Reichel <sre@kernel.org> del dia dv., 21 de des.
2018 a les 9:05:
>
> From: Sebastian Reichel <sebastian.reichel@collabora.com>
>
> Add a node for the UART part of WiLink chip.
>
> Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
> This is compile tested only!
> ---
>  arch/arm/boot/dts/omap3-igep0020-rev-f.dts | 8 ++++++++
>  arch/arm/boot/dts/omap3-igep0030-rev-g.dts | 8 ++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm/boot/dts/omap3-igep0020-rev-f.dts b/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
> index 285681d7af49..8bb4298ca05e 100644
> --- a/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
> +++ b/arch/arm/boot/dts/omap3-igep0020-rev-f.dts
> @@ -52,3 +52,11 @@
>                 interrupts = <17 IRQ_TYPE_EDGE_RISING>; /* gpio 177 */
>         };
>  };
> +
> +&uart2 {
> +       bluetooth {
> +               compatible = "ti,wl1835-st";

That should be "ti,wl1831-st"

> +               enable-gpios = <&gpio5 9 GPIO_ACTIVE_HIGH>; /* gpio 137 */
> +               max-speed = <300000>;
> +       };
> +};
> diff --git a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
> index 1adc73bd2ca0..03be171e9de7 100644
> --- a/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
> +++ b/arch/arm/boot/dts/omap3-igep0030-rev-g.dts
> @@ -74,3 +74,11 @@
>                 interrupts = <8 IRQ_TYPE_EDGE_RISING>; /* gpio 136 */
>         };
>  };
> +
> +&uart2 {
> +       bluetooth {
> +               compatible = "ti,wl1835-st";

That should be "ti,wl1831-st"

> +               enable-gpios = <&gpio5 9 GPIO_ACTIVE_HIGH>; /* gpio 137 */
> +               max-speed = <300000>;
> +       };
> +};
> --
> 2.19.2
>

Apart from that,

Acked-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
