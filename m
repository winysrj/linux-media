Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:42144 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754863AbeE2Hdv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 03:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <1527525431-22852-4-git-send-email-jacopo+renesas@jmondi.org>
References: <1527525431-22852-1-git-send-email-jacopo+renesas@jmondi.org> <1527525431-22852-4-git-send-email-jacopo+renesas@jmondi.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 29 May 2018 09:33:50 +0200
Message-ID: <CAMuHMdXuD8R5KL4msAnVPxrf5GyyA=o_q3R74sOeQJ1tr5DbXw@mail.gmail.com>
Subject: Re: [PATCH 3/5] arch: sh: kfr2r09: Use new renesas-ceu camera driver
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Mon, May 28, 2018 at 6:37 PM, Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> Use the new renesas-ceu camera driver in kfr2r09 board file instead of
> the soc_camera based sh_mobile_ceu_camera driver.
>
> Get rid of soc_camera specific components, and move clk and gpio handling
> away from board file, registering the clock source and the enable gpios
> for driver consumption.
>
> Memory for the CEU video buffers is now reserved with membocks APIs,
> and need to be declared as dma_coherent during machine initialization to
> remove that architecture specific part from CEU driver.
>
> While at there update license to SPDX header and sort headers alphabetically.
>
> No need to udapte the clock source names, as
> commit c2f9b05fd5c1 ("media: arch: sh: ecovec: Use new renesas-ceu camera driver")
> already updated it to the new ceu driver name for all SH7724 boards (possibly
> breaking kfr2r09 before this commit).
>
> Compile tested only.
>
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Thanks for your patch!

> --- a/arch/sh/boards/mach-kfr2r09/setup.c
> +++ b/arch/sh/boards/mach-kfr2r09/setup.c
> @@ -1,41 +1,53 @@

> @@ -635,6 +580,36 @@ static int __init kfr2r09_devices_setup(void)
>
>         i2c_register_board_info(0, &kfr2r09_backlight_board_info, 1);
>
> +       /* Set camera clock frequency and register and alias for rj54n1. */
> +       camera_clk = clk_get(NULL, "video_clk");
> +       if (!IS_ERR(camera_clk)) {
> +               clk_set_rate(camera_clk,
> +                            clk_round_rate(camera_clk, CEU_MCLK_FREQ));
> +               clk_put(camera_clk);
> +       }
> +       clk_add_alias(NULL, "1-0050", "video_clk", NULL);
> +
> +       /* set DRVCRB
> +        *
> +        * use 1.8 V for VccQ_VIO
> +        * use 2.85V for VccQ_SR
> +        */
> +       __raw_writew((__raw_readw(DRVCRB) & ~0x0003) | 0x0001, DRVCRB);
> +
> +       gpiod_add_lookup_table(&rj54n1_gpios);
> +
> +       i2c_register_board_info(1, &kfr2r09_i2c_camera, 1);
> +
> +       /* Initialize CEU platform device separately to map memory first */
> +       device_initialize(&kfr2r09_ceu_device.dev);
> +       arch_setup_pdev_archdata(&kfr2r09_ceu_device);

arch_setup_pdev_archdata() is a no-op on SH, so I think this can be
dropped (also in patches 4/5 and 5/5).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
