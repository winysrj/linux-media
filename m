Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750828AbdBWP2v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 10:28:51 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1487314666.git.joe@perches.com>
References: <cover.1487314666.git.joe@perches.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 23 Feb 2017 09:28:23 -0600
Message-ID: <CAL_JsqLTaq-QLTqfyDO8EVJYpgeUx1e4J0Fo2NvfFWqVoiVedQ@mail.gmail.com>
Subject: Re: [PATCH 00/35] treewide trivial patches converting pr_warning to pr_warn
To: Joe Perches <joe@perches.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        tboot-devel@lists.sourceforge.net, nouveau@lists.freedesktop.org,
        oprofile-list@lists.sf.net, sfi-devel@simplefirmware.org,
        xen-devel@lists.xenproject.org,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        drbd-dev@lists.linbit.com,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        gigaset307x-common@lists.sourceforge.net,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-alpha@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net,
        linux-ia64@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        sparclinux@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 17, 2017 at 1:11 AM, Joe Perches <joe@perches.com> wrote:
> There are ~4300 uses of pr_warn and ~250 uses of the older
> pr_warning in the kernel source tree.
>
> Make the use of pr_warn consistent across all kernel files.
>
> This excludes all files in tools/ as there is a separate
> define pr_warning for that directory tree and pr_warn is
> not used in tools/.
>
> Done with 'sed s/\bpr_warning\b/pr_warn/' and some emacsing.
>
> Miscellanea:
>
> o Coalesce formats and realign arguments
>
> Some files not compiled - no cross-compilers
>
> Joe Perches (35):
>   alpha: Convert remaining uses of pr_warning to pr_warn
>   ARM: ep93xx: Convert remaining uses of pr_warning to pr_warn
>   arm64: Convert remaining uses of pr_warning to pr_warn
>   arch/blackfin: Convert remaining uses of pr_warning to pr_warn
>   ia64: Convert remaining use of pr_warning to pr_warn
>   powerpc: Convert remaining uses of pr_warning to pr_warn
>   sh: Convert remaining uses of pr_warning to pr_warn
>   sparc: Convert remaining use of pr_warning to pr_warn
>   x86: Convert remaining uses of pr_warning to pr_warn
>   drivers/acpi: Convert remaining uses of pr_warning to pr_warn
>   block/drbd: Convert remaining uses of pr_warning to pr_warn
>   gdrom: Convert remaining uses of pr_warning to pr_warn
>   drivers/char: Convert remaining use of pr_warning to pr_warn
>   clocksource: Convert remaining use of pr_warning to pr_warn
>   drivers/crypto: Convert remaining uses of pr_warning to pr_warn
>   fmc: Convert remaining use of pr_warning to pr_warn
>   drivers/gpu: Convert remaining uses of pr_warning to pr_warn
>   drivers/ide: Convert remaining uses of pr_warning to pr_warn
>   drivers/input: Convert remaining uses of pr_warning to pr_warn
>   drivers/isdn: Convert remaining uses of pr_warning to pr_warn
>   drivers/macintosh: Convert remaining uses of pr_warning to pr_warn
>   drivers/media: Convert remaining use of pr_warning to pr_warn
>   drivers/mfd: Convert remaining uses of pr_warning to pr_warn
>   drivers/mtd: Convert remaining uses of pr_warning to pr_warn
>   drivers/of: Convert remaining uses of pr_warning to pr_warn
>   drivers/oprofile: Convert remaining uses of pr_warning to pr_warn
>   drivers/platform: Convert remaining uses of pr_warning to pr_warn
>   drivers/rapidio: Convert remaining use of pr_warning to pr_warn
>   drivers/scsi: Convert remaining use of pr_warning to pr_warn
>   drivers/sh: Convert remaining use of pr_warning to pr_warn
>   drivers/tty: Convert remaining uses of pr_warning to pr_warn
>   drivers/video: Convert remaining uses of pr_warning to pr_warn
>   kernel/trace: Convert remaining uses of pr_warning to pr_warn
>   lib: Convert remaining uses of pr_warning to pr_warn
>   sound/soc: Convert remaining uses of pr_warning to pr_warn

Where's the removal of pr_warning so we don't have more sneak in?

Rob
