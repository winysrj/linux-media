Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33699 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbeLAGuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Dec 2018 01:50:55 -0500
Received: by mail-yb1-f196.google.com with SMTP id i78-v6so2695052ybg.0
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 11:40:33 -0800 (PST)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id n4sm1921536ywc.89.2018.11.30.11.40.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Nov 2018 11:40:30 -0800 (PST)
Received: by mail-yw1-f50.google.com with SMTP id h193so2751700ywc.4
        for <linux-media@vger.kernel.org>; Fri, 30 Nov 2018 11:40:29 -0800 (PST)
MIME-Version: 1.0
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 30 Nov 2018 11:40:17 -0800
Message-ID: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Axtens <dja@axtens.net>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Maling list - DRI developers
        <dri-devel@lists.freedesktop.org>,
        Eric Dumazet <edumazet@google.com>, federico.vaga@vaga.pv.it,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Helge Deller <deller@gmx.de>, Jonathan Corbet <corbet@lwn.net>,
        Joshua Kinard <kumba@gentoo.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux mtd <linux-mtd@lists.infradead.org>,
        linux-parisc <linux-parisc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-scsi@vger.kernel.org, matthias.bgg@gmail.com,
        Network Development <netdev@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Burton <paul.burton@mips.com>,
        Petr Mladek <pmladek@suse.com>, Rob Herring <robh@kernel.org>,
        sean.wang@mediatek.com,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        shannon.nelson@oracle.com, Stefano Brivio <sbrivio@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Tobin C. Harding" <me@tobin.cc>, makita.toshiaki@lab.ntt.co.jp,
        Willem de Bruijn <willemb@google.com>,
        Yonghong Song <yhs@fb.com>, yanjun.zhu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> In order to comply with the CoC, replace **** with a hug.

Heh. I support the replacement of the stronger language, but I find
"hug", "hugged", and "hugging" to be very weird replacements. Can we
bikeshed this to "heck", "hecked", and "hecking" (or "heckin" to
follow true Doggo meme style).

"This API is hugged" doesn't make any sense to me. "This API is
hecked" is better, or at least funnier (to me). "Hug this interface"
similarly makes no sense, but "Heck this interface" seems better.
"Don't touch my hecking code", "What the heck were they thinking?"
etc... "hug" is odd.

Better yet, since it's only 17 files, how about doing context-specific
changes? "This API is terrible", "Hateful interface", "Don't touch my
freakin' code", "What in the world were they thinking?" etc?

-Kees

>
> Jarkko Sakkinen (15):
>   MIPS: replace **** with a hug
>   Documentation: replace **** with a hug
>   drm/nouveau: replace **** with a hug
>   m68k: replace **** with a hug
>   parisc: replace **** with a hug
>   cpufreq: replace **** with a hug
>   ide: replace **** with a hug
>   media: replace **** with a hug
>   mtd: replace **** with a hug
>   net/sunhme: replace **** with a hug
>   scsi: replace **** with a hug
>   inotify: replace **** with a hug
>   irq: replace **** with a hug
>   lib: replace **** with a hug
>   net: replace **** with a hug
>
>  Documentation/kernel-hacking/locking.rst      |  2 +-
>  arch/m68k/include/asm/sun3ints.h              |  2 +-
>  arch/mips/pci/ops-bridge.c                    | 24 +++++++++----------
>  arch/mips/sgi-ip22/ip22-setup.c               |  2 +-
>  arch/parisc/kernel/sys_parisc.c               |  2 +-
>  drivers/cpufreq/powernow-k7.c                 |  2 +-
>  .../gpu/drm/nouveau/nvkm/subdev/bios/init.c   |  2 +-
>  .../nouveau/nvkm/subdev/pmu/fuc/macros.fuc    |  2 +-
>  drivers/ide/cmd640.c                          |  2 +-
>  drivers/media/i2c/bt819.c                     |  8 ++++---
>  drivers/mtd/mtd_blkdevs.c                     |  2 +-
>  drivers/net/ethernet/sun/sunhme.c             |  4 ++--
>  drivers/scsi/qlogicpti.h                      |  2 +-
>  fs/notify/inotify/inotify_user.c              |  2 +-
>  kernel/irq/timings.c                          |  2 +-
>  lib/vsprintf.c                                |  2 +-
>  net/core/skbuff.c                             |  2 +-
>  17 files changed, 33 insertions(+), 31 deletions(-)
>
> --
> 2.19.1
>


-- 
Kees Cook
