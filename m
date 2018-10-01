Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725266AbeJAWPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 Oct 2018 18:15:06 -0400
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6984C213A2
        for <linux-media@vger.kernel.org>; Mon,  1 Oct 2018 15:36:43 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id e9-v6so14438635qtp.7
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 08:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20181001152649.15975-1-mjourdan@baylibre.com>
In-Reply-To: <20181001152649.15975-1-mjourdan@baylibre.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 1 Oct 2018 11:36:31 -0400
Message-ID: <CA+5PVA6gn5XqP69M4K2bKzR12RC+JujERYDqtBZnScy=0EAfFA@mail.gmail.com>
Subject: Re: [linux-firmware] [GIT PULL] amlogic: add video decoder firmwares
To: mjourdan@baylibre.com
Cc: Linux Firmware <linux-firmware@kernel.org>, jbrunet@baylibre.com,
        hverkuil@xs4all.nl, linux-amlogic@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 1, 2018 at 11:27 AM Maxime Jourdan <mjourdan@baylibre.com> wrote:
>
> Hello,
>
> Below is a pull request to add the firmwares required by the Amlogic video
> decoder.
>
> The firmwares were dumped from GPLv2+ in-kernel source files from Amlogic's
> vendor kernel, in their buildroot package
> "buildroot_openlinux_kernel_4.9_wayland_20180316"
>
> You can find an example of such a file in an older kernel here:
> https://github.com/hardkernel/linux/blob/odroidc2-3.14.y/drivers/amlogic/amports/arch/ucode/mpeg12/vmpeg12_mc.c
>
> The corresponding driver is currently being upstreamed:
> https://lore.kernel.org/patchwork/cover/993093/
>
> Regards,
> Maxime
>
> The following changes since commit 7c81f23ad903f72e87e2102d8f52408305c0f7a2:
>
>   ti-connectivity: add firmware for CC2560(A) Bluetooth (2018-10-01 10:08:30 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/Elyotna/linux-firmware.git

This seems questionable to me.  You have the license listed as GPLv2
or later, which is what the header file originally had but you have no
corresponding source included in your commit and it's completely
unclear who would be fulfilling the GPL obligations around this.  Even
less clear is how one would take whatever source is provided and turn
them back into the binaries you've provided.  Have you contacted AM
Logic to see if they can post the firmware files themselves or confirm
the license should be GPLv2?

josh

> for you to fetch changes up to b99cf8dcfb6e7a3dd00bdb6aa4f6c71cb6b42e58:
>
>   amlogic: add video decoder firmwares (2018-10-01 17:06:18 +0200)
>
> ----------------------------------------------------------------
> Maxime Jourdan (1):
>       amlogic: add video decoder firmwares
>
>  WHENCE                  |  16 ++++++++++++++++
>  amlogic/gx/h263_mc      | Bin 0 -> 16384 bytes
>  amlogic/gx/vh265_mc     | Bin 0 -> 16384 bytes
>  amlogic/gx/vh265_mc_mmu | Bin 0 -> 16384 bytes
>  amlogic/gx/vmjpeg_mc    | Bin 0 -> 16384 bytes
>  amlogic/gx/vmpeg12_mc   | Bin 0 -> 16384 bytes
>  amlogic/gx/vmpeg4_mc_5  | Bin 0 -> 16384 bytes
>  amlogic/gxbb/vh264_mc   | Bin 0 -> 36864 bytes
>  amlogic/gxl/vh264_mc    | Bin 0 -> 36864 bytes
>  amlogic/gxm/vh264_mc    | Bin 0 -> 36864 bytes
>  10 files changed, 16 insertions(+)
>  create mode 100644 amlogic/gx/h263_mc
>  create mode 100644 amlogic/gx/vh265_mc
>  create mode 100644 amlogic/gx/vh265_mc_mmu
>  create mode 100644 amlogic/gx/vmjpeg_mc
>  create mode 100644 amlogic/gx/vmpeg12_mc
>  create mode 100644 amlogic/gx/vmpeg4_mc_5
>  create mode 100644 amlogic/gxbb/vh264_mc
>  create mode 100644 amlogic/gxl/vh264_mc
>  create mode 100644 amlogic/gxm/vh264_mc
