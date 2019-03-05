Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E6DC43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0458020675
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfCEIE7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:04:59 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:42765 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfCEIE7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 03:04:59 -0500
Received: by mail-ua1-f66.google.com with SMTP id s26so6935102uao.9;
        Tue, 05 Mar 2019 00:04:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M6LpDQmBzSRwAPxQU2WaLr09kOypn9kKAvee3P1SlOk=;
        b=hhL0y65M8XwG7SnkkGwXAvgPFDvXXqde3AUhgiGbacL8wFf/yvdmJCeDR31L23TpJE
         QRvD+rP2id8znzgAWQaF7nWDN9GifJRg9GB9BR4CtO2BGD7E5vVPB8AqbTnXDBMNZCQe
         yUxbQ7ZQx2wlTO8bkHdbamOjLaVtAPhrmC0TeLDcaRIp3u7wpiAfXeOiqACPqAdfmeSk
         VG+F2GaXCPgiIe72qjlv8PEU+uCxOCOUnjNXPUo0LUDwXMfoyyJpE7dWkzXSP08ZxVRo
         qo7G3qpgNWIY49Of51N89o90mmFcc+6wuHqqqSXj+GKvSRvvuNh6BC15Diz6MI6rwv8h
         ak3A==
X-Gm-Message-State: APjAAAWWehPUN5ncQqC1Uw+uur+sYf+t1/cy60+WGeG4qAC49WcBunFf
        tAFKm3XPnYC8cSuaTZ0YpDrl1Z6eGbnxSu9Ph1deGw==
X-Google-Smtp-Source: APXvYqzL6VpTYLqqcJgZRHlngn/K0Ri0haEHah+GEZ2RFvsud1ZvXykps55bOHf1lbWXE+r+CosG469yS5sbJQfO6Zs=
X-Received: by 2002:a67:fc9a:: with SMTP id x26mr527610vsp.166.1551773097693;
 Tue, 05 Mar 2019 00:04:57 -0800 (PST)
MIME-Version: 1.0
References: <20190304203003.1862052-1-arnd@arndb.de>
In-Reply-To: <20190304203003.1862052-1-arnd@arndb.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Mar 2019 09:04:46 +0100
Message-ID: <CAMuHMdVELnQ5STP_AG=VQddZPewCpg8NgBds8OPh2t+_W7QEHw@mail.gmail.com>
Subject: Re: [PATCH] media: staging: davinci_vpfe: disallow building with COMPILE_TEST
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Arnd,

On Mon, Mar 4, 2019 at 9:30 PM Arnd Bergmann <arnd@arndb.de> wrote:
> The driver should really call dm365_isif_setup_pinmux() through a callback,
> but it runs platform specific code by itself, which never actually compiled:
>
> /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: implicit declaration of function 'davinci_cfg_reg' [-Werror,-Wimplicit-function-declaration]
>         davinci_cfg_reg(DM365_VIN_CAM_WEN);
>         ^
> /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: this function declaration is not a prototype [-Werror,-Wstrict-prototypes]
> /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:18: error: use of undeclared identifier 'DM365_VIN_CAM_WEN'
>         davinci_cfg_reg(DM365_VIN_CAM_WEN);
>                         ^
> /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2029:18: error: use of undeclared identifier 'DM365_VIN_CAM_VD'
>         davinci_cfg_reg(DM365_VIN_CAM_VD);
>                         ^
> /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2030:18: error: use of undeclared identifier 'DM365_VIN_CAM_HD'
>         davinci_cfg_reg(DM365_VIN_CAM_HD);
>                         ^
> /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2031:18: error: use of undeclared identifier 'DM365_VIN_YIN4_7_EN'
>         davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
>                         ^
> /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2032:18: error: use of undeclared identifier 'DM365_VIN_YIN0_3_EN'
>         davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
>                         ^
> 7 errors generated.

Which tree and which config is this?
This driver compiles fine with m68k/allmodconfig on v5.0?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
