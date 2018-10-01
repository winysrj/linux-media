Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33300 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJAWcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 18:32:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id e4-v6so728347wrs.0
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 08:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20181001152649.15975-1-mjourdan@baylibre.com> <CA+5PVA6gn5XqP69M4K2bKzR12RC+JujERYDqtBZnScy=0EAfFA@mail.gmail.com>
In-Reply-To: <CA+5PVA6gn5XqP69M4K2bKzR12RC+JujERYDqtBZnScy=0EAfFA@mail.gmail.com>
From: Maxime Jourdan <mjourdan@baylibre.com>
Date: Mon, 1 Oct 2018 17:54:08 +0200
Message-ID: <CAMO6nay02aFiWZMzs_9-eV2jDpeEp9Rfd7VLTD5+KPo9bHK_CQ@mail.gmail.com>
Subject: Re: [linux-firmware] [GIT PULL] amlogic: add video decoder firmwares
To: jwboyer@kernel.org
Cc: linux-firmware@kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 1, 2018 at 5:36 PM Josh Boyer <jwboyer@kernel.org> wrote:
>
> On Mon, Oct 1, 2018 at 11:27 AM Maxime Jourdan <mjourdan@baylibre.com> wrote:
> >
> > Hello,
> >
> > Below is a pull request to add the firmwares required by the Amlogic video
> > decoder.
> >
> > The firmwares were dumped from GPLv2+ in-kernel source files from Amlogic's
> > vendor kernel, in their buildroot package
> > "buildroot_openlinux_kernel_4.9_wayland_20180316"
> >
> > You can find an example of such a file in an older kernel here:
> > https://github.com/hardkernel/linux/blob/odroidc2-3.14.y/drivers/amlogic/amports/arch/ucode/mpeg12/vmpeg12_mc.c
> >
> > The corresponding driver is currently being upstreamed:
> > https://lore.kernel.org/patchwork/cover/993093/
> >
> > Regards,
> > Maxime
> >
> > The following changes since commit 7c81f23ad903f72e87e2102d8f52408305c0f7a2:
> >
> >   ti-connectivity: add firmware for CC2560(A) Bluetooth (2018-10-01 10:08:30 -0400)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/Elyotna/linux-firmware.git
>
> This seems questionable to me.  You have the license listed as GPLv2
> or later, which is what the header file originally had but you have no
> corresponding source included in your commit and it's completely
> unclear who would be fulfilling the GPL obligations around this.  Even
> less clear is how one would take whatever source is provided and turn
> them back into the binaries you've provided.  Have you contacted AM
> Logic to see if they can post the firmware files themselves or confirm
> the license should be GPLv2?
>
> josh
>

Hi Josh,

I see your point. The "source" files that are GPLv2+ in the vendor
kernel only contain binary arrays, and there is no actual source code
available for these firmwares. I had hoped this would at least mean we
could redistribute the binary firmwares.

I will contact Amlogic and (hopefully) follow up with clarified
licensing regarding the firmwares.

Regards,
Maxime
