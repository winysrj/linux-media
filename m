Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:45536 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751059AbdEaM1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 08:27:23 -0400
Received: from mail-oi0-f46.google.com (mail-oi0-f46.google.com [209.85.218.46])
        by imap.netup.ru (Postfix) with ESMTPSA id 70E378B3F86
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 15:27:21 +0300 (MSK)
Received: by mail-oi0-f46.google.com with SMTP id l18so13029016oig.2
        for <linux-media@vger.kernel.org>; Wed, 31 May 2017 05:27:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170409193828.18458-17-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com> <20170409193828.18458-17-d.scheller.oss@gmail.com>
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 31 May 2017 08:26:59 -0400
Message-ID: <CAK3bHNWSBhF4vi6ZntRf6wAHfxE-qFcxqbtfVvUoMrh2P1LnEQ@mail.gmail.com>
Subject: Re: [PATCH 16/19] [media] ddbridge: board control setup, ts quirk flags
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: Kozlov Sergey <serjk@netup.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>, rjkm@metzlerbros.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

not related to cxd2841er. I'm skipping this ...

2017-04-09 15:38 GMT-04:00 Daniel Scheller <d.scheller.oss@gmail.com>:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> This is a backport of the board control setup from the vendor provided
> dddvb driver package, which does additional device initialisation based
> on the board_control device info values. Also backports the TS quirk
> flags which is used to control setup and usage of the tuner modules
> soldered on the bridge cards (e.g. CineCTv7, CineS2 V7, MaxA8 and the
> likes).
>
> Functionality originates from ddbridge vendor driver. Permission for
> reuse and kernel inclusion was formally granted by Ralph Metzler
> <rjkm@metzlerbros.de>.
>
> Cc: Ralph Metzler <rjkm@metzlerbros.de>
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/pci/ddbridge/ddbridge-core.c | 13 +++++++++++++
>  drivers/media/pci/ddbridge/ddbridge-regs.h |  4 ++++
>  drivers/media/pci/ddbridge/ddbridge.h      | 10 ++++++++++
>  3 files changed, 27 insertions(+)
>
> diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
> index 12f5aa3..6b49fa9 100644
> --- a/drivers/media/pci/ddbridge/ddbridge-core.c
> +++ b/drivers/media/pci/ddbridge/ddbridge-core.c
> @@ -1763,6 +1763,19 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         ddbwritel(0xfff0f, INTERRUPT_ENABLE);
>         ddbwritel(0, MSI1_ENABLE);
>
> +       /* board control */
> +       if (dev->info->board_control) {
> +               ddbwritel(0, DDB_LINK_TAG(0) | BOARD_CONTROL);
> +               msleep(100);
> +               ddbwritel(dev->info->board_control_2,
> +                       DDB_LINK_TAG(0) | BOARD_CONTROL);
> +               usleep_range(2000, 3000);
> +               ddbwritel(dev->info->board_control_2
> +                       | dev->info->board_control,
> +                       DDB_LINK_TAG(0) | BOARD_CONTROL);
> +               usleep_range(2000, 3000);
> +       }
> +
>         if (ddb_i2c_init(dev) < 0)
>                 goto fail1;
>         ddb_ports_init(dev);
> diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
> index 6ae8103..98cebb9 100644
> --- a/drivers/media/pci/ddbridge/ddbridge-regs.h
> +++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
> @@ -34,6 +34,10 @@
>
>  /* ------------------------------------------------------------------------- */
>
> +#define BOARD_CONTROL    0x30
> +
> +/* ------------------------------------------------------------------------- */
> +
>  /* Interrupt controller                                     */
>  /* How many MSI's are available depends on HW (Min 2 max 8) */
>  /* How many are usable also depends on Host platform        */
> diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
> index 0898f60..734e18e 100644
> --- a/drivers/media/pci/ddbridge/ddbridge.h
> +++ b/drivers/media/pci/ddbridge/ddbridge.h
> @@ -43,6 +43,10 @@
>  #define DDB_MAX_PORT    4
>  #define DDB_MAX_INPUT   8
>  #define DDB_MAX_OUTPUT  4
> +#define DDB_MAX_LINK    4
> +#define DDB_LINK_SHIFT 28
> +
> +#define DDB_LINK_TAG(_x) (_x << DDB_LINK_SHIFT)
>
>  struct ddb_info {
>         int   type;
> @@ -51,6 +55,12 @@ struct ddb_info {
>         char *name;
>         int   port_num;
>         u32   port_type[DDB_MAX_PORT];
> +       u32   board_control;
> +       u32   board_control_2;
> +       u8    ts_quirks;
> +#define TS_QUIRK_SERIAL   1
> +#define TS_QUIRK_REVERSED 2
> +#define TS_QUIRK_ALT_OSC  8
>  };
>
>  /* DMA_SIZE MUST be divisible by 188 and 128 !!! */
> --
> 2.10.2
>



-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
