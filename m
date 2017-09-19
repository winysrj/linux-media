Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:55547 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdISPXs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 11:23:48 -0400
MIME-Version: 1.0
In-Reply-To: <20170919073331.29007-1-hverkuil@xs4all.nl>
References: <20170919073331.29007-1-hverkuil@xs4all.nl>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 19 Sep 2017 17:23:46 +0200
Message-ID: <CAMuHMdXTxLBNeBnnT2x95kdORFu1ya0QyqGChXKh5eK33ALYQg@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] drm/bridge/adv7511: add CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Sep 19, 2017 at 9:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> I should have posted this a month ago, but I completely forgot about
> it. Apologies for that.
>
> This patch series adds CEC support to the drm adv7511/adv7533 drivers.
>
> I have tested this with the Qualcomm Dragonboard C410 (adv7533 based)
> and the Renesas R-Car Koelsch board (adv7511 based).
>
> I only have the Koelsch board to test with, but it looks like other
> R-Car boards use the same adv7511. It would be nice if someone can
> add CEC support to the other R-Car boards as well. The main thing
> to check is if they all use the same 12 MHz fixed CEC clock source.

Have a 12 MHz fixed CEC clock source connected to the CEC_CLK pin
on ADV7511:
  - r8a7790/lager
  - r8a7791/koelsch
  - r8a7791/porter
  - r8a7792/blanche
  - r8a7793/gose
  - r8a7794/alt
  - r8a7794/silk

I don't know about r8a7792/wheat. But according to its .dts file, it has two
instances of the ADV7513, not ADV7511.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
