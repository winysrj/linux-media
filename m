Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32923 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932941AbdBQM1C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 07:27:02 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1487314666.git.joe@perches.com>
References: <cover.1487314666.git.joe@perches.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 17 Feb 2017 13:27:00 +0100
Message-ID: <CAJZ5v0gNcGtnXpE1n6LSq7ey+UDKx+oQfmTg0_PgFwzB0Dd_5A@mail.gmail.com>
Subject: Re: [PATCH 00/35] treewide trivial patches converting pr_warning to pr_warn
To: Joe Perches <joe@perches.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        tboot-devel@lists.sourceforge.net, nouveau@lists.freedesktop.org,
        oprofile-list@lists.sf.net, sfi-devel@simplefirmware.org,
        xen-devel@lists.xenproject.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        drbd-dev@lists.linbit.com,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        gigaset307x-common@lists.sourceforge.net,
        linux-media@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
        "moderated list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..."
        <alsa-devel@alsa-project.org>, linux-alpha@vger.kernel.org,
        adi-buildroot-devel@lists.sourceforge.net,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        sparclinux@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 17, 2017 at 8:11 AM, Joe Perches <joe@perches.com> wrote:
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

Sorry about asking if that has been asked already.

Wouldn't it be slightly less intrusive to simply redefined
pr_warning() as a synonym for pr_warn()?

Thanks,
Rafael
