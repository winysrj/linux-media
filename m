Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38185 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdHNPen (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 11:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <20170730130743.19681-4-hverkuil@xs4all.nl>
References: <20170730130743.19681-1-hverkuil@xs4all.nl> <20170730130743.19681-4-hverkuil@xs4all.nl>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 14 Aug 2017 17:34:41 +0200
Message-ID: <CAMuHMdXSHz2vKNOfJGM3ByzTankzd66Hj_Q_KewmHSWhSmV1Sg@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm: dts: renesas: add cec clock for Koelsch board
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 30, 2017 at 3:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>

Probably the one-line summary should be

    ARM: dts: koelsch: Add CEC clock  for HDMI transmitter

> The adv7511 on the Koelsch board has a 12 MHz fixed clock
> for the CEC block. Specify this in the dts to enable CEC support.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
