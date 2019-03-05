Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23594C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F17BF20675
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 08:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfCEIrW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 03:47:22 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36650 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfCEIrW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 03:47:22 -0500
Received: by mail-qt1-f193.google.com with SMTP id p25so8200833qtb.3;
        Tue, 05 Mar 2019 00:47:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=izJRav3xBXOxXrLsUrx1vJh3HuRLgGZMauE7uaNR2R4=;
        b=jbPglvmf36rnGC4R5XHSTB3nrqZt/c1l/s0kbOeYn4McmTE+lUmLX1NVwUE4+YULV3
         Z5gPKzjVaiGMVEht7zhB4myS+frNUKVIR3wPOmskpJIWvycL4/TvWhuqRHkfg4vkj0an
         qBMd9twokny5rLt2XnnrH/EeEP6VEWxnAWodWNuRqUlSGocgnOyeBIbU6Vc2v+umkT1T
         GvD0FPjU/cnxAPD2Cm7nurd0E0YJPJtk3tG7qnOxvKJBq5iaaPoZwXol5NRaMFZSz/g0
         fzlKrL5AUtXnX0ugDWtcz0+jsW2z8czo4IKOx8u+q9FW0lYhXJR7B70X8tZBvvY8pAzS
         TAeg==
X-Gm-Message-State: APjAAAU+qDZ3/IJFI62YjGcdaPPV4LMSMYNpFJyNNEaBDWwOCLp5Kybe
        /xmjNKEPAVrdV31H2El7QJ/YpLhJac4IL4IPoVw=
X-Google-Smtp-Source: APXvYqzTKn/deZNboY447grtoXmZ8qoCMbdjng6pjq0mE0IKrI5Py0DFzPjF6up1+P4ZoTl7b5RdPSbbC/CbGuEQn9k=
X-Received: by 2002:ac8:237b:: with SMTP id b56mr552009qtb.343.1551775640632;
 Tue, 05 Mar 2019 00:47:20 -0800 (PST)
MIME-Version: 1.0
References: <20190304203003.1862052-1-arnd@arndb.de> <CAMuHMdVELnQ5STP_AG=VQddZPewCpg8NgBds8OPh2t+_W7QEHw@mail.gmail.com>
In-Reply-To: <CAMuHMdVELnQ5STP_AG=VQddZPewCpg8NgBds8OPh2t+_W7QEHw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 5 Mar 2019 09:47:04 +0100
Message-ID: <CAK8P3a16nO+1+niZ8XUUoxZsMnrXHsD7ZbxMB_Z=723Ce1cvDw@mail.gmail.com>
Subject: Re: [PATCH] media: staging: davinci_vpfe: disallow building with COMPILE_TEST
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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

On Tue, Mar 5, 2019 at 9:05 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Mon, Mar 4, 2019 at 9:30 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > The driver should really call dm365_isif_setup_pinmux() through a callback,
> > but it runs platform specific code by itself, which never actually compiled:
> >
> > /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: implicit declaration of function 'davinci_cfg_reg' [-Werror,-Wimplicit-function-declaration]
> >         davinci_cfg_reg(DM365_VIN_CAM_WEN);
> >         ^
> > /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:2: error: this function declaration is not a prototype [-Werror,-Wstrict-prototypes]
> > /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2028:18: error: use of undeclared identifier 'DM365_VIN_CAM_WEN'
> >         davinci_cfg_reg(DM365_VIN_CAM_WEN);
> >                         ^
> > /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2029:18: error: use of undeclared identifier 'DM365_VIN_CAM_VD'
> >         davinci_cfg_reg(DM365_VIN_CAM_VD);
> >                         ^
> > /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2030:18: error: use of undeclared identifier 'DM365_VIN_CAM_HD'
> >         davinci_cfg_reg(DM365_VIN_CAM_HD);
> >                         ^
> > /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2031:18: error: use of undeclared identifier 'DM365_VIN_YIN4_7_EN'
> >         davinci_cfg_reg(DM365_VIN_YIN4_7_EN);
> >                         ^
> > /git/arm-soc/drivers/staging/media/davinci_vpfe/dm365_isif.c:2032:18: error: use of undeclared identifier 'DM365_VIN_YIN0_3_EN'
> >         davinci_cfg_reg(DM365_VIN_YIN0_3_EN);
> >                         ^
> > 7 errors generated.
>
> Which tree and which config is this?
> This driver compiles fine with m68k/allmodconfig on v5.0?

Ah, thanks for checking, I found the real issue now:

The Makefile contains a nasty hack that makes it work /almost/ everywhere

# Allow building it with COMPILE_TEST on other archs
ifndef CONFIG_ARCH_DAVINCI
ccflags-y += -I $(srctree)/arch/arm/mach-davinci/include/
endif

This is something we probably don't want to do, but it mostly happens to
do the right thing for compile testing. The case I ran into is the rare
exception of arch/arm/mach-omap1, which has a different mach/mux.h
header, so the '#include <mach/mux.h>' in the driver gets the omap
file rather than the davinci file, and then misses the davinci_cfg_reg()
declaration and the macros.

One way to work around this is to pile on to the hack by adding
'depends on !ARCH_OMAP1'. Should we do that, or is there
a better way out? Do we actually still need the staging driver
in addition to the one in drivers/media/platform/davinci ?

       Arnd
