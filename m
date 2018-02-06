Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:45127 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeBFIUp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 03:20:45 -0500
MIME-Version: 1.0
In-Reply-To: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 6 Feb 2018 09:20:43 +0100
Message-ID: <CAMuHMdWnV17DCxr71k6n3w+5jPtQmeuPugr58xadq9U_qchJnQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfram,

On Mon, Feb 5, 2018 at 9:09 PM, Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> In one Renesas driver, I found a typo which turned an intended bit shift ('<<')
> into a comparison ('<'). Because this is a subtle issue, I looked tree wide for
> similar patterns. This small patch series is the outcome.
>
> Buildbot and checkpatch are happy. Only compile-tested. To be applied
> individually per sub-system, I think. I'd think only the net: amd: patch needs
> to be conisdered for stable, but I leave this to people who actually know this
> driver.
>
> CCing Dan. Maybe he has an idea how to add a test to smatch? In my setup, only
> cppcheck reported a 'coding style' issue with a low prio.

I found two more using "git grep 'define.*0x[0-9a-f]* < '":

drivers/net/can/m_can/m_can.c:#define RXFC_FWM_MASK     (0x7f < RXFC_FWM_SHIFT)
drivers/usb/gadget/udc/goku_udc.h:#define INT_EPnNAK(n)
(0x00100 < (n))         /* 0 < n < 4 */

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
